import 'package:caterease/core/storage/secure_storage.dart';
import 'package:caterease/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:caterease/features/authentication/data/repositories/auth_repository.dart';
import 'package:caterease/features/authentication/domain/usecases/password_reset_use_case.dart';
import 'package:flutter/material.dart';
import '../screens/verification_screen.dart';
import 'package:caterease/core/widgets/custom_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/bloc/password_reset/password_reset_bloc.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PasswordResetBloc(
        PasswordResetUseCase(AuthRepository(AuthRemoteDataSource())),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: BlocConsumer<PasswordResetBloc, PasswordResetState>(
          listener: (context, state) {
            if (state is PasswordResetEmailSent) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => VerificationPage(
                  scenario: "forgotPassword",
                  email: emailController.text,
                  userId: SecureStorage().getUserId().toString(),
                ),
              ));
            } else if (state is PasswordResetEmailFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(40),
                  child: Form(
                    key: formState,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Enter your email",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 50),
                        CustomTextField(
                          label: "Email",
                          controller: emailController,
                          hint: "example@gmail.com",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            }
                            const pattern =
                                r'^[\w\.-]+@([\w\-]+\.)+[\w\-]{2,4}$';
                            final regex = RegExp(pattern);
                            if (!regex.hasMatch(value)) {
                              return "Please enter a valid email";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (formState.currentState!.validate()) {
                              context.read<PasswordResetBloc>().add(
                                    PasswordResetRequested(
                                      email: emailController.text,
                                    ),
                                  );
                            }
                          },
                          child: const Text("Send"),
                        ),
                      ],
                    ),
                  ),
                ),
                if (state is PasswordResetLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            );
          },
        ),
      ),
    );
  }
}
