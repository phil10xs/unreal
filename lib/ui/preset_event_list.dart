import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unreal/models/preset_event.dart';
import 'package:unreal/socket_porovider.dart';

class PresetEventList extends StatelessWidget {
  const PresetEventList({super.key});

  @override
  Widget build(BuildContext context) {
    var events = context.read<SocketProvider>().events;
    return ListView.builder(
        itemCount: context.select<SocketProvider, int>((s) => s.events.length),
        itemBuilder: (context, index) {
          var item = events[index];

          return Column(
            children: [
              ListTile(
                  onTap: () {},
                  title: Text(item.presetName ?? item.preset?.name ?? ''),
                  subtitle: Text(item.type ?? '')),
              if (index < events.length - 1) const Divider(height: 1),
            ],
          );
        });
  }
}
