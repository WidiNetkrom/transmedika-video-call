import 'package:json_annotation/json_annotation.dart';
part 'stop_param.g.dart';

@JsonSerializable()
class StopParam{
  @JsonKey(name: 'id')
  final String id;

  StopParam({required this.id});

  factory StopParam.fromJson(Map<String, dynamic> json) => _$StopParamFromJson(json);

  Map<String, dynamic> toJson() => _$StopParamToJson(this);
}