// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) =>
    Transaction()
      ..transactionId = (json['transactionId'] as num?)?.toInt()
      ..amount = (json['amount'] as num?)?.toDouble()
      ..transactionDate = json['transactionDate'] as String?
      ..paymentMethod = json['paymentMethod'] as String?
      ..paymentId = json['paymentId'] as String?
      ..payerId = json['payerId'] as String?
      ..clientId = (json['clientId'] as num?)?.toInt()
      ..insurancePolicyId = (json['insurancePolicyId'] as num?)?.toInt()
      ..client =
          json['client'] == null
              ? null
              : Client.fromJson(json['client'] as Map<String, dynamic>)
      ..insurancePolicy =
          json['insurancePolicy'] == null
              ? null
              : InsurancePolicy.fromJson(
                json['insurancePolicy'] as Map<String, dynamic>,
              );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'transactionId': instance.transactionId,
      'amount': instance.amount,
      'transactionDate': instance.transactionDate,
      'paymentMethod': instance.paymentMethod,
      'paymentId': instance.paymentId,
      'payerId': instance.payerId,
      'clientId': instance.clientId,
      'insurancePolicyId': instance.insurancePolicyId,
      'client': instance.client,
      'insurancePolicy': instance.insurancePolicy,
    };
