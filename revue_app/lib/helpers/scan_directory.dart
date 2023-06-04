import 'dart:async';
import 'dart:io';

/// Scans [rootDir] for entities that meet a certain condition
Stream<FileSystemEntity> scanDirectoryForCondition({
  required bool Function(FileSystemEntity) condition,
  required Directory rootDir,
}) async* {
  try {
    // Find entities recursively
    await for (FileSystemEntity entity in rootDir.list(
      recursive: true,
      followLinks: false,
    )) {
      // Check if entity meets condition
      if (condition(entity)) {
        yield entity;
      }
    }
  } catch (e) {
    // Handle any errors that occur
    print('Error scanning directory: $e');
  }
}
