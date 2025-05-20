// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportTicket _$SupportTicketFromJson(Map<String, dynamic> json) =>
    SupportTicket()
      ..supportTicketId = (json['supportTicketId'] as num?)?.toInt()
      ..clientId = (json['clientId'] as num?)?.toInt()
      ..subject = json['subject'] as String?
      ..message = json['message'] as String?
      ..reply = json['reply'] as String?
      ..createdAt = json['createdAt'] as String?
      ..isAnswered = json['isAnswered'] as bool?
      ..isClosed = json['isClosed'] as bool?;

Map<String, dynamic> _$SupportTicketToJson(SupportTicket instance) =>
    <String, dynamic>{
      'supportTicketId': instance.supportTicketId,
      'clientId': instance.clientId,
      'subject': instance.subject,
      'message': instance.message,
      'reply': instance.reply,
      'createdAt': instance.createdAt,
      'isAnswered': instance.isAnswered,
      'isClosed': instance.isClosed,
    };
