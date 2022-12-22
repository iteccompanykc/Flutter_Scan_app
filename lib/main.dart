import 'package:flutter/foundation.dart';
// @dart=2.9
import 'package:flutter/material.dart';
import 'dart:developer';
// ignore: import_of_legacy_library_into_null_safe
import 'loginUser.dart';
import 'main_activity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Itec Scan App';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Future<http.Response> sendDataToServer(String username, String password) async {
    final Map<String, dynamic> data = {
      'login-username': username,
      'login-password': password,
    };
    final http.Response response = await http.post(
      'https://sn.ibitaramo.com/android_access/login',
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: data,
    );
    return response;
  }
  void login(String username, String password) async {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const SimpleDialog(
          children: <Widget>[
            SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ),
            SizedBox(height: 20),
            Text('Loading. Please wait...'),
          ],
        );
      },
    );

    try {
      final http.Response response = await sendDataToServer(username, password);
      log(response.body);
      final userData = json.decode(response.body);
      log("User data: $userData");
      final status = userData['status'];
      // In the login() method
      if (status == 'Success') {
        final user = userData['user'];
        final loggedInUser = LoggedInUser(
            regdate: user['reg_date'],
            fname: user['first_name'],
            lname: user['family_name'],
            email: user['email'],
            role: int.parse(user['role']),
            userId: int.parse(user['Identification']),
            identification: int.parse(user['Identification'])

        );
        //log("loggedInUser:$loggedInUser");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MAinActivity(loggedInUser: loggedInUser),
            ),
          );
        });



      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pop(context); // Dismiss the progress indicator
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(userData['status']),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      Navigator.pop(context); // Dismiss the progress indicator
      showDialog(
        context: context,
        builder: (BuildContext context) {
          log('Error: $e)');
          // print('Error here: ${e.toString()}');
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('An error occurred while logging in '),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'TutorialKart',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Sign in',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',

                ),

              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                //forgot password screen
              },
              child: const Text('Forgot Password',),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () {

                    String username=nameController.text;
                    String password= passwordController.text;
                    if (kDebugMode) {
                      print(username);
                      print(password);
                    }
                    login(
                      username,
                      password,
                    );

                  },
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Does not have account?'),
                TextButton(
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    //signup screen
                  },
                )
              ],
            ),
          ],
        ));
  }
}