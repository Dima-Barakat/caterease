import 'package:caterease/core/network/network_info.dart';
import 'package:caterease/features/authentication/domain/usecases/logout_use_case.dart';
import 'package:caterease/features/authentication/presentation/controllers/bloc/logout/logout_bloc.dart';
import 'package:caterease/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:caterease/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:caterease/features/cart/domain/repositories/cart_repository.dart';
import 'package:caterease/features/cart/domain/usecases/add_to_cart_use_case.dart';
import 'package:caterease/features/cart/domain/usecases/get_cart_packages_use_case.dart';
import 'package:caterease/features/cart/domain/usecases/remove_cart_item_use_case.dart';
import 'package:caterease/features/cart/domain/usecases/update_cart_item_use_case.dart';
import 'package:caterease/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:caterease/features/customer_order_list/domain/usecases/delete_order_use_case.dart';

import 'package:caterease/features/customer_order_list/data/datasources/customer_order_list_remote_data_source.dart';
import 'package:caterease/features/customer_order_list/data/repositories/customer_order_list_repository_impl.dart';
import 'package:caterease/features/customer_order_list/domain/repositories/customer_order_list_repository.dart';
import 'package:caterease/features/customer_order_list/domain/usecases/get_customer_order_list_use_case.dart';
import 'package:caterease/features/customer_order_list/presentation/bloc/customer_order_list_bloc.dart';
import 'package:caterease/features/customer_orders/data/datasources/customer_order_remote_data_source.dart';
import 'package:caterease/features/customer_orders/data/repositories/customer_order_repository_impl.dart';
import 'package:caterease/features/customer_orders/domain/repositories/customer_order_repository.dart';
import 'package:caterease/features/customer_orders/domain/usecases/create_customer_order_use_case.dart';
import 'package:caterease/features/customer_orders/presentation/bloc/customer_order_bloc.dart';

import 'package:caterease/features/location/data/datasources/location_data_source.dart';
import 'package:caterease/features/delivery/data/datasources/delivery_profile_remote_data_source.dart';
import 'package:caterease/features/delivery/data/repositories/delivery_profile_repository.dart';
import 'package:caterease/features/delivery/domain/repositories/base_delivery_profile_repository.dart';
import 'package:caterease/features/delivery/domain/usecases/delivery_profile_use_cases.dart';
import 'package:caterease/features/delivery/presentation/controller/bloc/profile/delivery_profile_bloc.dart';
import 'package:caterease/features/location/data/datasources/send_location_remote_data_source.dart';
import 'package:caterease/features/location/data/repositories/location_repository_impl.dart';
import 'package:caterease/features/location/domain/repositories/location_repository.dart';
import 'package:caterease/features/location/domain/usecases/get_current_location.dart';
import 'package:caterease/features/location/domain/usecases/request_location_permission.dart';
import 'package:caterease/features/location/domain/usecases/send_location_usecase.dart';
import 'package:caterease/features/location/presentation/bloc/location_bloc.dart';
import 'package:caterease/features/order_details_feature/data/datasources/order_details_remote_data_source.dart';
import 'package:caterease/features/order_details_feature/data/datasources/order_details_remote_data_source_impl.dart';
import 'package:caterease/features/order_details_feature/data/repositories/order_details_repository_impl.dart';
import 'package:caterease/features/order_details_feature/domain/repositories/order_details_repository.dart';
import 'package:caterease/features/order_details_feature/presentation/bloc/order_details_bloc.dart';

import 'package:caterease/features/order_details_feature/domain/usecases/get_order_details_usecase.dart';
import 'package:caterease/features/packages/data/datasources/packages_remote_data_source.dart';
import 'package:caterease/features/packages/data/repositories/packages_repository_impl.dart';
import 'package:caterease/features/packages/domain/repositories/packages_repository.dart';
import 'package:caterease/features/packages/domain/usecases/get_packages_for_branch.dart';
import 'package:caterease/features/packages/domain/usecases/get_package_detail.dart';
import 'package:caterease/features/packages/presentation/bloc/packages_bloc.dart';

import 'package:caterease/features/delivery/data/datasources/order_remote_data_source.dart';
import 'package:caterease/features/delivery/data/repositories/order_repository.dart';
import 'package:caterease/features/delivery/domain/repositories/base_order_repository.dart';
import 'package:caterease/features/delivery/presentation/controller/bloc/order/delivery_order_bloc.dart';
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

import 'package:caterease/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:caterease/features/profile/data/repositories/user_repository.dart';
import 'package:caterease/features/profile/domain/repositories/base_profile_repository.dart';
import 'package:caterease/features/profile/domain/usecases/profile/get_profile_details_use_case.dart';
import 'package:caterease/features/profile/domain/usecases/profile/update_profile_use_case.dart';
import 'package:caterease/features/profile/presentation/controller/bloc/profile/profile_bloc.dart';

