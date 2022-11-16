import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unreal/models/preset.dart';

import '../socket_porovider.dart';
import 'preset_event_list.dart';
import 'preset_list.dart';

class PresetScreen extends StatefulWidget {
  const PresetScreen({super.key});

  @override
  State<PresetScreen> createState() => _PresetScreenState();
}

class _PresetScreenState extends State<PresetScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var reloadButton = ElevatedButton.icon(
        onPressed: context.read<SocketProvider>().getPresets,
        icon: const Icon(Icons.refresh),
        label: const Text('Reload'));
    return Scaffold(
        appBar: AppBar(
            title: const Text('Presets'),
            leading:
                BackButton(onPressed: context.read<SocketProvider>().close)),
        body: FutureBuilder<Object?>(
            future: Future.delayed(const Duration(milliseconds: 1500)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox.square(
                            dimension: 30,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))));
              }
              return context
                      .select<SocketProvider, bool>((s) => s.isPresetValid)
                  ? Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Center(child: reloadButton),
                              const SizedBox(height: 20),
                              Expanded(
                                child: Builder(builder: (context) {
                                  var presets = context.select<SocketProvider,
                                      List<Preset>>((s) => s.preset);
                                  if (presets.isNotEmpty) {
                                    return PresetList(data: presets);
                                  }
                                  return const SizedBox();
                                }),
                              ),
                            ],
                          ),
                        ),
                        Container(color: Colors.black, width: 1),
                        const Expanded(
                            child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 50),
                          child: PresetEventList(),
                        )),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('No presets available'),
                          SizedBox(height: 20),
                          reloadButton
                        ],
                      ),
                    );
            }));
  }
}
