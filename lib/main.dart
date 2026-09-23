import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

import 'data/database.dart';
import 'data/providers.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final db = AppDatabase();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        dbProvider.overrideWithValue(db),
        sharedPrefsProvider.overrideWithValue(prefs),
      ],
      child: const XpencApp(),
    ),
  );
}
