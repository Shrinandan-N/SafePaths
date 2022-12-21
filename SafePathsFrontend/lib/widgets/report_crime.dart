import 'package:flutter/material.dart';

class ReportCrimeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(10)),
      width: size.width / 3.5,
      height: size.height * 0.05,
      child: Center(
        child: const Text(
          "Report Crime",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
