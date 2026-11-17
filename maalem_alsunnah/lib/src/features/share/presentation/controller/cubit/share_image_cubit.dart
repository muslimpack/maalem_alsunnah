import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:bloc/bloc.dart';
import 'package:capture_widget/capture_widget.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/src/core/extensions/extension_platform.dart';
import 'package:maalem_alsunnah/src/core/functions/print.dart';
import 'package:maalem_alsunnah/src/core/models/wrapped.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/data/error_reporter.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/repository/hadith_db_helper.dart';
import 'package:maalem_alsunnah/src/features/share/data/models/share_image_aspect.dart';
import 'package:maalem_alsunnah/src/features/share/data/models/share_image_settings.dart';
import 'package:maalem_alsunnah/src/features/share/data/models/share_image_theme.dart';
import 'package:maalem_alsunnah/src/features/share/data/models/share_type.dart';
import 'package:maalem_alsunnah/src/features/share/data/repository/share_image_settings_repo.dart';
import 'package:maalem_alsunnah/src/features/share/domain/share_image_layout.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

part 'share_image_state.dart';

enum ShareImageExportResult { shared, saved, cancelled, failed }

class ShareImageCubit extends Cubit<ShareImageState> {
  /// Exported images are the 1080-wide canvas at twice its size.
  static const double exportPixelRatio = 2;

  final HadithDbHelper hadithDbHelper;
  final ShareImageSettingsRepo settingsRepo;
  final PageController pageController = PageController();

  Brightness _appBrightness = Brightness.dark;

  ShareImageCubit(this.hadithDbHelper, this.settingsRepo) : super(ShareImageLoadingState());

  Future<void> start({
    required String itemId,
    required ShareType shareType,
    required Brightness appBrightness,
  }) async {
    _appBrightness = appBrightness;

    final String text;
    final List<TitleModel> titleChain;
    switch (shareType) {
      case ShareType.content:
        final content = await hadithDbHelper.getContentById(int.parse(itemId));
        text = content.text;
        // A content item is its title's text, so the last title is left out.
        final chain = await hadithDbHelper.getTitleChain(content.titleId);
        titleChain = chain.isEmpty ? chain : chain.sublist(0, chain.length - 1);
      case ShareType.hadith:
        final hadith = (await hadithDbHelper.getHadithById(itemId))!;
        text = hadith.text;
        titleChain = await hadithDbHelper.getTitleChain(hadith.titleId);
    }

    final settings = settingsRepo.settings;
    final theme = settings.theme(_appBrightness);
    final showTitleChain = settings.showTitleChain && titleChain.isNotEmpty;

    if (isClosed) return;
    emit(
      ShareImageLoadedState(
        itemId: itemId,
        shareType: shareType,
        text: text,
        titleChain: titleChain,
        settings: settings,
        theme: theme,
        pagination: _paginate(text, theme, settings, showTitleChain: showTitleChain),
        activeIndex: 0,
        progress: null,
      ),
    );
  }

  ShareImagePagination _paginate(
    String text,
    ShareImageTheme theme,
    ShareImageSettings settings, {
    required bool showTitleChain,
  }) {
    return TextPaginator.layout(
      text: text,
      theme: theme,
      fontSize: settings.fontSize,
      aspect: settings.aspect,
      showTitleChain: showTitleChain,
    );
  }

  /// MARK: Settings

  void setPalette(ShareImagePalette palette) => _update((s) => s.copyWith(palette: palette));

  void setBrightness(Brightness brightness) => _update((s) => s.copyWith(brightness: brightness));

  void setAspect(ShareImageAspect aspect) => _update((s) => s.copyWith(aspect: aspect));

  void increaseFontSize() => _update(
        (s) => s.copyWith(fontSize: s.fontSize + ShareImageSettings.fontSizeStep),
      );

  void decreaseFontSize() => _update(
        (s) => s.copyWith(fontSize: s.fontSize - ShareImageSettings.fontSizeStep),
      );

  void toggleTitleChain() => _update((s) => s.copyWith(showTitleChain: !s.showTitleChain));

  void _update(ShareImageSettings Function(ShareImageSettings) change) {
    final state = this.state;
    if (state is! ShareImageLoadedState || state.isExporting) return;

    final settings = change(state.settings);
    if (settings == state.settings) return;
    unawaited(settingsRepo.setSettings(settings));

    final theme = settings.theme(_appBrightness);

    // Colours alone don't move any text.
    final layoutChanged = settings.aspect != state.settings.aspect ||
        settings.fontSize != state.settings.fontSize ||
        settings.showTitleChain != state.settings.showTitleChain;

    final pagination = layoutChanged
        ? _paginate(
            state.text,
            theme,
            settings,
            showTitleChain: settings.showTitleChain && state.titleChain.isNotEmpty,
          )
        : _recolor(state, theme, settings);

    final activeIndex = state.activeIndex.clamp(0, pagination.pages.length - 1);
    emit(
      state.copyWith(
        settings: settings,
        theme: theme,
        pagination: pagination,
        activeIndex: activeIndex,
      ),
    );

    if (pageController.hasClients && pageController.page?.round() != activeIndex) {
      pageController.jumpToPage(activeIndex);
    }
  }

