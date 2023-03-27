import 'package:json_annotation/json_annotation.dart';
part 'incoming_call_param.g.dart';

@JsonSerializable()
class IncomingCallParam{
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'from')
  final String from;

  @JsonKey(name: 'callResponse')
  final String callResponse;

  @JsonKey(name: 'sdpOffer')
  final String? sdpOffer;

  IncomingCallParam({required this.id, required this.from, required this.callResponse, required this.sdpOffer});

  factory IncomingCallParam.fromJson(Map<String, dynamic> json) => _$IncomingCallParamFromJson(json);

  Map<String, dynamic> toJson() => _$IncomingCallParamToJson(this);
}