// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:equatable/equatable.dart';
import 'package:maalem_alsunnah/src/features/home/data/models/hadith_ruling_enum.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/hadith.dart';
import 'package:maalem_alsunnah/src/features/search/data/repository/hadith_db_helper.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HadithDbHelper hadithDbHelper;

  HomeCubit(this.hadithDbHelper) : super(HomeLoadingState());

  Future start() async {
    final authenticHadith = await hadithDbHelper.randomHadith(
      HadithRulingEnum.authentic,
    );
    final weakHadith = await hadithDbHelper.randomHadith(
      HadithRulingEnum.weak,
    );
    final abandonedHadith = await hadithDbHelper.randomHadith(
      HadithRulingEnum.abandoned,
    );
    final fabricatedHadith = await hadithDbHelper.randomHadith(
      HadithRulingEnum.fabricated,
    );

    emit(
      HomeLoadedState(
        authenticHadith: authenticHadith,
        weakHadith: weakHadith,
        abandonedHadith: abandonedHadith,
        fabricatedHadith: fabricatedHadith,
        search: false,
      ),
    );
  }

  Future refresh() async {
    final state = this.state;
    if (state is! HomeLoadedState) return;

    final authenticHadith = await hadithDbHelper.randomHadith(
      HadithRulingEnum.authentic,
    );
    final weakHadith = await hadithDbHelper.randomHadith(
      HadithRulingEnum.weak,
    );
    final abandonedHadith = await hadithDbHelper.randomHadith(
      HadithRulingEnum.abandoned,
    );
    final fabricatedHadith = await hadithDbHelper.randomHadith(
      HadithRulingEnum.fabricated,
    );

    emit(
      state.copyWith(
        authenticHadith: authenticHadith,
        weakHadith: weakHadith,
        abandonedHadith: abandonedHadith,
        fabricatedHadith: fabricatedHadith,
      ),
    );
  }

  Future toggleSearch(bool search) async {
    final state = this.state;
    if (state is! HomeLoadedState) return;

    emit(state.copyWith(search: search));
  }

  @override
  Future<void> close() {
    EasyDebounce.cancelAll();
    return super.close();
  }
}
