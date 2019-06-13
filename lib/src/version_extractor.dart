import 'dart:io';

import 'package:pub_semver/pub_semver.dart';

abstract class VersionExtractor {
  static const String VERSION_REGEX = "version:.+?[^#](?=[^('|\")]*(?:(\"|')[^('|\")]*('|\")[^('|\")]*)*\$)";

  static Version extractVersion(File pubSpec) {
    RegExp versionMatch = RegExp(VERSION_REGEX);
    String lines = pubSpec.readAsStringSync();
    String versionStringUnformatted = versionMatch.firstMatch(lines)?.group(0);

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
