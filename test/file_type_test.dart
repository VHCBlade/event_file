import 'dart:io';

import 'package:event_bloc_tester/event_bloc_tester.dart';
import 'package:event_file/event_file.dart';
import 'package:test/test.dart';

final testCases = {
  'Empty': () => 'fake_image.png',
  'Normal': () => 'test_image.png',
  'Text': () => 'text.png',
  'EmptyPDF': () => 'fake_document.pdf',
  'NormalPDF': () => 'test_document.pdf',
  'TextPDF': () => 'text.pdf',
};

void main() {
  group('FileTypeRepository', () {
    group('getMimeType', mimeTypeTest);
  });
}

void mimeTypeTest() {
  SerializableListTester<String>(
    testGroupName: 'FileTypeRepository',
    mainTestName: 'getMimeType',
    mode: ListTesterMode.auto,
    testFunction: (value, tester) async {
      final repository = FileTypeRepository();

      final file = File('test_files/$value');
      tester.addTestValue(repository.getMimeType(file.readAsBytesSync()));
    },
    testMap: testCases,
  ).runTests();
}
