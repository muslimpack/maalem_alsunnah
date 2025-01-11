// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/data/models/text_formatter_settings.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/format_text.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/hadith_format_text_style.dart';
import 'package:maalem_alsunnah/src/features/content_viewer/presentation/components/titles_chain_rich_text_builder.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/hadith_model.dart';
import 'package:maalem_alsunnah/src/features/search/data/models/title_model.dart';
import 'package:maalem_alsunnah/src/features/share/data/models/hadith_image_card_settings.dart';
import 'package:maalem_alsunnah/src/features/share/presentation/components/dot_bar.dart';

class HadithAsImageCard extends StatelessWidget {
  final HadithModel hadith;
  final HadithImageCardSettings settings;
  final List<TitleModel> titleChain;
  final TextRange? matnRange;
  final int splittedLength;
  final int splittedindex;
  const HadithAsImageCard({
    super.key,
    required this.hadith,
    required this.settings,
    required this.titleChain,
    this.matnRange,
    this.splittedLength = 0,
    this.splittedindex = 0,
  });

  String get hadithText {
    const String separator = "...";
    String hadithText = matnRange != null
        ? hadith.text.substring(
            matnRange!.start,
            matnRange!.end,
          )
        : hadith.text;

    if (splittedLength > 1) {
      if (splittedindex == 0) {
        hadithText += separator;
      } else if (splittedindex == splittedLength - 1) {
        hadithText = "$separator$hadithText";
      } else {
        hadithText = "$separator$hadithText$separator";
      }
    }

    return hadithText;
  }

  @override
  Widget build(BuildContext context) {
    const imageBackgroundColor = Color(0xff1a110e);
    const secondaryColor = Color(0xfffeb99c);
    final secondaryElementsColor = Color(0xff451b1b).withValues(alpha: 1);

    final mainTextStyle = TextStyle(
      fontSize: 150,
      fontFamily: settings.mainFontFamily,
      color: Colors.white,
    );

    final secondaryTextStyle = TextStyle(
      fontSize: 40,
      color: secondaryColor,
      fontFamily: settings.secondaryFontFamily,
    );

    final defaultStyle = TextStyle(
      fontFamily: 'adwaa',
      height: 1.5,
    );

    final TextFormatterSettings textFormatterSettings =
        hadithTextFormatterSettingsByDefault(context, defaultStyle);

    final textSpan = FormattedText(
      text: hadith.text,
      textRange: matnRange,
      settings: textFormatterSettings,
    ).textSpan();
    return Container(
      color: imageBackgroundColor,
      width: settings.imageSize.width,
      height: settings.imageSize.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/grid.png",
            fit: BoxFit.cover,
            color: secondaryElementsColor,
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  imageBackgroundColor,
                  Colors.transparent,
                ],
                radius: 1,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(40).copyWith(top: 60, bottom: 60),
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .11),
              border: Border.all(
                color: secondaryElementsColor,
                width: 5,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
                bottomRight: Radius.circular(50),
                bottomLeft: Radius.circular(255),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TitlesChainRichTextBuilder(
                  titlesChains: titleChain.sublist(0, titleChain.length),
                  textStyle: secondaryTextStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: Center(
                    child: AutoSizeText.rich(
                      textSpan,
                      minFontSize: 30,
                      textAlign: TextAlign.center,
                      style: mainTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (splittedLength > 1)
            Padding(
              padding: const EdgeInsets.all(15).copyWith(left: 200, right: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DotBar(
                    activeIndex: splittedindex,
                    length: splittedLength,
                    dotColor: secondaryColor,
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Image.asset(
                "assets/images/app_icon.png",
                height: 125,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
