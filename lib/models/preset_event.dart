import 'package:unreal/models/preset.dart';

class PresetEvent {
  String? type;
  String? presetName;
  String? presetId;
  Preset? preset;

  PresetEvent({this.type, this.presetName, this.presetId, this.preset});

  PresetEvent.fromJson(Map<String, dynamic> json) {
    type = json['Type'];
    presetName = json['PresetName'];
    presetId = json['PresetId'];
    preset = json['Preset'] != null ? Preset.fromJson(json['Preset']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Type'] = type;
    data['PresetName'] = presetName;
    data['PresetId'] = presetId;
    if (preset != null) {
      data['Preset'] = preset?.toJson();
    }

    return data;
  }
}
