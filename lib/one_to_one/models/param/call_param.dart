import 'package:json_annotation/json_annotation.dart';
part 'call_param.g.dart';

@JsonSerializable()
class CallParam{
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'from')
  final String from;

  @JsonKey(name: 'to')
  final String to;

  @JsonKey(name: 'sdpOffer')
  final String? sdpOffer;

  CallParam({required this.id, required this.from, required this.to, required this.sdpOffer});

  factory CallParam.fromJson(Map<String, dynamic> json) => _$CallParamFromJson(json);

  Map<String, dynamic> toJson() => _$CallParamToJson(this);
}