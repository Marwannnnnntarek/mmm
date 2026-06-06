import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  const ConnectivityService();

  Future<bool> isConnected() async {
    final result = await Connectivity().checkConnectivity();
    return result.isNotEmpty &&
        !result.contains(ConnectivityResult.none);
  }
}
