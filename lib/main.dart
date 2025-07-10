import 'package:caterease/features/authentication/presentation/controllers/bloc/login/login_bloc.dart';
import 'package:caterease/features/authentication/presentation/controllers/bloc/register/register_bloc.dart';
import 'package:caterease/features/authentication/presentation/controllers/bloc/verify/verify_bloc.dart';
import 'package:caterease/features/authentication/presentation/screens/forget_password_screen.dart';
import 'package:caterease/features/authentication/presentation/screens/register_screen.dart';
import 'package:caterease/features/authentication/presentation/screens/login_screen.dart';
import 'package:caterease/core/theming/colors_theme.dart';
import 'package:caterease/features/delivery/presentation/screens/order_details.dart';
import 'package:caterease/features/restaurants/presentation/bloc/restaurants_bloc.dart';
import 'package:caterease/features/location/presentation/bloc/location_bloc.dart'; // تأكد من استيراد LocationBloc
import 'package:caterease/injection_container.dart';
import 'package:caterease/features/restaurants/presentation/pages/home_page.dart';
import 'package:caterease/features/delivery/presentation/screens/my_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CaterEase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
            centerTitle: true,
            color: ColorsTheme.darkBlue,
            titleTextStyle: TextStyle(
                color: ColorsTheme.lightGray,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<LoginBloc>()),
          BlocProvider(create: (_) => sl<RegisterBloc>()),
          BlocProvider(create: (_) => sl<VerifyBloc>()),
          BlocProvider(create: (_) => sl<RestaurantsBloc>()),
          BlocProvider(create: (_) => sl<LocationBloc>()),
        ],
        child: const ForgetPassword(),
      ),
    );
  }
}
