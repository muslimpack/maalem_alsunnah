import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/controller/bloc/bookmarks_bloc.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/components/title_card.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/controller/cubit/home_cubit.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarksBloc, BookmarksState>(
      builder: (context, state) {
        if (state is! BookmarksLoadedState) {
          return const Center(child: CircularProgressIndicator());
        }

        final homeState = context.read<HomeCubit>().state;
        if (homeState is! HomeLoadedState) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: state.favoriteTitles.length,
          itemBuilder: (context, index) {
            final title = state.favoriteTitles[index];
            return TitleCard(title: title);
          },
        );
      },
    );
  }
}
