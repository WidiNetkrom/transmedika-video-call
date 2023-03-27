import 'package:json_annotation/json_annotation.dart';
part 'register_param.g.dart';

@JsonSerializable()
class RegisterParam{
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  RegisterParam({required this.id, required this.name});

  factory RegisterParam.fromJson(Map<String, dynamic> json) => _$RegisterParamFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterParamToJson(this);
}