// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(number) => "Chapter ${number}";

  static String m1(number, total) => "Chapter ${number} of ${total}";

  static String m2(current, total) => "Content ${current} of ${total}";

  static String m3(count) =>
      "${Intl.plural(count, one: '1 hadith', other: '${count} hadith')}";

  static String m4(chars, words) => "${chars} chars • ${words} words";

  static String m5(min, max) => "Enter a number from ${min} to ${max}";

  static String m6(minutes) =>
      "${Intl.plural(minutes, zero: 'Under a minute', one: '1 min', other: '${minutes} min')}";

  static String m7(seconds) =>
      "${Intl.plural(seconds, one: '1 sec', other: '${seconds} sec')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "SearchTypeTypical": MessageLookupByLibrary.simpleMessage("Typical"),
    "aboutApp": MessageLookupByLibrary.simpleMessage("About app"),
    "addBookmark": MessageLookupByLibrary.simpleMessage("Add bookmark"),
    "addNotes": MessageLookupByLibrary.simpleMessage("Add notes"),
    "agreedUpon": MessageLookupByLibrary.simpleMessage("Agreed upon"),
    "all": MessageLookupByLibrary.simpleMessage("All"),
    "appHashtag": MessageLookupByLibrary.simpleMessage("#maalem_alsunnah"),
    "appTitle": MessageLookupByLibrary.simpleMessage("Maalem Al-Sunnah"),
    "apply": MessageLookupByLibrary.simpleMessage("Apply"),
    "bold": MessageLookupByLibrary.simpleMessage("Bold"),
    "bookmarks": MessageLookupByLibrary.simpleMessage("Bookamarks"),
    "bukhariMuallaq": MessageLookupByLibrary.simpleMessage(
      "al-Bukhari (mu\'allaq)",
    ),
    "chapterNumber": m0,
    "chapterOfTotal": m1,
    "chat": MessageLookupByLibrary.simpleMessage("Chat"),
    "clear": MessageLookupByLibrary.simpleMessage("Clear"),
    "close": MessageLookupByLibrary.simpleMessage("Close"),
    "contentNumber": MessageLookupByLibrary.simpleMessage("Content number"),
    "contentXofY": m2,
    "continueReading": MessageLookupByLibrary.simpleMessage("Continue reading"),
    "copiedToClipboard": MessageLookupByLibrary.simpleMessage(
      "Copied to clipboard",
    ),
    "copy": MessageLookupByLibrary.simpleMessage("Copy"),
    "displayedResultsCount": MessageLookupByLibrary.simpleMessage(
      "Displayed results count",
    ),
    "done": MessageLookupByLibrary.simpleMessage("Done"),
    "first": MessageLookupByLibrary.simpleMessage("First"),
    "fontDecreaseSize": MessageLookupByLibrary.simpleMessage(
      "Decrease font size",
    ),
    "fontIncreaseSize": MessageLookupByLibrary.simpleMessage(
      "Increase font size",
    ),
    "fontResetSize": MessageLookupByLibrary.simpleMessage("Reset font size"),
    "fontSettings": MessageLookupByLibrary.simpleMessage("Font settings"),
    "freeAdFreeAndOpenSourceApp": MessageLookupByLibrary.simpleMessage(
      "Free, ad-free and open source app",
    ),
    "github": MessageLookupByLibrary.simpleMessage("Github source code"),
    "goTo": MessageLookupByLibrary.simpleMessage("Go"),
    "hadith": MessageLookupByLibrary.simpleMessage("Hadith"),
    "hadithBookAuthor": MessageLookupByLibrary.simpleMessage(
      "Sheikh Saleh Ahmed Al Shami",
    ),
    "hadithBookSource": MessageLookupByLibrary.simpleMessage(
      "Maalem Al-sunnah",
    ),
    "hadithBookSourceDesc": MessageLookupByLibrary.simpleMessage(
      "The Prophetic Sunnah from the most authentic to the weakest",
    ),
    "hadithCount": m3,
    "hadithTextColor": MessageLookupByLibrary.simpleMessage(
      "Hadith text color",
    ),
    "index": MessageLookupByLibrary.simpleMessage("Index"),
    "italic": MessageLookupByLibrary.simpleMessage("Italic"),
    "last": MessageLookupByLibrary.simpleMessage("Last"),
    "markAsRead": MessageLookupByLibrary.simpleMessage("Mark as read"),
    "markAsUnread": MessageLookupByLibrary.simpleMessage("Mark as unread"),
    "minutes": MessageLookupByLibrary.simpleMessage("min"),
    "misspelled": MessageLookupByLibrary.simpleMessage("Misspelled"),
    "next": MessageLookupByLibrary.simpleMessage("Next"),
    "no": MessageLookupByLibrary.simpleMessage("No"),
    "noMoreResultsMsg": MessageLookupByLibrary.simpleMessage(
      "That\'s it, there are no more results.",
    ),
    "noResultsFound": MessageLookupByLibrary.simpleMessage("No results found"),
    "noteStats": m4,
    "notes": MessageLookupByLibrary.simpleMessage("Notes"),
    "outOfRange": m5,
    "prayForUsAndParents": MessageLookupByLibrary.simpleMessage(
      "Pray for us and our parents.",
    ),
    "prefAppLanguage": MessageLookupByLibrary.simpleMessage("App language"),
    "prefThemeDarkMode": MessageLookupByLibrary.simpleMessage("Dark Mode"),
    "previous": MessageLookupByLibrary.simpleMessage("Previous"),
    "quranTextColor": MessageLookupByLibrary.simpleMessage("Quran text color"),
    "read": MessageLookupByLibrary.simpleMessage("Read"),
    "readingTime": MessageLookupByLibrary.simpleMessage("Reading time"),
    "readingTimeMinutes": m6,
    "readingTimeSeconds": m7,
    "refresh": MessageLookupByLibrary.simpleMessage("Refresh"),
    "removeBookmark": MessageLookupByLibrary.simpleMessage("Remove bookmark"),
    "reportMisspelled": MessageLookupByLibrary.simpleMessage(
      "Report misspelled",
    ),
    "reset": MessageLookupByLibrary.simpleMessage("Reset"),
    "roundBracketsColor": MessageLookupByLibrary.simpleMessage(
      "Round brackets color",
    ),
    "sahihBukhari": MessageLookupByLibrary.simpleMessage("al-Bukhari"),
    "sahihMuslim": MessageLookupByLibrary.simpleMessage("Muslim"),
    "search": MessageLookupByLibrary.simpleMessage("Search"),
    "searchFilters": MessageLookupByLibrary.simpleMessage("Search filters"),
    "searchForContent": MessageLookupByLibrary.simpleMessage("Content"),
    "searchForHadith": MessageLookupByLibrary.simpleMessage("Hadith"),
    "searchForTitle": MessageLookupByLibrary.simpleMessage("Title"),
    "searchResultCount": MessageLookupByLibrary.simpleMessage(
      "Search result count",
    ),
    "searchTypeAllWords": MessageLookupByLibrary.simpleMessage("All words"),
    "searchTypeAnyWords": MessageLookupByLibrary.simpleMessage("Any words"),
    "seconds": MessageLookupByLibrary.simpleMessage("sec"),
    "select": MessageLookupByLibrary.simpleMessage("Select"),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "share": MessageLookupByLibrary.simpleMessage("Share"),
    "shareAsImage": MessageLookupByLibrary.simpleMessage("Share as image"),
    "showDiacritics": MessageLookupByLibrary.simpleMessage("Show diacritics"),
    "source": MessageLookupByLibrary.simpleMessage("Source"),
    "sourceBookAuthor": MessageLookupByLibrary.simpleMessage("Book Author"),
    "squareBracketsColor": MessageLookupByLibrary.simpleMessage(
      "Square brackets color",
    ),
    "startingNumberColor": MessageLookupByLibrary.simpleMessage(
      "Starting number color",
    ),
    "strikethrough": MessageLookupByLibrary.simpleMessage("Strikethrough"),
    "textFormatterColorSettings": MessageLookupByLibrary.simpleMessage(
      "Text formatter color settings",
    ),
    "theme": MessageLookupByLibrary.simpleMessage("Theme"),
    "themeAppColor": MessageLookupByLibrary.simpleMessage("App color"),
    "titles": MessageLookupByLibrary.simpleMessage("Titles"),
    "underline": MessageLookupByLibrary.simpleMessage("Underline"),
    "yes": MessageLookupByLibrary.simpleMessage("Yes"),
  };
}
