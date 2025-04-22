// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Client _$ClientFromJson(Map<String, dynamic> json) =>
    Client()
      ..clientId = (json['clientId'] as num?)?.toInt()
      ..firstName = json['firstName'] as String?
      ..lastName = json['lastName'] as String?
      ..email = json['email'] as String?
      ..phoneNumber = json['phoneNumber'] as String?
      ..username = json['username'] as String?
      ..isActive = json['isActive'] as bool?
      ..profilePicture = json['profilePicture'] as String?
      ..registrationDate = json['registrationDate'] as String?;

Map<String, dynamic> _$ClientToJson(Client instance) => <String, dynamic>{
  'clientId': instance.clientId,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'phoneNumber': instance.phoneNumber,
  'username': instance.username,
  'isActive': instance.isActive,
  'profilePicture': instance.profilePicture,
  'registrationDate': instance.registrationDate,
};
