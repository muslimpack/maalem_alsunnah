// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/data/models/bookmark_view_enum.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/controller/bloc/bookmarks_bloc.dart';

class BookmarkViewBar extends StatelessWidget {
  const BookmarkViewBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarksBloc, BookmarksState>(
      builder: (context, state) {
        if (state is! BookmarksLoadedState) return const SizedBox.shrink();
        return Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 10,
          spacing: 10,
          children: BookmarkViewEnum.values.map((e) {
            return ChoiceChip(
              label: Text(
                e.localeName(context),
              ),
              showCheckmark: false,
              selected: state.bookmarkView == e,
              onSelected: (value) async {
                context
                    .read<BookmarksBloc>()
                    .add(BookmarksChangeViewEvent(bookmarkView: e));
              },
            );
          }).toList(),
        );
      },
    );
  }
}
