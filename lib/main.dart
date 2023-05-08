import 'package:flutter/material.dart';
import 'package:katswiri/db_manager.dart' show DBManager;
import 'package:katswiri/screens/screens.dart' show Katswiri;

void main() async {
  await DBManager.instance.database;
  runApp(const Katswiri());
}
