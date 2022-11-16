class Preset {
  String? name;
  String? id;
  String? path;

  Preset({this.name, this.id, this.path});

  Preset.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    id = json['ID'];
    path = json['Path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['ID'] = id;
    data['Path'] = path;
    return data;
  }
}
