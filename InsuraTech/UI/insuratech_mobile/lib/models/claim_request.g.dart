// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claim_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClaimRequest _$ClaimRequestFromJson(Map<String, dynamic> json) =>
    ClaimRequest()
      ..claimRequestId = (json['claimRequestId'] as num?)?.toInt()
      ..insurancePolicyId = (json['insurancePolicyId'] as num?)?.toInt()
      ..description = json['description'] as String?
      ..comment = json['comment'] as String?
      ..estimatedAmount = (json['estimatedAmount'] as num?)?.toDouble()
      ..status = json['status'] as String?
      ..submittedAt = json['submittedAt'] as String?
      ..insurancePolicy =
          json['insurancePolicy'] == null
              ? null
              : InsurancePolicy.fromJson(
                json['insurancePolicy'] as Map<String, dynamic>,
              );

Map<String, dynamic> _$ClaimRequestToJson(ClaimRequest instance) =>
    <String, dynamic>{
      'claimRequestId': instance.claimRequestId,
      'insurancePolicyId': instance.insurancePolicyId,
      'description': instance.description,
      'comment': instance.comment,
      'estimatedAmount': instance.estimatedAmount,
      'status': instance.status,
      'submittedAt': instance.submittedAt,
      'insurancePolicy': instance.insurancePolicy,
    };
