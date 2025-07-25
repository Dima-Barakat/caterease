import 'package:caterease/features/authentication/domain/entities/reset_password.dart';

class ResetPasswordModel extends ResetPassword {
  const ResetPasswordModel({
    required super.userId,
    required super.message,
  });

  @override
  List<Object> get props => [userId, message];

  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordModel(
      userId: json['user_id'],
      message: json['message'],
    );
  }
}
