import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityProvider extends GetxService {
  final RxBool _isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    _monitorConnection();
  }

  void _monitorConnection() {
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      _isConnected.value =
          results.isNotEmpty && results.first != ConnectivityResult.none;
    });
  }

  bool get isConnected => _isConnected.value;

  Future<bool> checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }
}
