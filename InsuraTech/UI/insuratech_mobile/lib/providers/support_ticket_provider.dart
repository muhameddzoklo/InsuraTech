import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:insuratech_mobile/models/support_ticket.dart';
import 'package:insuratech_mobile/providers/base_provider.dart';

class SupportTicketProvider extends BaseProvider<SupportTicket> {
  SupportTicketProvider() : super("SupportTicket");

  @override
  SupportTicket fromJson(data) {
    // TODO: implement fromJson
    return SupportTicket.fromJson(data);
  }

  Future<String> CloseTicket(int ticketId) async {
    var url = "${BaseProvider.baseUrl}SupportTicket/$ticketId/close";
    var uri = Uri.parse(url);
    var headers = createHeaders();
    var response = await http.patch(uri, headers: headers);

    if (isValidResponse(response)) {
      return response.body;
    } else {
      throw Exception("Failed to close support ticket.");
    }
  }
}
