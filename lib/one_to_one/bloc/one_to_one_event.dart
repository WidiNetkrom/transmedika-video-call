import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

@immutable
abstract class OneToOneUiUIEvent extends Equatable{
  @override
  List<Object> get props => [];
}

@immutable
class OnConnectToSocket extends OneToOneUiUIEvent {
  OnConnectToSocket({required this.host, required this.self, this.other});
  final String host;
  final String self;
  final String? other;
}

@immutable
class OnSocketOpen extends OneToOneUiUIEvent {
  OnSocketOpen({required this.self, this.other});
  final String self;
  final String? other;
}

@immutable
class OnSocketMessage extends OneToOneUiUIEvent {
  OnSocketMessage({required this.message, required this.self, this.other});
  final String message;
  final String self;
  final String? other;
}

@immutable
class OnSocketClose extends OneToOneUiUIEvent {
  OnSocketClose({required this.ex, required this.from});
  final String ex;
  final bool from;
}

@immutable
class OnSocketRegister extends OneToOneUiUIEvent {
  OnSocketRegister({required this.self, this.other});
  final String self;
  final String? other;
}

@immutable
class OnLocalStream extends OneToOneUiUIEvent {
  OnLocalStream({required this.mediaStream});
  final MediaStream mediaStream;
}

@immutable
class OnRemoteStream extends OneToOneUiUIEvent {
  OnRemoteStream({required this.mediaStream});
  final MediaStream mediaStream;
}