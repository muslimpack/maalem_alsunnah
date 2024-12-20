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

  final bool search;

  const HomeLoadedState({
    required this.maqassedList,
    required this.search,
  });

  HomeLoadedState copyWith({
    List<TitleModel>? maqassedList,
    bool? search,
  }) {
    return HomeLoadedState(
      maqassedList: maqassedList ?? this.maqassedList,
      search: search ?? this.search,
    );
  }

  @override
  List<Object?> get props => [
        maqassedList,
        search,
      ];
}
