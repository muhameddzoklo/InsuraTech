import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:insuratech_mobile/models/insurance_package.dart';
import 'package:insuratech_mobile/providers/auth_provider.dart';
import 'package:insuratech_mobile/providers/base_provider.dart';

class InsurancePackageProvider extends BaseProvider<InsurancePackage> {
  InsurancePackageProvider() : super("InsurancePackage");

  @override
  InsurancePackage fromJson(data) {
    // TODO: implement fromJson
    return InsurancePackage.fromJson(data);
  }

  Future<List<InsurancePackage>> getRecommended() async {
    var url =
        "${BaseProvider.baseUrl}InsurancePackage/recommended?clientId=${AuthProvider.clientId}";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var obj = jsonDecode(response.body);

      if (obj is List) {
        List<InsurancePackage> list =
            obj.map((item) => InsurancePackage.fromJson(item)).toList();
        return list;
      } else {
        throw new Exception("Expected JSON list");
      }
    }
    throw new Exception("Error");
  }
}
