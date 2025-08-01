import 'package:caterease/animated_splash_screen.dart';
import 'package:caterease/features/authentication/presentation/controllers/bloc/login/login_bloc.dart';
import 'package:caterease/features/authentication/presentation/controllers/bloc/register/register_bloc.dart';
import 'package:caterease/features/authentication/presentation/controllers/bloc/verify/verify_bloc.dart';
import 'package:caterease/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:caterease/features/delivery/presentation/controller/bloc/delivery_order_bloc.dart';
import 'package:caterease/features/profile/presentation/controller/bloc/address/address_bloc.dart';
import 'package:caterease/features/authentication/presentation/controllers/bloc/password_reset/password_reset_bloc.dart';
import 'package:caterease/features/profile/presentation/controller/bloc/profile/profile_bloc.dart';
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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<LoginBloc>()),
        BlocProvider(create: (_) => sl<RegisterBloc>()),
        BlocProvider(create: (_) => sl<VerifyBloc>()),
        BlocProvider(create: (_) => sl<RestaurantsBloc>()),
        BlocProvider(create: (_) => sl<PackagesBloc>()),
        BlocProvider(create: (_) => sl<CartBloc>()),
        BlocProvider(create: (_) => sl<ProfileBloc>()),
        BlocProvider(create: (_) => sl<PasswordResetBloc>()),
        BlocProvider(create: (_) => sl<AddressBloc>()),
        BlocProvider(create: (_) => sl<LocationBloc>()),
        BlocProvider(create: (_) => sl<DeliveryOrderBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Caterease',
        theme: AppTheme.lightTheme,
        navigatorObservers: [routeObserver],
        home: AnimatedSplashScreen(),
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
}
