import 'package:flutter/material.dart';
import 'package:okta_oidc_example/constants/preference_key_constants.dart';
import 'package:okta_oidc_example/ui/login_screen.dart';
import 'package:okta_oidc_example/ui/user_profile_screen.dart';
import 'package:okta_oidc_example/utils/shared_preference_utils.dart';

import '../utils/okta_login_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initialMethod();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: FlutterLogo(
        size: 100,
      )),
    );
  }

  Future<void> initialMethod() async {
    bool? isInitialize =
        await OktaLoginUtils().initOkta().catchError((onError) {
      print(onError);
    });
    await Future.delayed(const Duration(seconds: 2));
    navigateToLogin();
  }

  void navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => getBool(SharedPrefConst.isLogin, false)
            ? const UserProfileScreen()
            : const LoginScreen(),
      ),
    );
  }
}
