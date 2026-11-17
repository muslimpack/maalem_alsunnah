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

  static String m1(number, total) => "باب ${number} من ${total}";

  static String m2(min) => "اكتب ${min} أحرف على الأقل";

  static String m3(email) =>
      "لم يُعثر على تطبيق بريد، تم نسخ الرسالة. أرسلها إلى ${email}";

  static String m4(current, total) => "المحتوى ${current} من ${total}";

  static String m5(email) =>
      "أرسل هذا التقرير إلى ${email}\nواشرح ما كنت تفعله عند حدوث الخطأ:\n";

  static String m6(count) =>
      "${Intl.plural(count, zero: 'لا أحاديث', one: 'حديث واحد', two: 'حديثان', few: '${count} أحاديث', many: '${count} حديثًا', other: '${count} حديث')}";

  static String m7(chars, words) => "${chars} حرف • ${words} كلمة";

  static String m8(min, max) => "أدخل رقمًا من ${min} إلى ${max}";

  static String m9(minutes) =>
      "${Intl.plural(minutes, zero: 'أقل من دقيقة', one: 'دقيقة', two: 'دقيقتان', few: '${minutes} دقائق', many: '${minutes} دقيقة', other: '${minutes} دقيقة')}";

  static String m10(seconds) =>
      "${Intl.plural(seconds, one: 'ثانية', two: 'ثانيتان', few: '${seconds} ثوانٍ', many: '${seconds} ثانية', other: '${seconds} ثانية')}";

  static String m11(current, total) => "جارٍ تجهيز ${current} من ${total}…";

  static String m12(count) => "حفظ الكل (${count})";

  static String m13(count) => "مشاركة الكل (${count})";

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
    "bukhariMuallaq": MessageLookupByLibrary.simpleMessage("معلقات البخاري"),
    "cancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "chapterNumber": m0,
    "chapterOfTotal": m1,
    "chat": MessageLookupByLibrary.simpleMessage("تواصل"),
    "clear": MessageLookupByLibrary.simpleMessage("امحُ"),
    "close": MessageLookupByLibrary.simpleMessage("أغلق"),
    "contactDeveloper": MessageLookupByLibrary.simpleMessage("تواصل مع المطور"),
    "contactMessage": MessageLookupByLibrary.simpleMessage("الرسالة"),
    "contactMessageTooShort": m2,
    "contactNoEmailApp": m3,
    "contactSend": MessageLookupByLibrary.simpleMessage("إرسال"),
    "contactShareDeviceInfo": MessageLookupByLibrary.simpleMessage(
      "إرفاق معلومات الجهاز",
    ),
    "contactShareDeviceInfoHint": MessageLookupByLibrary.simpleMessage(
      "لا تتضمن أي بيانات شخصية. سيُرفق ما يلي:",
    ),
    "contactType": MessageLookupByLibrary.simpleMessage("نوع الرسالة"),
    "contactTypeBug": MessageLookupByLibrary.simpleMessage("الإبلاغ عن خطأ"),
    "contactTypeContentError": MessageLookupByLibrary.simpleMessage(
      "خطأ في المحتوى",
    ),
    "contactTypeFeatureRequest": MessageLookupByLibrary.simpleMessage(
      "اقتراح ميزة",
    ),
    "contactTypeOther": MessageLookupByLibrary.simpleMessage("أخرى"),
    "contactTypeQuestion": MessageLookupByLibrary.simpleMessage("سؤال"),
    "contactTypeRequired": MessageLookupByLibrary.simpleMessage(
      "اختر نوع الرسالة",
    ),
    "contentNumber": MessageLookupByLibrary.simpleMessage("رقم المحتوى"),
    "contentXofY": m4,
    "continueReading": MessageLookupByLibrary.simpleMessage("استكمال القراءة"),
    "copiedToClipboard": MessageLookupByLibrary.simpleMessage(
      "تم النسخ إلى الحافظة",
    ),
    "copy": MessageLookupByLibrary.simpleMessage("نسخ"),
    "displayedResultsCount": MessageLookupByLibrary.simpleMessage(
      "عدد النتائج المعروضة",
    ),
    "done": MessageLookupByLibrary.simpleMessage("تم"),
    "errorBackHome": MessageLookupByLibrary.simpleMessage("العودة للرئيسية"),
    "errorBody": MessageLookupByLibrary.simpleMessage(
      "نعتذر عن ذلك. إرسال تقرير الخطأ يساعدنا على إصلاحه.",
    ),
    "errorCopyDetails": MessageLookupByLibrary.simpleMessage("نسخ التفاصيل"),
    "errorReportCopied": MessageLookupByLibrary.simpleMessage("تم نسخ التقرير"),
    "errorReportDescribe": MessageLookupByLibrary.simpleMessage(
      "اشرح ما كنت تفعله عند حدوث الخطأ:",
    ),
    "errorReportShareText": m5,
    "errorSendReport": MessageLookupByLibrary.simpleMessage(
      "إرسال تقرير الخطأ",
    ),
    "errorShowDetails": MessageLookupByLibrary.simpleMessage("عرض التفاصيل"),
    "errorTitle": MessageLookupByLibrary.simpleMessage("حدث خطأ غير متوقع"),
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
    "hadithCount": m6,
    "hadithTextColor": MessageLookupByLibrary.simpleMessage("لون نص الحديث"),
    "index": MessageLookupByLibrary.simpleMessage("الفهرس"),
    "italic": MessageLookupByLibrary.simpleMessage("مائل"),
    "last": MessageLookupByLibrary.simpleMessage("الأخير"),
    "markAsRead": MessageLookupByLibrary.simpleMessage("تعليم كمقروء"),
    "markAsUnread": MessageLookupByLibrary.simpleMessage("تعليم كغير مقروء"),
    "minutes": MessageLookupByLibrary.simpleMessage("د"),
    "misspelled": MessageLookupByLibrary.simpleMessage("خطأ إملائي"),
    "misspellingCorrection": MessageLookupByLibrary.simpleMessage("التصحيح"),
    "misspellingCorrectionHint": MessageLookupByLibrary.simpleMessage(
      "اكتب الكلمة أو الجملة كما ينبغي أن تكون",
    ),
    "misspellingOriginal": MessageLookupByLibrary.simpleMessage("النص الأصلي"),
    "next": MessageLookupByLibrary.simpleMessage("التالي"),
    "no": MessageLookupByLibrary.simpleMessage("لا"),
    "noMoreResultsMsg": MessageLookupByLibrary.simpleMessage(
      "هذا كل شيء لا مزيد من النتائج.",
    ),
    "noResultsFound": MessageLookupByLibrary.simpleMessage("لا توجد نتائج"),
    "noteStats": m7,
    "notes": MessageLookupByLibrary.simpleMessage("ملاحظات"),
    "outOfRange": m8,
    "prayForUsAndParents": MessageLookupByLibrary.simpleMessage(
      "نسألكم الدعاء لنا ولوالدينا",
    ),
    "prefAppLanguage": MessageLookupByLibrary.simpleMessage("لغة التطبيق"),
    "prefThemeDarkMode": MessageLookupByLibrary.simpleMessage("الوضع الليلي"),
    "previous": MessageLookupByLibrary.simpleMessage("السابق"),
    "quranTextColor": MessageLookupByLibrary.simpleMessage("لون نص القرآن"),
    "read": MessageLookupByLibrary.simpleMessage("قرأته"),
    "readingTime": MessageLookupByLibrary.simpleMessage("وقت القراءة"),
    "readingTimeMinutes": m9,
    "readingTimeSeconds": m10,
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
    "shareImageAuto": MessageLookupByLibrary.simpleMessage("تلقائي"),
    "shareImageColors": MessageLookupByLibrary.simpleMessage("الألوان"),
    "shareImageContinued": MessageLookupByLibrary.simpleMessage("يتبع"),
    "shareImageDark": MessageLookupByLibrary.simpleMessage("داكن"),
    "shareImageFailed": MessageLookupByLibrary.simpleMessage(
      "تعذر إنشاء الصورة",
    ),
    "shareImageLight": MessageLookupByLibrary.simpleMessage("فاتح"),
    "shareImagePaletteEmerald": MessageLookupByLibrary.simpleMessage("زمردي"),
    "shareImagePaletteIndigo": MessageLookupByLibrary.simpleMessage("نيلي"),
    "shareImagePaletteMaroon": MessageLookupByLibrary.simpleMessage("عنابي"),
    "shareImagePaletteSand": MessageLookupByLibrary.simpleMessage("رملي"),
    "shareImagePreparing": m11,
    "shareImageSaveAll": m12,
    "shareImageSavePage": MessageLookupByLibrary.simpleMessage(
      "حفظ هذه الصفحة",
    ),
    "shareImageSaved": MessageLookupByLibrary.simpleMessage("تم الحفظ"),
    "shareImageShareAll": m13,
    "shareImageSharePage": MessageLookupByLibrary.simpleMessage(
      "مشاركة هذه الصفحة",
    ),
    "shareImageShowTitles": MessageLookupByLibrary.simpleMessage("العناوين"),
    "shareImageSize": MessageLookupByLibrary.simpleMessage("المقاس"),
    "shareImageTextSize": MessageLookupByLibrary.simpleMessage("حجم الخط"),
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
