import 'package:caterease/features/profile/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

class Authentication extends Equatable {
  final String accessToken;
  final User user;

  const Authentication({required this.accessToken, required this.user});

  @override
  List<Object?> get props => [accessToken, user];
}
