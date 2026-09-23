import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

import 'data/database.dart';
import 'data/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final db = AppDatabase();
  SettingRow? initialSettings;
  try {
    initialSettings = await db.getSettings();
  } catch (_) {
    // databaseReadyProvider will surface this error later.
  }

  runApp(
    ProviderScope(
      overrides: [
        dbProvider.overrideWithValue(db),
        initialSettingsProvider.overrideWithValue(initialSettings),
      ],
      child: const XpencApp(),
    ),
  );
}
