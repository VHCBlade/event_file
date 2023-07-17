import 'dart:io';
import 'dart:typed_data';
import 'package:event_file/event_file.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  group('Local File Repository', () {
    test('Save', () {
      resetFileDB();
      final directory = Directory('test_db/');
      final repo = LocalFileRepository(directory);

      expect(repo.loadFile('Amazing'), null);
      expect(repo.saveFile('Amazing', Uint8List.fromList([20, 256, 40])), true);
      expect(repo.loadFile('Amazing'), Uint8List.fromList([20, 256, 40]));
      expect(repo.loadFile('Cool'), null);
      expect(repo.deleteFile('Amazing'), true);
      expect(repo.loadFile('Amazing'), null);
      expect(repo.deleteFile('Cool'), false);
    });
    test('Recursive', () {
      resetFileDB();
      final directory = Directory('test_db/amazing/incredible');
      final repo = LocalFileRepository(directory);

      expect(repo.loadFile('Amazing'), null);
      expect(repo.saveFile('Amazing', Uint8List.fromList([20, 256, 40])), true);
      expect(repo.loadFile('Amazing'), Uint8List.fromList([20, 256, 40]));
      expect(repo.loadFile('Cool'), null);
      expect(repo.deleteFile('Amazing'), true);
      expect(repo.loadFile('Amazing'), null);
      expect(repo.deleteFile('Cool'), false);
    });
  });
}
