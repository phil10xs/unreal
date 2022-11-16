import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unreal/ui/preset_screen.dart';

import '../socket_porovider.dart';

class ConnectionScreen extends StatelessWidget {
  const ConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.select<SocketProvider, ConnectionState>(
            (s) => s.connectionState) ==
        ConnectionState.active) {
      return const PresetScreen();
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Remote Control test')),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 400,
                child: TextFormField(
                  initialValue: context.read<SocketProvider>().uri,
                  onChanged: (val) => context.read<SocketProvider>().uri = val,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                    onPressed: () {
                      context.read<SocketProvider>().connect().then((value) {
                        if (value) {
                          context.read<SocketProvider>()
                            ..resetEvent()
                            ..getPresets();
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (c) => const PresetScreen()));
                        }
                      });
                    },
                    child: context.select<SocketProvider, ConnectionState>(
                                (s) => s.connectionState) ==
                            ConnectionState.waiting
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SizedBox.square(
                                  dimension: 15,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  )),
                            ),
                          )
                        : const Text('Connect')),
              )
            ]),
      ),
    );
  }
}
