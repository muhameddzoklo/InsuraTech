import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:insuratech_mobile/models/client.dart';
import 'package:insuratech_mobile/providers/base_provider.dart';

class ClientProvider extends BaseProvider<Client> {
  ClientProvider() : super("Client");

  @override
  Client fromJson(data) {
    // TODO: implement fromJson
    return Client.fromJson(data);
  }

  Future<Client> login(String username, String password) async {
    var url =
        "${BaseProvider.baseUrl}Client/Login?username=${username}&password=${password}";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.post(uri, headers: headers);
    if (response.body == "") {
      throw new Exception("Wrong username or password");
    }
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw new Exception("Unknown error");
    }
  }
}