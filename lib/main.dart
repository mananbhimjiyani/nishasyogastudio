import 'package:flutter/material.dart';
import 'package:nishas_yoga/Widget/internet_check.dart';
import '../Views/login_page.dart';
import 'package:nishas_yoga/Widget/Loading_Widget.dart';
import 'package:nishas_yoga/Views/internet_not_connected.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isInternetConnected = false;
  bool isLoading = true;

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // Start loading process
    _startLoadingProcess();
  }

  // Function to start the loading process
  void _startLoadingProcess() async {
    // Set loading to true
    setState(() {
      isLoading = true;
    });

    // Check internet connection
    await checkInternetConnection((bool isConnected) {
      setState(() {
        isInternetConnected = isConnected;
        isLoading = false;
        if (isConnected) {
          _navigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(
              builder: (_) => const LoginPage(),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey, // Set navigatorKey
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Colors.black,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.brown),
          ),
        ),
      ),
      title: 'Nisha\'s Yoga Studio',
      home: isLoading
          ? const LoadingWidget() // Show loading widget while checking internet
          : isInternetConnected
              ? const LoginPage() // Show login page if internet connected
              : InternetNotConnectedWidget(), // Show not connected page if no internet
    );
  }
}
