import 'package:flutter/material.dart';
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/domain/error_report.dart';

/// Shown when an unexpected error happens. Purely presentational: the
/// actions are passed in, so it also works before the app finished starting.
class ErrorScreen extends StatelessWidget {
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

  final ErrorReport report;
  final VoidCallback onReport;
  final VoidCallback onCopy;
  final VoidCallback? onHome;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final strings = _ErrorStrings.of(context);
    final colors = Theme.of(context).colorScheme;

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
                  report.summary,
                  style: TextStyle(color: colors.onErrorContainer),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              key: reportKey,
              onPressed: onReport,
              icon: const Icon(Icons.send),
              label: Text(strings.sendReport),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              key: copyKey,
              onPressed: onCopy,
              icon: const Icon(Icons.copy),
              label: Text(strings.copyDetails),
            ),
            if (onHome != null) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                key: homeKey,
                onPressed: onHome,
                icon: const Icon(Icons.home_outlined),
                label: Text(strings.backHome),
              ),
            ],
            const SizedBox(height: 8),
            TextButton.icon(
              key: contactKey,
              onPressed: onContact,
              icon: const Icon(Icons.mail_outline),
              label: Text(strings.contactDeveloper),
            ),
            const SizedBox(height: 16),
            ExpansionTile(
              key: detailsKey,
              title: Text(strings.showDetails),
              children: [
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: SelectableText(
                    report.toText(),
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
  );

  final String title;
  final String body;
  final String sendReport;
  final String copyDetails;
  final String backHome;
  final String contactDeveloper;
  final String showDetails;
}
