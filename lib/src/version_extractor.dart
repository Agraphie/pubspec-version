import 'dart:io';

import 'package:pub_semver/pub_semver.dart';

abstract class VersionExtractor {
  static Version extractVersion(File pubSpec) {
    List<String> lines = pubSpec.readAsLinesSync();
    String versionStringUnformatted =
        lines.firstWhere((l) => l.startsWith("version: "), orElse: () => null);
    if (versionStringUnformatted == null) {
      throw new StateError("No version found!");
    }

    String versionString = _extractVersion(versionStringUnformatted);
    Version oldVersion = Version.parse(versionString);
    return oldVersion;
  }

  static String _extractVersion(String versionStringUnformatted) {
    String versionString = versionStringUnformatted
        .replaceAll('"', "")
        .split("version: ")
        .skip(1)
        .first;
    return versionString;
  }
}