  /// The same pages in a new theme's colours.
  ShareImagePagination _recolor(
    ShareImageLoadedState state,
    ShareImageTheme theme,
    ShareImageSettings settings,
  ) {
    final old = state.pagination;
    return ShareImagePagination(
      aspect: old.aspect,
      canvasSize: old.canvasSize,
      pages: old.pages,
      // Keep the font size the pages were measured at (a single page may
      // have grown past the chosen size).
      source: SharePageText.format(state.text, theme, old.source.style.fontSize!),
    );
  }

  void onPageChanged(int index) {
    final state = this.state;
    if (state is! ShareImageLoadedState) return;
    emit(state.copyWith(activeIndex: index));
  }

  /// MARK: Export

  /// Renders the current page, or every page when [all], and shares them
  /// (phones) or saves them to a folder the user picks (desktop).
  ///
  /// [pageBuilder] builds the card of a page. Pages are rendered off screen,
  /// so ones the user never scrolled to come out too. Images the card shows
  /// must be precached first.
  Future<ShareImageExportResult> export({
    required bool all,
    required Widget Function(int index) pageBuilder,
    Rect? shareOrigin,
  }) async {
    final state = this.state;
    if (state is! ShareImageLoadedState || state.isExporting) {
      return ShareImageExportResult.cancelled;
    }

    final indexes = all ? List.generate(state.pageCount, (i) => i) : [state.activeIndex];

    try {
      final files = <(String, List<int>)>[];
      for (var i = 0; i < indexes.length; i++) {
        _emitProgress((current: i + 1, total: indexes.length));

        final index = indexes[i];
        final image = await captureOffscreen(
          pageBuilder(index),
          logicalSize: state.pagination.canvasSize,
          pixelRatio: exportPixelRatio,
          textDirection: TextDirection.rtl,
        );
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        image.dispose();
        if (bytes == null) throw StateError("Page ${index + 1} has no image data");

        files.add((
          _fileName(state.itemId, index, state.pageCount),
          bytes.buffer.asUint8List(),
        ));
      }

      return PlatformExtension.isDesktop
          ? await _saveDesktop(files)
          : await _sharePhone(files, shareOrigin);
    } catch (e, stack) {
      ErrorReporter.instance.record(e, stack, where: 'ShareImageCubit');
      appPrint(e.toString());
      return ShareImageExportResult.failed;
    } finally {
      _emitProgress(null);
    }
  }

  void _emitProgress(ShareImageProgress? progress) {
    final state = this.state;
    if (isClosed || state is! ShareImageLoadedState) return;
    emit(state.copyWith(progress: Wrapped.value(progress)));
  }

  String _fileName(String itemId, int index, int count) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final page = count > 1 ? "_${index + 1}-of-$count" : "";
    return "maalem_alsunnah_$itemId${page}_$timestamp.png";
  }

  Future<ShareImageExportResult> _saveDesktop(List<(String, List<int>)> files) async {
    final String? dir = await FilePicker.platform.getDirectoryPath();
    if (dir == null) return ShareImageExportResult.cancelled;

    for (final (name, bytes) in files) {
      await File(path.join(dir, name)).writeAsBytes(bytes);
    }
    return ShareImageExportResult.saved;
  }

  Future<ShareImageExportResult> _sharePhone(
    List<(String, List<int>)> files,
    Rect? shareOrigin,
  ) async {
    // Old images are cleared before a new share, not right after one: the
    // app the user shares to may still be reading them.
    final dir = Directory(path.join((await getTemporaryDirectory()).path, "share_images"));
    if (dir.existsSync()) await dir.delete(recursive: true);
    await dir.create(recursive: true);

    final xFiles = <XFile>[];
    for (final (name, bytes) in files) {
      final file = await File(path.join(dir.path, name)).writeAsBytes(bytes);
      xFiles.add(XFile(file.path, mimeType: "image/png"));
    }

    final result = await SharePlus.instance.share(
      ShareParams(files: xFiles, sharePositionOrigin: shareOrigin),
    );
    return result.status == ShareResultStatus.dismissed
        ? ShareImageExportResult.cancelled
        : ShareImageExportResult.shared;
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
