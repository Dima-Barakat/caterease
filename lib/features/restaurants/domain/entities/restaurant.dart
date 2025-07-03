
import 'package:equatable/equatable.dart';

class Restaurant extends Equatable {
  final int id;
  final String name;
  final String description;
  final String photo;
  final double rating;
  final int totalRatings;
  final double? distance;
  final City? city;

  const Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.photo,
    required this.rating,
    required this.totalRatings,
    this.distance,
    this.city,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        photo,
        rating,
        totalRatings,
        distance,
        city,
      ];
}

class City extends Equatable {
  final int id;
  final String name;
  final String country;

  const City({
    required this.id,
    required this.name,
    required this.country,
  });

  @override
  List<Object> get props => [id, name, country];
}


