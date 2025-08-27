import 'package:caterease/features/customer_order_list/domain/entities/package_entity.dart';

class PackageModel extends PackageEntity {
  const PackageModel({
    required int packageId,
    required String name,
    required String photo,
    required String branchName,
    required String basePrice,
  }) : super(
          packageId: packageId,
          name: name,
          photo: photo,
          branchName: branchName,
          basePrice: basePrice,
        );

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      packageId: json["package_id"],
      name: json["name"],
      photo: json["photo"],
      branchName: json["branch_name"],
      basePrice: json["base_price"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "package_id": packageId,
      "name": name,
      "photo": photo,
      "branch_name": branchName,
      "base_price": basePrice,
    };
  }
}


