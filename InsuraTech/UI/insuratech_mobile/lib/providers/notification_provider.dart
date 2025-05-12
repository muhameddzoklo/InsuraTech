import 'package:insuratech_mobile/models/notification.dart' as model;
import 'package:insuratech_mobile/providers/base_provider.dart';

class NotificationProvider extends BaseProvider<model.Notification> {
  NotificationProvider() : super("Notification");

  @override
  model.Notification fromJson(data) {
    // TODO: implement fromJson
    return model.Notification.fromJson(data);
  }
}
