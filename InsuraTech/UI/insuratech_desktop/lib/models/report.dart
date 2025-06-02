import 'package:json_annotation/json_annotation.dart';

part 'report.g.dart';

@JsonSerializable(explicitToJson: true)
class Report {
  // Policies
  final int totalPolicies;
  final int activePolicies;
  final int expiredPolicies;
  final int paidPolicies;

  // Claim Requests
  final int totalClaimRequests;
  final int acceptedClaims;
  final int declinedClaims;
  final int pendingClaims;

  // Revenue
  final double totalProfit;
  final List<RevenuePerMonth> profitPerMonth;

  // Top Packages
  final List<TopPackage> topPackagesBySales;

  // Feedback
  final int totalReviews;
  final double averagePackageRating;

  Report({
    required this.totalPolicies,
    required this.activePolicies,
    required this.expiredPolicies,
    required this.paidPolicies,
    required this.totalClaimRequests,
    required this.acceptedClaims,
    required this.declinedClaims,
    required this.pendingClaims,
    required this.totalProfit,
    required this.profitPerMonth,
    required this.topPackagesBySales,
    required this.totalReviews,
    required this.averagePackageRating,
  });

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
  Map<String, dynamic> toJson() => _$ReportToJson(this);
}

@JsonSerializable()
class RevenuePerMonth {
  final String month;
  final double profit;

  RevenuePerMonth({required this.month, required this.profit});

  factory RevenuePerMonth.fromJson(Map<String, dynamic> json) =>
      _$RevenuePerMonthFromJson(json);
  Map<String, dynamic> toJson() => _$RevenuePerMonthToJson(this);
}

@JsonSerializable()
class TopPackage {
  final int insurancePackageId;
  final String name;
  final int soldPolicies;
  final double? averageRating;

  TopPackage({
    required this.insurancePackageId,
    required this.name,
    required this.soldPolicies,
    this.averageRating,
  });

  factory TopPackage.fromJson(Map<String, dynamic> json) =>
      _$TopPackageFromJson(json);
  Map<String, dynamic> toJson() => _$TopPackageToJson(this);
}
