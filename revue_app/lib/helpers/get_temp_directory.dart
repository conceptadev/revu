import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// Returns a temp `Directory` for sidekick
/// If [subDirectory] is provided it will add to the path
Future<Directory> getSidekickTempDir({
  Directory? subDirectory,
}) async {
  final rootTempDir = await getTemporaryDirectory();
  final appTempDir = Directory(path.join(rootTempDir.path, kAppBundleId));

  // Final temp directory
  var tempDir = appTempDir;

  // If subdirectory add it to app temp directory
  if (subDirectory != null) {
    final subPath = path.join(appTempDir.path, subDirectory.path);
    tempDir = Directory(subPath);
  }

  // Check if it exists if not create it
  if (!await tempDir.exists()) {
    await tempDir.create(recursive: true);
  }

  return tempDir;
}
