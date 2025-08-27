import 'package:equatable/equatable.dart';

class Notification extends Equatable {
  final String title;
  final String body;
  final String type;
  final String modelId;

  const Notification({
    required this.body,
    required this.title,
    required this.type,
    required this.modelId,
  });

  @override
  List<Object> get props => [body, title, modelId];
}
