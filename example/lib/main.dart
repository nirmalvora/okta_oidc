import 'package:flutter/material.dart';
import 'package:okta_oidc_example/ui/splash_screen.dart';
import 'package:okta_oidc_example/utils/shared_preference_utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const appBarColor = Colors.blue;

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
