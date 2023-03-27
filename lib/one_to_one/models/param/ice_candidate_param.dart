import 'package:json_annotation/json_annotation.dart';
import 'package:transmedika_video_call/one_to_one/models/response/candidate.dart';
part 'ice_candidate_param.g.dart';

@JsonSerializable()
class IceCandidateParam{
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'candidate')
  final Candidate candidate;

  IceCandidateParam({required this.id, required this.candidate});

  factory IceCandidateParam.fromJson(Map<String, dynamic> json) => _$IceCandidateParamFromJson(json);

  Map<String, dynamic> toJson() => _$IceCandidateParamToJson(this);
}