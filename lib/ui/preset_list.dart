import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unreal/models/preset.dart';
import 'package:unreal/ui/preset_tile.dart';

import '../socket_porovider.dart';

class PresetList extends StatelessWidget {
  final List<Preset> data;
  const PresetList({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          var item = data[index];

          return Column(
            children: [
             PresetTile(data: item),
              if (index < data.length - 1) const Divider(height: 1),
            ],
          );
        });
  }
}
