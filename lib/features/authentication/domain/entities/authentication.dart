import 'package:equatable/equatable.dart';

class Authentication extends Equatable {
  final String accessToken;

  const Authentication({required this.accessToken});

  @override
  List<Object?> get props => [accessToken];
}
