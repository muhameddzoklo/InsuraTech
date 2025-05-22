import 'package:insuratech_mobile/models/client.dart';
import 'package:insuratech_mobile/models/client_feedback.dart';
import 'package:insuratech_mobile/models/insurance_package.dart';
import 'package:json_annotation/json_annotation.dart';
part 'insurance_policy.g.dart';

@JsonSerializable()
class InsurancePolicy {
  int? insurancePolicyId;
  int? insurancePackageId;
  int? clientId;
  String? startDate;
  String? endDate;
  bool? isActive;
  bool? isNotificationSent;
  bool? isPaid;
  InsurancePackage? insurancePackage;
  Client? client;
  bool? hasActiveClaimRequest;
  ClientFeedback? clientFeedback;

  InsurancePolicy();

  factory InsurancePolicy.fromJson(Map<String, dynamic> json) =>
      _$InsurancePolicyFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$InsurancePolicyToJson(this);
}
