import 'package:equatable/equatable.dart';

class Discount extends Equatable {
  final String value;
  final String description;
  final String startAt;
  final String endAt;

  const Discount({
    required this.value,
    required this.description,
    required this.startAt,
    required this.endAt,
  });

  @override
  List<Object?> get props => [value, description, startAt, endAt];
}


