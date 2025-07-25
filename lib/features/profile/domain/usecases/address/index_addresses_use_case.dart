import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/profile/data/models/address_model.dart';
import 'package:caterease/features/profile/domain/repositories/base_address_repository.dart';
import 'package:dartz/dartz.dart';

class IndexAddressesUseCase {
  final BaseAddressRepository repository;
  IndexAddressesUseCase(this.repository);

  Future<Either<Failure, List<AddressModel>>> getAllAddresses() async {
    return await repository.indexAddresses();
  }
}
