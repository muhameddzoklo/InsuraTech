import 'package:insuratech_mobile/models/client.dart';
import 'package:insuratech_mobile/models/insurance_policy.dart';
import 'package:json_annotation/json_annotation.dart';
part 'transaction.g.dart';

@JsonSerializable()
class Transaction {
  int? transactionId;
  double? amount;
  String? transactionDate;
  String? paymentMethod;
  String? paymentId;
  String? payerId;
  int? clientId;
  int? insurancePolicyId;
  Client? client;
  InsurancePolicy? insurancePolicy;

  Transaction();

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
