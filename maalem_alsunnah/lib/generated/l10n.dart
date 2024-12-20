// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `About app`
  String get aboutApp {
    return Intl.message(
      'About app',
      name: 'aboutApp',
      desc: '',
      args: [],
    );
  }

  /// `#maalem_alsunnah`
  String get appHashtag {
    return Intl.message(
      '#maalem_alsunnah',
      name: 'appHashtag',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `Maalem Al-Sunnah`
  String get appTitle {
    return Intl.message(
      'Maalem Al-Sunnah',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Bookamarks`
  String get bookmarks {
    return Intl.message(
      'Bookamarks',
      name: 'bookmarks',
      desc: '',
      args: [],
    );
  }

  /// `Chat`
  String get chat {
    return Intl.message(
      'Chat',
      name: 'chat',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Continue reading`
  String get continueReading {
    return Intl.message(
      'Continue reading',
      name: 'continueReading',
      desc: '',
      args: [],
    );
  }

  /// `Copied to clipboard`
  String get copiedToClipboard {
    return Intl.message(
      'Copied to clipboard',
      name: 'copiedToClipboard',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get copy {
    return Intl.message(
      'Copy',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `Displayed results count`
  String get displayedResultsCount {
    return Intl.message(
      'Displayed results count',
      name: 'displayedResultsCount',
      desc: '',
      args: [],
    );
  }

  /// `Decrease font size`
  String get fontDecreaseSize {
    return Intl.message(
      'Decrease font size',
      name: 'fontDecreaseSize',
      desc: '',
      args: [],
    );
  }

  /// `Increase font size`
  String get fontIncreaseSize {
    return Intl.message(
      'Increase font size',
      name: 'fontIncreaseSize',
      desc: '',
      args: [],
    );
  }

  /// `Reset font size`
  String get fontResetSize {
    return Intl.message(
      'Reset font size',
      name: 'fontResetSize',
      desc: '',
      args: [],
    );
  }

  /// `Font settings`
  String get fontSettings {
    return Intl.message(
      'Font settings',
      name: 'fontSettings',
      desc: '',
      args: [],
    );
  }

  /// `Free, ad-free and open source app`
  String get freeAdFreeAndOpenSourceApp {
    return Intl.message(
      'Free, ad-free and open source app',
      name: 'freeAdFreeAndOpenSourceApp',
      desc: '',
      args: [],
    );
  }

  /// `Github source code`
  String get github {
    return Intl.message(
      'Github source code',
      name: 'github',
      desc: '',
      args: [],
    );
  }

  /// `Sheikh Saleh Ahmed Al Shami`
  String get hadithBookAuthor {
    return Intl.message(
      'Sheikh Saleh Ahmed Al Shami',
      name: 'hadithBookAuthor',
      desc: '',
      args: [],
    );
  }

  /// `Maalem Al-sunnah`
  String get hadithBookSource {
    return Intl.message(
      'Maalem Al-sunnah',
      name: 'hadithBookSource',
      desc: '',
      args: [],
    );
  }

  /// `The Prophetic Sunnah from the most authentic to the weakest`
  String get hadithBookSourceDesc {
    return Intl.message(
      'The Prophetic Sunnah from the most authentic to the weakest',
      name: 'hadithBookSourceDesc',
      desc: '',
      args: [],
    );
  }

  /// `Index`
  String get index {
    return Intl.message(
      'Index',
      name: 'index',
      desc: '',
      args: [],
    );
  }

  /// `Misspelled`
  String get misspelled {
    return Intl.message(
      'Misspelled',
      name: 'misspelled',
      desc: '',
      args: [],
    );
  }

  /// `That's it, there are no more results.`
  String get noMoreResultsMsg {
    return Intl.message(
      'That\'s it, there are no more results.',
      name: 'noMoreResultsMsg',
      desc: '',
      args: [],
    );
  }

  /// `No results found`
  String get noResultsFound {
    return Intl.message(
      'No results found',
      name: 'noResultsFound',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get notes {
    return Intl.message(
      'Notes',
      name: 'notes',
      desc: '',
      args: [],
    );
  }

  /// `Pray for us and our parents.`
  String get prayForUsAndParents {
    return Intl.message(
      'Pray for us and our parents.',
      name: 'prayForUsAndParents',
      desc: '',
      args: [],
    );
  }

  /// `App language`
  String get prefAppLanguage {
    return Intl.message(
      'App language',
      name: 'prefAppLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get prefThemeDarkMode {
    return Intl.message(
      'Dark Mode',
      name: 'prefThemeDarkMode',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message(
      'Refresh',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `Report misspelled`
  String get reportMisspelled {
    return Intl.message(
      'Report misspelled',
      name: 'reportMisspelled',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Search filters`
  String get searchFilters {
    return Intl.message(
      'Search filters',
      name: 'searchFilters',
      desc: '',
      args: [],
    );
  }

  /// `Search result count`
  String get searchResultCount {
    return Intl.message(
      'Search result count',
      name: 'searchResultCount',
      desc: '',
      args: [],
    );
  }

  /// `All words`
  String get searchTypeAllWords {
    return Intl.message(
      'All words',
      name: 'searchTypeAllWords',
      desc: '',
      args: [],
    );
  }

  /// `Any words`
  String get searchTypeAnyWords {
    return Intl.message(
      'Any words',
      name: 'searchTypeAnyWords',
      desc: '',
      args: [],
    );
  }

  /// `Typical`
  String get SearchTypeTypical {
    return Intl.message(
      'Typical',
      name: 'SearchTypeTypical',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Share as image`
  String get shareAsImage {
    return Intl.message(
      'Share as image',
      name: 'shareAsImage',
      desc: '',
      args: [],
    );
  }

  /// `Show diacritics`
  String get showDiacritics {
    return Intl.message(
      'Show diacritics',
      name: 'showDiacritics',
      desc: '',
      args: [],
    );
  }

  /// `Source`
  String get source {
    return Intl.message(
      'Source',
      name: 'source',
      desc: '',
      args: [],
    );
  }

  /// `Book Author`
  String get sourceBookAuthor {
    return Intl.message(
      'Book Author',
      name: 'sourceBookAuthor',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
