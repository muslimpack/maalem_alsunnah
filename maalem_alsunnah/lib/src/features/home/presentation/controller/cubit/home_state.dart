// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final List<TitleModel> maqassedList;

  final int tabIndex;

  final bool search;

  final TitleModel? lastReadTitle;

  const HomeLoadedState({
    required this.maqassedList,
    required this.tabIndex,
    required this.search,
    required this.lastReadTitle,
  });

  HomeLoadedState copyWith({
    List<TitleModel>? maqassedList,
    int? tabIndex,
    bool? search,
    Wrapped<TitleModel?>? lastReadTitle,
  }) {
    return HomeLoadedState(
      maqassedList: maqassedList ?? this.maqassedList,
      tabIndex: tabIndex ?? this.tabIndex,
      search: search ?? this.search,
      lastReadTitle:
          lastReadTitle != null ? lastReadTitle.value : this.lastReadTitle,
    );
  }

  @override
  List<Object?> get props => [
        maqassedList,
        tabIndex,
        search,
        lastReadTitle,
      ];
}
