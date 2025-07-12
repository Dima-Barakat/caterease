import 'package:caterease/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:caterease/features/authentication/data/repositories/auth_repository.dart';
import 'package:caterease/features/authentication/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:caterease/core/widgets/custom_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/bloc/password_reset/password_reset_bloc.dart';
import '../../domain/usecases/password_reset_use_case.dart';
import 'package:caterease/injection_container.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String email;
  final String userId;

  const ChangePasswordScreen({
    required this.email,
    required this.userId,
    super.key,
  });
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isPasswordEnabled = false;
  bool isConfirmEnabled = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PasswordResetBloc(
          PasswordResetUseCase(AuthRepository(AuthRemoteDataSource()))),
      child: BlocConsumer<PasswordResetBloc, PasswordResetState>(
        listener: (context, state) {
          if (state is PasswordChangeLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Changing Password...')),
            );
          } else if (state is PasswordChangeSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Password changed successfully!")),
            );
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ));
          } else if (state is PasswordChangeFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
            ),
            body: Container(
              padding: const EdgeInsets.all(40),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Account Confirmation",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Enter your new password",
                      textAlign: TextAlign.end,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      label: "Password",
                      hint: "",
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return 'Must contain at least one uppercase letter';
                        }
                        if (!RegExp(r'[a-z]').hasMatch(value)) {
                          return 'Must contain at least one lowercase letter';
                        }
                        if (!RegExp(r'\d').hasMatch(value)) {
                          return 'Must contain at least one number';
                        }
                        if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
                          return 'Must contain at least one special character (!@#\$&*~)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      label: "Confirm Password",
                      hint: "",
                      controller: confirmPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            BlocProvider.of<PasswordResetBloc>(context).add(
                              ChangePasswordEvent(
                                email: widget.email,
                                newPassword: passwordController.text,
                                passwordConfirmation:
                                    confirmPasswordController.text,
                              ),
                            );
                          }
                        },
                        child: const Text("Confirm"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
