import 'package:flutter_test/flutter_test.dart';
import 'package:maalem_alsunnah/src/core/utils/rich_text_controller.dart';

void main() {
  test('plainTextOf strips formatting tags and unescapes text', () {
    expect(
      RichTextController.plainTextOf('<b>bold</b> &amp; <i>it</i> a &lt; b'),
      'bold & it a < b',
    );
    expect(RichTextController.plainTextOf('legacy plain note'), 'legacy plain note');
  });
}
