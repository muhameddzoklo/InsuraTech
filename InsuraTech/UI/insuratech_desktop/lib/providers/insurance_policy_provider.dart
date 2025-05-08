import 'package:insuratech_desktop/models/insurance_policy.dart';
import 'package:insuratech_desktop/providers/base_provider.dart';

class InsurancePolicyProvider extends BaseProvider<InsurancePolicy> {
  InsurancePolicyProvider() : super("InsurancePolicy");

  @override
  InsurancePolicy fromJson(data) {
    // TODO: implement fromJson
    return InsurancePolicy.fromJson(data);
  }
}
