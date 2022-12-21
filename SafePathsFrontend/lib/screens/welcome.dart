import 'package:flutter/material.dart';
import 'package:warn_me/screens/dashboard.dart';
import 'package:warn_me/theme/theme.dart';
import 'package:warn_me/theme/style.dart';
import 'package:warn_me/widgets/textfield.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/logo.png"),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFieldContainer(),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DashboardScreen()));
                      },
                      icon: const Icon(Icons.chevron_right))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
