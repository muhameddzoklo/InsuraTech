// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_feedback.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientFeedback _$ClientFeedbackFromJson(Map<String, dynamic> json) =>
    ClientFeedback()
      ..clientFeedbackId = (json['clientFeedbackId'] as num?)?.toInt()
      ..insurancePackageId = (json['insurancePackageId'] as num?)?.toInt()
      ..insurancePolicyId = (json['insurancePolicyId'] as num?)?.toInt()
      ..clientId = (json['clientId'] as num?)?.toInt()
      ..rating = (json['rating'] as num?)?.toDouble()
      ..comment = json['comment'] as String?
      ..createdAt = json['createdAt'] as String?
      ..packageName = json['packageName'] as String?
      ..clientName = json['clientName'] as String?
      ..clientProfilePicture = json['clientProfilePicture'] as String?
      ..isDeleted = json['isDeleted'] as bool?;

Map<String, dynamic> _$ClientFeedbackToJson(ClientFeedback instance) =>
    <String, dynamic>{
      'clientFeedbackId': instance.clientFeedbackId,
      'insurancePackageId': instance.insurancePackageId,
      'insurancePolicyId': instance.insurancePolicyId,
      'clientId': instance.clientId,
      'rating': instance.rating,
      'comment': instance.comment,
      'createdAt': instance.createdAt,
      'packageName': instance.packageName,
      'clientName': instance.clientName,
      'clientProfilePicture': instance.clientProfilePicture,
      'isDeleted': instance.isDeleted,
    };
