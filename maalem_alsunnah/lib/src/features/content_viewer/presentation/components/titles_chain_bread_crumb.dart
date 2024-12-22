// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:maalem_alsunnah/src/core/di/dependency_injection.dart';
import 'package:maalem_alsunnah/src/core/extensions/extension.dart';
import 'package:maalem_alsunnah/src/core/functions/print.dart';
import 'package:maalem_alsunnah/src/core/utils/app_nav_observer.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/screens/content_viewer_screen.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/repository/hadith_db_helper.dart';

class TitlesChainBreadCrumb extends StatefulWidget {
  const TitlesChainBreadCrumb({
    super.key,
    required this.titleId,
  });

  final int titleId;

  @override
  State<TitlesChainBreadCrumb> createState() => _TitlesChainBreadCrumbState();
}

class _TitlesChainBreadCrumbState extends State<TitlesChainBreadCrumb> {
  late Future<List<TitleModel>> titlesChains;
  @override
  void initState() {
    super.initState();
    titlesChains = _updateAndGetList();
  }

  void refreshList() {
    setState(() {
      titlesChains = _updateAndGetList();
    });
  }

  Future<List<TitleModel>> _updateAndGetList() async {
    return sl<HadithDbHelper>().getTitleChain(widget.titleId);
  }

  @override
  void didUpdateWidget(covariant TitlesChainBreadCrumb oldWidget) {
    if (oldWidget.titleId != widget.titleId) {
      refreshList();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: titlesChains,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: LinearProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
            ),
          );
        } else {
          return TitlesChainRichTextBuilder(titlesChains: snapshot.data!);
        }
      },
    );
  }
}

class TitlesChainRichTextBuilder extends StatelessWidget {
  const TitlesChainRichTextBuilder({
    super.key,
    required this.titlesChains,
  });

  final List<TitleModel> titlesChains;

  void onPressed(BuildContext context, int index, TitleModel title) {
    bool titleFoundInStack = false;
    for (var route in routeStack) {
      final int? routeTitleId = route.settings.arguments as int?;
      if (routeTitleId != null && title.id == routeTitleId) {
        titleFoundInStack = true;
        break;
      }
      appPrint(title);
    }
    if (titleFoundInStack) {
      Navigator.popUntil(
          context, (r) => (r.settings.arguments as int) == title.id);
    } else {
      if (routeStack.length <= 1) {
        context.pushNamed(
          ContentViewerScreen.routeName,
          arguments: title.id,
        );
      } else {
        Navigator.of(context).pushReplacementNamed(
          ContentViewerScreen.routeName,
          arguments: title.id,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<InlineSpan> spans = titlesChains.map((title) {
      return TextSpan(
        text: title.name,
        style: TextStyle(
          fontSize: 15,
          color: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.bold,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap =
              () => onPressed(context, titlesChains.indexOf(title), title),
      );
    }).toList();

    // The item to insert between the spans
    final InlineSpan separator = WidgetSpan(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text("/"),
    ));

// Interleave the separator between the spans
    final List<InlineSpan> interleavedSpans = spans.expand((span) sync* {
      yield span;
      if (span != spans.last) {
        yield separator;
      }
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text.rich(TextSpan(children: interleavedSpans)),
    );
  }
}

class TitlesChainBreadCrumbBuilder extends StatelessWidget {
  const TitlesChainBreadCrumbBuilder({
    super.key,
    required this.titlesChains,
  });

  final List<TitleModel> titlesChains;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: BreadCrumb.builder(
        itemCount: titlesChains.length,
        builder: (index) {
          return BreadCrumbItem(
            content: BreadCrumbItemBuilder(
              index: index,
              titlesChains: titlesChains,
              onPressed: (index, title) {
                bool titleFoundInStack = false;
                for (var route in routeStack) {
                  final int? routeTitleId = route.settings.arguments as int?;
                  if (routeTitleId != null && title.id == routeTitleId) {
                    titleFoundInStack = true;
                    break;
                  }
                  appPrint(title);
                }
                if (titleFoundInStack) {
                  Navigator.popUntil(context,
                      (r) => (r.settings.arguments as int) == title.id);
                } else {
                  if (routeStack.length <= 1) {
                    context.pushNamed(
                      ContentViewerScreen.routeName,
                      arguments: title.id,
                    );
                  } else {
                    Navigator.of(context).pushReplacementNamed(
                      ContentViewerScreen.routeName,
                      arguments: title.id,
                    );
                  }
                }
              },
            ),
          );
        },
        divider: Text(
          '/',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

class BreadCrumbItemBuilder extends StatelessWidget {
  final int index;
  final List<TitleModel> titlesChains;
  final Function(int index, TitleModel title)? onPressed;
  const BreadCrumbItemBuilder({
    super.key,
    required this.index,
    required this.titlesChains,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final title = titlesChains[index];

    if (index == 0) {
      return TextButton(
        child: Text(
          title.name,
        ),
        onPressed: () {
          onPressed?.call(index, title);
        },
      );
    } else if (index == titlesChains.length - 1) {
      return TextButton(
        child: Text(
          title.name,
        ),
        onPressed: () {
          onPressed?.call(index, title);
        },
      );
    }
    return TextButton(
      child: Text(
        title.name,
      ),
      onPressed: () {
        onPressed?.call(index, title);
      },
    );
  }
}
