class Constants{
  static const String register = 'register';
  static const String stop = 'stop';
  static const String call = 'call';
  static const String onIceCandidate = 'onIceCandidate';
  static const String incomingCallResponse = 'incomingCallResponse';
  static const String registerResponse = 'registerResponse';
  static const String presenterResponse = 'presenterResponse';
  static const String iceCandidate = 'iceCandidate';
  static const String viewerResponse = 'viewerResponse';
  static const String stopCommunication = 'stopCommunication';
  static const String closeRoomResponse = 'closeRoomResponse';
  static const String incomingCall = 'incomingCall';
  static const String startCommunication = 'startCommunication';
  static const String callResponse = 'callResponse';
  static const String existingParticipants = 'existingParticipants';
  static const String newParticipantArrived = 'newParticipantArrived';
  static const String participantLeft = 'participantLeft';
  static const String receiveVideoAnswer = 'receiveVideoAnswer';
  static const String unknown = 'unknown';

  static const String accept = 'accept';
  static const String accepted = 'accepted';
  static const String rejected = 'rejected';
  static const iceServers = {
    'iceServers': [
      {'url': 'stun:stun.l.google.com:19302'},
      {'url': 'stun:stun1.l.google.com:19302'},
      {'url': 'stun:stun2.l.google.com:19302'},
      {'url': 'stun:stun3.l.google.com:19302'},
      {'url': 'stun:stun4.l.google.com:19302'},
    ]
  };
  static const constraints = {
    'mandatory': {
      'OfferToReceiveAudio': true,
      'OfferToReceiveVideo': true,
    },
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ],
  };

  static const rtcConfig = {
    'tcpCandidatePolicy': 'enabled',
    'keyType': 'ECDSA',
    'sdpSemantics': 'unified-plan',
    'bundlePolicy': 'max-bundle',
    'rtcpMuxPolicy': 'negotiate',
    'continualGatheringPolicy':'gather_continually'
  };


}