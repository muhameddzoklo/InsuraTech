// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insurance_package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InsurancePackage _$InsurancePackageFromJson(Map<String, dynamic> json) =>
    InsurancePackage()
      ..insurancePackageId = (json['insurancePackageId'] as num?)?.toInt()
      ..name = json['name'] as String?
      ..description = json['description'] as String?
      ..price = (json['price'] as num?)?.toDouble()
      ..picture = json['picture'] as String?
      ..stateMachine = json['stateMachine'] as String?;

Map<String, dynamic> _$InsurancePackageToJson(InsurancePackage instance) =>
    <String, dynamic>{
      'insurancePackageId': instance.insurancePackageId,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'picture': instance.picture,
      'stateMachine': instance.stateMachine,
    };
