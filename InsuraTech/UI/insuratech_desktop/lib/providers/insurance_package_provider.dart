import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:insuratech_desktop/models/insurance_package.dart';
import 'package:insuratech_desktop/models/user.dart';
import 'package:insuratech_desktop/providers/base_provider.dart';

class InsurancePackageProvider extends BaseProvider<InsurancePackage> {
  InsurancePackageProvider() : super("InsurancePackage");

  @override
  InsurancePackage fromJson(data) {
    // TODO: implement fromJson
    return InsurancePackage.fromJson(data);
  }
}
