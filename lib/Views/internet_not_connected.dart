import 'package:flutter/material.dart';

class InternetNotConnectedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off,
              size: 64,
              color: Colors.red,
            ),
            SizedBox(height: 16),
            Text(
              'No internet connection',
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
            SizedBox(height: 8),
            Text(
              'Please check your internet connection and try again.',
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: () {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       const SnackBar(
            //         content: Text('Retrying...'),
            //         duration: Duration(seconds: 2), // Adjust duration as needed
            //       ),
            //     );
            //     // Implement retry logic here
            //   },
            //   style: ButtonStyle(
            //     foregroundColor: MaterialStateProperty.all(Colors.white),
            //   ),
            //   child: Text('Retry'),
            // ),
          ],
        ),
      ),
    );
  }
}
