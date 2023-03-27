// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incoming_call_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncomingCallParam _$IncomingCallParamFromJson(Map<String, dynamic> json) =>
    IncomingCallParam(
      id: json['id'] as String,
      from: json['from'] as String,
      callResponse: json['callResponse'] as String,
      sdpOffer: json['sdpOffer'] as String?,
    );

Map<String, dynamic> _$IncomingCallParamToJson(IncomingCallParam instance) =>
    <String, dynamic>{
      'id': instance.id,
      'from': instance.from,
      'callResponse': instance.callResponse,
      'sdpOffer': instance.sdpOffer,
    };
