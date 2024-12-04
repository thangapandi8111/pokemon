import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:pokemon/components/login_or_register.dart';
import 'package:pokemon/components/my_button.dart';
import 'package:pokemon/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pokemon/components/square_cont.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailcontroller = TextEditingController();
  final confirmpasswordcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  void signUserUp() async {
    try {
      if (passwordcontroller.text == confirmpasswordcontroller.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailcontroller.text,
          password: passwordcontroller.text,
        );
      } else {
        showErrorMessage("Pass word Don't match");
      }
      // Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.lightBlue,
          title: Center(
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5FFF2),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Gap(50),
                Icon(
                  Icons.lock_open_outlined,
                  size: 100,
                ),
                Gap(20),
                Text(
                  'Register here',
                ),
               Gap(20),
                my_textfield(
                    controller: emailcontroller,
                    hintText: 'email ID',
                    obscureText: false),
               Gap(20),
                my_textfield(
                    controller: passwordcontroller,
                    hintText: "password",
                    obscureText: true),
                Gap(20),
                my_textfield(
                    controller: confirmpasswordcontroller,
                    hintText: "conform password",
                    obscureText: true),
               Gap(50),
                my_button(onTaps: signUserUp, text: "sign user"),
               Gap(50),

               Gap(20),
                loginorregisterbtn(
                    text_loginor: "I Already Have Account",
                    onTapr: widget.onTap,
                    bt_text: "Login")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
