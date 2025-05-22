import 'package:insuratech_mobile/models/client_feedback.dart';
import 'package:insuratech_mobile/providers/base_provider.dart';

class ClientFeedbackProvider extends BaseProvider<ClientFeedback> {
  ClientFeedbackProvider() : super("ClientFeedback");

  @override
  ClientFeedback fromJson(data) {
    // TODO: implement fromJson
    return ClientFeedback.fromJson(data);
  }
}
