import 'package:json_annotation/json_annotation.dart';
part 'client_feedback.g.dart';

@JsonSerializable()
class ClientFeedback {
  int? clientFeedbackId;
  int? insurancePackageId;
  int? insurancePolicyId;
  int? clientId;
  double? rating;
  String? comment;
  String? createdAt;
  String? packageName;
  String? clientName;
  String? clientProfilePicture;
  bool? isDeleted;

  ClientFeedback();

  factory ClientFeedback.fromJson(Map<String, dynamic> json) =>
      _$ClientFeedbackFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ClientFeedbackToJson(this);
}
