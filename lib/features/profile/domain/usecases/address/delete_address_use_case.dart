import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/profile/domain/repositories/base_address_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteAddressUseCase {
  final BaseAddressRepository repository;
  DeleteAddressUseCase(this.repository);

  Future<Either<Failure, Unit>> deleteAddress({required int id}) async {
    return await repository.deleteAddress(id: id);
  }
}
