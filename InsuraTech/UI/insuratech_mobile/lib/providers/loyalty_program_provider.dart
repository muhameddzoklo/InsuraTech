import 'package:insuratech_mobile/models/loyalty_program.dart';
import 'package:insuratech_mobile/providers/base_provider.dart';

class LoyaltyProgramProvider extends BaseProvider<LoyaltyProgram> {
  LoyaltyProgramProvider() : super("LoyaltyProgram");

  @override
  LoyaltyProgram fromJson(data) {
    // TODO: implement fromJson
    return LoyaltyProgram.fromJson(data);
  }
}
