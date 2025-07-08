import 'package:caterease/features/authentication/presentation/controllers/bloc/login/login_bloc.dart';
import 'package:caterease/features/authentication/presentation/controllers/bloc/register/register_bloc.dart';
import 'package:caterease/features/authentication/presentation/screens/register_screen.dart';
import 'package:caterease/features/restaurants/presentation/bloc/restaurants_bloc.dart';
import 'package:caterease/features/location/presentation/bloc/location_bloc.dart'; // تأكد من استيراد LocationBloc
import 'package:caterease/injection_container.dart';
import 'package:caterease/features/authentication/presentation/screens/login_screen.dart';
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
      title: 'CaterEase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<LoginBloc>()),
          BlocProvider(create: (_) => sl<RegisterBloc>()),
          BlocProvider(create: (_) => sl<RestaurantsBloc>()),
          BlocProvider(create: (_) => sl<LocationBloc>()),
        ],
        child: const RegisterPage(),
      ),
    );
  }
}
