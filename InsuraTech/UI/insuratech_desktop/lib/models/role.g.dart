// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Role _$RoleFromJson(Map<String, dynamic> json) =>
    Role()
      ..roleId = (json['roleId'] as num?)?.toInt()
      ..description = json['description'] as String?
      ..roleName = json['roleName'] as String?;

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
  'roleId': instance.roleId,
  'description': instance.description,
  'roleName': instance.roleName,
};
