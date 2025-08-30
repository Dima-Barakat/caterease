import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../core/error/failures.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/repositories/restaurants_repository.dart';
import '../datasources/restaurants_remote_data_source.dart';
import '../models/branch_model.dart';
import 'package:caterease/core/storage/secure_storage.dart';

class RestaurantsRepositoryImpl implements RestaurantsRepository {
  final RestaurantsRemoteDataSource remoteDataSource;

  RestaurantsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Restaurant>>> getNearbyRestaurants(
    double latitude,
    double longitude,
  ) async {
    try {
      final restaurants = await remoteDataSource.getNearbyRestaurants(
        latitude,
        longitude,
      );
      return Right(restaurants);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Restaurant>>> getAllRestaurants() async {
    try {
      final restaurants = await remoteDataSource.getAllRestaurants();
      return Right(restaurants);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  // الجديد - تنفيذ method للفلترة حسب المحافظة
  @override
  Future<Either<Failure, List<Restaurant>>> getRestaurantsByCity(int cityId) async {
    try {
      final restaurants = await remoteDataSource.getRestaurantsByCity(cityId);
      return Right(restaurants);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  Future<List<BranchModel>> getBranchesByCategory(String category) async {
    final url =
        Uri.parse("http://192.168.67.155:8000/api/branches/category/$category");

    SecureStorage secureStorage = SecureStorage();
    String? token = await secureStorage.getAccessToken();

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('📤 toto: $token');

    print('📤 Sending request to category: $category');
    print('📥 Response status: ${response.statusCode}');
    print('📥 Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List branches = data['data'];
      return branches.map((e) => BranchModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load branches");
    }
  }
}

