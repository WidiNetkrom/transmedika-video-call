// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ice_candidate_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IceCandidateParam _$IceCandidateParamFromJson(Map<String, dynamic> json) =>
    IceCandidateParam(
      id: json['id'] as String,
      candidate: Candidate.fromJson(json['candidate'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IceCandidateParamToJson(IceCandidateParam instance) =>
    <String, dynamic>{
      'id': instance.id,
      'candidate': instance.candidate,
    };
