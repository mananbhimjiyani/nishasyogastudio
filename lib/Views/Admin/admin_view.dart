import 'package:flutter/material.dart';
import 'package:nishas_yoga/Widget/app_drawer.dart';
import '../../Schema/User.dart';

class AdminHomePage extends StatelessWidget {
  final User user;

  const AdminHomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ClientNavBar(user: user),
      appBar: AppBar(
          title: const Text(
            'Admin Home Page',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.brown),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text("Welcome to Nisha's Yoga Studio")],
        ),
      ),
    );
  }
}
