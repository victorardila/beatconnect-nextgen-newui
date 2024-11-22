import 'package:beatconnect_app/imports.dart';

class UserAuthController extends GetxController {
  final UserAuthService _userAuthService = UserAuthService();
  final _response = Rxn<List<dynamic>>();
  final _message = "".obs;
  final Rxn<dynamic> _user = Rxn<dynamic>();
  final _isLoading = false.obs;

  Future<void> login(String email, String password) async {
    _isLoading.value = true;
    try {
      // Llamamos al servicio de autenticación
      _response.value = await _userAuthService.login(email, password);
      await handleLoginResponse(_response.value);
    } catch (e) {
      _handleError(e);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> logout() async {
    _isLoading.value = true;
    try {
      // Llamamos al servicio de logout
      await _userAuthService.logout();
      _message.value = "Sesión cerrada correctamente.";
    } catch (e) {
      _handleError(e);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> createUser(
      String userType, String username, String email, String password,
      [Map<String, dynamic>? profileData]) async {
    _isLoading.value = true;
    try {
      _response.value = await _userAuthService.register(
          userType, username, email, password, profileData);
      await handleUserResponse(_response.value);
    } catch (e) {
      _handleError(e);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> getUser(String id) async {
    _isLoading.value = true;
    try {
      _response.value = await _userAuthService.getUserById(id);
      await handleUserResponse(_response.value);
    } catch (e) {
      _handleError(e);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> getUsers() async {
    _isLoading.value = true;
    try {
      _response.value = await _userAuthService.getAllUsers();
      await handleUserResponse(_response.value);
    } catch (e) {
      _handleError(e);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> deleteUser() async {
    _isLoading.value = true;
    try {
      _response.value = await _userAuthService.deleteUser();
      await handleUserResponse(_response.value);
    } catch (e) {
      _handleError(e);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateUser(String email, String password) async {
    _isLoading.value = true;
    try {
      _response.value = await _userAuthService.updateUser(email, password);
      await handleUserResponse(_response.value);
    } catch (e) {
      _handleError(e);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateProfile(Map<String, dynamic> user) async {
    var uid = user['uid'];
    _isLoading.value = true;
    try {
      _response.value = await _userAuthService.updateProfile(uid, user);
      await handleUserResponse(_response.value);
    } catch (e) {
      _handleError(e);
    } finally {
      _isLoading.value = false;
    }
  }

  // Método para manejar la respuesta del login
  Future<void> handleLoginResponse(List<dynamic>? response) async {
    if (response != null && response[0] != null && response[1] != null) {
      // Verificamos si response[0] es un booleano
      if (response[0] is! bool) {
        _user.value =
            response[0]; // Aquí asumo que response[0] debería ser un User
      }
      _message.value = response[1];
    } else {
      _message.value = response?[1] ?? "Operación fallida. Datos no válidos.";
      _user.value = null;
    }
  }

  Future<void> handleUserResponse(List<dynamic>? response) async {
    if (response != null && response[0] != null && response[1] != null) {
      // Verificamos si response[0] es un booleano
      if (response[0] is! bool) {
        _user.value =
            response[0]; // Aquí asumo que response[0] debería ser un User
      }
      _message.value = response[1];
    } else {
      _message.value = response?[1] ?? "Operación fallida. Datos no válidos.";
      _user.value = null;
    }
  }

  void _handleError(dynamic error) {
    _message.value = error.toString().isNotEmpty
        ? "Error: ${error.toString()}"
        : "An error occurred, please try again.";
  }

  bool get isLoading => _isLoading.value;
  String get userMessage => _message.value;
  dynamic get validUser => _user.value;
}
