import 'package:caterease/features/notification/domain/entities/notification.dart';

class NotificationModel extends Notification {
  const NotificationModel({
    required super.body,
    required super.title,
    required super.type,
    required super.modelId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'],
      body: json['body'],
      type: json['type'],
      modelId: json['modelId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'modelId': modelId,
    };
  }
}
