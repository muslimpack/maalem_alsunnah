/// `mailto:` link with every part percent-encoded. Built by hand because
/// [Uri.queryParameters] encodes spaces as `+`, which mail apps show as-is.
Uri mailtoUri({
  required String to,
  required String subject,
  String body = '',
}) {
  return Uri.parse(
    'mailto:$to'
    '?subject=${Uri.encodeComponent(subject)}'
    '&body=${Uri.encodeComponent(body)}',
  );
}
