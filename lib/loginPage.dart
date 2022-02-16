//@dart=2.9
import 'package:fiberly/homePage.dart';
import 'package:fiberly/main.dart';
import 'package:fiberly/userDetails.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController unController = TextEditingController();
TextEditingController pwdController = TextEditingController();

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String userName;
  String password;

  List userDetails = ["daniel", "123456789"];

  loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    userName = unController.text.toString();
    password = pwdController.text.toString();
    prefs.setString("username", userName);
    prefs.setString("password", password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Fiberly",
              style:
                  TextStyle(fontSize: 40, color: Colors.green.withOpacity(0.8)),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: unController,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_outlined),
                  labelText: "Username"),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: pwdController,
              obscureText: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                labelText: "Password",
              ),
            ),
            const SizedBox(height: 30),
            MaterialButton(
              onPressed: () async {
                if (unController.text.toString() == userDetails[0] &&
                    pwdController.text.toString() == userDetails[1]) {
                  loadPrefs();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => HomePage(
                      userDetails: UserDetails(userName, password),
                    ),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Invalid Username or Password"),
                    backgroundColor: Colors.red,
                  ));
                }
              },
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.green.withOpacity(0.8),
            )
          ],
        ),
      ),
    );
  }
}
