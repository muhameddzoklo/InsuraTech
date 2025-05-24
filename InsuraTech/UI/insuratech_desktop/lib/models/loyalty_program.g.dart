// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_program.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoyaltyProgram _$LoyaltyProgramFromJson(Map<String, dynamic> json) =>
    LoyaltyProgram()
      ..loyaltyProgramId = (json['loyaltyProgramId'] as num?)?.toInt()
      ..clientId = (json['clientId'] as num?)?.toInt()
      ..points = (json['points'] as num?)?.toInt()
      ..tier = (json['tier'] as num?)?.toInt()
      ..lastUpdated = json['lastUpdated'] as String?
      ..client =
          json['client'] == null
              ? null
              : Client.fromJson(json['client'] as Map<String, dynamic>);

Map<String, dynamic> _$LoyaltyProgramToJson(LoyaltyProgram instance) =>
    <String, dynamic>{
      'loyaltyProgramId': instance.loyaltyProgramId,
      'clientId': instance.clientId,
      'points': instance.points,
      'tier': instance.tier,
      'lastUpdated': instance.lastUpdated,
      'client': instance.client,
    };
