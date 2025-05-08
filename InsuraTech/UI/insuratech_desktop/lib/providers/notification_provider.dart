import 'package:insuratech_desktop/models/notification.dart' as model;
import 'package:insuratech_desktop/providers/base_provider.dart';

class NotificationProvider extends BaseProvider<model.Notification> {
  NotificationProvider() : super("Notification");

  @override
  model.Notification fromJson(data) {
    // TODO: implement fromJson
    return model.Notification.fromJson(data);
  }
}
