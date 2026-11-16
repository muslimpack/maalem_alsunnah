import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/di/dependency_injection.dart';
import 'package:maalem_alsunnah/src/core/extensions/extension_platform.dart';
import 'package:maalem_alsunnah/src/core/extensions/safe_padding_extension.dart';
import 'package:maalem_alsunnah/src/core/utils/rich_text_controller.dart';
import 'package:maalem_alsunnah/src/core/widgets/text_styling_bar.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/data_source/bookmark_repository.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_type.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/controller/bloc/bookmarks_bloc.dart';

/// Opens the note editor: a bottom sheet on phones (so the styling bar sits
/// right above the keyboard) and a dialog elsewhere. The note is saved
/// automatically however the editor is closed.
Future<void> showNoteDialog(
  BuildContext context, {
  required String itemId,
  required BookmarkType type,
}) {
  final editor = NoteDialog(itemId: itemId, type: type);

  if (PlatformExtension.isPhone) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: sheetBottomInset(context)),
        child: editor,
      ),
    );
  }

  return showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      clipBehavior: Clip.antiAlias,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 580,
          maxHeight: MediaQuery.sizeOf(context).height * 0.8,
        ),
        child: editor,
      ),
    ),
  );
}

class NoteDialog extends StatefulWidget {
  final String itemId;
  final BookmarkType type;

  const NoteDialog({
    super.key,
    required this.itemId,
    required this.type,
  });

  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  final RichTextController _controller = RichTextController();
  bool _isLoading = true;

  /// The note as loaded (normalized through the controller), used to skip
  /// saving when nothing changed.
  String _initialNote = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bookmark = await sl<BookmarkRepository>().isExist(
      itemId: widget.itemId,
      type: widget.type,
    );
    if (!mounted) return;

    if (bookmark != null && bookmark.note.isNotEmpty) {
      _controller.loadHtml(bookmark.note);
    }
    _initialNote = _controller.toHtml().trim();
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    // Every way of closing (Done, ✕, scrim, back, drag) ends up here.
    _saveIfChanged();
    _controller.dispose();
    super.dispose();
  }

  void _saveIfChanged() {
    if (_isLoading) return;
    final note = _controller.toHtml().trim();
    if (note == _initialNote) return;
    sl<BookmarksBloc>().add(
      BookmarksNoteEvent(itemId: widget.itemId, type: widget.type, note: note),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isPhone = PlatformExtension.isPhone;

    if (_isLoading) {
      return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 8, 4),
          child: Row(
            children: [
              Icon(Icons.edit_note_rounded, color: colors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  S.of(context).notes,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                tooltip: S.of(context).close,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),

        // Editor
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, _) => TextField(
                controller: _controller,
                autofocus: true,
                minLines: isPhone ? 5 : 8,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textDirection: _textDirection(context),
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                decoration: InputDecoration(
                  hintText: S.of(context).addNotes,
                  filled: true,
                  fillColor: colors.surfaceContainerLowest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colors.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colors.outlineVariant),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Stats
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 0),
          child: ListenableBuilder(
            listenable: _controller,
            builder: (context, _) => Text(
              S.of(context).noteStats(_controller.text.length, _wordCount),
              textAlign: TextAlign.end,
              style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
            ),
          ),
        ),

        // Toolbar + Done
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 16, 12),
          child: Row(
            children: [
              TextStylingBar(controller: _controller),
              const Spacer(),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(S.of(context).done),
              ),
            ],
          ),
        ),
      ],
    );
  }

  TextDirection _textDirection(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty) return Directionality.of(context);
    return intl.Bidi.startsWithRtl(text) ? TextDirection.rtl : TextDirection.ltr;
  }

  int get _wordCount {
    final text = _controller.text.trim();
    return text.isEmpty ? 0 : text.split(RegExp(r'\s+')).length;
  }
}
