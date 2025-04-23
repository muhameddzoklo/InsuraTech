
import 'package:insuratech_mobile/models/insurance_package.dart';
import 'package:insuratech_mobile/providers/base_provider.dart';

class InsurancePackageProvider extends BaseProvider<InsurancePackage> {
  InsurancePackageProvider() : super("InsurancePackage");

  @override
  InsurancePackage fromJson(data) {
    // TODO: implement fromJson
    return InsurancePackage.fromJson(data);
  }
    
}