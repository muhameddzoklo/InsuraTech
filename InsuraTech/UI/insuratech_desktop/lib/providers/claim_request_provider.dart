import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:insuratech_desktop/models/claim_request.dart';
import 'package:insuratech_desktop/providers/base_provider.dart';

class ClaimRequestProvider extends BaseProvider<ClaimRequest> {
  ClaimRequestProvider() : super("ClaimRequest");

  @override
  ClaimRequest fromJson(data) {
    // TODO: implement fromJson
    return ClaimRequest.fromJson(data);
  }

  Future<List<String>> getStatusOptions() async {
    final response = await http.get(
      Uri.parse("${BaseProvider.baseUrl}ClaimRequest/status-options"),
      headers: createHeaders(),
    );
    print(response);
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((e) => e.toString()).toList();
    } else {
      throw Exception("Failed to load status options");
    }
  }
}
