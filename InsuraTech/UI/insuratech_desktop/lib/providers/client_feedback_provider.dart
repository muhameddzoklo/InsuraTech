import 'package:insuratech_desktop/models/client_feedback.dart';
import 'package:insuratech_desktop/providers/base_provider.dart';

class ClientFeedbackProvider extends BaseProvider<ClientFeedback> {
  ClientFeedbackProvider() : super("ClientFeedback");

  @override
  ClientFeedback fromJson(data) {
    // TODO: implement fromJson
    return ClientFeedback.fromJson(data);
  }
}
