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
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
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
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `About app`
  String get aboutApp {
    return Intl.message('About app', name: 'aboutApp', desc: '', args: []);
  }

  /// `Add bookmark`
  String get addBookmark {
    return Intl.message(
      'Add bookmark',
      name: 'addBookmark',
      desc: '',
      args: [],
    );
  }

  /// `Add notes`
  String get addNotes {
    return Intl.message('Add notes', name: 'addNotes', desc: '', args: []);
  }

  /// `Agreed upon`
  String get agreedUpon {
    return Intl.message('Agreed upon', name: 'agreedUpon', desc: '', args: []);
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
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
    return Intl.message('Apply', name: 'apply', desc: '', args: []);
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

  /// `Bold`
  String get bold {
    return Intl.message('Bold', name: 'bold', desc: '', args: []);
  }

  /// `Bookamarks`
  String get bookmarks {
    return Intl.message('Bookamarks', name: 'bookmarks', desc: '', args: []);
  }

  /// `al-Bukhari (mu'allaq)`
  String get bukhariMuallaq {
    return Intl.message(
      'al-Bukhari (mu\'allaq)',
      name: 'bukhariMuallaq',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Chapter {number}`
  String chapterNumber(Object number) {
    return Intl.message(
      'Chapter $number',
      name: 'chapterNumber',
      desc: '',
      args: [number],
    );
  }

  /// `Chapter {number} of {total}`
  String chapterOfTotal(Object number, Object total) {
    return Intl.message(
      'Chapter $number of $total',
      name: 'chapterOfTotal',
      desc: '',
      args: [number, total],
    );
  }

  /// `Chat`
  String get chat {
    return Intl.message('Chat', name: 'chat', desc: '', args: []);
  }

  /// `Clear`
  String get clear {
    return Intl.message('Clear', name: 'clear', desc: '', args: []);
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `Contact the developer`
  String get contactDeveloper {
    return Intl.message(
      'Contact the developer',
      name: 'contactDeveloper',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get contactMessage {
    return Intl.message('Message', name: 'contactMessage', desc: '', args: []);
  }

  /// `Write at least {min} characters`
  String contactMessageTooShort(Object min) {
    return Intl.message(
      'Write at least $min characters',
      name: 'contactMessageTooShort',
      desc: '',
      args: [min],
    );
  }

  /// `No email app found, the message was copied. Send it to {email}`
  String contactNoEmailApp(Object email) {
    return Intl.message(
      'No email app found, the message was copied. Send it to $email',
      name: 'contactNoEmailApp',
      desc: '',
      args: [email],
    );
  }

  /// `Send`
  String get contactSend {
    return Intl.message('Send', name: 'contactSend', desc: '', args: []);
  }

  /// `Include device info`
  String get contactShareDeviceInfo {
    return Intl.message(
      'Include device info',
      name: 'contactShareDeviceInfo',
      desc: '',
      args: [],
    );
  }

  /// `Contains no personal data. The following will be included:`
  String get contactShareDeviceInfoHint {
    return Intl.message(
      'Contains no personal data. The following will be included:',
      name: 'contactShareDeviceInfoHint',
      desc: '',
      args: [],
    );
  }

  /// `Message type`
  String get contactType {
    return Intl.message(
      'Message type',
      name: 'contactType',
      desc: '',
      args: [],
    );
  }

  /// `Bug report`
  String get contactTypeBug {
    return Intl.message(
      'Bug report',
      name: 'contactTypeBug',
      desc: '',
      args: [],
    );
  }

  /// `Content error`
  String get contactTypeContentError {
    return Intl.message(
      'Content error',
      name: 'contactTypeContentError',
      desc: '',
      args: [],
    );
  }

  /// `Feature request`
  String get contactTypeFeatureRequest {
    return Intl.message(
      'Feature request',
      name: 'contactTypeFeatureRequest',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get contactTypeOther {
    return Intl.message('Other', name: 'contactTypeOther', desc: '', args: []);
  }

  /// `Question`
  String get contactTypeQuestion {
    return Intl.message(
      'Question',
      name: 'contactTypeQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Choose a message type`
  String get contactTypeRequired {
    return Intl.message(
      'Choose a message type',
      name: 'contactTypeRequired',
      desc: '',
      args: [],
    );
  }

  /// `Content number`
  String get contentNumber {
    return Intl.message(
      'Content number',
      name: 'contentNumber',
      desc: '',
      args: [],
    );
  }

  /// `Content {current} of {total}`
  String contentXofY(Object current, Object total) {
    return Intl.message(
      'Content $current of $total',
      name: 'contentXofY',
      desc: '',
      args: [current, total],
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
    return Intl.message('Copy', name: 'copy', desc: '', args: []);
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

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `Back to home`
  String get errorBackHome {
    return Intl.message(
      'Back to home',
      name: 'errorBackHome',
      desc: '',
      args: [],
    );
  }

  /// `Sorry about that. Sending the error report helps us fix it.`
  String get errorBody {
    return Intl.message(
      'Sorry about that. Sending the error report helps us fix it.',
      name: 'errorBody',
      desc: '',
      args: [],
    );
  }

  /// `Copy details`
  String get errorCopyDetails {
    return Intl.message(
      'Copy details',
      name: 'errorCopyDetails',
      desc: '',
      args: [],
    );
  }

  /// `What were you doing when it happened? (optional)`
  String get errorDescribe {
    return Intl.message(
      'What were you doing when it happened? (optional)',
      name: 'errorDescribe',
      desc: '',
      args: [],
    );
  }

  /// `The app hit an error last time and the report wasn't sent. Would you like to send it?`
  String get errorPendingBody {
    return Intl.message(
      'The app hit an error last time and the report wasn\'t sent. Would you like to send it?',
      name: 'errorPendingBody',
      desc: '',
      args: [],
    );
  }

  /// `Not now`
  String get errorPendingDismiss {
    return Intl.message(
      'Not now',
      name: 'errorPendingDismiss',
      desc: '',
      args: [],
    );
  }

  /// `Send report`
  String get errorPendingSend {
    return Intl.message(
      'Send report',
      name: 'errorPendingSend',
      desc: '',
      args: [],
    );
  }

  /// `Unsent error report`
  String get errorPendingTitle {
    return Intl.message(
      'Unsent error report',
      name: 'errorPendingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Report copied`
  String get errorReportCopied {
    return Intl.message(
      'Report copied',
      name: 'errorReportCopied',
      desc: '',
      args: [],
    );
  }

  /// `Send this report to {email}`
  String errorReportShareText(Object email) {
    return Intl.message(
      'Send this report to $email',
      name: 'errorReportShareText',
      desc: '',
      args: [email],
    );
  }

  /// `Send error report`
  String get errorSendReport {
    return Intl.message(
      'Send error report',
      name: 'errorSendReport',
      desc: '',
      args: [],
    );
  }

  /// `Show details`
  String get errorShowDetails {
    return Intl.message(
      'Show details',
      name: 'errorShowDetails',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get errorTitle {
    return Intl.message(
      'Something went wrong',
      name: 'errorTitle',
      desc: '',
      args: [],
    );
  }

  /// `First`
  String get first {
    return Intl.message('First', name: 'first', desc: '', args: []);
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

  /// `Go`
  String get goTo {
    return Intl.message('Go', name: 'goTo', desc: '', args: []);
  }

  /// `Hadith`
  String get hadith {
    return Intl.message('Hadith', name: 'hadith', desc: '', args: []);
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

  /// `{count, plural, one{1 hadith} other{{count} hadith}}`
  String hadithCount(num count) {
    return Intl.plural(
      count,
      one: '1 hadith',
      other: '$count hadith',
      name: 'hadithCount',
      desc: '',
      args: [count],
    );
  }

  /// `Hadith text color`
  String get hadithTextColor {
    return Intl.message(
      'Hadith text color',
      name: 'hadithTextColor',
      desc: '',
      args: [],
    );
  }

  /// `Index`
  String get index {
    return Intl.message('Index', name: 'index', desc: '', args: []);
  }

  /// `Italic`
  String get italic {
    return Intl.message('Italic', name: 'italic', desc: '', args: []);
  }

  /// `Last`
  String get last {
    return Intl.message('Last', name: 'last', desc: '', args: []);
  }

  /// `Mark as read`
  String get markAsRead {
    return Intl.message('Mark as read', name: 'markAsRead', desc: '', args: []);
  }

  /// `Mark as unread`
  String get markAsUnread {
    return Intl.message(
      'Mark as unread',
      name: 'markAsUnread',
      desc: '',
      args: [],
    );
  }

  /// `min`
  String get minutes {
    return Intl.message('min', name: 'minutes', desc: '', args: []);
  }

  /// `Misspelled`
  String get misspelled {
    return Intl.message('Misspelled', name: 'misspelled', desc: '', args: []);
  }

  /// `Correction`
  String get misspellingCorrection {
    return Intl.message(
      'Correction',
      name: 'misspellingCorrection',
      desc: '',
      args: [],
    );
  }

  /// `Write the word or sentence as it should be`
  String get misspellingCorrectionHint {
    return Intl.message(
      'Write the word or sentence as it should be',
      name: 'misspellingCorrectionHint',
      desc: '',
      args: [],
    );
  }

  /// `Original text`
  String get misspellingOriginal {
    return Intl.message(
      'Original text',
      name: 'misspellingOriginal',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
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
    return Intl.message('Notes', name: 'notes', desc: '', args: []);
  }

  /// `{chars} chars • {words} words`
  String noteStats(Object chars, Object words) {
    return Intl.message(
      '$chars chars • $words words',
      name: 'noteStats',
      desc: '',
      args: [chars, words],
    );
  }

  /// `Enter a number from {min} to {max}`
  String outOfRange(Object min, Object max) {
    return Intl.message(
      'Enter a number from $min to $max',
      name: 'outOfRange',
      desc: '',
      args: [min, max],
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

  /// `Previous`
  String get previous {
    return Intl.message('Previous', name: 'previous', desc: '', args: []);
  }

  /// `Quran text color`
  String get quranTextColor {
    return Intl.message(
      'Quran text color',
      name: 'quranTextColor',
      desc: '',
      args: [],
    );
  }

  /// `Read`
  String get read {
    return Intl.message('Read', name: 'read', desc: '', args: []);
  }

  /// `Reading time`
  String get readingTime {
    return Intl.message(
      'Reading time',
      name: 'readingTime',
      desc: '',
      args: [],
    );
  }

  /// `{minutes, plural, zero{Under a minute} one{1 min} other{{minutes} min}}`
  String readingTimeMinutes(num minutes) {
    return Intl.plural(
      minutes,
      zero: 'Under a minute',
      one: '1 min',
      other: '$minutes min',
      name: 'readingTimeMinutes',
      desc: '',
      args: [minutes],
    );
  }

  /// `{seconds, plural, one{1 sec} other{{seconds} sec}}`
  String readingTimeSeconds(num seconds) {
    return Intl.plural(
      seconds,
      one: '1 sec',
      other: '$seconds sec',
      name: 'readingTimeSeconds',
      desc: '',
      args: [seconds],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message('Refresh', name: 'refresh', desc: '', args: []);
  }

  /// `Remove bookmark`
  String get removeBookmark {
    return Intl.message(
      'Remove bookmark',
      name: 'removeBookmark',
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

  /// `Reset`
  String get reset {
    return Intl.message('Reset', name: 'reset', desc: '', args: []);
  }

  /// `Round brackets color`
  String get roundBracketsColor {
    return Intl.message(
      'Round brackets color',
      name: 'roundBracketsColor',
      desc: '',
      args: [],
    );
  }

  /// `al-Bukhari`
  String get sahihBukhari {
    return Intl.message('al-Bukhari', name: 'sahihBukhari', desc: '', args: []);
  }

  /// `Muslim`
  String get sahihMuslim {
    return Intl.message('Muslim', name: 'sahihMuslim', desc: '', args: []);
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
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

  /// `Content`
  String get searchForContent {
    return Intl.message(
      'Content',
      name: 'searchForContent',
      desc: '',
      args: [],
    );
  }

  /// `Hadith`
  String get searchForHadith {
    return Intl.message('Hadith', name: 'searchForHadith', desc: '', args: []);
  }

  /// `Title`
  String get searchForTitle {
    return Intl.message('Title', name: 'searchForTitle', desc: '', args: []);
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

  /// `sec`
  String get seconds {
    return Intl.message('sec', name: 'seconds', desc: '', args: []);
  }

  /// `Select`
  String get select {
    return Intl.message('Select', name: 'select', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Share`
  String get share {
    return Intl.message('Share', name: 'share', desc: '', args: []);
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

  /// `Auto`
  String get shareImageAuto {
    return Intl.message('Auto', name: 'shareImageAuto', desc: '', args: []);
  }

  /// `Colors`
  String get shareImageColors {
    return Intl.message('Colors', name: 'shareImageColors', desc: '', args: []);
  }

  /// `Continued`
  String get shareImageContinued {
    return Intl.message(
      'Continued',
      name: 'shareImageContinued',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get shareImageDark {
    return Intl.message('Dark', name: 'shareImageDark', desc: '', args: []);
  }

  /// `Couldn't create the image`
  String get shareImageFailed {
    return Intl.message(
      'Couldn\'t create the image',
      name: 'shareImageFailed',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get shareImageLight {
    return Intl.message('Light', name: 'shareImageLight', desc: '', args: []);
  }

  /// `Emerald`
  String get shareImagePaletteEmerald {
    return Intl.message(
      'Emerald',
      name: 'shareImagePaletteEmerald',
      desc: '',
      args: [],
    );
  }

  /// `Indigo`
  String get shareImagePaletteIndigo {
    return Intl.message(
      'Indigo',
      name: 'shareImagePaletteIndigo',
      desc: '',
      args: [],
    );
  }

  /// `Maroon`
  String get shareImagePaletteMaroon {
    return Intl.message(
      'Maroon',
      name: 'shareImagePaletteMaroon',
      desc: '',
      args: [],
    );
  }

  /// `Sand`
  String get shareImagePaletteSand {
    return Intl.message(
      'Sand',
      name: 'shareImagePaletteSand',
      desc: '',
      args: [],
    );
  }

  /// `Preparing {current} of {total}…`
  String shareImagePreparing(Object current, Object total) {
    return Intl.message(
      'Preparing $current of $total…',
      name: 'shareImagePreparing',
      desc: '',
      args: [current, total],
    );
  }

  /// `Save all ({count})`
  String shareImageSaveAll(Object count) {
    return Intl.message(
      'Save all ($count)',
      name: 'shareImageSaveAll',
      desc: '',
      args: [count],
    );
  }

  /// `Saved`
  String get shareImageSaved {
    return Intl.message('Saved', name: 'shareImageSaved', desc: '', args: []);
  }

  /// `Save this page`
  String get shareImageSavePage {
    return Intl.message(
      'Save this page',
      name: 'shareImageSavePage',
      desc: '',
      args: [],
    );
  }

  /// `Share all ({count})`
  String shareImageShareAll(Object count) {
    return Intl.message(
      'Share all ($count)',
      name: 'shareImageShareAll',
      desc: '',
      args: [count],
    );
  }

  /// `Share this page`
  String get shareImageSharePage {
    return Intl.message(
      'Share this page',
      name: 'shareImageSharePage',
      desc: '',
      args: [],
    );
  }

  /// `Titles`
  String get shareImageShowTitles {
    return Intl.message(
      'Titles',
      name: 'shareImageShowTitles',
      desc: '',
      args: [],
    );
  }

  /// `Size`
  String get shareImageSize {
    return Intl.message('Size', name: 'shareImageSize', desc: '', args: []);
  }

  /// `Text size`
  String get shareImageTextSize {
    return Intl.message(
      'Text size',
      name: 'shareImageTextSize',
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
    return Intl.message('Source', name: 'source', desc: '', args: []);
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

  /// `Square brackets color`
  String get squareBracketsColor {
    return Intl.message(
      'Square brackets color',
      name: 'squareBracketsColor',
      desc: '',
      args: [],
    );
  }

  /// `Starting number color`
  String get startingNumberColor {
    return Intl.message(
      'Starting number color',
      name: 'startingNumberColor',
      desc: '',
      args: [],
    );
  }

  /// `Strikethrough`
  String get strikethrough {
    return Intl.message(
      'Strikethrough',
      name: 'strikethrough',
      desc: '',
      args: [],
    );
  }

  /// `Text formatter color settings`
  String get textFormatterColorSettings {
    return Intl.message(
      'Text formatter color settings',
      name: 'textFormatterColorSettings',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message('Theme', name: 'theme', desc: '', args: []);
  }

  /// `App color`
  String get themeAppColor {
    return Intl.message('App color', name: 'themeAppColor', desc: '', args: []);
  }

  /// `Titles`
  String get titles {
    return Intl.message('Titles', name: 'titles', desc: '', args: []);
  }

  /// `Underline`
  String get underline {
    return Intl.message('Underline', name: 'underline', desc: '', args: []);
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
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
