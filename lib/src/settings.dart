import 'dart:convert';
import 'dart:io';

import 'package:fimber_io/fimber_io.dart';
import 'package:flutter/material.dart';

const defaultConfig = {
  "lePath": "",
  "blurNsfw": false,
  "hideNsfw": false,
  "gelbooruTags":
      "cat_ears -rating:questionable -rating:explicit -huge_filesize width:>=1080 score:>=30",
  "vndbTitles": "default"
};

class LauncherConfig extends ChangeNotifier {
  final File configFile;
  late String lePath;
  late bool blurNsfw;
  late bool hideNsfw;
  late String gelbooruTags;
  late String vndbTitles;

  get defaults => defaultConfig;

  LauncherConfig(this.configFile) {
    Fimber.i("Loading launcher config from ${configFile.absolute}.");
    if (!configFile.existsSync()) {
      Fimber.i("Launcher config file not found, creating a new one.");
      configFile.createSync(recursive: true);
      configFile.writeAsStringSync(jsonEncode(defaultConfig));
    }
    var content = configFile.readAsStringSync();
    var config = jsonDecode(content) as Map<String, dynamic>;
    lePath = config["lePath"] ?? defaultConfig["lePath"];
    blurNsfw = config["blurNsfw"] ?? defaultConfig["blurNsfw"];
    hideNsfw = config["hideNsfw"] ?? defaultConfig["hideNsfw"];
    gelbooruTags = config["gelbooruTags"] ?? defaultConfig["gelbooruTags"];
    vndbTitles = config["vndbTitles"] ?? defaultConfig["vndbTitles"];
  }

  void save() {
    var config = {
      "lePath": lePath,
      "blurNsfw": blurNsfw,
      "hideNsfw": hideNsfw,
      "gelbooruTags": gelbooruTags,
      "vndbTitles": vndbTitles
    };
    Fimber.i("Saving launcher config changes to file.");
    configFile.writeAsStringSync(jsonEncode(config));
    notifyListeners();
  }
}
