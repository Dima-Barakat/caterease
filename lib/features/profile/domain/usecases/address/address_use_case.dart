import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/profile/data/models/address_model.dart';
import 'package:caterease/features/profile/domain/repositories/base_address_repository.dart';
import 'package:dartz/dartz.dart';

class AddressUseCase {
  final BaseAddressRepository repository;

  AddressUseCase(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> getAllCities() async {
    return await repository.getCities();
  }

  Future<Either<Failure, List<Map<String, dynamic>>>> getAllDistricts(
      String cityId) async {
    return await repository.getDistricts(cityId);
  }

  Future<Either<Failure, List<Map<String, dynamic>>>> getAllAreas(
      String districtId) async {
    return await repository.getAreas(districtId);
  }

  Future<Either<Failure, List<AddressModel>>> getAllAddresses() async {
    return await repository.indexAddresses();
  }

  Future<Either<Failure, Unit>> createAddress(
      {required String cityId,
      required String districtId,
      String? areaId,
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

  Future<Either<Failure, Unit>> deleteAddress({required int id}) async {
    return await repository.deleteAddress(id: id);
  }
}
