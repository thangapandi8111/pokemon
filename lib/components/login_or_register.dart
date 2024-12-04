
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@immutable
class loginorregisterbtn extends StatefulWidget {
  final Function()? onTapr;
  String text_loginor;
  String bt_text;
   loginorregisterbtn({super.key,required this.text_loginor,required this.onTapr,required this.bt_text});

  @override
  State<loginorregisterbtn> createState() => _loginorregisterState();
}

class _loginorregisterState extends State<loginorregisterbtn> {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(widget.text_loginor),
        SizedBox(width: 4,),
        GestureDetector(
          onTap: widget.onTapr,
          child: Text(
            widget.bt_text,
            style: TextStyle(
            color: Colors.blue,fontWeight: FontWeight.bold
          ),
          ),
        )
      ],
    );
  }
}

