import 'package:maalem_alsunnah/src/core/functions/print.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/data/error_reporter.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openURL(String url) async {
  final parsed = Uri.parse(url);

  try {
    if (await canLaunchUrl(parsed)) {
      await launchUrl(parsed, mode: LaunchMode.externalApplication);
    }
  } catch (e, stack) {
    ErrorReporter.instance.record(e, stack, where: 'openURL');
    appPrint(e);
  }
}
