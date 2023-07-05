import 'package:flutter/material.dart';
import 'package:katswiri/app_settings.dart';
import 'package:katswiri/managers/managers.dart' show DBManager;
import 'package:katswiri/screens/screens.dart' show Katswiri;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait(
    [
      AppSettings.init(),
      DBManager.instance.database,
    ],
  );
  runApp(const Katswiri());
}
