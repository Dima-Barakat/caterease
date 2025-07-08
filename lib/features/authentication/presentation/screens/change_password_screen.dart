import 'package:flutter/material.dart';
import 'package:caterease/core/widgets/custom_text_feild.dart';

class ChangePasswordScreen extends StatefulWidget {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  " Account confirmation",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "enter your new password",
                  textAlign: TextAlign.end,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  label: "password",
                  hint: "",
                  controller: passwordController,
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
                SizedBox(
                  height: 30,
                ),
                CustomTextField(
                  label: "confirm password",
                  hint: "",
                  controller: confirmPasswordController,
                  //   enabled: isConfirmEnabled,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى تأكيد كلمة المرور';
                    }
                    if (value != passwordController.text) {
                      return 'كلمة المرور غير متطابقة';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('جاري إنشاء الحساب...')),
                          );
                        }
                      },
                      child: Text("confirm")),
                )
              ],
            )),
      ),
    );
  }
}
