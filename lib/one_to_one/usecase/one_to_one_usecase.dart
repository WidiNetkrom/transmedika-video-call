import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:transmedika_video_call/one_to_one/models/param/call_param.dart';
import 'package:transmedika_video_call/one_to_one/models/param/ice_candidate_param.dart';
import 'package:transmedika_video_call/one_to_one/models/param/incoming_call_param.dart';
import 'package:transmedika_video_call/one_to_one/models/param/stop_param.dart';
import 'package:transmedika_video_call/one_to_one/models/response/candidate.dart';
import 'package:transmedika_video_call/one_to_one/models/response/socket_response.dart';
import 'package:transmedika_video_call/webrtc/constants.dart';
import 'package:transmedika_video_call/websocket/websocket.dart'
if (dart.library.js) 'package:webrtc/websocket/websocket_web.dart';

import '../models/param/register_param.dart';
import 'one_to_one_usecase_service.dart';

class OneToOneUseCase implements OneToOneUseCaseService{
  late SimpleWebSocket _socket;
  late RTCPeerConnection _peerConnection;
  late MediaStream localStream;
  final List<RTCIceCandidate> remoteCandidates = <RTCIceCandidate>[];
  final List<RTCRtpSender> _senders = <RTCRtpSender>[];

  @override
  Future<void> connect({
      required String url,
      required Function()? onOpen,
      required Function(dynamic)? onMessage,
      required Function(int? code, String? reason)? onClose}) async {
    try{
      _socket = SimpleWebSocket(url);
      _socket.onOpen = () {
        onOpen?.call();
      };

      _socket.onMessage = (message) {
        onMessage?.call(message);
      };

      _socket.onClose = (int? code, String? reason) {
        onClose?.call(code, reason);
      };

      await _socket.connect();
    }on SocketException catch(e){
      onClose?.call(e.osError?.errorCode, e.osError?.message);
    }
  }

  @override
  SimpleWebSocket getSocket() {
    return _socket;
  }

  @override
  Future<void> close() async {
    await _socket.close();
  }

  @override
  Future<void> register(String id) async {
    RegisterParam param = RegisterParam(
      id: Constants.register,
      name: id
    );
    await _socket.send(const JsonEncoder().convert(param));
  }

  @override
  Future<void> createLocalPeerConnection({
    required Function(MediaStream stream) onLocalStream,
    required Function(MediaStream stream) onRemoteStream
  }) async {
    localStream = await createStream();
    onLocalStream.call(localStream);
    _peerConnection = await createPeerConnection({
      ...Constants.iceServers,
      ...Constants.rtcConfig
    }, Constants.constraints);

    _peerConnection.onIceCandidate = (candidate) {
      onIceCandidate(candidate);
    };

    _peerConnection.onTrack = (event) {
      if (event.track.kind == 'video') {
        onRemoteStream.call(event.streams[0]);
      }
    };

    localStream.getTracks().forEach((track) async {
      _senders.add(await _peerConnection.addTrack(track, localStream));
    });
  }

  @override
  Future<MediaStream> createStream() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'mandatory': {
          'minWidth': '320',
          'minHeight': '240',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      }
    };
    MediaStream stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    return stream;
  }

  @override
  RTCPeerConnection? getPeerConnection() {
    return _peerConnection;
  }

  @override
  Future<void> stop() async {
    StopParam param = StopParam(
        id: Constants.stop
    );
    await _socket.send(const JsonEncoder().convert(param));
  }

  @override
  Future<void> publishCallVideo({
    required String from,
    required String to,
    required RTCSessionDescription sessionDescription}) async {
    CallParam param = CallParam(
      id: Constants.call,
      to: to,
      from: from,
      sdpOffer: sessionDescription.sdp
    );
    await _socket.send(const JsonEncoder().convert(param));
  }

  @override
  Future<void> publishIncomingCallVideo({
    required String to,
    required RTCSessionDescription sessionDescription}) async {
    IncomingCallParam param = IncomingCallParam(
      id: Constants.incomingCallResponse,
      from: to,
      callResponse: Constants.accept,
      sdpOffer: sessionDescription.sdp
    );
    await _socket.send(const JsonEncoder().convert(param));
  }

  @override
  Future<void> iceCandidate(SocketResponse response) async {
    Candidate? candidateModel = response.candidate;
    RTCIceCandidate iceCandidate = RTCIceCandidate(candidateModel?.sdp, candidateModel?.sdpMid, candidateModel?.sdpMLineIndex);
    RTCSessionDescription? remoteDescription = await _peerConnection.getRemoteDescription();

    switch(_peerConnection.signalingState){
      case RTCSignalingState.RTCSignalingStateClosed:
        debugPrint("saveIceCandidate error: PeerConnection object is closed");
        break;
      case RTCSignalingState.RTCSignalingStateStable:
        if(remoteDescription!=null){
          _peerConnection.addCandidate(iceCandidate);
        }else{
          remoteCandidates.add(iceCandidate);
        }
        break;
      default:
        remoteCandidates.add(iceCandidate);
    }
  }



  @override
  Future<void> receiveVideoAnswer(SocketResponse response) async {
    RTCSessionDescription sessionDescription = RTCSessionDescription(response.sdpAnswer,'answer');
    _peerConnection.setRemoteDescription(sessionDescription);
  }

  @override
  Future<void> onIceCandidate(RTCIceCandidate rtcIceCandidate) async {
    Candidate candidate = Candidate(
        sdpMid: rtcIceCandidate.sdpMid!,
        sdpMLineIndex: rtcIceCandidate.sdpMLineIndex!,
        sdp: rtcIceCandidate.candidate!);

    IceCandidateParam param = IceCandidateParam(
      id: Constants.onIceCandidate,
      candidate: candidate
    );
    await _socket.send(const JsonEncoder().convert(param));
  }

  @override
  Future<void> createOffer({String? from, required String to}) async {
    try {
      RTCSessionDescription sessionDescription = await _peerConnection.createOffer(Constants.constraints);
      await _peerConnection.setLocalDescription(sessionDescription);
      if(from!=null){
        publishCallVideo(from: from, to: to, sessionDescription: sessionDescription);
      }else {
        publishIncomingCallVideo(to: to, sessionDescription: sessionDescription);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

}