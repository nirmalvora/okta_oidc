import 'package:flutter/material.dart';
import 'package:okta_oidc_example/constants/preference_key_constants.dart';
import 'package:okta_oidc_example/ui/user_profile_screen.dart';
import 'package:okta_oidc_example/utils/okta_login_utils.dart';
import 'package:okta_oidc_example/utils/shared_preference_utils.dart';

import '../model/login_response_model/okta_login_response_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            OktaLoginUtils().login().then((value) {
              OktaLoginResponse loginResponse =
                  OktaLoginResponse.fromJson(value!);
              if (loginResponse.status ?? false) {
                setBool(SharedPrefConst.isLogin, true);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserProfileScreen(),
                  ),
                );
              } else {
                print(loginResponse.message);
              }
            }).catchError((onError) {
              print(onError);
            });
          },
          child: const Text("Login with okta"),
        ),
      ),
    );
  }
}
