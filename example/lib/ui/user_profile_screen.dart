import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:okta_oidc_example/ui/login_screen.dart';
import 'package:okta_oidc_example/utils/okta_login_utils.dart';
import 'package:okta_oidc_example/utils/shared_preference_utils.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  dynamic userData;
  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              OktaLoginUtils().logout().then((value) {
                if (value ?? false) {
                  prefClear();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                }
              }).catchError((onError) {
                print(onError);
              });
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: userData != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text("Name: ${userData['name']}"),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text("Email: ${userData['preferred_username']}"),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      OktaLoginUtils().getAccessToken();
                    },
                    child: const Text("Get access token"),
                  )
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> getUserProfile() async {
    OktaLoginUtils().getAccessToken().then((value) async {
      var userProfile =
          await OktaLoginUtils().getUserProfile().catchError((onError) {
        print(onError);
      });
      userData = jsonDecode(userProfile);
      print(userData);
      setState(() {});
    });
  }
}
