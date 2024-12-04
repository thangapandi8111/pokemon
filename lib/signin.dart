import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'LoginOrRegisterPage.dart';
import 'homepage.dart';

class signin extends StatelessWidget {
  const signin({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return homepage();
            } else {
              return loginorregiserpg();
            }
          }),
    );
  }
}
