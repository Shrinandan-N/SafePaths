import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      child: const TextField(
        decoration: InputDecoration(hintText: "University Name"),
      ),
    );
  }
}
