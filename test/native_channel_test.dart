import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {


  test('Kotlin package matches its directory and the Gradle namespace', () {
    final kotlin =
        File('android/app/src/main/kotlin/com/codeshowoff/xpenc/MainActivity.kt')
            .readAsStringSync();
    final gradle = File('android/app/build.gradle.kts').readAsStringSync();

    expect(kotlin, contains('package com.codeshowoff.xpenc'));
    expect(gradle, contains('namespace = "com.codeshowoff.xpenc"'));
    expect(gradle, contains('applicationId = "com.codeshowoff.xpenc"'));
  });
}
