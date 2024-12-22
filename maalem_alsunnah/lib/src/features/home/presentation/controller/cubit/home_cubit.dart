// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:equatable/equatable.dart';
import 'package:maalem_alsunnah/src/core/functions/print.dart';
import 'package:maalem_alsunnah/src/core/models/wrapped.dart';
import 'package:maalem_alsunnah/src/features/home/domain/repository/home_repo.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/repository/hadith_db_helper.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HadithDbHelper hadithDbHelper;
  final HomeRepo homeRepo;

  HomeCubit(
    this.hadithDbHelper,
    this.homeRepo,
  ) : super(HomeLoadingState());

  Future start() async {
    final maqassedList = await hadithDbHelper.getAllMaqassed();

    TitleModel? lastReadTitle;
    final lastReadTitleId = homeRepo.lastReadTitleId;
    if (lastReadTitleId != null) {
      lastReadTitle = await hadithDbHelper.getTitleById(lastReadTitleId);
    }
    appPrint(lastReadTitle);
    emit(
      HomeLoadedState(
        maqassedList: maqassedList,
        search: false,
        tabIndex: 0,
        lastReadTitle: lastReadTitle,
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

  Future updateLastReadTitle(int titleId) async {
    final state = this.state;
    if (state is! HomeLoadedState) return;

    TitleModel? lastReadTitle;
    lastReadTitle = await hadithDbHelper.getTitleById(titleId);
    await homeRepo.setLastReadTitleId(titleId);

    appPrint(lastReadTitle);

    emit(state.copyWith(lastReadTitle: Wrapped.value(lastReadTitle)));
  }

  @override
  Future<void> close() {
    EasyDebounce.cancelAll();
    return super.close();
  }
}
