import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/Animation.json', // Replace with your animation file path
            width: 350,
            height: 350,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
