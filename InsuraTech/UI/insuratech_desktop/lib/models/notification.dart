import 'package:insuratech_desktop/models/insurance_policy.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:insuratech_desktop/models/client.dart';
part 'notification.g.dart';

@JsonSerializable()
class Notification {
  int? notificationId;
  int? insurancePolicyId;
  int? clientId;
  String? message;
  bool? isRead;
  String? sentAt;
  InsurancePolicy? insurancePolicy;
  Client? client;

  Notification();

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
