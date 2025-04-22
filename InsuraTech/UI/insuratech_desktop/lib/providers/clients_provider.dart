import 'package:insuratech_desktop/models/client.dart';
import 'package:insuratech_desktop/providers/base_provider.dart';

class ClientsProvider extends BaseProvider<Client> {
  ClientsProvider() : super("Client");

  @override
  Client fromJson(data) {
    // TODO: implement fromJson
    return Client.fromJson(data);
  }
}
