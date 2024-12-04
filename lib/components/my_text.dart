import 'package:flutter/material.dart';
@immutable
class my_text extends StatelessWidget {
  String text;
  my_text({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: Colors.grey[700], fontSize: 16),
    );
  }
}
