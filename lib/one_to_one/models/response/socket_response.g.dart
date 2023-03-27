// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocketResponse _$SocketResponseFromJson(Map<String, dynamic> json) =>
    SocketResponse(
      json['id'] as String,
      json['response'] as String?,
      json['sdpAnswer'] as String?,
      json['candidate'] == null
          ? null
          : Candidate.fromJson(json['candidate'] as Map<String, dynamic>),
      json['message'] as String?,
      json['success'] as bool?,
      json['from'] as String?,
      json['name'] as String?,
    );

Map<String, dynamic> _$SocketResponseToJson(SocketResponse instance) {
  final val = <String, dynamic>{
    'id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('response', instance.response);
  writeNotNull('sdpAnswer', instance.sdpAnswer);
  writeNotNull('candidate', instance.candidate);
  writeNotNull('message', instance.message);
  writeNotNull('success', instance.success);
  writeNotNull('from', instance.from);
  writeNotNull('name', instance.name);
  return val;
}
