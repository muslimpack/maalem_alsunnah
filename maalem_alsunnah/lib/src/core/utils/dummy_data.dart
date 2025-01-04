import 'package:maalem_alsunnah/src/features/search/data/models/content_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/hadith_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';

final titleModelDummyData = List.generate(
  10,
  (index) => TitleModel(
    id: index + 1,
    orderId: (index + 1) * index,
    name: 'lorem ipsum dolor $index' * index,
    parentId: -1,
    subTitlesCount: 0,
  ),
);

final contentModelDummyData = List.generate(
  10,
  (index) {
    final String text = "lorem ipsum dolor" * (index + 5) * index;
    return ContentModel(
      id: index + 1,
      orderId: (index + 1) * index,
      searchText: text,
      text: text,
      titleId: index + 1,
    );
  },
);

final hadithModelDummyData = List.generate(
  10,
  (index) {
    final String text =
        List.generate((index + 15) * index, (index) => "lorem ipsum dolor")
            .join(" ")
            .toString();
    return HadithModel(
      id: "${index + 1}",
      count: index + index,
      contentId: index + 1,
      orderId: (index + 1) * index,
      searchText: text,
      text: text,
      titleId: index + 1,
    );
  },
);
