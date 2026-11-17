import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/di/dependency_injection.dart';
import 'package:maalem_alsunnah/src/core/functions/show_toast.dart';
import 'package:maalem_alsunnah/src/core/utils/email_manager.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_type.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/components/note_dialog.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/controller/bloc/bookmarks_bloc.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/misspelling_dialog.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/hadith_model.dart';
import 'package:maalem_alsunnah/src/features/share/data/models/share_type.dart';
import 'package:maalem_alsunnah/src/features/share/presentation/components/share_dialog.dart';

enum _HadithAction { note, toggleRead, copy, share, report }

/// The ⋮ menu of a hadith: note, read state, copy, share, report.
class HadithCardPopupMenu extends StatelessWidget {
  final HadithModel hadith;
  const HadithCardPopupMenu({super.key, required this.hadith});

  bool _isRead(BuildContext context) {
    final state = context.read<BookmarksBloc>().state;
    if (state is! BookmarksLoadedState) return false;
    return state.bookmarks.any(
      (b) => b.itemId == hadith.id && b.type == BookmarkType.hadith && b.isRead,
    );
  }

  Future<void> _onSelected(BuildContext context, _HadithAction action) async {
    switch (action) {
      case _HadithAction.note:
        await showNoteDialog(context, itemId: hadith.id, type: BookmarkType.hadith);
      case _HadithAction.toggleRead:
        sl<BookmarksBloc>().add(
          BookmarksMarkItemAsReadEvent(
            itemId: hadith.id,
            type: BookmarkType.hadith,
            isRead: !_isRead(context),
          ),
        );
      case _HadithAction.copy:
        // The full text keeps the number, source and reference.
        await Clipboard.setData(ClipboardData(text: hadith.text));
        await showToast(msg: S.current.copiedToClipboard);
      case _HadithAction.share:
        await showShareDialog(context, shareType: ShareType.hadith, itemId: hadith.id);
      case _HadithAction.report:
        final correction = await showMisspellingDialog(context);
        if (correction == null) return;
        await EmailManager.sendMisspelled(hadith: hadith, correction: correction);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return PopupMenuButton<_HadithAction>(
      icon: const Icon(Icons.more_vert),
      onSelected: (action) => _onSelected(context, action),
      itemBuilder: (context) {
        final isRead = _isRead(context);
        return [
          _item(_HadithAction.note, Icons.edit_note_rounded, s.addNotes),
          _item(
            _HadithAction.toggleRead,
            isRead ? Icons.remove_done : Icons.done,
            isRead ? s.markAsUnread : s.markAsRead,
          ),
          _item(_HadithAction.copy, Icons.copy_rounded, s.copy),
          _item(_HadithAction.share, Icons.share_outlined, s.share),
          const PopupMenuDivider(),
          _item(_HadithAction.report, Icons.report_gmailerrorred, s.reportMisspelled),
        ];
      },
    );
  }

  static PopupMenuItem<_HadithAction> _item(_HadithAction value, IconData icon, String label) {
    return PopupMenuItem(
      value: value,
      child: Row(
        spacing: 12,
        children: [Icon(icon, size: 20), Text(label)],
      ),
    );
  }
}
