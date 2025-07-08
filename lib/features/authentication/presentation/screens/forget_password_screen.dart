import 'package:flutter/material.dart';
import '../screens/verification_screen.dart';
import 'package:caterease/core/widgets/customtextfeild.dart';

class ForgetPassword extends StatefulWidget {
  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  GlobalKey<FormState> formstate = GlobalKey();
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
        /*  actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_forward))
        ], */
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(""), fit: BoxFit.cover)),
        padding: EdgeInsets.all(40),
        child: Form(
            key: formstate,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "enter your email",
                  //    textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 50,
                ),
                CustomTextField(
                  label: "email",
                  controller: emailController,
                  hint: "example@gmail.com",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "this fieled is required";
                    }

                    // التعبير المنتظم لفحص البريد الإلكتروني
                    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                    RegExp regex = RegExp(pattern);
                    if (!regex.hasMatch(value)) {
                      return "please enter correct email";
                    }

                    return null; // صالح
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)))),
                    onPressed: () {
                      if (formstate.currentState!.validate()) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => VerificationPage()));
                      }
                    },
                    child: Text("send"))
              ],
            )),
      ),
    );
  }
}
