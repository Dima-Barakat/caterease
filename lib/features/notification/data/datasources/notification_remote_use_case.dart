import 'package:caterease/core/network/network_client.dart';
import 'package:caterease/features/notification/data/models/notification_model.dart';

abstract class BaseNotificationRemoteUseCase {
  Future<NotificationModel> getNotificationList();
}

class NotificationRemoteUseCase implements BaseNotificationRemoteUseCase {
  final NetworkClient client;

  NotificationRemoteUseCase(this.client);

  @override
  Future<NotificationModel> getNotificationList() async {
    return NotificationModel.fromJson({"X": "Z", "aA": "d", "a": "s"});
  }
}
