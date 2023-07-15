import 'dart:io';

void resetFileDB() {
  if (Directory('test_db').existsSync()) {
    Directory('test_db').deleteSync(recursive: true);
  }
}
