import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/delivery/data/models/delivery_profile_model.dart';
import 'package:caterease/features/delivery/domain/repositories/base_delivery_profile_repository.dart';
import 'package:dartz/dartz.dart';

class DeliveryProfileUseCases {
  final BaseDeliveryProfileRepository repository;

  DeliveryProfileUseCases(this.repository);

  Future<Either<Failure, DeliveryProfileModel>> getProfile() async {
    return await repository.getProfile();
  }
}
