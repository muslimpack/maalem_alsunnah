import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maalem_alsunnah/src/features/bookmarks/presentation/controller/bloc/bookmarks_bloc.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/controller/cubit/home_cubit.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

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
          itemCount: state.notes.length,
          itemBuilder: (context, index) {
            return Card(
              clipBehavior: Clip.hardEdge,
              child: ListTile(
                onTap: () {},
                leading: Icon(
                  Icons.library_books_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                subtitle: Text("Hadith $index"),
                title: Text("Hadith $index"),
                trailing: Icon(Icons.chevron_right_outlined),
              ),
            );
          },
        );
      },
    );
  }
}
