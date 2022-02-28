import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void configureWindowForSpecTest(WidgetTester tester) {
  tester.binding.window
    ..physicalSizeTestValue = const Size(100, 100)
    // valid for dektop app. not valid for mobile since it is largely densed.
    ..devicePixelRatioTestValue = 1.0;
}

class TestAssetBundle implements AssetBundle {
  @override
  void clear() {
    // TODO: implement clear
  }

  @override
  void evict(String key) {
    // TODO: implement evict
  }

  /// [filepath] is relative to the "/test/" directory.
  @override
  Future<ByteData> load(String filepath) async {
    final file = File("test/assets/$filepath");
    final fileData = await file.readAsBytes();
    return ByteData.view(fileData.buffer);
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) {
    // TODO: implement loadString
    throw UnimplementedError();
  }

  @override
  Future<T> loadStructuredData<T>(
      String key, Future<T> Function(String value) parser) {
    // TODO: implement loadStructuredData
    throw UnimplementedError();
  }
}
