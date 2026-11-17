import 'package:maalem_alsunnah/src/features/search/data/models/hadith_model.dart';

/// Email body of a misspelling report: where it is, what it should be, and
/// the original text for reference.
String misspellingReportBody({
  required HadithModel hadith,
  required String correction,
  required String correctionLabel,
  required String originalLabel,
}) {
  return (StringBuffer()
        ..writeln(
            't:${hadith.titleId} | c:${hadith.contentId} | h:${hadith.id}')
        ..writeln()
        ..writeln('$correctionLabel:')
        ..writeln(correction)
        ..writeln()
        ..writeln('$originalLabel:')
        ..writeln(hadith.text))
      .toString();
}
