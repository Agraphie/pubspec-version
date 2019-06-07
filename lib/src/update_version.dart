import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_version/src/console.dart';
import 'package:pubspec_version/src/version_extractor.dart';

abstract class UpdateVersion extends Command {
  final Console console;

  UpdateVersion(this.console);

  Future run() async {
    final dir = Directory(globalResults['pubspec-dir']);
    final File pubSpec = File(p.join(dir.path, "pubspec.yaml"));

    Version oldVersion = VersionExtractor.extractVersion(pubSpec);
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

  Version nextVersion(Version v);
}
