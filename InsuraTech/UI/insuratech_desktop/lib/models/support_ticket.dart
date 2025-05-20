import 'package:json_annotation/json_annotation.dart';
part 'support_ticket.g.dart';

@JsonSerializable()
class SupportTicket {
  int? supportTicketId;
  int? clientId;
  String? subject;
  String? message;
  String? reply;
  String? createdAt;
  bool? isAnswered;
  bool? isClosed;

  SupportTicket();

  factory SupportTicket.fromJson(Map<String, dynamic> json) =>
      _$SupportTicketFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$SupportTicketToJson(this);
}
