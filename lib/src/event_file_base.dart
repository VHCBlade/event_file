import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:event_bloc/event_bloc.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

/// Repository that manages saving and loading files.
abstract class FileRepository extends Repository {
  /// Saves the [bytes] representing a file under the given [id]
  FutureOr<bool> saveFile(String id, Uint8List bytes);

  /// Loads the saved bytes under the given id. Will return null if
  /// nothing was found.
  FutureOr<Uint8List?> loadFile(String id);

  /// Deletes the saved bytes under the given id. Will return true if
  /// the file was successfully deleted. Otherwise, will return false.
  FutureOr<bool> deleteFile(String id);

  @override
  List<BlocEventListener<dynamic>> generateListeners(
    BlocEventChannel channel,
  ) =>
      [];
}

/// Implementation of [FileRepository] that saves and loads the files from
/// the local directory.
class LocalFileRepository extends FileRepository {
  /// [directory] is the base directory for the files. All files will be saved
  /// directly into their id.
  LocalFileRepository(this.directory) {
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
  }

  /// [directory] the base directory for the files. All files will be saved
  /// directly into their id.
  final Directory directory;

  /// Gives the corresponding [File] for the given [id] in the correct
  /// [directory]
  File fileObject(String id) => File(join(directory.path, id));

  @override
  Uint8List? loadFile(String id) {
    final file = fileObject(id);
    if (!file.existsSync()) {
      return null;
    }

    return file.readAsBytesSync();
  }

  @override
  bool saveFile(String id, Uint8List bytes) {
    fileObject(id).writeAsBytesSync(bytes, flush: true);

    return true;
  }

  @override
  FutureOr<bool> deleteFile(String id) {
    final file = fileObject(id);
    if (!file.existsSync()) {
      return false;
    }

    file.deleteSync();
    return true;
  }
}

/// Checks the type of a file based on the bytes
class FileTypeRepository extends Repository {
  /// Returns the type of the file specified by [bytes]
  String? getMimeType(Uint8List bytes) {
    return lookupMimeType(
      'temp',
      headerBytes: bytes,
    );
  }

  @override
  List<BlocEventListener<dynamic>> generateListeners(
    BlocEventChannel channel,
  ) =>
      [];
}
