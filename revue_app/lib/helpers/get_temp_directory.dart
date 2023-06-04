import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// Returns a temp `Directory` for the app
/// If [subDirectory] is provided it will add to the path
Future<Directory> getAppTempDir(
  Directory? subDirectory,
) async {
  final rootTempDir = await getTemporaryDirectory();

  // Final temp directory
  var tempDir = rootTempDir;

  // If subdirectory add it to app temp directory
  if (subDirectory != null) {
    final subPath = path.join(rootTempDir.path, subDirectory.path);
    tempDir = Directory(subPath);
  }

  // Check if it exists if not create it
  if (!await tempDir.exists()) {
    await tempDir.create(recursive: true);
  }

  return tempDir;
}
