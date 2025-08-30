import 'package:caterease/core/network/network_client.dart';
import 'package:caterease/features/delivery/data/models/delivery_profile_model.dart';
import 'package:dartz/dartz.dart';

abstract class BaseProfileRemoteDataSource {
  // Future<DeliveryProfileModel> getProfile();
  Future<Unit> changeAvailability();
}

class ProfileRemoteDataSource extends BaseProfileRemoteDataSource {
  final NetworkClient client;

  ProfileRemoteDataSource({required this.client});

/*   @override
  Future<DeliveryProfileModel> getProfile() async {

    
  } */

  @override
  Future<Unit> changeAvailability() async {
    return unit;
  }
}