import 'package:caterease/features/restaurants/domain/entities/restaurant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'features/restaurants/data/datasources/restaurants_remote_data_source.dart';
import 'features/restaurants/data/repositories/restaurants_repository_impl.dart';
import 'features/restaurants/domain/repositories/restaurants_repository.dart';
import 'features/restaurants/domain/usecases/get_all_restaurants.dart';
import 'features/restaurants/domain/usecases/get_nearby_restaurants.dart';
import 'features/restaurants/domain/usecases/get_restaurants_by_city.dart'; // الجديد
import 'features/restaurants/presentation/bloc/restaurants_bloc.dart';
import 'features/restaurants/presentation/bloc/search_bloc.dart';
import 'core/network/network_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initAuthentication();
  await _initLocation();
  await _initRestaurants();
  await _initPackages();
  await _initCart();
  await _initProfile();
  await _initDeliveryProfile();
  await _initAddress();
  await _initOrder();
  await _initCustomerOrders();
  await _initCustomerOrderList();
  await _initCustomerOrderDetails();
  await _initCore();
  await _initExternal();
}

// ---------------- AUTH ----------------
Future<void> _initAuthentication() async {
  // Bloc
  sl.registerFactory(() => LoginBloc(sl()));
  sl.registerFactory(() => LogoutBloc(sl()));
  sl.registerFactory(() => RegisterBloc(sl()));
  sl.registerFactory(() => VerifyBloc(sl()));
  sl.registerFactory(() => PasswordResetBloc(sl()));

  // Use Cases
  sl.registerLazySingleton(() => LoginUserUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUserUseCase(sl()));
  sl.registerLazySingleton(() => VerifyEmailUseCase(sl()));
  sl.registerLazySingleton(() => PasswordResetUseCase(sl()));

  // Repository
  sl.registerLazySingleton<BaseAuthRepository>(() => AuthRepository(sl()));

  // Data Source
  sl.registerLazySingleton<BaseAuthRemoteDataSource>(
      () => AuthRemoteDataSource(sl()));
}

