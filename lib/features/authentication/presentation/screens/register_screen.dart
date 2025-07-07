import 'package:caterease/core/widgets/customtextfeild.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterPage();
}

class _RegisterPage extends State<Register> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isPasswordEnabled = false;
  bool isConfirmEnabled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Register",
       /*    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold), */
        ),
  
        elevation: 0,
      ),
      body: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /*     Text(
                    "Register",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ), 
                  SizedBox(
                    height: 50,
                  ),*/
                  CustomTextField(
                      label: "first_name",
                      hint: "xxxx",
                      controller: firstNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "هذا الحقل مطلوب";
                        }
                      }),
                  SizedBox(height: 20),
                  CustomTextField(
                      label: "last_name",
                      hint: "xxxx",
                      controller: lastNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "هذا الحقل مطلوب";
                        }
                      }),
                  SizedBox(height: 20),
                  CustomTextField(
                    label: "email",
                    controller: emailController,
                    hint: "example@gmail.com",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "هذا الحقل مطلوب";
                      }
                      String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                      RegExp regex = RegExp(pattern);
                      if (!regex.hasMatch(value)) {
                        return "الرجاء إدخال بريد إلكتروني صالح";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
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
                      }),
                  SizedBox(height: 20),
                  TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        label: Text("phone_number"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "هذا الحقل مطلوب";
                        }
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            // تنفيذ عملية التسجيل (API أو Bloc...)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('جاري إنشاء الحساب...')),
                            );
                          }
                        },
                        child: Text("send")),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
