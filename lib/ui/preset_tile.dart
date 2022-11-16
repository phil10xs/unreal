import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unreal/models/preset.dart';
import 'package:unreal/socket_porovider.dart';

class PresetTile extends StatelessWidget {
  const PresetTile({super.key, required this.data});
  final Preset data;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        selectedColor: Colors.amber,
        selected:
            context.select<SocketProvider, Preset?>((s) => s.selected)?.name ==
                data.name,
        onTap: () {
          context.read<SocketProvider>().select(data);
        },
        title: Text(data.name ?? ''),
        trailing: const Icon(CupertinoIcons.forward));
  }
}
