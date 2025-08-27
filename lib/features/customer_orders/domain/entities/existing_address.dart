import 'package:equatable/equatable.dart';

class ExistingAddress extends Equatable {
  final String type;
  final int existingId;

  const ExistingAddress({
    required this.type,
    required this.existingId,
  });

  @override
  List<Object?> get props => [type, existingId];
}


