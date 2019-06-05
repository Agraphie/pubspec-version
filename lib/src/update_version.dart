import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_version/src/console.dart';

abstract class UpdateVersion extends Command {
  final Console console;

  UpdateVersion(this.console);

  Future run() async {
    final dir = Directory(globalResults['pubspec-dir']);
    final File pubSpec = File(p.join(dir.path, "pubspec.yaml"));

    List<String> lines = pubSpec.readAsLinesSync();
    String versionStringUnformatted =
        lines.firstWhere((l) => l.startsWith("version: "), orElse: () => null);
    if (versionStringUnformatted == null) {
      throw new StateError("No version found!");
    }

    String versionString = _extractVersion(versionStringUnformatted);
    Version oldVersion = Version.parse(versionString);
    Version newVersion = nextVersion(oldVersion);
    console.log(newVersion.toString());

    _writeNewPubSpec(pubSpec, oldVersion, newVersion);
  }

  Future _writeNewPubSpec(
      File pubSpec, Version oldVersion, Version newVersion) async {
    String newPubSpec = pubSpec.readAsStringSync().replaceFirst(
        'version: "${oldVersion}"', "version: " + '"${newVersion.toString()}"');

    final ioSink =
        await File(p.join(pubSpec.parent.path, 'pubspec.yaml')).openWrite();

    try {
      ioSink.write(newPubSpec);
    } finally {
      return ioSink.close();
    }
  }

  String _extractVersion(String versionStringUnformatted) {
    String versionString = versionStringUnformatted
        .replaceAll('"', "")
        .split("version: ")
        .skip(1)
        .first;
    return versionString;
  }

  Version nextVersion(Version v);
}
