// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/di/dependency_injection.dart';
import 'package:maalem_alsunnah/src/core/shared/custom_field_decoration.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/data_source/bookmark_repository.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_model.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_type.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/controller/bloc/bookmarks_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

Future showNoteDialog(BuildContext context,
    {required int itemId, required BookmarkType type}) {
  return showDialog(
    context: context,
    builder: (context) {
      return NoteDialog(itemId: itemId, type: type);
    },
  );
}

class NoteDialog extends StatefulWidget {
  final int itemId;
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
  late final BookmarkModel? bookmark;
  bool isLoading = true;

  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();

    init();
  }

  Future init() async {
    bookmark = await sl<BookmarkRepository>()
        .isExist(itemId: widget.itemId, type: widget.type);

    _noteController = TextEditingController(text: bookmark?.note);

    setState(() {
      isLoading = false;
    });
  }

  BookmarkModel get bookmarkModel {
    return bookmark ??= BookmarkModel(
      itemId: widget.itemId,
      type: widget.type,
      isBookmarked: false,
      isRead: false,
      note: "",
      addedDate: DateTime.now(),
      updateDate: DateTime.now(),
    );
  }

  Future onClear() async {
    _noteController.clear();
  }

  Future onDone() async {
    Navigator.of(context).pop();
    sl<BookmarksBloc>().add(BookmarksNoteEvent(
      itemId: widget.itemId,
      type: widget.type,
      note: _noteController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 200),
      child: AlertDialog(
        scrollable: true,
        contentPadding: const EdgeInsets.all(10),
        title: Text(S.of(context).notes),
        content: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                constraints: const BoxConstraints(maxHeight: 350),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: _noteController,
                    maxLines: null,
                    decoration: customInputDecoration,
                  ),
                ),
              ),
        actions: [
          IconButton(
            tooltip: S.of(context).clear,
            icon: Icon(MdiIcons.eraser),
            onPressed: onClear,
          ),
          IconButton(
            tooltip: S.of(context).apply,
            icon: const Icon(Icons.done_all_rounded),
            onPressed: onDone,
          ),
        ],
      ),
    );
  }
}
