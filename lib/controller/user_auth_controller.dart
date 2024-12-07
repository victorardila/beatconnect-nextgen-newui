import 'package:beatconnect_nextgen_newui/imports.dart';

class UserAuthController extends GetxController {
  final UserAuthService _userAuthService = UserAuthService();
  final ConnectivityProvider _connectivityService =
      Get.find<ConnectivityProvider>(); // Corregido
  final _response = Rxn<List<dynamic>>();
  final _message = "".obs;
  final Rxn<dynamic> _user = Rxn<dynamic>();
  final _isLoading = false.obs;

  Future<void> login(String email, String password) async =>
      _executeWithConnectionCheck(
          () async => await _userAuthService.login(email, password));

  Future<void> logout() async =>
      _executeWithConnectionCheck(() async => await _userAuthService.logout());

  Future<void> createUser(
          String userType, String username, String email, String password,
          [Map<String, dynamic>? profileData]) async =>
      _executeWithConnectionCheck(() async => await _userAuthService.register(
          userType, username, email, password, profileData));

  Future<void> getUser(String id) async => _executeWithConnectionCheck(
      () async => await _userAuthService.getUserById(id));

  Future<void> getUsers() async => _executeWithConnectionCheck(
      () async => await _userAuthService.getAllUsers());

  Future<void> deleteUser() async => _executeWithConnectionCheck(
      () async => await _userAuthService.deleteUser()); // Refactorizado

  Future<void> updateUser(String email, String password) async =>
      _executeWithConnectionCheck(() async =>
          await _userAuthService.updateUser(email, password)); // Refactorizado

  Future<void> updateProfile(Map<String, dynamic> user) async {
    var uid = user['uid'];
    return _executeWithConnectionCheck(() async =>
        await _userAuthService.updateProfile(uid, user)); // Refactorizado
  }

  Future<void> _executeWithConnectionCheck(
      Future<List<dynamic>> Function() action) async {
    _isLoading.value = true;
    if (await _connectivityService.checkConnection()) {
      try {
        _response.value = await action();
        handleUserResponse(_response.value);
      } catch (e) {
        _handleError(e);
      }
    } else {
      _message.value = "No hay conexión a Internet.";
    }
    _isLoading.value =
        false; // Asegúrate que isLoading se pone en false, incluso si hay error
  }

  // Método para manejar la respuesta del login
  Future<void> handleLoginResponse(List<dynamic>? response) async {
    if (response != null &&
        response.length >= 2 &&
        response[0] != null &&
        response[1] != null) {
      if (response[0] is! bool) {
        _user.value = response[0];
      }
      _message.value = response[1];
    } else {
      _message.value = response?[1] ?? "Operación fallida. Datos no válidos.";
      _user.value = null;
    }
  }

  Future<void> handleUserResponse(List<dynamic>? response) async {
    if (response != null &&
        response.length >= 2 &&
        response[0] != null &&
        response[1] != null) {
      if (response[0] is! bool) {
        _user.value = response[0];
      }
      _message.value = response[1];
    } else {
      _message.value = response?[1] ?? "Operación fallida. Datos no válidos.";
      _user.value = null;
    }
  }

  void _handleError(dynamic error) {
    // Aquí puedes mejorar el manejo de errores como se sugirió anteriormente.
    _message.value = error.toString().isNotEmpty
        ? "Error: ${error.toString()}"
        : "An error occurred, please try again.";
  }

  bool get isLoading => _isLoading.value;
  String get userMessage => _message.value;
  dynamic get validUser => _user.value;
}
