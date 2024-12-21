// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:equatable/equatable.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/repository/hadith_db_helper.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HadithDbHelper hadithDbHelper;

  HomeCubit(this.hadithDbHelper) : super(HomeLoadingState());

  Future start() async {
    final maqassedList = await hadithDbHelper.getAllMaqassed();

    emit(
      HomeLoadedState(
        maqassedList: maqassedList,
        searchList: [],
        listToView: maqassedList,
        tabIndex: 0,
        search: false,
      ),
    );
  }

  Future toggleSearch(bool search) async {
    final state = this.state;
    if (state is! HomeLoadedState) return;

    emit(state.copyWith(search: search));
  }

  Future tabIndexChanged(int tabIndex) async {
    final state = this.state;
    if (state is! HomeLoadedState) return;

    emit(state.copyWith(tabIndex: tabIndex));
  }

  @override
  Future<void> close() {
    EasyDebounce.cancelAll();
    return super.close();
  }
}
