import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'features/restaurants/data/datasources/restaurants_remote_data_source.dart';
import 'features/restaurants/data/repositories/restaurants_repository_impl.dart';
import 'features/restaurants/domain/repositories/restaurants_repository.dart';
import 'features/restaurants/domain/usecases/get_nearby_restaurants.dart';
import 'features/restaurants/domain/usecases/get_all_restaurants.dart';
import 'features/restaurants/presentation/bloc/restaurants_bloc.dart';

import 'features/location/data/datasources/location_data_source.dart';
import 'features/location/data/repositories/location_repository_impl.dart';
import 'features/location/domain/repositories/location_repository.dart';
import 'features/location/domain/usecases/get_current_location.dart';
import 'features/location/domain/usecases/request_location_permission.dart';
import 'features/location/presentation/bloc/location_bloc.dart';

import 'core/network/network_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features
  await _initRestaurants();
  await _initLocation();

  // Core
  await _initCore();

  // External
  await _initExternal();
}

Future<void> _initRestaurants() async {
  // Bloc
  sl.registerFactory(
    () => RestaurantsBloc(
      getNearbyRestaurants: sl(),
      getAllRestaurants: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetNearbyRestaurants(sl()));
  sl.registerLazySingleton(() => GetAllRestaurants(sl()));

  // Repository
  sl.registerLazySingleton<RestaurantsRepository>(
    () => RestaurantsRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<RestaurantsRemoteDataSource>(
    () => RestaurantsRemoteDataSourceImpl(client: sl()),
  );
}

Future<void> _initLocation() async {
  // Bloc
  sl.registerFactory(
    () => LocationBloc(
      getCurrentLocation: sl(),
      requestLocationPermission: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetCurrentLocation(sl()));
  sl.registerLazySingleton(() => RequestLocationPermission(sl()));

  // Repository
  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(dataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<LocationDataSource>(
    () => LocationDataSourceImpl(),
  );
}

Future<void> _initCore() async {
  sl.registerLazySingleton(() => NetworkClient(sl()));
}

Future<void> _initExternal() async {
  sl.registerLazySingleton(() => http.Client());
}
