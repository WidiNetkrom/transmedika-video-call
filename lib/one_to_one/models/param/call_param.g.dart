// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallParam _$CallParamFromJson(Map<String, dynamic> json) => CallParam(
      id: json['id'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      sdpOffer: json['sdpOffer'] as String?,
    );

Map<String, dynamic> _$CallParamToJson(CallParam instance) => <String, dynamic>{
      'id': instance.id,
      'from': instance.from,
      'to': instance.to,
      'sdpOffer': instance.sdpOffer,
    };
