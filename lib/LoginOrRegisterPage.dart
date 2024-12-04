import 'package:flutter/material.dart';
import 'Register_page.dart';
import 'login_page.dart';
class loginorregiserpg extends StatefulWidget {
  const loginorregiserpg({super.key});

  @override
  State<loginorregiserpg> createState() => _loginorregiserpgState();
}

class _loginorregiserpgState extends State<loginorregiserpg> {
  // initially show login page

  bool showLoginPage = true;
  // toggle bettween login and register page

  void togglePage(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return login_page(onTap: togglePage,);
    }else{
      return RegisterPage(onTap: togglePage,);
    }
  }
}
