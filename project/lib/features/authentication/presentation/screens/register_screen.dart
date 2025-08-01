import 'package:caterease/features/authentication/presentation/controllers/bloc/register/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caterease/core/widgets/custom_text_field.dart';
import 'package:caterease/features/authentication/presentation/screens/verification_screen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneNumberController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          // optional: show loading
        } else if (state is RegisterFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        } else if (state is RegisterSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationPage(
                email: emailController.text,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Register"),
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextField(
                      label: "Name",
                      hint: "Full Name",
                      controller: nameController,
                      validator: (value) => value == null || value.isEmpty
                          ? "This field is required"
                          : null,
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: selectedGender,
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'm', child: Text('Male')),
                        DropdownMenuItem(value: 'f', child: Text('Female')),
                      ],
                      onChanged: (value) => setState(() {
                        selectedGender = value;
                      }),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please select a gender'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: "Email",
                      controller: emailController,
                      hint: "example@gmail.com",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field is required";
                        }
                        final pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                        final regex = RegExp(pattern);
                        return !regex.hasMatch(value)
                            ? "Please enter a valid email address"
                            : null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: "Password",
                      controller: passwordController,
                      hint: "p@sSw0rd",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
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
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: "Confirm Password",
                      hint: "",
                      controller: confirmPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field is required";
                        }
                        if (value != passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: phoneNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        label: const Text("Phone Number"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? "This field is required"
                          : null,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is RegisterLoading
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  context.read<RegisterBloc>().add(
                                        RegisterSubmitted(
                                          name: nameController.text,
                                          email: emailController.text,
                                          password: passwordController.text,
                                          confirmationPassword:
                                              confirmPasswordController.text,
                                          phone: phoneNumberController.text,
                                          gender: selectedGender ?? '',
                                        ),
                                      );
                                }
                              },
                        child: state is RegisterLoading
                            ? const CircularProgressIndicator()
                            : const Text("Register"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
