import 'package:equatable/equatable.dart';

class Package extends Equatable {
  final int id;
  final String name;
  final String photo;
  final String description;
  final int servesCount;
  final String basePrice;

  const Package({
    required this.id,
    required this.name,
    required this.photo,
    required this.description,
    required this.servesCount,
    required this.basePrice,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        photo,
        description,
        servesCount,
        basePrice,
      ];
}
