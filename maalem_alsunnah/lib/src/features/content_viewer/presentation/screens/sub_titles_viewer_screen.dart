// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/src/core/di/dependency_injection.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/screens/index_screen.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/repository/hadith_db_helper.dart';

class SubTitlesViewerScreen extends StatefulWidget {
  final TitleModel title;
  const SubTitlesViewerScreen({
    super.key,
    required this.title,
  });

  @override
  State<SubTitlesViewerScreen> createState() => _SubTitlesViewerScreenState();
}

class _SubTitlesViewerScreenState extends State<SubTitlesViewerScreen> {
  late final List<TitleModel> titles;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    titles = await sl<HadithDbHelper>().getTitleById(widget.title.id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title.name),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : IndexScreen(
              maqassedList: titles,
            ),
    );
  }
}