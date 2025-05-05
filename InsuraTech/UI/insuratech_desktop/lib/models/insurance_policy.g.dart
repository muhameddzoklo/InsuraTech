// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insurance_policy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InsurancePolicy _$InsurancePolicyFromJson(Map<String, dynamic> json) =>
    InsurancePolicy()
      ..insurancePolicyId = (json['insurancePolicyId'] as num?)?.toInt()
      ..insurancePackageId = (json['insurancePackageId'] as num?)?.toInt()
      ..clientId = (json['clientId'] as num?)?.toInt()
      ..startDate = json['startDate'] as String?
      ..endDate = json['endDate'] as String?
      ..isActive = json['isActive'] as bool?
      ..insurancePackage =
          json['insurancePackage'] == null
              ? null
              : InsurancePackage.fromJson(
                json['insurancePackage'] as Map<String, dynamic>,
              )
      ..client =
          json['client'] == null
              ? null
              : Client.fromJson(json['client'] as Map<String, dynamic>)
      ..hasActiveClaimRequest = json['hasActiveClaimRequest'] as bool?;

Map<String, dynamic> _$InsurancePolicyToJson(InsurancePolicy instance) =>
    <String, dynamic>{
      'insurancePolicyId': instance.insurancePolicyId,
      'insurancePackageId': instance.insurancePackageId,
      'clientId': instance.clientId,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'isActive': instance.isActive,
      'insurancePackage': instance.insurancePackage,
      'client': instance.client,
      'hasActiveClaimRequest': instance.hasActiveClaimRequest,
    };
