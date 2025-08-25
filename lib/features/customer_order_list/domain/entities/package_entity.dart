import 'package:equatable/equatable.dart';

class PackageEntity extends Equatable {
  final int packageId;
  final String name;
  final String photo;
  final String branchName;
  final String basePrice;

  const PackageEntity({
    required this.packageId,
    required this.name,
    required this.photo,
    required this.branchName,
    required this.basePrice,
  });

  @override
  List<Object?> get props => [packageId, name, photo, branchName, basePrice];
}


