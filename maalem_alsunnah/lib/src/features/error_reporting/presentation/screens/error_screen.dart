import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/domain/error_report.dart';

/// Shown when an unexpected error happens. Purely presentational: the
/// actions are passed in, so it also works before the app finished starting.
/// Send and copy get the report with what the user typed, if anything.
class ErrorScreen extends StatefulWidget {
  const ErrorScreen({
    super.key,
    required this.report,
    required this.onReport,
    required this.onCopy,
    required this.onHome,
    required this.onContact,
  });

  static const reportKey = Key('error_screen_report');
  static const copyKey = Key('error_screen_copy');
  static const homeKey = Key('error_screen_home');
  static const contactKey = Key('error_screen_contact');
  static const detailsKey = Key('error_screen_details');
  static const descriptionKey = Key('error_screen_description');

  final ErrorReport report;
  final ValueChanged<ErrorReport> onReport;
  final ValueChanged<ErrorReport> onCopy;
  final VoidCallback? onHome;
  final VoidCallback onContact;

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  final _description = TextEditingController();

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  ErrorReport get _report => widget.report.withDescription(_description.text);

  @override
  Widget build(BuildContext context) {
    final strings = _ErrorStrings.of(context);
    final colors = Theme.of(context).colorScheme;
    final onHome = widget.onHome;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 24),
            Icon(Icons.error_outline, size: 72, color: colors.error),
            const SizedBox(height: 16),
            Text(
              strings.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(strings.body, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  widget.report.summary,
                  style: TextStyle(color: colors.onErrorContainer),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              key: ErrorScreen.descriptionKey,
              controller: _description,
              minLines: 3,
              maxLines: 8,
              // Keeps the details section in step with what's typed.
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: strings.describe,
                alignLabelWithHint: true,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              key: ErrorScreen.reportKey,
              onPressed: () => widget.onReport(_report),
              icon: const Icon(Icons.send),
              label: Text(strings.sendReport),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              key: ErrorScreen.copyKey,
              onPressed: () => widget.onCopy(_report),
              icon: const Icon(Icons.copy),
              label: Text(strings.copyDetails),
            ),
            if (onHome != null) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                key: ErrorScreen.homeKey,
                onPressed: onHome,
                icon: const Icon(Icons.home_outlined),
                label: Text(strings.backHome),
              ),
            ],
            const SizedBox(height: 8),
            TextButton.icon(
              key: ErrorScreen.contactKey,
              onPressed: widget.onContact,
              icon: const Icon(Icons.mail_outline),
              label: Text(strings.contactDeveloper),
            ),
            const SizedBox(height: 16),
            ExpansionTile(
              key: ErrorScreen.detailsKey,
              title: Text(strings.showDetails),
              children: [
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: SelectableText(
                    _report.toText(),
                    style:
                        const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Uses the app's translations when loaded; falls back to Arabic, since the
/// screen can appear before localization finished loading.
class _ErrorStrings {
  const _ErrorStrings({
    required this.title,
    required this.body,
    required this.sendReport,
    required this.copyDetails,
    required this.backHome,
    required this.contactDeveloper,
    required this.showDetails,
    required this.describe,
  });

  factory _ErrorStrings.of(BuildContext context) {
    final s = S.maybeOf(context);
    if (s == null) return _arabic;
    return _ErrorStrings(
      title: s.errorTitle,
      body: s.errorBody,
      sendReport: s.errorSendReport,
      copyDetails: s.errorCopyDetails,
      backHome: s.errorBackHome,
      contactDeveloper: s.contactDeveloper,
      showDetails: s.errorShowDetails,
      describe: s.errorDescribe,
    );
  }

  static const _arabic = _ErrorStrings(
    title: 'حدث خطأ غير متوقع',
    body: 'نعتذر عن ذلك. إرسال تقرير الخطأ يساعدنا على إصلاحه.',
    sendReport: 'إرسال تقرير الخطأ',
    copyDetails: 'نسخ التفاصيل',
    backHome: 'العودة للرئيسية',
    contactDeveloper: 'تواصل مع المطور',
    showDetails: 'عرض التفاصيل',
    describe: 'ماذا كنت تفعل عند حدوث الخطأ؟ (اختياري)',
  );

  final String title;
  final String body;
  final String sendReport;
  final String copyDetails;
  final String backHome;
  final String contactDeveloper;
  final String showDetails;
  final String describe;
}
