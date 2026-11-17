import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart'
    show FlutterEmailSender;
import 'package:flutter_email_sender/flutter_email_sender.dart' as mail;
import 'package:maalem_alsunnah/generated/l10n.dart';
import 'package:maalem_alsunnah/src/core/constants/constant.dart';
import 'package:maalem_alsunnah/src/core/functions/mailto_uri.dart';
import 'package:maalem_alsunnah/src/core/functions/send_email.dart';
import 'package:maalem_alsunnah/src/core/functions/show_toast.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/data/app_info.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/data/device_snapshot_loader.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/data/pending_report_store.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/domain/app_log.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/domain/contact_message.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/domain/error_gate.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/domain/error_report.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/presentation/components/pending_report_dialog.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/presentation/screens/contact_screen.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/presentation/screens/error_screen.dart';
import 'package:maalem_alsunnah/src/features/error_reporting/presentation/screens/startup_error_app.dart';
import 'package:maalem_alsunnah/src/features/home/presentation/screens/home_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Wires uncaught errors to the [ErrorScreen], and sends reports and
/// contact messages to the developer by email.
class ErrorReporter {
  ErrorReporter._();

  static final ErrorReporter instance = ErrorReporter._();

  /// Given to the app's `MaterialApp` so errors can open a screen from
  /// anywhere.
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final ErrorGate _gate = ErrorGate();
  final AppLog _log = AppLog.instance;
  final PendingReportStore _pending =
      PendingReportStore(getApplicationSupportDirectory);

