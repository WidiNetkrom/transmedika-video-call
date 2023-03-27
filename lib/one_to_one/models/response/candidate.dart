
import 'package:json_annotation/json_annotation.dart';
part 'candidate.g.dart';

@JsonSerializable()
class Candidate{
  @JsonKey(name: "sdpMid")
  final String sdpMid;
  @JsonKey(name: "sdpMLineIndex")
  final int sdpMLineIndex;
  @JsonKey(name: "candidate")
  final String sdp;

  Candidate({required this.sdpMid, required this.sdpMLineIndex, required this.sdp});

  factory Candidate.fromJson(Map<String, dynamic> json) => _$CandidateFromJson(json);

  Map<String, dynamic> toJson() => _$CandidateToJson(this);
}