import 'package:flutter/material.dart';
import 'package:warn_me/screens/welcome.dart';
import 'package:warn_me/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.light,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const WelcomePage(),
    );
  }
}
