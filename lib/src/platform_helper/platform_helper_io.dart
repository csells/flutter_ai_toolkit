import 'dart:io';

import 'package:cross_file/cross_file.dart';

/// Deletes a file from the file system.
///
/// This method takes an [XFile] object and deletes the corresponding file
/// from the file system. It uses the [File] class from dart:io to perform
/// the deletion.
///
/// Parameters:
///   - file: An [XFile] object representing the file to be deleted.
///
/// Returns:
///   A [Future] that completes when the file has been deleted.
///
/// Throws:
///   - [FileSystemException] if the file cannot be deleted.
Future<void> deleteFile(XFile file) async {
  await File(file.path).delete();
}
