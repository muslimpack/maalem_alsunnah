import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';

final titleModelDummyData = List.generate(
  10,
  (index) => TitleModel(
    id: index + 1,
    name: 'Title $index',
    parentId: -1,
    subTitlesCount: 0,
  ),
);
