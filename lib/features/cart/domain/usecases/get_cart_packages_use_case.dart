import 'package:dartz/dartz.dart';
import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/cart/domain/entities/cart_packages.dart';
import 'package:caterease/features/cart/domain/repositories/cart_repository.dart';

class GetCartPackagesUseCase {
  final CartRepository repository;

  GetCartPackagesUseCase(this.repository);

  Future<Either<Failure, CartPackages>> call() async {
    return await repository.getCartPackages();
  }
}

