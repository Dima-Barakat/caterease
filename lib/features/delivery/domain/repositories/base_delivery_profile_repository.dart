import 'package:caterease/core/error/failures.dart';
import 'package:caterease/features/delivery/data/models/delivery_profile_model.dart';
import 'package:dartz/dartz.dart';

abstract class BaseDeliveryProfileRepository {
  Future<Either<Failure, DeliveryProfileModel>> getProfile();
}
