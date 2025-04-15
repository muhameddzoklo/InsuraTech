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
  String? profilePicture;
  String? registrationDate;

  Client();

  factory Client.fromJson(Map<String, dynamic> json) =>
      _$ClientFromJson(json);

      Map<String, dynamic> toJson() => _$ClientToJson(this);
}