import 'package:json_annotation/json_annotation.dart';
import 'package:transmedika_video_call/one_to_one/models/response/candidate.dart';
part 'socket_response.g.dart';

@JsonSerializable(includeIfNull: false)
class SocketResponse{
  @JsonKey(name: "id")
  final String id;

  @JsonKey(name: "response")
  final String? response;

  @JsonKey(name: "sdpAnswer")
  final String? sdpAnswer;

  @JsonKey(name: "candidate")
  final Candidate? candidate;

  @JsonKey(name: "message")
  final String? message;

  @JsonKey(name: "success")
  final bool? success;

  @JsonKey(name: "from")
  final String? from;

  @JsonKey(name: "name")
  final String? name;

  SocketResponse(this.id, this.response, this.sdpAnswer, this.candidate, this.message, this.success, this.from, this.name);

  factory SocketResponse.fromJson(Map<String, dynamic> json) => _$SocketResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SocketResponseToJson(this);
}