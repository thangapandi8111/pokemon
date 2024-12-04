import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'components/login_or_register.dart';
import 'components/my_button.dart';
import 'components/my_textfield.dart';
import 'components/square_cont.dart';


class login_page extends StatefulWidget {
  final Function()? onTap;
  login_page({super.key, required this.onTap});

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  void signuserin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailcontroller.text,
        password: passwordcontroller.text,
      );
      // Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String messager) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.lightBlue,
            title: Center(
              child: Text(
                messager,
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        });
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
                  Icons.account_circle,
                  size: 100,
                ),
               Gap(50),
                Text(
                  'hii pokemon !',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
               Gap(50),
                my_textfield(
                  controller: emailcontroller,
                  hintText: 'EMAIL',
                  obscureText: false,
                ),
                Gap(10),
                my_textfield(
                    controller: passwordcontroller,
                    hintText: 'PASSCODE',
                    obscureText: true),
                Gap(10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Passcode?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Gap(10),
                my_button(
                  onTaps: signuserin,
                  text: 'Sign in',
                ),
                Gap(25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                Gap(50),
                loginorregisterbtn(
                    text_loginor: "New User",
                    onTapr: widget.onTap,
                    bt_text: "Register Now"),
                Gap(50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
