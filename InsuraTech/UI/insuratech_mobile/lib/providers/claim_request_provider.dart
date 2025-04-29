
import 'package:insuratech_mobile/models/claim_request.dart';
import 'package:insuratech_mobile/providers/base_provider.dart';

class ClaimRequestProvider extends BaseProvider<ClaimRequest> {
  ClaimRequestProvider() : super("ClaimRequest");

  @override
  ClaimRequest fromJson(data) {
    // TODO: implement fromJson
    return ClaimRequest.fromJson(data);
  }
    
}