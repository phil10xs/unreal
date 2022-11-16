import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:unreal/models/preset.dart';
import 'package:unreal/models/preset_event.dart';

class ResponseProcessor {
  static handle(String response) {
    try {
      var decoded = jsonDecode(response); // as Map<String, dynamic>;
      if (kDebugMode) {
        print('message:::decoded $decoded, ${decoded['Presets']}');
      }
      if (decoded['ResponseCode'] == 200 && decoded["ResponseBody"] != null) {
        var responseBody = decoded['ResponseBody'];
        var presets = responseBody['Presets'];
        if (kDebugMode) {
          print('message:::presets $presets');
        }
        if (presets != null && presets is List) {
          return (presets).map((e) => Preset.fromJson(e)).toList();
        }
      }
      if (decoded['Type'] != null) {
        return PresetEvent.fromJson(decoded);
      }
    } catch (e) {
      if (kDebugMode) {
        print('message::: $e');
      }
    }
  }
}
