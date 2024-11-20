import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:beatconnect_app/imports.dart';

class UserAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<dynamic> response = [null, ""];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<dynamic>> login(String usernameOrEmail, String password) async {
    if (!_isValidInput(usernameOrEmail) || !_isValidPassword(password)) {
      return [null, "Email o contraseña no válidos."];
    }

    try {
      // Intentar obtener el usuario por email o username
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: usernameOrEmail)
          .get();

      if (querySnapshot.docs.isEmpty) {
        querySnapshot = await _firestore
            .collection('users')
            .where('username', isEqualTo: usernameOrEmail)
            .get();
      }

      if (querySnapshot.docs.isEmpty) {
        return [null, "Usuario no encontrado."];
      }

      var userDoc = querySnapshot.docs.first;
      String storedHash = userDoc['password'];
      String salt = userDoc['salt'];

      // Verificar la contraseña ingresada con la almacenada
      bool isPasswordValid = await PasswordSecurityService.verifyPassword(
          password, storedHash, salt);

      if (isPasswordValid) {
        return [userDoc.data(), "Inicio de sesión exitoso."];
      } else {
        return [null, "Contraseña incorrecta."];
      }
    } catch (e) {
      return [null, "Ocurrió un error al intentar iniciar sesión."];
    }
  }

  // Método para cerrar la sesión del usuario (logout)
  Future<List<dynamic>> logout() async {
    try {
      // Cerrar la sesión del usuario
      await _auth.signOut();

      return [true, "Sesión cerrada exitosamente."];
    } catch (e) {
      return [false, "Ocurrió un error al cerrar la sesión."];
    }
  }

  // Método para registrar un nuevo usuario con sal aleatoria
  Future<List<dynamic>> register(String userId, String userType,
      String username, String email, String password) async {
    // Validar email, username y contraseña
    if (!_isValidEmail(email) ||
        !_isValidPassword(password) ||
        !_isValidUsername(username)) {
      return [null, "Email, usuario o contraseña no válidos."];
    }

    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        // Genera una sal aleatoria única
        String salt = PasswordSecurityService.generateSalt();

        // Cifra la contraseña con la sal generada
        String encryptedPassword =
            await PasswordSecurityService.encryptPassword(password, salt);

        // Guarda los datos en Firestore con el hash, la sal y el username
        await _firestore.collection('users').doc(user.uid).set({
          'uid': userId,
          'accountType': userType,
          'username': username,
          'email': email,
          'password': encryptedPassword, // Contraseña cifrada
          'salt': salt, // Almacena la sal
          'createdAt': FieldValue.serverTimestamp(),
        });

        return [user, "Usuario registrado exitosamente en Firestore."];
      } else {
        return [null, "No se pudo obtener la información del usuario."];
      }
    } on FirebaseAuthException catch (e) {
      return [null, _handleFirebaseAuthError(e)];
    } catch (e) {
      return [
        null,
        "Ocurrió un error desconocido. Por favor intenta de nuevo."
      ];
    }
  }

  // Método para consultar todos los usuarios (no se puede hacer directamente con Firebase Auth)
  Future<List<dynamic>> getAllUsers() async {
    // Aquí puedes obtener los usuarios desde Firestore si tienes una colección de usuarios
    List<dynamic> users = [];
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      users = querySnapshot.docs.map((doc) => doc.data()).toList();
      return [users, "Usuarios obtenidos exitosamente."];
    } catch (e) {
      return [null, "No se pudo obtener la lista de usuarios."];
    }
  }

  // Método para consultar un usuario por ID
  Future<List<dynamic>> getUserById(String userId) async {
    try {
      final user = _auth.currentUser;
      if (user?.uid == userId) {
        response = [user, "Usuario encontrado."];
      } else {
        response = [null, "Usuario no encontrado."];
      }
    } catch (e) {
      response = [null, "Ocurrió un error al obtener el usuario."];
    }
    return response;
  }

  // Método para eliminar un usuario
  Future<List<dynamic>> deleteUser() async {
    try {
      final user = _auth.currentUser;
      await user?.delete();
      // Obtener la lista actualizada de usuarios
      return await getAllUsers(); // Llama a getAllUsers para obtener la lista actualizada
    } catch (e) {
      return [null, "No se pudo eliminar el usuario."];
    }
  }

  // Método para actualizar la información del usuario
  Future<List<dynamic>> updateUser(String email, String password) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Actualizar el email y solicitar verificación
        await user.verifyBeforeUpdateEmail(email);

        // Actualizar la contraseña
        await user.updatePassword(password);

        // Obtener el usuario actualizado
        User? updatedUser = _auth.currentUser; // Obtén el usuario actualizado

        return [
          updatedUser,
          "Usuario actualizado exitosamente. Verifica el cambio de correo."
        ];
      } else {
        response = [false, "No hay usuario autenticado."];
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        response = [
          false,
          "Para actualizar el email, debes iniciar sesión nuevamente."
        ];
      } else {
        response = [false, "No se pudo actualizar el usuario."];
      }
    } catch (e) {
      response = [false, "Ocurrió un error al actualizar el usuario."];
    }
    return response;
  }

  // Método para actualizar la información del usuario
  Future<List<dynamic>> updateProfile(
      String uid, Map<String, dynamic> newUser) async {
    try {
      final user = _auth.currentUser;
      if (user != null && user.uid == uid) {
        // Actualiza los datos del usuario en Firestore
        await _firestore.collection('users').doc(uid).update(newUser);

        return [
          newUser, // Retorna el nuevo objeto de usuario
          "Perfil creado exitosamente."
        ];
      } else {
        return [null, "Error ya este perfil existe"];
      }
    } catch (e) {
      return [null, "Ocurrió un error al actualizar el usuario."];
    }
  }

  // Método de validación para el input
  bool _isValidInput(String input) {
    final userRegex = RegExp(r'^[a-zA-Z0-9]+(?:\.[a-zA-Z0-9]+)?$');
    return input.contains('@') || userRegex.hasMatch(input);
  }

  // Validación de email
  bool _isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email);
  }

// Validación de username
  bool _isValidUsername(String username) {
    return username.isNotEmpty && username.length >= 3;
  }

  bool _isValidPassword(String password) {
    return password.length >= 8;
  }

  // Método para manejar errores de Firebase
  String _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return "El correo electrónico ya está en uso.";
      case 'invalid-email':
        return "El correo electrónico es inválido.";
      case 'weak-password':
        return "La contraseña es demasiado débil.";
      default:
        return "Ocurrió un error desconocido. Por favor intenta de nuevo.";
    }
  }
}
