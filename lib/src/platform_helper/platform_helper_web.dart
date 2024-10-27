import 'package:cross_file/cross_file.dart';

/// Deletes a file from the file system.
///
/// This method is a no-op on web platforms, as web browsers do not have
/// direct access to the file system. The method is provided for API
/// compatibility with non-web platforms.
///
/// Parameters:
///   - file: An [XFile] object representing the file to be deleted.
///           This parameter is ignored on web platforms.
///
/// Returns:
///   A [Future] that completes immediately, as no actual deletion occurs.
Future<void> deleteFile(XFile file) async {}
