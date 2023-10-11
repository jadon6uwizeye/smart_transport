// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:app/presentation/views/locations.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Login Screen'),
        ),
        body: LoginScreen(),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void handleLogin() async {
    if (usernameController.text == "" || passwordController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            const Expanded(
              child: Text(
                " Please enter all information ",
                style: TextStyle(color: Colors.white),
              ),
            ),
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 4, 37, 99),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        duration: const Duration(seconds: 3),
      ));
    } else {
      try {
        print("\n\n\n\n\nSending request");
        // send to backend endpoint
        var resp = await http
            .post(Uri.parse('http://localhost:8001/accounts/login/'), body: {
          'username': usernameController.text,
          'password': passwordController.text
        });
        print(resp.body);
        var json_resp = json.decode(resp.body);
        if (resp.statusCode == 200) {
          // save toke shared preferences
          var prefs = await SharedPreferences.getInstance();
          prefs.setString('token', json_resp['access']);
          prefs.setString('username', usernameController.text);
          // navigate to map
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LocationMap(
                locations: [],
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(
              children: [
                Expanded(
                  child: Text(
                    json_resp['detail'].toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Color.fromARGB(255, 80, 21, 17),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            duration: const Duration(seconds: 3),
          ));
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              Expanded(
                child: Text(
                  "Error while trying to login ${e}",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Color.fromARGB(255, 80, 21, 17),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          duration: const Duration(seconds: 3),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 241, 243),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 10),
                const Text(
                  'Ticket Tracking App',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.email),
                    // border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: passwordController,
                  obscureText: true, // For password input
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  // change color
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 4, 37, 99),
                    minimumSize: Size(130, 60),
                    // add border radius
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    handleLogin();
                  },
                  child: const Text('Login'),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
