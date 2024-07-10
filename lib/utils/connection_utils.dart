import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionUtils{
  static Future<bool> checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.first == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult.first == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}