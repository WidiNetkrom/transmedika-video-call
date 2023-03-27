import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:transmedika_video_call/one_to_one/bloc/one_to_one_bloc.dart';
import 'package:transmedika_video_call/one_to_one/usecase/one_to_one_usecase.dart';

import 'one_to_one/bloc/one_to_one_event.dart';
import 'one_to_one/bloc/one_to_one_state.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RepositoryProvider.value(
          value: OneToOneUseCase(),
          child: BlocProvider<OneToOneBloc>(
              create: (context) =>
                  OneToOneBloc(
                      oneToOneUseCaseService: context.read<OneToOneUseCase>()
                  ),
              child: const MyHomePage(title: 'Flutter WebRTC One To One Kurento')
          )
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  _onConnectToSocket({required String url, required String self, String? other}) async {
    context
        .read<OneToOneBloc>()
        .add(OnConnectToSocket(host: url, self: self, other: other));
  }

  _onCloseSocket() async {
    context
        .read<OneToOneBloc>()
        .add(OnSocketClose(ex: "Close Socket from UI", from: true));
  }

  _initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  _disposeRenderers() async {
    await _localRenderer.dispose();
    await _remoteRenderer.dispose();
  }

  @override
  void initState() {
    _initRenderers();
    _onConnectToSocket(url: "wss://192.168.100.146:8443/call", self: 'widi');
    super.initState();
  }


  @override
  void dispose() {
    _disposeRenderers();
    _onCloseSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocConsumer<OneToOneBloc, OneToOneUiState>(
        listenWhen: (previous, current) {
          return previous!=current;
        },
        listener: (context, state) {
          debugPrint('State: ${state.socketState?.socketConnectionState.toString()}');
          switch(state.socketState?.socketConnectionState){
            case SocketConnectionState.connecting :
              break;
            case SocketConnectionState.open :
              debugPrint('Message: ${state.socketState?.message}');
              break;
            case SocketConnectionState.close :
            case SocketConnectionState.error :
            debugPrint('Error: ${state.socketState?.exception}');
              break;
            default:
          }
        },
        builder: (context, state) {
          String? socketStateStr = "";
          Color socketColor = Colors.white;
          switch(state.socketState?.socketConnectionState){
            case SocketConnectionState.connecting:
              socketStateStr = "Connecting";
              socketColor = Colors.yellow;
              break;
            case SocketConnectionState.open:
              socketStateStr = "Connected";
              socketColor = Colors.green;
              break;
            case SocketConnectionState.idle:
              socketStateStr = "Idle";
              socketColor = Colors.blue;
              break;
            case SocketConnectionState.error:
            case SocketConnectionState.close:
              socketStateStr = state.socketState?.exception;
              socketColor = Colors.red;
              break;
            default:
          }

          String? callStateStr = "";
          Color callColor = Colors.white;
          switch(state.callState){
            case CallState.registering:
              callStateStr = "Registering";
              callColor = Colors.yellow;
              break;
            case CallState.registerAccepted:
              callStateStr = "Register Accepted";
              callColor = Colors.green;
              break;
            case CallState.registerRejected:
              callStateStr = "Register Rejected";
              callColor = Colors.red;
              break;
            case CallState.callAccepted:
              callStateStr = "Call Accepted";
              callColor = Colors.green;
              break;
            case CallState.callRejected:
              callStateStr = "Call Rejected";
              callColor = Colors.red;
              break;
            case CallState.incomingCall:
              callStateStr = "Incoming Call From: ${state.socketState?.messageModel?.from}";
              callColor = Colors.green;
              break;
            case CallState.startCommunication:
              callStateStr = "Start Communication";
              callColor = Colors.green;
              break;
            case CallState.iceCandidate:
              callStateStr = "Ice Candidate/On Call";
              callColor = Colors.green;
              break;
            case CallState.stopCommunication:
              callStateStr = "Stop Communication";
              callColor = Colors.green;
              _localRenderer.srcObject = null;
              _remoteRenderer.srcObject = null;
              break;
            default:
          }

          if(state.remoteStream!=null){
            _remoteRenderer.srcObject = state.remoteStream;
          }

          if(state.localStream!=null) {
            _localRenderer.srcObject = state.localStream;
          }

          return OrientationBuilder(builder: (context, orientation) {
            return Stack(children: <Widget>[
              Positioned(
                  left: 0.0,
                  right: 0.0,
                  top: 0.0,
                  bottom: 0.0,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(color: Colors.black54),
                    child: RTCVideoView(_remoteRenderer),
                  )
              ),
              Positioned(
                left: 20.0,
                top: 40.0,
                child: Container(
                  width: orientation == Orientation.portrait ? 90.0 : 120.0,
                  height: orientation == Orientation.portrait ? 120.0 : 90.0,
                  decoration: const BoxDecoration(color: Colors.black54),
                  child: RTCVideoView(_localRenderer),
                ),
              ),
              Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Socket State: ',
                            style: const TextStyle(color: Colors.white),
                            children: <TextSpan>[
                              TextSpan(text: socketStateStr!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: socketColor
                                  )),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Call State: ',
                            style: const TextStyle(color: Colors.white),
                            children: <TextSpan>[
                              TextSpan(text: callStateStr!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: callColor
                                  )),
                            ],
                          ),
                        ),
                      ],
                    )
                  )
              ),
            ]);
          });
        }
      )
    );
  }
}
