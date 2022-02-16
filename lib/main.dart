//@dart=2.9
import 'dart:ffi';

import 'package:fiberly/homePage.dart';
import 'package:fiberly/loginPage.dart';
import 'package:fiberly/userDetails.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userName = prefs.getString('username');
  String password = prefs.getString('password');
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: userName != null
        ? HomePage(userDetails: UserDetails(userName, password))
        : const LoginPage(),
  ));
}
