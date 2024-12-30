import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/constants/constant.dart';
import 'package:maalem_alsunnah/src/core/di/dependency_injection.dart'
    as service_locator;
import 'package:maalem_alsunnah/src/core/di/dependency_injection.dart';
import 'package:maalem_alsunnah/src/core/extensions/extension_platform.dart';
import 'package:maalem_alsunnah/src/core/functions/print.dart';
import 'package:maalem_alsunnah/src/core/utils/app_bloc_observer.dart';
import 'package:maalem_alsunnah/src/features/themes/data/repository/theme_repo.dart';
import 'package:maalem_alsunnah/src/features/ui/data/repository/ui_repo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';

Future<void> initServices() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = AppBlocObserver();

  await service_locator.initSL();

  if (PlatformExtension.isDesktopOrWeb) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await initHive();

  await loadLocalizations();

  await phoneDeviceBars();

  await initWindowsManager();
}

Future phoneDeviceBars() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

Future initWindowsManager() async {
  if (!PlatformExtension.isDesktop) return;

  await windowManager.ensureInitialized();

  final WindowOptions windowOptions = WindowOptions(
    size: sl<UIRepo>().desktopWindowSize,
    center: true,
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setTitleBarStyle(
      TitleBarStyle.hidden,
      windowButtonVisibility: false,
    );
    await windowManager.show();
    await windowManager.focus();
  });
}

Future loadLocalizations() async {
  Locale? localeToSet = sl<ThemeRepo>().appLocale;
  final languageCode = PlatformExtension.languageCode;
  localeToSet ??= Locale.fromSubtags(languageCode: languageCode ?? "ar");
  await S.load(localeToSet);
}

Future initHive() async {
  final String? path;
  if (!kIsWeb) {
    final dir = await getApplicationSupportDirectory();
    path = dir.path;
  } else {
    path = null;
  }

  appPrint(path);

  Hive.init(path);
  await Hive.initFlutter();
  await Hive.openBox(kHiveBoxName, path: path);
}
