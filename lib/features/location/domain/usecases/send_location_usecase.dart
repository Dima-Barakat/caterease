import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/location_repository.dart';

class SendLocationUseCase {
  final LocationRepository repository;

  SendLocationUseCase(this.repository);

  Future<Either<Failure, void>> call(double latitude, double longitude) async {
    return await repository.sendLocation(latitude, longitude);
  }
}
