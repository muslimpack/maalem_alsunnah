import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/src/core/di/dependency_injection.dart';
import 'package:maalem_alsunnah/src/core/extensions/extension.dart';
import 'package:maalem_alsunnah/src/core/utils/app_nav_observer.dart';
import 'package:maalem_alsunnah/src/core/utils/dummy_data.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/manuscript_ornament.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/screens/content_viewer_screen.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/repository/hadith_db_helper.dart';
import 'package:skeletonizer/skeletonizer.dart';

enum BreadcrumbMode {
  /// The whole chain, wrapping onto more lines if needed (search results).
  full,

  /// Only the parents of the title. Use where the title itself is already
  /// on screen (sub-list).
  ancestors,

  /// Only the title itself (e.g. the chapter of a bookmarked hadith).
  current,

  /// The parents as centred links separated by gold dots, for the
  /// manuscript-style chapter opening in the reader.
  opening,
}

/// Tappable path of a title: `المقصد الأول › الكتاب الأول › باب …`.
/// Tapping a level opens it (or pops back to it if it's already open).
class TitlesChainBreadCrumb extends StatefulWidget {
  const TitlesChainBreadCrumb({
    super.key,
    required this.titleId,
    this.mode = BreadcrumbMode.full,
  });

  final int titleId;
  final BreadcrumbMode mode;

  @override
  State<TitlesChainBreadCrumb> createState() => _TitlesChainBreadCrumbState();
}

class _TitlesChainBreadCrumbState extends State<TitlesChainBreadCrumb> {
  late Future<List<TitleModel>> _titles = _load();

  Future<List<TitleModel>> _load() async {
    final db = sl<HadithDbHelper>();
    switch (widget.mode) {
      case BreadcrumbMode.current:
        final title = await db.getTitleById(widget.titleId);
        return [if (title != null) title];
      case BreadcrumbMode.ancestors:
      case BreadcrumbMode.opening:
        final chain = await db.getTitleChain(widget.titleId);
        return chain.isEmpty ? chain : chain.sublist(0, chain.length - 1);
      case BreadcrumbMode.full:
        return db.getTitleChain(widget.titleId);
    }
  }

  @override
  void didUpdateWidget(covariant TitlesChainBreadCrumb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.titleId != widget.titleId || oldWidget.mode != widget.mode) {
      setState(() => _titles = _load());
    }
  }

  static int? _titleIdOf(Route<dynamic> route) {
    final args = route.settings.arguments;
    return args is Map ? args['titleId'] as int? : null;
  }

  void _open(BuildContext context, TitleModel title) {
    final current = ModalRoute.of(context);
    if (current != null && _titleIdOf(current) == title.id) return; // already here

    if (routeStack.any((route) => _titleIdOf(route) == title.id)) {
      Navigator.popUntil(context, (route) => _titleIdOf(route) == title.id);
    } else if (routeStack.length <= 1) {
      context.pushNamed(ContentViewerScreen.routeName, arguments: {"titleId": title.id});
    } else {
      Navigator.of(context).pushReplacementNamed(
        ContentViewerScreen.routeName,
        arguments: {"titleId": title.id},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _titles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Skeletonizer(
            child: _Trail(
              titles: titleModelDummyData.take(widget.mode == BreadcrumbMode.current ? 1 : 2).toList(),
              mode: widget.mode,
              onTap: (_) {},
            ),
          );
        }
        final titles = snapshot.data ?? const <TitleModel>[];
        if (titles.isEmpty) return const SizedBox.shrink();
        return _Trail(titles: titles, mode: widget.mode, onTap: (t) => _open(context, t));
      },
    );
  }
}

/// The chain as one rich text: each level is a span with its own tap
/// recognizer, separated by `›` (or gold `•` in the chapter opening). One
/// text flows and wraps like a sentence, so it takes far less room than a
/// row of buttons.
class _Trail extends StatefulWidget {
  const _Trail({required this.titles, required this.mode, required this.onTap});

  final List<TitleModel> titles;
  final BreadcrumbMode mode;
  final ValueChanged<TitleModel> onTap;

  @override
  State<_Trail> createState() => _TrailState();
}

class _TrailState extends State<_Trail> {
  List<TapGestureRecognizer> _recognizers = const [];

  @override
  void initState() {
    super.initState();
    _createRecognizers();
  }

  @override
  void didUpdateWidget(covariant _Trail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.titles != widget.titles) {
      _disposeRecognizers();
      _createRecognizers();
    }
  }

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  void _createRecognizers() {
    _recognizers = [
      for (final title in widget.titles) TapGestureRecognizer()..onTap = () => widget.onTap(title),
    ];
  }

  void _disposeRecognizers() {
    for (final r in _recognizers) {
      r.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final mode = widget.mode;
    final titles = widget.titles;
    final isOpening = mode == BreadcrumbMode.opening;

    final base = theme.textTheme.labelMedium?.copyWith(
      color: colors.onSurfaceVariant,
      height: 1.7,
    );
    // The no-break spaces (\u00A0) glue the separator to the next level, so
    // when the path wraps the new line starts with "• …" instead of a dot
    // dangling at the end of the previous one.
    final separator = TextSpan(
      text: isOpening ? '  •\u00A0\u00A0' : '  ›\u00A0\u00A0',
      style: TextStyle(
        color: isOpening ? manuscriptGold(context) : colors.outline,
        fontWeight: FontWeight.bold,
      ),
    );

    return Text.rich(
      TextSpan(
        style: base,
        children: [
          for (var i = 0; i < titles.length; i++) ...[
            if (i > 0) separator,
            TextSpan(
              text: titles[i].name,
              recognizer: _recognizers[i],
              // In the full chain the last level is the item itself.
              style: mode == BreadcrumbMode.full && i == titles.length - 1
                  ? TextStyle(color: colors.primary, fontWeight: FontWeight.w600)
                  : null,
            ),
          ],
        ],
      ),
      // Always the whole path, wrapping as needed. (No `overflow: ellipsis`:
      // with no maxLines it would silently cut the text to one line.)
      textAlign: isOpening ? TextAlign.center : TextAlign.start,
    );
  }
}
