import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;

abstract class PubSpecLocator {
  static Future<File> findPubSpec(Directory dir) async {
    String tempPath;
    String pubSpecPath = p.join(dir.path, "pubspec.yaml");

    while (!await File(pubSpecPath).exists()) {
      // Need this to stop in case we can't traverse any further
      if (tempPath == dir.path) {
        throw Exception("No pubspec.yml found!");
      }
      tempPath = dir.path;
      dir = dir.parent;
      pubSpecPath = p.join(dir.path, "pubspec.yaml");
    }

    return File(pubSpecPath);
  }
}