// ---------------- PROFILE ----------------
Future<void> _initProfile() async {
  sl.registerFactory(() => ProfileBloc(sl(), sl()));
  sl.registerLazySingleton(() => GetProfileDetailsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton<BaseProfileRepository>(() => UserRepository(sl()));
  sl.registerLazySingleton<BaseProfileRemoteDatasource>(
      () => ProfileRemoteDatasource(sl()));
}

// ---------------- DELIVERY PROFILE ----------------
Future<void> _initDeliveryProfile() async {
  sl.registerFactory(() => DeliveryProfileBloc(sl()));
  sl.registerLazySingleton(() => DeliveryProfileUseCases(sl()));
  sl.registerLazySingleton<BaseDeliveryProfileRepository>(
      () => DeliveryProfileRepository(sl()));
  sl.registerLazySingleton<BaseDeliveryProfileRemoteDataSource>(
      () => DeliveryProfileRemoteDataSource(sl()));
}

// ---------------- RESTAURANTS ----------------
Future<void> _initRestaurants() async {
  sl.registerLazySingleton<RestaurantsRemoteDataSource>(
      () => RestaurantsRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<RestaurantsRepository>(
      () => RestaurantsRepositoryImpl(remoteDataSource: sl()));

  sl.registerLazySingleton(() => GetNearbyRestaurants(sl()));
  sl.registerLazySingleton(() => GetAllRestaurants(sl()));
  sl.registerLazySingleton(() => GetRestaurantsByCity(sl()));

  sl.registerFactory(() => RestaurantsBloc(
        getNearbyRestaurants: sl(),
        getAllRestaurants: sl(),
        repo: sl(),
        getRestaurantsByCity: sl(),
      ));

  sl.registerFactoryParam<SearchBloc, List<Restaurant>, void>(
    (allRestaurants, _) => SearchBloc(
      allRestaurants: allRestaurants,
      locationBloc: sl<LocationBloc>(),
    ),
  );
}

// ---------------- LOCATION ----------------
Future<void> _initLocation() async {
  sl.registerLazySingleton<LocationDataSource>(() => LocationDataSourceImpl());
  sl.registerLazySingleton<SendLocationRemoteDataSource>(
      () => SendLocationRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton<LocationRepository>(() => LocationRepositoryImpl(
        dataSource: sl<LocationDataSource>(),
        remoteDataSource: sl<SendLocationRemoteDataSource>(),
      ));

  sl.registerLazySingleton(() => GetCurrentLocation(sl()));
  sl.registerLazySingleton(() => RequestLocationPermission(sl()));
  sl.registerLazySingleton(() => SendLocationUseCase(sl()));

  sl.registerFactory(() => LocationBloc(
        getCurrentLocation: sl(),
        requestLocationPermission: sl(),
        sendLocationUseCase: sl(),
      ));
}

// ---------------- PACKAGES ----------------
Future<void> _initPackages() async {
  sl.registerLazySingleton<PackagesRemoteDataSource>(
      () => PackagesRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<PackagesRepository>(
      () => PackagesRepositoryImpl(remoteDataSource: sl()));

  sl.registerLazySingleton(() => GetPackagesForBranch(sl()));
  sl.registerLazySingleton(() => GetPackageDetail(sl()));

  sl.registerFactory(() => PackagesBloc(
        getPackagesForBranch: sl(),
        getPackageDetail: sl(),
      ));
}

// ---------------- CART ----------------
Future<void> _initCart() async {
  sl.registerLazySingleton<CartRemoteDataSource>(
      () => CartRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<CartRepository>(
      () => CartRepositoryImpl(remoteDataSource: sl()));

  sl.registerLazySingleton(() => AddToCartUseCase(sl()));
  sl.registerLazySingleton(() => GetCartPackagesUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCartItemUseCase(sl()));
  sl.registerLazySingleton(() => RemoveCartItemUseCase(sl()));

  sl.registerFactory(() => CartBloc(
        addToCartUseCase: sl(),
        getCartPackagesUseCase: sl(),
        updateCartItemUseCase: sl(),
        removeCartItemUseCase: sl(),
      ));
}

// ---------------- ADDRESS ----------------
Future<void> _initAddress() async {
  sl.registerFactory(() => AddressBloc(sl()));
  sl.registerLazySingleton(() => IndexAddressesUseCase(sl()));
  sl.registerLazySingleton(() => CreateAddressUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAddressUseCase(sl()));

  sl.registerLazySingleton<BaseAddressRepository>(
      () => AddressRepository(sl(), sl()));
  sl.registerLazySingleton<BaseAddressRemoteDatasource>(
      () => AddressRemoteDatasource(client: sl()));
}

// ---------------- ORDER ----------------
Future<void> _initOrder() async {
  sl.registerFactory(() => DeliveryOrderBloc(sl()));
  sl.registerLazySingleton(() => GetOrderDetailsUseCase(sl()));
  sl.registerLazySingleton<BaseOrderRepository>(
      () => OrderRepository(dataSource: sl()));
  sl.registerLazySingleton<BaseOrderRemoteDataSource>(
      () => OrderRemoteDataSource(client: sl()));
}

// ---------------- CUSTOMER ORDERS ----------------
Future<void> _initCustomerOrders() async {
  sl.registerLazySingleton<CustomerOrderRemoteDataSource>(
      () => CustomerOrderRemoteDataSourceImpl(networkClient: sl()));
  sl.registerLazySingleton<CustomerOrderRepository>(
      () => CustomerOrderRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton(() => CreateCustomerOrderUseCase(repository: sl()));
  sl.registerFactory(() => CustomerOrderBloc(createCustomerOrderUseCase: sl()));
}

// ---------------- CUSTOMER ORDER LIST ----------------
Future<void> _initCustomerOrderList() async {
  sl.registerFactory(() => CustomerOrderListBloc(
        getCustomerOrderListUseCase: sl(),
        deleteOrderUseCase: sl(),
      ));
  sl.registerLazySingleton(() => GetCustomerOrderListUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteOrderUseCase(sl()));
  sl.registerLazySingleton<CustomerOrderListRepository>(() =>
      CustomerOrderListRepositoryImpl(
          remoteDataSource: sl(), networkInfo: sl()));
  sl.registerLazySingleton<CustomerOrderListRemoteDataSource>(
      () => CustomerOrderListRemoteDataSourceImpl(client: sl()));
}

// ---------------- CUSTOMER ORDER DETAILS ----------------
Future<void> _initCustomerOrderDetails() async {
  sl.registerFactory(() => OrderDetailsBloc(getOrderDetailsUseCase: sl()));
  sl.registerLazySingleton(() => GetOrderDetailsUseCase(sl()));
  sl.registerLazySingleton<OrderDetailsRepository>(
      () => OrderDetailsRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<OrderDetailsRemoteDataSource>(
      () => OrderDetailsRemoteDataSourceImpl(client: sl()));
}

// ---------------- CORE ----------------
Future<void> _initCore() async {
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => NetworkClient(sl(), sl()));
}

// ---------------- EXTERNAL ----------------
Future<void> _initExternal() async {
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
