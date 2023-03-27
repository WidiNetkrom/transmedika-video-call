import 'dart:io';

import 'package:flutter/foundation.dart';

class SimpleWebSocket {
  final String _url;
  late WebSocket _socket;
  Function()? onOpen;
  Function(dynamic msg)? onMessage;
  Function(int code, String reason)? onClose;

  SimpleWebSocket(this._url);

  Future<void> connect() async {
    _socket = await WebSocket.connect(_url); //_connectForSelfSignedCert(_url);
    onOpen?.call();
    _socket.listen((e) {
      onMessage?.call(e);
    }, onDone: () {
      onClose?.call(_socket.closeCode!, (_socket.closeReason?.isEmpty == true ? "Socket was close":_socket.closeReason!));
    }, onError: (e){
      onClose?.call(500, e.toString());
    });
  }

  send(data) {
    try{
      _socket.add(data);
    }on Exception catch (e){
      if (kDebugMode) {
        print(e);
      }
    }
  }

  close() async {
    try{
      await _socket.close();
    }on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}