import 'package:caterease/core/error/failures.dart';
import 'package:caterease/core/network/network_client.dart';
import 'package:caterease/features/profile/data/datasources/address_remote_datasource.dart';
import 'package:caterease/features/profile/data/models/address_model.dart';
import 'package:caterease/features/profile/domain/repositories/base_address_repository.dart';
import 'package:dartz/dartz.dart';

class AddressRepository implements BaseAddressRepository {
  final BaseAddressRemoteDatasource datasource;
  final NetworkClient client;
  const AddressRepository(this.datasource, this.client);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getCities() async {
    final cities = await datasource.fetchCities();
    return Right(cities);
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getDistricts(
      String cityId) async {
    final districts = await datasource.fetchDistricts(cityId);
    return Right(districts);
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAreas(
      String districtId) async {
    final areas = await datasource.fetchAreas(districtId);
    return Right(areas);
  }

  @override
  Future<Either<Failure, List<AddressModel>>> indexAddresses() async {
    final addresses = await datasource.getAllAddresses();
    return Right(addresses);
  }

  @override
  Future<Either<Failure, Unit>> createAddress(
      {required String cityId,
      String? districtId,
      String? areaId,
      String? street,
      String? building,
      String? floor,
      String? apartment,
      String? long,
      String? lat}) async {
    try {
      final response = await datasource.createAddress(
        cityId,
        districtId,
        areaId,
        street,
        building,
        floor,
        apartment,
        long,
        lat,
      );

      return Right(response);
    } catch (e) {
      throw Exception("Failed to get All Addresses: $e");
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAddress({required int id}) async {
    try {
      final response = await datasource.deleteAddress(id);
      return Right(response);
    } catch (e) {
      throw Exception("Failed to delete address : $e");
    }
  }
}
