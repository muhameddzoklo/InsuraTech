import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:insuratech_desktop/models/insurance_package.dart';
import 'package:insuratech_desktop/providers/base_provider.dart';

class InsurancePackageProvider extends BaseProvider<InsurancePackage> {
  InsurancePackageProvider() : super("InsurancePackage");

  @override
  InsurancePackage fromJson(data) {
    // TODO: implement fromJson
    return InsurancePackage.fromJson(data);
  }

  Future ChangeState(int id, String state) async {
    var endpoint = "InsurancePackage/${id}/$state";
    var baseUrl = BaseProvider.baseUrl;
    var url = "$baseUrl$endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.put(uri, headers: headers);
    if (isValidResponse(response)) {
      if (response.body.isEmpty) return fromJson({});
      var data = jsonDecode(response.body);
      return fromJson(data);
    }
  }
}
