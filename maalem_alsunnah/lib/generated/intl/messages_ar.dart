// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
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
  String get localeName => 'ar';

  static String m0(number) => "باب ${number}";

  static String m1(current, total) => "المحتوى ${current} من ${total}";

  static String m2(count) =>
      "${Intl.plural(count, zero: 'لا أحاديث', one: 'حديث واحد', two: 'حديثان', few: '${count} أحاديث', many: '${count} حديثًا', other: '${count} حديث')}";

  static String m3(chars, words) => "${chars} حرف • ${words} كلمة";

  static String m4(min, max) => "أدخل رقمًا من ${min} إلى ${max}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "SearchTypeTypical": MessageLookupByLibrary.simpleMessage("بحث مطابق"),
    "aboutApp": MessageLookupByLibrary.simpleMessage("عن التطبيق"),
    "addBookmark": MessageLookupByLibrary.simpleMessage("أضف للمفضلة"),
    "addNotes": MessageLookupByLibrary.simpleMessage("كتابة ملاحظات"),
    "agreedUpon": MessageLookupByLibrary.simpleMessage("متفق عليه"),
    "all": MessageLookupByLibrary.simpleMessage("الجميع"),
    "appHashtag": MessageLookupByLibrary.simpleMessage("#معالم_السنة_النبوية"),
    "appTitle": MessageLookupByLibrary.simpleMessage("معالم السنة النبوية"),
    "apply": MessageLookupByLibrary.simpleMessage("تطبيق"),
    "bold": MessageLookupByLibrary.simpleMessage("عريض"),
    "bookmarks": MessageLookupByLibrary.simpleMessage("المفضلة"),
    "chapterNumber": m0,
    "chat": MessageLookupByLibrary.simpleMessage("تواصل"),
    "clear": MessageLookupByLibrary.simpleMessage("امحُ"),
    "close": MessageLookupByLibrary.simpleMessage("أغلق"),
    "contentNumber": MessageLookupByLibrary.simpleMessage("رقم المحتوى"),
    "contentXofY": m1,
    "continueReading": MessageLookupByLibrary.simpleMessage("استكمال القراءة"),
    "copiedToClipboard": MessageLookupByLibrary.simpleMessage(
      "تم النسخ إلى الحافظة",
    ),
    "copy": MessageLookupByLibrary.simpleMessage("نسخ"),
    "displayedResultsCount": MessageLookupByLibrary.simpleMessage(
      "عدد النتائج المعروضة",
    ),
    "done": MessageLookupByLibrary.simpleMessage("تم"),
    "first": MessageLookupByLibrary.simpleMessage("الأول"),
    "fontDecreaseSize": MessageLookupByLibrary.simpleMessage("تقليل حجم الخط"),
    "fontIncreaseSize": MessageLookupByLibrary.simpleMessage("تكبير حجم الخط"),
    "fontResetSize": MessageLookupByLibrary.simpleMessage(
      "إعادة تعيين حجم الخط",
    ),
    "fontSettings": MessageLookupByLibrary.simpleMessage("إعدادات الخط"),
    "freeAdFreeAndOpenSourceApp": MessageLookupByLibrary.simpleMessage(
      "تطبيق مجاني خالي من الإعلانات ومفتوح المصدر",
    ),
    "github": MessageLookupByLibrary.simpleMessage("الكود المصدري للمشروع"),
    "goTo": MessageLookupByLibrary.simpleMessage("انتقال"),
    "hadith": MessageLookupByLibrary.simpleMessage("الأحاديث"),
    "hadithBookAuthor": MessageLookupByLibrary.simpleMessage(
      "الشيخ صالح أحمد الشامي",
    ),
    "hadithBookSource": MessageLookupByLibrary.simpleMessage(
      "كتاب معالم السنة النبوية",
    ),
    "hadithBookSourceDesc": MessageLookupByLibrary.simpleMessage(
      "معالم السنة النبوية وهو خلاصة 14 كتابا هي أصول كتب السنة",
    ),
    "hadithCount": m2,
    "hadithTextColor": MessageLookupByLibrary.simpleMessage("لون نص الحديث"),
    "index": MessageLookupByLibrary.simpleMessage("الفهرس"),
    "italic": MessageLookupByLibrary.simpleMessage("مائل"),
    "last": MessageLookupByLibrary.simpleMessage("الأخير"),
    "markAsRead": MessageLookupByLibrary.simpleMessage("تعليم كمقروء"),
    "markAsUnread": MessageLookupByLibrary.simpleMessage("تعليم كغير مقروء"),
    "minutes": MessageLookupByLibrary.simpleMessage("د"),
    "misspelled": MessageLookupByLibrary.simpleMessage("خطأ إملائي"),
    "next": MessageLookupByLibrary.simpleMessage("التالي"),
    "no": MessageLookupByLibrary.simpleMessage("لا"),
    "noMoreResultsMsg": MessageLookupByLibrary.simpleMessage(
      "هذا كل شيء لا مزيد من النتائج.",
    ),
    "noResultsFound": MessageLookupByLibrary.simpleMessage("لا توجد نتائج"),
    "noteStats": m3,
    "notes": MessageLookupByLibrary.simpleMessage("ملاحظات"),
    "outOfRange": m4,
    "prayForUsAndParents": MessageLookupByLibrary.simpleMessage(
      "نسألكم الدعاء لنا ولوالدينا",
    ),
    "prefAppLanguage": MessageLookupByLibrary.simpleMessage("لغة التطبيق"),
    "prefThemeDarkMode": MessageLookupByLibrary.simpleMessage("الوضع الليلي"),
    "previous": MessageLookupByLibrary.simpleMessage("السابق"),
    "quranTextColor": MessageLookupByLibrary.simpleMessage("لون نص القرآن"),
    "read": MessageLookupByLibrary.simpleMessage("قرأته"),
    "readingTime": MessageLookupByLibrary.simpleMessage("وقت القراءة"),
    "refresh": MessageLookupByLibrary.simpleMessage("تحديث"),
    "removeBookmark": MessageLookupByLibrary.simpleMessage("حذف من المفضلة"),
    "reportMisspelled": MessageLookupByLibrary.simpleMessage("تبليغ عن خطأ"),
    "reset": MessageLookupByLibrary.simpleMessage("إعادة تعيين"),
    "roundBracketsColor": MessageLookupByLibrary.simpleMessage(
      "لون الأقواس المستديرة",
    ),
    "sahihBukhari": MessageLookupByLibrary.simpleMessage("البخاري"),
    "sahihMuslim": MessageLookupByLibrary.simpleMessage("مسلم"),
    "search": MessageLookupByLibrary.simpleMessage("بحث"),
    "searchFilters": MessageLookupByLibrary.simpleMessage("مرشحات البحث"),
    "searchForContent": MessageLookupByLibrary.simpleMessage("المحتوى"),
    "searchForHadith": MessageLookupByLibrary.simpleMessage("الأحاديث"),
    "searchForTitle": MessageLookupByLibrary.simpleMessage("فهرس"),
    "searchResultCount": MessageLookupByLibrary.simpleMessage(
      "عدد نتائج البحث",
    ),
    "searchTypeAllWords": MessageLookupByLibrary.simpleMessage("جميع الكلمات"),
    "searchTypeAnyWords": MessageLookupByLibrary.simpleMessage("أي كلمة"),
    "seconds": MessageLookupByLibrary.simpleMessage("ث"),
    "select": MessageLookupByLibrary.simpleMessage("تحديد"),
    "settings": MessageLookupByLibrary.simpleMessage("الإعدادات"),
    "share": MessageLookupByLibrary.simpleMessage("مشاركة"),
    "shareAsImage": MessageLookupByLibrary.simpleMessage("مشاركة كصورة"),
    "showDiacritics": MessageLookupByLibrary.simpleMessage("عرض التشكيل"),
    "source": MessageLookupByLibrary.simpleMessage("المصدر"),
    "sourceBookAuthor": MessageLookupByLibrary.simpleMessage("مؤلف الكتاب"),
    "squareBracketsColor": MessageLookupByLibrary.simpleMessage(
      "لون الأقواس المربعة",
    ),
    "startingNumberColor": MessageLookupByLibrary.simpleMessage(
      "لون رقم البداية",
    ),
    "strikethrough": MessageLookupByLibrary.simpleMessage("يتوسطه خط"),
    "textFormatterColorSettings": MessageLookupByLibrary.simpleMessage(
      "إعدادات ألوان تنسيق النص",
    ),
    "theme": MessageLookupByLibrary.simpleMessage("مظهر التطبيق"),
    "themeAppColor": MessageLookupByLibrary.simpleMessage("لون التطبيق"),
    "titles": MessageLookupByLibrary.simpleMessage("العناوين"),
    "underline": MessageLookupByLibrary.simpleMessage("تسطير"),
    "yes": MessageLookupByLibrary.simpleMessage("نعم"),
  };
}
