import 'package:equatable/equatable.dart';

class ResetPassword extends Equatable {
  final int userId;
  final String message;

  const ResetPassword({
    required this.userId,
    required this.message,
  });
  @override
  List<Object> get props => [userId, message];
}
