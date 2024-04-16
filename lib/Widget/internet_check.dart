import 'dart:async';
import 'package:connectivity/connectivity.dart';

typedef InternetConnectionCallback = void Function(bool isConnected);

Future<void> checkInternetConnection(InternetConnectionCallback callback) async {
  try {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      callback(true); // Internet is connected
    } else {
      callback(false); // Internet is not connected
    }
  } catch (error) {
    callback(false); // Error occurred, internet is not connected
  }
}
