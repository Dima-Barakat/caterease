import 'package:caterease/features/profile/data/datasources/address_remote_datasource.dart';
import 'package:caterease/features/profile/data/repositories/address_repository.dart';
import 'package:caterease/features/profile/domain/repositories/base_address_repository.dart';
import 'package:caterease/features/profile/domain/usecases/address/create_address_use_case.dart';
import 'package:caterease/features/profile/domain/usecases/address/delete_address_use_case.dart';
import 'package:caterease/features/profile/domain/usecases/address/index_addresses_use_case.dart';
import 'package:caterease/features/profile/presentation/controller/bloc/address/address_bloc.dart';
import 'package:caterease/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:caterease/features/authentication/data/repositories/auth_repository.dart';
import 'package:caterease/features/authentication/domain/repositories/base_auth_repository.dart';
import 'package:caterease/features/authentication/domain/usecases/login_user_use_case.dart';
import 'package:caterease/features/authentication/domain/usecases/password_reset_use_case.dart';
import 'package:caterease/features/authentication/domain/usecases/register_user_use_case.dart';
import 'package:caterease/features/authentication/domain/usecases/verify_email_use_case.dart';
import 'package:caterease/features/authentication/presentation/controllers/bloc/login/login_bloc.dart';
import 'package:caterease/features/authentication/presentation/controllers/bloc/password_reset/password_reset_bloc.dart';
import 'package:caterease/features/authentication/presentation/controllers/bloc/register/register_bloc.dart';
import 'package:caterease/features/authentication/presentation/controllers/bloc/verify/verify_bloc.dart';
import 'package:caterease/features/location/data/datasources/send_location_remote_data_source.dart';
import 'package:caterease/features/location/domain/usecases/send_location_usecase.dart';
import 'package:caterease/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:caterease/features/profile/data/repositories/user_repository.dart';
import 'package:caterease/features/profile/domain/repositories/base_profile_repository.dart';
import 'package:caterease/features/profile/domain/usecases/profile/get_profile_details_use_case.dart';
import 'package:caterease/features/profile/domain/usecases/profile/update_profile_use_case.dart';
import 'package:caterease/features/profile/presentation/controller/bloc/profile/profile_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'features/restaurants/data/datasources/restaurants_remote_data_source.dart';
import 'features/restaurants/data/repositories/restaurants_repository_impl.dart';
import 'features/restaurants/domain/repositories/restaurants_repository.dart';
import 'features/restaurants/domain/usecases/get_all_restaurants.dart';
import 'features/restaurants/domain/usecases/get_nearby_restaurants.dart';
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
  await _initAuthentication();
  await _initRestaurants();
  await _initLocation();
  await _initCore();
  await _initExternal();
  await _initProfile();
  await _initAddress();
}

Future<void> _initAuthentication() async {
  //:Bloc
  sl.registerFactory(() => LoginBloc(sl()));
  sl.registerFactory(() => RegisterBloc(sl()));
  sl.registerFactory(() => VerifyBloc(sl()));
  sl.registerFactory(() => PasswordResetBloc(sl()));

  //: UseCases
  sl.registerLazySingleton(() => LoginUserUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUserUseCase(sl()));
  sl.registerLazySingleton(() => VerifyEmailUseCase(sl()));
  sl.registerLazySingleton(() => PasswordResetUseCase(sl()));
  //: Repositories
  sl.registerLazySingleton<BaseAuthRepository>(() => AuthRepository(sl()));

  //: DataSources
  sl.registerLazySingleton<BaseAuthRemoteDataSource>(
      () => AuthRemoteDataSource(sl()));
}

Future<void> _initProfile() async {
  //: Bloc
  sl.registerFactory(() => ProfileBloc(sl(), sl()));

  //:UseCases
  sl.registerLazySingleton(() => GetProfileDetailsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));

  //:Repository
  sl.registerLazySingleton<BaseProfileRepository>(() => UserRepository(sl()));

  //:DataSource
  sl.registerLazySingleton<BaseProfileRemoteDatasource>(
      () => ProfileRemoteDatasource(sl()));
}

Future<void> _initRestaurants() async {
  sl.registerLazySingleton<RestaurantsRemoteDataSource>(
    () => RestaurantsRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<RestaurantsRepository>(
    () => RestaurantsRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetNearbyRestaurants(sl()));
  sl.registerLazySingleton(() => GetAllRestaurants(sl()));

  sl.registerFactory(() => RestaurantsBloc(
        getNearbyRestaurants: sl(),
        getAllRestaurants: sl(),
        repo: sl(),
      ));
}

Future<void> _initLocation() async {
  // ✅ Data Sources
  sl.registerLazySingleton<LocationDataSource>(
    () => LocationDataSourceImpl(),
  );
  sl.registerLazySingleton<SendLocationRemoteDataSource>(
    () => SendLocationRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(
      dataSource: sl<LocationDataSource>(),
      remoteDataSource: sl<SendLocationRemoteDataSource>(),
    ),
  );

  // ✅ Use Cases
  sl.registerLazySingleton(() => GetCurrentLocation(sl()));
  sl.registerLazySingleton(() => RequestLocationPermission(sl()));
  sl.registerLazySingleton(() => SendLocationUseCase(sl()));

  // ✅ Bloc
  sl.registerFactory(() => LocationBloc(
        getCurrentLocation: sl(),
        requestLocationPermission: sl(),
        sendLocationUseCase: sl(),
      ));
}

Future<void> _initCore() async {
  sl.registerLazySingleton(() => NetworkClient(sl(), sl()));
}

Future<void> _initExternal() async {
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
}

Future<void> _initAddress() async {
  //:Bloc
  sl.registerFactory(() => AddressBloc(sl(), sl(), sl()));

  //:UseCase
  sl.registerLazySingleton(() => IndexAddressesUseCase(sl()));
  sl.registerLazySingleton(() => CreateAddressUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAddressUseCase(sl()));

  //:Repository
  sl.registerLazySingleton<BaseAddressRepository>(
      () => AddressRepository(sl(), sl()));

  //:DataSource
  sl.registerLazySingleton<BaseAddressRemoteDatasource>(
      () => AddressRemoteDatasource(client: sl()));
}
