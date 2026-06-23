import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:behabior/app.dart';
import 'package:behabior/core/systems/audio_system.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  await AudioSystem.init();

  runApp(const DinoApp());
}
