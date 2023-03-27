// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'candidate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Candidate _$CandidateFromJson(Map<String, dynamic> json) => Candidate(
      sdpMid: json['sdpMid'] as String,
      sdpMLineIndex: json['sdpMLineIndex'] as int,
      sdp: json['candidate'] as String,
    );

Map<String, dynamic> _$CandidateToJson(Candidate instance) => <String, dynamic>{
      'sdpMid': instance.sdpMid,
      'sdpMLineIndex': instance.sdpMLineIndex,
      'candidate': instance.sdp,
    };
