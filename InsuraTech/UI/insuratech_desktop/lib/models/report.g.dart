// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) => Report(
  totalPolicies: (json['totalPolicies'] as num).toInt(),
  activePolicies: (json['activePolicies'] as num).toInt(),
  expiredPolicies: (json['expiredPolicies'] as num).toInt(),
  paidPolicies: (json['paidPolicies'] as num).toInt(),
  totalClaimRequests: (json['totalClaimRequests'] as num).toInt(),
  acceptedClaims: (json['acceptedClaims'] as num).toInt(),
  declinedClaims: (json['declinedClaims'] as num).toInt(),
  pendingClaims: (json['pendingClaims'] as num).toInt(),
  totalProfit: (json['totalProfit'] as num).toDouble(),
  profitPerMonth:
      (json['profitPerMonth'] as List<dynamic>)
          .map((e) => RevenuePerMonth.fromJson(e as Map<String, dynamic>))
          .toList(),
  topPackagesBySales:
      (json['topPackagesBySales'] as List<dynamic>)
          .map((e) => TopPackage.fromJson(e as Map<String, dynamic>))
          .toList(),
  totalReviews: (json['totalReviews'] as num).toInt(),
  averagePackageRating: (json['averagePackageRating'] as num).toDouble(),
);

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
  'totalPolicies': instance.totalPolicies,
  'activePolicies': instance.activePolicies,
  'expiredPolicies': instance.expiredPolicies,
  'paidPolicies': instance.paidPolicies,
  'totalClaimRequests': instance.totalClaimRequests,
  'acceptedClaims': instance.acceptedClaims,
  'declinedClaims': instance.declinedClaims,
  'pendingClaims': instance.pendingClaims,
  'totalProfit': instance.totalProfit,
  'profitPerMonth': instance.profitPerMonth.map((e) => e.toJson()).toList(),
  'topPackagesBySales':
      instance.topPackagesBySales.map((e) => e.toJson()).toList(),
  'totalReviews': instance.totalReviews,
  'averagePackageRating': instance.averagePackageRating,
};

RevenuePerMonth _$RevenuePerMonthFromJson(Map<String, dynamic> json) =>
    RevenuePerMonth(
      month: json['month'] as String,
      profit: (json['profit'] as num).toDouble(),
    );

Map<String, dynamic> _$RevenuePerMonthToJson(RevenuePerMonth instance) =>
    <String, dynamic>{'month': instance.month, 'profit': instance.profit};

TopPackage _$TopPackageFromJson(Map<String, dynamic> json) => TopPackage(
  insurancePackageId: (json['insurancePackageId'] as num).toInt(),
  name: json['name'] as String,
  soldPolicies: (json['soldPolicies'] as num).toInt(),
  averageRating: (json['averageRating'] as num?)?.toDouble(),
);

Map<String, dynamic> _$TopPackageToJson(TopPackage instance) =>
    <String, dynamic>{
      'insurancePackageId': instance.insurancePackageId,
      'name': instance.name,
      'soldPolicies': instance.soldPolicies,
      'averageRating': instance.averageRating,
    };
