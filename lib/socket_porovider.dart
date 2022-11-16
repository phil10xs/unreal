import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:unreal/models/preset.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'models/preset_event.dart';
import 'utils/response_processor.dart';

class SocketProvider extends ChangeNotifier {
  ConnectionState _connectionState = ConnectionState.none;

  ConnectionState get connectionState => _connectionState;

  String uri = 'ws://127.0.0.1:30020';

  StreamSubscription? subscription;
  WebSocketChannel? channel;

  List<Preset> _preset = [];
  List<Preset> get preset => _preset;

  List<PresetEvent> _events = [];
  List<PresetEvent> get events => _events;

  Preset? get selected => _selected;
  Preset? _selected;

  bool get isPresetValid => _preset.isNotEmpty;

  setConnection(ConnectionState state) {
    _connectionState = state;
    notifyListeners();
  }

  Future<bool> connect() async {
    setConnection(ConnectionState.waiting);

    try {
      channel = WebSocketChannel.connect(Uri.parse(uri));
      if (kDebugMode) {
        print(channel?.sink);
      }
      setConnection(ConnectionState.active);

      subscription = channel?.stream.listen((message) {
        if (kDebugMode) {
          print('message::: $message, ${utf8.decode(message)}');
        }
        final data = ResponseProcessor.handle(utf8.decode(message));
        if (kDebugMode) {
          print('message::: $data,');
        }

        if (data is List<Preset>) {
          _preset = data;
          notifyListeners();
          if (kDebugMode) {
            print('message::: $_preset');
          }
        }
        if (data is PresetEvent) {
          _events.add(data);
          if (kDebugMode) {
            print('message::: $data, $_events');
          }
          notifyListeners();
        }
      });

      subscription
        ?..onDone(() {
          // reset connection when connection closes
          setConnection(ConnectionState.none);
        })
        ..onError((err) {
          if (kDebugMode) {
            print(err);
          }
          // reset connection when connection closes
          setConnection(ConnectionState.none);
        });
    } catch (e) {
      if (kDebugMode) {
        print('message::: $e');
      }
      setConnection(ConnectionState.none);
    }
    return channel?.sink != null;
  }

  getPresets() {
    channel?.sink.add(jsonEncode({
      "MessageName": "http",
      "Parameters": {
        "Url": "/remote/presets",
        "Verb": "GET",
        "Body": {
          "ObjectPath":
              "/Game/ThirdPersonBP/Maps/ThirdPersonExampleMap.ThirdPersonExampleMap:PersistentLevel.CubeMesh_5.StaticMeshComponent0",
          "propertyName": "StreamingDistanceMultiplier",
          "access": "READ_ACCESS"
        }
      }
    }));
  }

  close() {
    subscription?.cancel();
    channel = null;
    _preset = [];
    _events = [];
    _connectionState = ConnectionState.none;
    notifyListeners();
  }

  resetEvent() {
    _events = [];
    notifyListeners();
  }

  select(Preset preset) {
    if (selected != null) {
      unregister(selected!);
    }
    _selected = preset;
    notifyListeners();
    register(selected!);
  }

  register(Preset preset) {
    channel?.sink.add(jsonEncode({
      "MessageName": "preset.register",
      "Parameters": {"PresetName": preset.name}
    }));
  }

  unregister(Preset preset) {
    _events = [];
    channel?.sink.add(jsonEncode({
      "MessageName": "preset.unregister",
      "Parameters": {"PresetName": preset.name}
    }));
  }
}
