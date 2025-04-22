import 'package:json_annotation/json_annotation.dart';
part 'client.g.dart';

@JsonSerializable()
class Client {
  int? clientId;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? username;
  bool? isActive;
  String? profilePicture;
  String? registrationDate;


  Client();

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ClientToJson(this);
}
