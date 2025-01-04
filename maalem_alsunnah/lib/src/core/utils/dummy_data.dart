import 'package:maalem_alsunnah/src/features/search/data/models/content_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/hadith_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';

List<TitleModel> get titleModelDummyData => List.generate(
      5,
      (index) => TitleModel(
        id: index + 1,
        orderId: (index + 2) * index,
        name: 'lorem ipsum ' * index,
        parentId: -1,
        subTitlesCount: 0,
      ),
    );

List<ContentModel> get contentModelDummyData => List.generate(
      10,
      (index) {
        final String text = "lorem ipsum dolor " * (index + 4);
        return ContentModel(
          id: index + 1,
          orderId: (index + 1) * index,
          searchText: text,
          text: text,
          titleId: index + 1,
        );
      },
    );

List<HadithModel> get hadithModelDummyData => List.generate(
      10,
      (index) {
        final String text = "lorem ipsum dolor " * (index + 3);
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
