import '../../domain/entities/package.dart';

class PackageModel extends Package {
  const PackageModel({
    required int id,
    required String name,
    required String photo,
    required String description,
    required int servesCount,
    required String basePrice,
  }) : super(
          id: id,
          name: name,
          photo: photo,
          description: description,
          servesCount: servesCount,
          basePrice: basePrice,
        );

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json["id"],
      name: json["name"],
      photo: json["photo"],
      description: json["description"],
      servesCount: json["serves_count"],
      basePrice: json["base_price"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "photo": photo,
      "description": description,
      "serves_count": servesCount,
      "base_price": basePrice,
    };
  }
}
