import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:transmedika_video_call/one_to_one/models/response/socket_response.dart';
import 'package:transmedika_video_call/websocket/websocket.dart'
if (dart.library.js) 'package:webrtc/websocket/websocket_web.dart';

abstract class OneToOneUseCaseService{
  Future<void> connect({required String url,
    required Function()? onOpen,
    required Function(dynamic message) onMessage,
    required Function(int? code, String? reason)? onClose});
  SimpleWebSocket getSocket();
  Future<void> close();
  Future<void> register(String id);
  Future<void> stop();
  Future<void> publishCallVideo({
    required String from,
    required String to,
    required RTCSessionDescription sessionDescription
  });
  Future<void> publishIncomingCallVideo({
    required String to,
    required RTCSessionDescription sessionDescription
  });
  RTCPeerConnection? getPeerConnection();
  Future<void> createLocalPeerConnection({
    required Function(MediaStream stream) onLocalStream,
    required Function(MediaStream stream) onRemoteStream
  });
  Future<MediaStream> createStream();
  Future<void> createOffer({String? from, required String to});
  Future<void> iceCandidate(SocketResponse response);
  Future<void> receiveVideoAnswer(SocketResponse response);
  Future<void> onIceCandidate(RTCIceCandidate rtcIceCandidate);
}