import 'package:json_annotation/json_annotation.dart';
part 'loyalty_program.g.dart';

@JsonSerializable()
class LoyaltyProgram {
  int? loyaltyProgramId;
  int? clientId;
  int? points;
  int? tier;
  String? lastUpdated;

  LoyaltyProgram();

  factory LoyaltyProgram.fromJson(Map<String, dynamic> json) =>
      _$LoyaltyProgramFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$LoyaltyProgramToJson(this);
}
