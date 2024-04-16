import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:nishas_yoga/Views/Admin/admin_view.dart';
import 'package:nishas_yoga/Widget/Loading_Widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'client_register_page.dart';
import '../Schema/User.dart';
import 'inquiry.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Check if user session exists
    checkUserSession();
  }

  Future<void> checkUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool authenticated = prefs.getBool('authenticated') ?? false;
    if (authenticated) {
      String userJson = prefs.getString('user') ?? '';
      if (userJson.isNotEmpty) {
        User user = User.fromJson(json.decode(userJson));
        if (user.userTypeId == 2) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => AdminHomePage(user: user),
            ),
          );
        } else {
          // Redirect to user's home page
          // You need to define this based on your app's logic
          // Example: Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => UserHomePage(user: user))),
        }
      }
    }
  }

  Future<void> authenticateUser() async {
    // Set isLoading to true to show loading indicator
    setState(() {
      _isLoading = true;
    });
    const String url = 'https://app.nishasyoga.com/appAuthenticate.php';
    final String username = usernameController.text.trim();
    final String password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showErrorDialog('Please enter both username and password.');
      return;
    }

    final Map<String, String> body = {
      'username': username,
      'password': password,
    };

    try {
      final response = await http.post(Uri.parse(url), body: json.encode(body));

      if (response.statusCode == 200) {
        final String responseBody = response.body.trim();

        if (responseBody.isNotEmpty) {
          final responseData = json.decode(responseBody);
          if (responseData['success'] == true) {
            final User user = User.fromJson(responseData);
            await saveUserSession(user);
            if (user.userTypeId == 1) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => AdminHomePage(user: user),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error: User not allowed.'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          } else {
            _showErrorDialog('Invalid credentials. Please try again.');
          }
        } else {
          _showErrorDialog('Empty response from the server.');
        }
      } else {
        _showErrorDialog('Server error: ${response.statusCode}');
      }
    } catch (error) {
      _showErrorDialog('Error: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> saveUserSession(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('authenticated', true);
    final String userJson = json.encode(user);
    prefs.setString('user', userJson);
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Authentication Failed'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome Back',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown, // Customize app bar color
      ),
      body: _isLoading
          ? const LoadingWidget()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Image.asset(
                      'assets/images/logo.png',
                      // Replace with your logo asset
                      width: 150,
                      height: 150,
                    ),
                  ),
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const InquiryPage()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text(
                          'Inquiry',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage())),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null // Disable button when isLoading is true
                            : () {
                                authenticateUser();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
