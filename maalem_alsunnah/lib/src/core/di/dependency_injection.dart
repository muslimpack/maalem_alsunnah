import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:maalem_alsunnah/src/core/constants/constant.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/controller/cubit/home_cubit.dart';
import 'package:maalem_alsunnah/src/features/search/data/repository/hadith_db_helper.dart';
import 'package:maalem_alsunnah/src/features/search/domain/repository/search_repo.dart';
import 'package:maalem_alsunnah/src/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:maalem_alsunnah/src/features/settings/domain/repository/text_font_repo.dart';
import 'package:maalem_alsunnah/src/features/settings/presentation/controller/cubit/settings_cubit.dart';
import 'package:maalem_alsunnah/src/features/share/presentation/controller/cubit/share_image_cubit.dart';
import 'package:maalem_alsunnah/src/features/themes/data/repository/theme_repo.dart';
import 'package:maalem_alsunnah/src/features/themes/presentation/controller/cubit/theme_cubit.dart';
import 'package:maalem_alsunnah/src/features/ui/data/repository/ui_repo.dart';

final sl = GetIt.instance;

Future<void> initSL() async {
  ///MARK: Init storages
  sl.registerLazySingleton(() => Hive.box(kHiveBoxName));
  sl.registerLazySingleton(() => UIRepo(sl()));
  sl.registerLazySingleton(() => ThemeRepo(sl()));
  sl.registerLazySingleton(() => TextFontRepo(sl()));
  sl.registerLazySingleton(() => SearchRepo(sl()));

  ///MARK: Init Repo
  sl.registerLazySingleton(() => HadithDbHelper());

  ///MARK: Init Manager

  ///MARK: Init BLOC

  /// Singleton BLoC
  sl.registerLazySingleton(() => SettingsCubit(sl()));
  sl.registerLazySingleton(() => ThemeCubit(sl()));
  sl.registerLazySingleton(() => SearchCubit(sl(), sl()));
  sl.registerLazySingleton(() => HomeCubit(sl()));

  /// Factory BLoC
  sl.registerFactory(() => ShareImageCubit());
}