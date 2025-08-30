import 'package:caterease/animated_splash_screen.dart';
import 'package:caterease/core/network/network_client.dart';
import 'package:caterease/core/services/firebase_notification_service.dart';
import 'package:caterease/core/services/payment_service.dart';
import 'package:caterease/core/storage/secure_storage.dart';
import 'package:caterease/features/authentication/presentation/controllers/bloc/login/login_bloc.dart';
import 'package:caterease/features/authentication/presentation/controllers/bloc/logout/logout_bloc.dart';
import 'package:caterease/features/authentication/presentation/controllers/bloc/register/register_bloc.dart';
import 'package:caterease/features/authentication/presentation/controllers/bloc/verify/verify_bloc.dart';
import 'package:caterease/features/authentication/presentation/screens/login_screen.dart';
import 'package:caterease/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:caterease/features/customer_order_list/presentation/bloc/customer_order_list_bloc.dart';
import 'package:caterease/features/customer_orders/presentation/bloc/customer_order_bloc.dart';
import 'package:caterease/features/delivery/presentation/controller/bloc/order/delivery_order_bloc.dart';
import 'package:caterease/features/delivery/presentation/controller/bloc/profile/delivery_profile_bloc.dart';
import 'package:caterease/features/delivery/presentation/screens/orders_list.dart';
import 'package:caterease/features/order_details_feature/presentation/bloc/order_details_bloc.dart';
import 'package:caterease/features/profile/presentation/screens/profile/profile_view_page.dart';
import 'package:caterease/features/restaurants/presentation/pages/orders_main_page.dart';
import 'package:caterease/features/profile/presentation/controller/bloc/address/address_bloc.dart';
import 'package:caterease/features/authentication/presentation/controllers/bloc/password_reset/password_reset_bloc.dart';
import 'package:caterease/features/profile/presentation/controller/bloc/profile/profile_bloc.dart';
import 'package:caterease/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caterease/features/restaurants/presentation/bloc/restaurants_bloc.dart';
import 'package:caterease/features/location/presentation/bloc/location_bloc.dart';
import 'package:caterease/features/packages/presentation/bloc/packages_bloc.dart';
import 'package:caterease/features/packages/presentation/pages/package_detail_page.dart';
import 'package:caterease/features/packages/domain/entities/package.dart';
import 'package:caterease/injection_container.dart';

import 'core/theming/app_theme.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();

  await FirebaseNotificationService.initialize();

  await PaymentService.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final SecureStorage _secureStorage = SecureStorage();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<LoginBloc>()),
        BlocProvider(create: (_) => sl<LogoutBloc>()),
        BlocProvider(create: (_) => sl<RegisterBloc>()),
        BlocProvider(create: (_) => sl<VerifyBloc>()),
        BlocProvider(create: (_) => sl<RestaurantsBloc>()),
        BlocProvider(create: (_) => sl<PackagesBloc>()),
        BlocProvider(create: (_) => sl<CartBloc>()),
        BlocProvider(create: (_) => sl<ProfileBloc>()),
        BlocProvider(create: (_) => sl<DeliveryProfileBloc>()),
        BlocProvider(create: (_) => sl<PasswordResetBloc>()),
        BlocProvider(create: (_) => sl<AddressBloc>()),
        BlocProvider(create: (_) => sl<LocationBloc>()),
        BlocProvider(create: (_) => sl<DeliveryOrderBloc>()),
        BlocProvider(create: (_) => sl<CustomerOrderBloc>()),
        BlocProvider(create: (_) => sl<CustomerOrderListBloc>()),
        BlocProvider(create: (_) => sl<OrderDetailsBloc>()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Caterease',
        theme: AppTheme.lightTheme,
        navigatorObservers: [routeObserver],
        home: FutureBuilder<Map<String, String?>>(
          future: _loadUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return AnimatedSplashScreen();
            }
            final data = snapshot.data;
            final token = data?['token'];
            final role = data?['role'];

            if (token != null) {
              if (role == "3") {
                return MainNavigation();
              } else if (role == "5") {
                return const OrdersList();
              } else {
                return const LoginPage();
              }
            } else {
              return const LoginPage();
            }
          },
        ),
        onGenerateRoute: (settings) {
          if (settings.name == '/packageDetails') {
            final Package package = settings.arguments as Package;
            return MaterialPageRoute(
              builder: (context) => PackageDetailPage(packageId: package.id),
            );
          }
          return null;
        },
      ),
    );
  }

  Future<Map<String, String?>> _loadUserData() async {
    final token = await _secureStorage.getAccessToken();
    final role = await _secureStorage.getRole();
    return {"token": token, "role": role};
  }
}
