import 'package:caterease/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:caterease/features/authentication/data/repositories/auth_repository.dart';
import 'package:caterease/features/authentication/domain/usecases/verify_email_use_case.dart';
import 'package:caterease/features/authentication/presentation/controllers/bloc/login/login_bloc.dart';
import 'package:caterease/features/authentication/presentation/controllers/bloc/verify/verify_bloc.dart';
import 'package:caterease/features/authentication/presentation/screens/login_screen.dart';
import 'package:caterease/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class VerificationPage extends StatefulWidget {
  final String email;

  const VerificationPage({required this.email, super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VerifyBloc(
          VerifyEmailUseCase(AuthRepository(AuthRemoteDataSource()))),
      child: BlocConsumer<VerifyBloc, VerifyState>(
        listener: (context, state) {
          if (state is VerifyLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Verifying...")),
            );
          } else if (state is VerifySuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Verification successful!")),
            );

            // Delay slightly so the SnackBar can show
            Future.delayed(const Duration(milliseconds: 500), () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider<LoginBloc>(
                    create: (_) => sl<LoginBloc>(),
                    child: const LoginPage(),
                  ),
                ),
              );
            });
          } else if (state is VerifyFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Verification failed: ${state.error}")),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Account Confirmation",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text("A verification code has been sent to:"),
                  Text(
                    widget.email,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Please enter the 6-digit code below",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(8),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeColor: Colors.blue,
                      selectedColor: Colors.blueAccent,
                      inactiveColor: Colors.grey[300]!,
                    ),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_otpController.text.length != 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Please enter a 6-digit code")),
                          );
                          return;
                        }

                        final userId = await storage.read(key: "user_id");

                        if (userId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("User ID not found.")),
                          );
                          return;
                        }

                        context.read<VerifyBloc>().add(
                              VerifySubmitted(
                                userId: userId,
                                otp: _otpController.text,
                              ),
                            );
                      },
                      child: const Text("Send", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
