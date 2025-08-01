import 'package:caterease/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:caterease/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:caterease/features/cart/domain/repositories/cart_repository.dart';
import 'package:caterease/features/cart/domain/usecases/add_to_cart_use_case.dart';
import 'package:caterease/features/cart/domain/usecases/get_cart_packages_use_case.dart';
import 'package:caterease/features/cart/domain/usecases/remove_cart_item_use_case.dart';
import 'package:caterease/features/cart/domain/usecases/update_cart_item_use_case.dart';
import 'package:caterease/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:caterease/features/location/data/datasources/send_location_remote_data_source.dart';
import 'package:caterease/features/location/domain/usecases/send_location_usecase.dart';
import 'package:caterease/features/packages/data/datasources/packages_remote_data_source.dart';
import 'package:caterease/features/packages/data/repositories/packages_repository_impl.dart';
import 'package:caterease/features/packages/domain/repositories/packages_repository.dart';
import 'package:caterease/features/packages/domain/usecases/get_packages_for_branch.dart';
import 'package:caterease/features/packages/domain/usecases/get_package_detail.dart';
import 'package:caterease/features/packages/presentation/bloc/packages_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:caterease/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:caterease/features/authentication/data/repositories/auth_repository.dart';
import 'package:caterease/features/authentication/domain/repositories/base_auth_repository.dart';
import 'package:caterease/features/authentication/domain/usecases/login_user_use_case.dart';
import 'package:caterease/features/authentication/domain/usecases/register_user_use_case.dart';
import 'package:caterease/features/authentication/domain/usecases/verify_email_use_case.dart';
import 'package:caterease/features/authentication/presentation/controllers/bloc/login/login_bloc.dart';
import 'package:caterease/features/authentication/presentation/controllers/bloc/register/register_bloc.dart';
import 'package:caterease/features/authentication/presentation/controllers/bloc/verify/verify_bloc.dart';

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
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initAuthentication();
  await _initLocation();
  await _initRestaurants();
  await _initPackages();
  await _initCart();
  await _initCore();
  await _initExternal();
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

Future<void> _initAuthentication() async {
  //:Bloc
  sl.registerFactory(() => LoginBloc(sl()));
  sl.registerFactory(() => RegisterBloc(sl()));
  sl.registerFactory(() => VerifyBloc(sl()));

  //: UseCases
  sl.registerLazySingleton(() => LoginUserUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUserUseCase(sl()));
  sl.registerLazySingleton(() => VerifyEmailUseCase(sl()));

  //: Repositories
  sl.registerLazySingleton<BaseAuthRepository>(() => AuthRepository(sl()));

  //: DataSources
  sl.registerLazySingleton<BaseAuthRemoteDataSource>(
      () => AuthRemoteDataSource());
}

Future<void> _initCore() async {
  sl.registerLazySingleton(() => NetworkClient(sl(), sl()));
}

Future<void> _initExternal() async {
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => const FlutterSecureStorage());
}

Future<void> _initPackages() async {
  // Data sources
  sl.registerLazySingleton<PackagesRemoteDataSource>(
    () => PackagesRemoteDataSourceImpl(client: sl()),
  );

  // Repositories
  sl.registerLazySingleton<PackagesRepository>(
    () => PackagesRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetPackagesForBranch(sl()));
  sl.registerLazySingleton(() => GetPackageDetail(sl()));

  // Bloc
  sl.registerFactory(() => PackagesBloc(
        getPackagesForBranch: sl(),
        getPackageDetail: sl(),
      ));
}

Future<void> _initCart() async {
  // Data sources
  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(client: sl()),
  );

  // Repositories
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => AddToCartUseCase(sl()));
  sl.registerLazySingleton(() => GetCartPackagesUseCase(sl()));
// ← أضف هذول
  sl.registerLazySingleton<UpdateCartItemUseCase>(
    () => UpdateCartItemUseCase(sl()),
  );
  sl.registerLazySingleton<RemoveCartItemUseCase>(
    () => RemoveCartItemUseCase(sl()),
  );
  // Bloc
  sl.registerFactory(() => CartBloc(
        addToCartUseCase: sl(),
        getCartPackagesUseCase: sl(),
        updateCartItemUseCase: sl(),
        removeCartItemUseCase: sl(),
      ));
}
