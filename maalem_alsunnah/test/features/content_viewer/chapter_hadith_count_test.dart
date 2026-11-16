import 'package:flutter_test/flutter_test.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/content_hadith_card.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/hadith_model.dart';

HadithModel row(String id, {int count = 0}) => HadithModel(
      id: id,
      titleId: 1,
      contentId: 1,
      orderId: 1,
      count: count,
      text: '',
      searchText: '',
    );

void main() {
  test('counts the hadith after each chapter, not the chapter row itself', () {
    // Like content 9 in book.db: chapter row with count = 4, then 3 hadith.
    final rows = [row('', count: 4), row('1'), row('2'), row('3')];
    expect(ContentHadithCard.chapterHadithCounts(rows), [3, 0, 0, 0]);
  });

  test('a section heading with no hadith gets 0', () {
    expect(ContentHadithCard.chapterHadithCounts([row('', count: 1)]), [0]);
  });

  test('two chapters on one page are counted separately', () {
    final rows = [row(''), row('1'), row(''), row('2'), row('3')];
    expect(ContentHadithCard.chapterHadithCounts(rows), [1, 0, 2, 0, 0]);
  });

  test('hadith before any chapter are not attributed', () {
    expect(ContentHadithCard.chapterHadithCounts([row('1'), row('')]), [0, 0]);
  });
}
