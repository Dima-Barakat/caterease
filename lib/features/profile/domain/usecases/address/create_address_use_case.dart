import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/profile/domain/repositories/base_address_repository.dart';
import 'package:dartz/dartz.dart';

class CreateAddressUseCase {
  final BaseAddressRepository repository;
  CreateAddressUseCase(this.repository);

  Future<Either<Failure, Unit>> createAddress(
      {required String cityId,
      required String areaId,
      required String districtId,
      String? street,
      String? building,
      String? floor,
      String? apartment,
      String? long,
      String? lat}) async {
    return await repository.createAddress(
        cityId: cityId,
        districtId: districtId,
        areaId: areaId,
        street: street,
        building: building,
        floor: floor,
        apartment: apartment,
        long: long,
        lat: lat);
  }
}
