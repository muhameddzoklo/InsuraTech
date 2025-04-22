
import 'package:insuratech_desktop/models/role.dart';
import 'package:insuratech_desktop/providers/base_provider.dart';

class RolesProvider extends BaseProvider<Role> {
  RolesProvider() : super("Role");

  @override
  Role fromJson(data) {
    // TODO: implement fromJson
    return Role.fromJson(data);
  }
}
