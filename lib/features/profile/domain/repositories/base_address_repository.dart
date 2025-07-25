import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/profile/data/models/address_model.dart';
import 'package:dartz/dartz.dart';

abstract class BaseAddressRepository {
  Future<Either<Failure, List<AddressModel>>> indexAddresses();

  Future<Either<Failure, Unit>> createAddress(
      {required String cityId,
      String? street,
      String? building,
      String? floor,
      String? apartment,
      String? long,
      String? lat});
  Future<Either<Failure, Unit>> deleteAddress({required int id});
}