  /// Hooks framework and uncaught async errors. Call first thing in `main`.
  void install() {
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      report(details.exception, details.stack, silent: details.silent);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      if (kDebugMode) debugPrint('$error\n$stack');
      report(error, stack);
      return true;
    };
  }

  /// For errors the app caught and recovered from: logged into the recent
  /// events of the next report, no screen. Only the error's type is kept,
  /// never its message.
  void record(Object error, StackTrace? stack, {required String where}) {
    _log.addCaught(error, stack, where: where);
  }

  /// Logs an uncaught error and, unless the gate holds it back, opens the
  /// error screen. If the app's navigator isn't mounted yet (the first frame
  /// failed), the whole app is replaced by [StartupErrorApp].
  Future<void> report(
    Object error,
    StackTrace? stack, {
    bool silent = false,
  }) async {
    _log.add('uncaught ${error.runtimeType}');
    if (!_gate.shouldShow(error, DateTime.now(), silent: silent)) return;
    try {
      final report = await buildReport(error, stack);
      await keepUntilHandled(report);
      final navigator = navigatorKey.currentState;
      if (navigator == null) {
        // The replacement app stays up, so the gate is left closed.
        runApp(StartupErrorApp(report: report));
        return;
      }
      await navigator.push(
        MaterialPageRoute<void>(
          settings: const RouteSettings(name: '/error'),
          builder: (_) => ErrorScreen(
            report: report,
            onReport: sendReport,
            onCopy: copyReport,
            onHome: () => navigator.pushNamedAndRemoveUntil(
              HomeScreen.routeName,
              (_) => false,
            ),
            onContact: () => navigator.push(
              contactRoute(initialType: ContactType.bug),
            ),
          ),
        ),
      );
      // The user saw it and moved on; don't offer it again next launch.
      await _forgetPending();
      _gate.screenClosed(DateTime.now());
    } catch (e) {
      if (kDebugMode) debugPrint('Error screen failed: $e');
      _gate.screenClosed(DateTime.now());
    }
  }

  Future<ErrorReport> buildReport(Object error, StackTrace? stack) async {
    return ErrorReport(
      error: error,
      stackTrace: stack,
      device: await loadDeviceSnapshot(),
      recentEvents: _log.lines,
      createdAt: DateTime.now(),
    );
  }

  /// Saves [report] so it can be offered on the next launch if the app is
  /// closed or killed before the user sends, copies or leaves it.
  Future<void> keepUntilHandled(ErrorReport report) async {
    try {
      await _pending.save(report);
    } catch (e) {
      if (kDebugMode) debugPrint('Saving pending report failed: $e');
    }
  }

  Future<void> _forgetPending() async {
    try {
      await _pending.clear();
    } catch (e) {
      if (kDebugMode) debugPrint('Clearing pending report failed: $e');
    }
  }

  /// The report left over from the last launch, if any. Removed as it's
  /// read, so it's offered once. Call before anything can save a new one.
  Future<ErrorReport?> takePendingReport() async {
    try {
      return await _pending.take();
    } catch (e) {
      if (kDebugMode) debugPrint('Reading pending report failed: $e');
      return null;
    }
  }

  /// Once the app is on screen, asks whether to send [report].
  void offerAfterFirstFrame(ErrorReport report) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final context = navigatorKey.currentContext;
      if (context == null) return;
      final send =
          await showPendingReportDialog(context, summary: report.summary);
      if (send ?? false) await sendReport(report);
    });
  }

  Route<void> contactRoute({ContactType? initialType}) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: ContactScreen.routeName),
      builder: (_) => ContactScreen(
        initialType: initialType,
        loadDevice: loadDeviceSnapshot,
        onSend: sendContactMessage,
      ),
    );
  }

  static bool get _canShareFiles =>
      !kIsWeb && !Platform.isLinux && !Platform.isFuchsia;

  /// Sends the report as a `.txt` attachment, trying in order:
  /// 1. the mail composer, prefilled with recipient, subject and attachment;
  /// 2. the share sheet with the file (user picks the app, types the address);
  /// 3. a plain `mailto:` with the full report copied to the clipboard.
  Future<void> sendReport(ErrorReport report) async {
    await _forgetPending();
    if (await _composeReportEmail(report)) return;

    final shareText = _shareText();
    try {
      if (_canShareFiles) {
        final file = await _writeReportFile(report);
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(file.path, mimeType: 'text/plain')],
            subject: _subject('Error report'),
            text: shareText,
            sharePositionOrigin: _shareOrigin(),
          ),
        );
        return;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Sharing report failed: $e');
    }
    await Clipboard.setData(ClipboardData(text: report.toText()));
    await openMail(
      mailtoUri(
        to: kOrgEmail,
        subject: _subject('Error report'),
        body: '$shareText\n\n${_mailBody(report)}',
      ),
      fallbackText: report.toText(),
    );
  }

  /// Whether the mail composer opened with the report attached. Fails over
  /// when there is no composer, or it can only do `mailto:` (which can't
  /// carry attachments, e.g. iOS without an Apple Mail account).
  Future<bool> _composeReportEmail(ErrorReport report) async {
    try {
      final capabilities = await FlutterEmailSender.getCapabilities();
      if (!capabilities.canSend || !capabilities.supportsAttachments) {
        return false;
      }
      await FlutterEmailSender.send(
        mail.Email(
          recipients: const [kOrgEmail],
          subject: _subject('Error report'),
          body: _mailBody(report),
          attachments: [
            mail.EmailAttachment.data(
              Uint8List.fromList(utf8.encode(report.toText())),
              fileName: report.fileName,
              mimeType: 'text/plain',
            ),
          ],
        ),
      );
      return true;
    } catch (e) {
      if (kDebugMode) debugPrint('Mail composer failed: $e');
      return false;
    }
  }

  /// Old reports are cleared before writing a new one, not right after
  /// sharing: the app the user shares to may still be reading the file.
  static Future<File> _writeReportFile(ErrorReport report) async {
    final dir = Directory(
      '${(await getTemporaryDirectory()).path}/error_reports',
    );
    if (dir.existsSync()) await dir.delete(recursive: true);
    await dir.create(recursive: true);
    final file = File('${dir.path}/${report.fileName}');
    return file.writeAsString(report.toText());
  }

  Future<void> copyReport(ErrorReport report) async {
    await _forgetPending();
    await Clipboard.setData(ClipboardData(text: report.toText()));
    try {
      await showToast(
        msg: _tryS((s) => s.errorReportCopied, 'تم نسخ التقرير'),
      );
    } catch (_) {
      // No toast host; the copy itself succeeded.
    }
  }

  Future<void> sendContactMessage(ContactMessage message) async {
    final s = S.current;
    final uri = message.toMailUri(
      to: kOrgEmail,
      appTitle: s.appTitle,
      typeLabel: message.type?.label(s) ?? '',
      appVersion: AppInfo.version,
    );
    await openMail(uri, fallbackText: message.body);
  }

  /// Plain email to the developer, for when the contact form can't be used
  /// (startup failed, so translations may be missing).
  Future<void> contactPlain() => openMail(
        mailtoUri(to: kOrgEmail, subject: _subject('Contact')),
        fallbackText: kOrgEmail,
      );

  String _shareText() => _tryS(
        (s) => s.errorReportShareText(kOrgEmail),
        'أرسل هذا التقرير إلى $kOrgEmail',
      );

  /// The user's own words first (they're also in the file), then the error.
  static String _mailBody(ErrorReport report) {
    final description = report.userDescription;
    return description.isEmpty
        ? '${report.summary}\n'
        : '$description\n\n---\n${report.summary}\n';
  }

  String _subject(String what) {
    final title = _tryS((s) => s.appTitle, 'معالم السنة النبوية');
    return '$title | $what | v${AppInfo.version}';
  }

  /// iPad needs an anchor for the share popover; use the screen's top half.
  static Rect? _shareOrigin() {
    final view = PlatformDispatcher.instance.views.firstOrNull;
    if (view == null) return null;
    final size = view.physicalSize / view.devicePixelRatio;
    return Rect.fromLTWH(0, 0, size.width, size.height / 2);
  }

  /// `S.current` throws if localization never loaded (startup failures).
  static String _tryS(String Function(S s) pick, String fallback) {
    try {
      return pick(S.current);
    } catch (_) {
      return fallback;
    }
  }
}
