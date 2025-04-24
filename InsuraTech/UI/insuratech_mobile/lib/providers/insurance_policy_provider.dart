import 'package:http/http.dart' as http;
import 'package:insuratech_mobile/models/insurance_policy.dart';
import 'package:insuratech_mobile/providers/base_provider.dart';
import 'package:intl/intl.dart';

class InsurancePolicyProvider extends BaseProvider<InsurancePolicy> {
  InsurancePolicyProvider() : super("InsurancePolicy");

  @override
  InsurancePolicy fromJson(data) {
    // TODO: implement fromJson
    return InsurancePolicy.fromJson(data);
  }

  Future<void> checkExpiry(DateTime currentDate) async {
    final String formattedDate = DateFormat("yyyy-MM-dd").format(currentDate);
    var url = 
      "${BaseProvider.baseUrl}InsurancePolicy/checkExpiery?currentDate=$formattedDate";
    var uri = Uri.parse(url);

    var headers = createHeaders();

    var response = await http.post(uri, headers: headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("Failed to check expiry: ${response.body}");
    }
  }
}
