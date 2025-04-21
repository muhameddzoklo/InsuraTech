import 'package:json_annotation/json_annotation.dart';
part 'insurance_package.g.dart';

@JsonSerializable()
class InsurancePackage {
  int? insurancePackageId;
  String? name;
  String? description;
  double? price;
  String? picture;
  String? stateMachine;
  InsurancePackage();

  factory InsurancePackage.fromJson(Map<String, dynamic> json) =>
      _$InsurancePackageFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$InsurancePackageToJson(this);
}
