import 'package:equatable/equatable.dart';
import 'package:transmedika_video_call/one_to_one/models/response/socket_response.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

enum SocketConnectionState { idle, connecting, open, close, error}
enum CallState{
  registering,
  registerAccepted,
  registerRejected,
  callAccepted,
  callRejected,
  incomingCall,
  startCommunication,
  iceCandidate,
  stopCommunication,
  unknown
}

class SocketState extends Equatable{
  final SocketConnectionState socketConnectionState;
  final String? exception;
  final String? message;
  final SocketResponse? messageModel;

  const SocketState({
    this.socketConnectionState = SocketConnectionState.idle,
    this.exception,
    this.message,
    this.messageModel
  });

  SocketState copyWith({
    SocketConnectionState? socketConnectionState,
    String? exception,
    String? message,
    SocketResponse? messageModel
  }) {
    return SocketState(
      socketConnectionState: socketConnectionState ?? this.socketConnectionState,
      exception: exception ?? this.exception,
      message: message ?? this.message,
      messageModel: messageModel ?? this.messageModel
    );
  }

  @override
  List<Object?> get props => [socketConnectionState, exception, message, messageModel];
}


class OneToOneUiState extends Equatable{
  const OneToOneUiState({
    this.socketState,
    this.callState,
    this.localStream,
    this.remoteStream,
    this.self,
    this.other
  });

  final SocketState? socketState;
  final CallState? callState;
  final MediaStream? localStream;
  final MediaStream? remoteStream;
  final String? self;
  final String? other;

  OneToOneUiState copyWith({
    SocketState? socketState,
    CallState? callState,
    MediaStream? localStream,
    MediaStream? remoteStream,
    String? self,
    String? other
  }) {
    return OneToOneUiState(
      socketState: socketState ?? this.socketState,
      callState: callState ?? this.callState,
      localStream: localStream ?? this.localStream,
      remoteStream: remoteStream ?? this.remoteStream,
      self: self ?? this.self,
      other: other ?? this.other
    );
  }

  @override
  List<Object?> get props => [socketState, callState, localStream, remoteStream, self, other];
}