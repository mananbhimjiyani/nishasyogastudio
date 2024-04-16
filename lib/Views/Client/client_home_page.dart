import 'package:flutter/material.dart';
import 'package:nishas_yoga/Widget/app_drawer.dart';
import '../../Schema/User.dart';

class ClientHomePage extends StatelessWidget {
  final User user;
  const ClientHomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ClientNavBar(user: user),
      appBar: AppBar(
          title: const Text('Home Page', style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.brown
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Welcome to Nisha's Yoga Studio"),
          ],
        ),
      ),
    );
  }
}