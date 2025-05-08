// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) =>
    Notification()
      ..notificationId = (json['notificationId'] as num?)?.toInt()
      ..insurancePolicyId = (json['insurancePolicyId'] as num?)?.toInt()
      ..clientId = (json['clientId'] as num?)?.toInt()
      ..message = json['message'] as String?
      ..isRead = json['isRead'] as bool?
      ..sentAt = json['sentAt'] as String?
      ..insurancePolicy =
          json['insurancePolicy'] == null
              ? null
              : InsurancePolicy.fromJson(
                json['insurancePolicy'] as Map<String, dynamic>,
              )
      ..client =
          json['client'] == null
              ? null
              : Client.fromJson(json['client'] as Map<String, dynamic>);

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'insurancePolicyId': instance.insurancePolicyId,
      'clientId': instance.clientId,
      'message': instance.message,
      'isRead': instance.isRead,
      'sentAt': instance.sentAt,
      'insurancePolicy': instance.insurancePolicy,
      'client': instance.client,
    };
