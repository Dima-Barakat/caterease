// lib/features/profile/data/models/address_model.dart

class Address {
  final String? addressId;
  final String city;
  final String country;
  final String street;
  final String building;
  final String floor;
  final String apartment;
  final List<double>? coordinate;

  Address({
    this.addressId,
    required this.city,
    required this.country,
    required this.street,
    required this.building,
    required this.floor,
    required this.apartment,
    this.coordinate,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressId: json['address_id'] as String?,
      city: json['city'] as String? ?? '–',
      country: json['country'] as String? ?? '–',
      street: json['street'] as String? ?? '–',
      building: json['building'] as String? ?? '–',
      floor: json['floor'] as String? ?? '–',
      apartment: json['apartment'] as String? ?? '–',
      coordinate: (json['coordinate'] is List)
          ? List<double>.from(
              (json['coordinate'] as List).map((e) => (e as num).toDouble()))
          : null,
    );
  }
}
