import 'package:caterease/features/authentication/presentation/controllers/bloc/register/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caterease/core/widgets/customtextfeild.dart';
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
                      label: "name",
                      hint: "ديما بركات",
                      controller: nameController,
                      validator: (value) =>
                          value == null || value.isEmpty ? "هذا الحقل مطلوب" : null,
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: selectedGender,
                      decoration: InputDecoration(
                        labelText: 'gender',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'm', child: Text('ذكر')),
                        DropdownMenuItem(value: 'f', child: Text('أنثى')),
                      ],
                      onChanged: (value) => setState(() {
                        selectedGender = value;
                      }),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'الرجاء اختيار الجنس' : null,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: "email",
                      controller: emailController,
                      hint: "example@gmail.com",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "هذا الحقل مطلوب";
                        }
                        final pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                        final regex = RegExp(pattern);
                        return !regex.hasMatch(value)
                            ? "الرجاء إدخال بريد إلكتروني صالح"
                            : null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: "password",
                      controller: passwordController,
                      hint: "p@sSw0rd",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال كلمة المرور';
                        }
                        if (value.length < 8) {
                          return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
                        }
                        if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return 'يجب أن تحتوي على حرف كبير واحد على الأقل';
                        }
                        if (!RegExp(r'[a-z]').hasMatch(value)) {
                          return 'يجب أن تحتوي على حرف صغير واحد على الأقل';
                        }
                        if (!RegExp(r'\d').hasMatch(value)) {
                          return 'يجب أن تحتوي على رقم واحد على الأقل';
                        }
                        if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
                          return 'يجب أن تحتوي على رمز خاص واحد على الأقل (!@#\$&*~)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: "confirm_password",
                      hint: "",
                      controller: confirmPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "هذا الحقل مطلوب";
                        }
                        if (value != passwordController.text) {
                          return "كلمة المرور غير متطابقة";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: phoneNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        label: const Text("phone_number"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? "هذا الحقل مطلوب" : null,
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
                            : const Text("send"),
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
