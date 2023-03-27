import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transmedika_video_call/one_to_one/models/response/socket_response.dart';
import 'package:transmedika_video_call/webrtc/constants.dart';

import '../usecase/one_to_one_usecase_service.dart';
import 'one_to_one_event.dart';
import 'one_to_one_state.dart';

class OneToOneBloc extends Bloc<OneToOneUiUIEvent, OneToOneUiState>{
  OneToOneBloc(
      {required OneToOneUseCaseService oneToOneUseCaseService}):
        _oneToOneUseCaseService = oneToOneUseCaseService, super(const OneToOneUiState(
        socketState: SocketState(socketConnectionState: SocketConnectionState.idle)
  )) {
    on<OnConnectToSocket>(
        _onConnectToSocket
    );

    on<OnSocketOpen>(
        _onSocketOpen
    );

    on<OnSocketMessage>(
        _onSocketMessage
    );

    on<OnSocketClose>(
        _onSocketClose
    );

    on<OnSocketRegister>(
        _onRegisterToSocket
    );

    on<OnLocalStream>(
        _onLocalStream
    );

    on<OnRemoteStream>(
        _onRemoteStream
    );
  }


  final OneToOneUseCaseService _oneToOneUseCaseService;

  _onRegisterToSocket(OnSocketRegister event, Emitter<OneToOneUiState> emit) async{
    emit(state.copyWith(callState: CallState.registering));
    await _oneToOneUseCaseService.register(event.self);
  }

  _onSocketOpen(OnSocketOpen event, Emitter<OneToOneUiState> emit) async{
    emit(state.copyWith(
        socketState: const SocketState(
            socketConnectionState: SocketConnectionState.open
        )
    ));
    add(OnSocketRegister(self: event.self, other: event.other));
  }

  _onLocalStream(OnLocalStream event, Emitter<OneToOneUiState> emit) async{
    emit(state.copyWith(localStream: event.mediaStream));
  }

  _onRemoteStream(OnRemoteStream event, Emitter<OneToOneUiState> emit) async{
    emit(state.copyWith(remoteStream: event.mediaStream));
  }

  _onSocketMessage(OnSocketMessage event, Emitter<OneToOneUiState> emit) async{
    Map<String, dynamic> valueMap = json.decode(event.message);
    SocketResponse response = SocketResponse.fromJson(valueMap);

    emit(state.copyWith(
        socketState: state.socketState?.copyWith(
          message: event.message,
          messageModel: response
        )
    ));

    switch (response.id) {
      case Constants.registerResponse:
        if (response.response == Constants.accepted) {
          emit(state.copyWith(callState: CallState.registerAccepted));
          if(event.other!=null) {
            await _createLocalPeerConnection();
            _createOffer(response,event.self, event.other);
          }
        } else {
          emit(state.copyWith(callState: CallState.registerRejected));
        }
        break;
      case Constants.callResponse:
        if (response.response == Constants.accepted) {
          emit(state.copyWith(callState: CallState.callAccepted));
          _oneToOneUseCaseService.receiveVideoAnswer(response);
        } else {
          emit(state.copyWith(callState: CallState.callRejected));
        }
        break;
      case Constants.incomingCall:
        if(event.other == null) {
          await _createLocalPeerConnection();
          _createOffer(response,event.self, event.other);
        }
        emit(state.copyWith(callState: CallState.incomingCall));
        break;
      case Constants.startCommunication:
        emit(state.copyWith(callState: CallState.startCommunication));
        _oneToOneUseCaseService.receiveVideoAnswer(response);
        break;
      case Constants.iceCandidate:
        emit(state.copyWith(callState: CallState.iceCandidate));
        _oneToOneUseCaseService.iceCandidate(response);
        break;
      case Constants.stopCommunication:
        emit(state.copyWith(callState: CallState.stopCommunication));
        break;
      default:
        emit(state.copyWith(callState: CallState.unknown));
        debugPrint(Constants.unknown);
    }
  }

  _createLocalPeerConnection() async{
    await _oneToOneUseCaseService.createLocalPeerConnection(
        onLocalStream: (stream) {
          add(OnLocalStream(mediaStream: stream));
        },
        onRemoteStream: (stream) {
          add(OnRemoteStream(mediaStream: stream));
        });
  }

  _createOffer(SocketResponse response, String self, String? other) async{
    if(other!=null){
      _oneToOneUseCaseService.createOffer(from: self,to: other);
    }else{
      _oneToOneUseCaseService.createOffer(to: response.from!);
    }

  }

  _onSocketClose(OnSocketClose event, Emitter<OneToOneUiState> emit) async{
    if(event.from){
      await _oneToOneUseCaseService.close();
    }
    emit(state.copyWith(
        socketState: SocketState(
            socketConnectionState: SocketConnectionState.close,
            exception: event.ex
        )
    ));
  }

  _onConnectToSocket(OnConnectToSocket event, Emitter<OneToOneUiState> emit) async{
    emit(state.copyWith(
      socketState: const SocketState(
          socketConnectionState: SocketConnectionState.connecting
      ),
    ));
    try{
      await _oneToOneUseCaseService.connect(url: event.host,
              onOpen: () => add(OnSocketOpen(self: event.self, other: event.other)),
              onMessage: (message) => add(OnSocketMessage(message: message, self: event.self, other: event.other)),
              onClose: (code, reason) => add(OnSocketClose(ex: reason!, from: false))
      );

    }on Exception catch(e){
      emit(state.copyWith(
        socketState: SocketState(
            socketConnectionState: SocketConnectionState.error,
            exception: e.toString())
      ));
    }
  }

  @override
  Future<void> close() async {
    _oneToOneUseCaseService.close();
    return super.close();
  }


}