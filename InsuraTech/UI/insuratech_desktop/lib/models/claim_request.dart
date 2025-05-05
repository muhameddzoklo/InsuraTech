import 'package:insuratech_desktop/models/insurance_policy.dart';
import 'package:json_annotation/json_annotation.dart';
part 'claim_request.g.dart';

@JsonSerializable()
class ClaimRequest {
  int? claimRequestId;
  int? insurancePolicyId;
  String? description;
  String? comment;
  double? estimatedAmount;
  String? status;
  String? submittedAt;
  InsurancePolicy? insurancePolicy;

  ClaimRequest();

  factory ClaimRequest.fromJson(Map<String, dynamic> json) =>
      _$ClaimRequestFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ClaimRequestToJson(this);
}
