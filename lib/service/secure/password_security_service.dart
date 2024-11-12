import 'dart:math';
import 'dart:typed_data';
import 'package:argon2/argon2.dart';
import 'package:convert/convert.dart'; // Agrega esta línea

class PasswordSecurityService {
  // Generar una sal aleatoria única para cada usuario
  static String generateSalt() {
    final random = Random.secure();
    final salt = List<int>.generate(16, (_) => random.nextInt(256));
    return hex.encode(
        salt); // Convierte la sal a una cadena hexadecimal usando hex.encode()
  }

  // Método para cifrar la contraseña usando Argon2 con una sal aleatoria
  static Future<String> encryptPassword(String password, String salt) async {
    var saltBytes = salt.toBytesLatin1();
    var parameters = Argon2Parameters(
      Argon2Parameters.ARGON2_i,
      saltBytes,
      version: Argon2Parameters.ARGON2_VERSION_10,
      iterations: 2,
      memoryPowerOf2: 16,
    );
    var argon2 = Argon2BytesGenerator();
    argon2.init(parameters);
    var passwordBytes = parameters.converter.convert(password);
    var result = Uint8List(32);
    argon2.generateBytes(passwordBytes, result, 0, result.length);
    var resultHex = result.toHexString();
    return resultHex;
  }

  // Método para verificar la contraseña ingresada con el hash almacenado
  static Future<bool> verifyPassword(
      String inputPassword, String storedHash, String salt) async {
    var saltBytes = salt.toBytesLatin1();

    var parameters = Argon2Parameters(
      Argon2Parameters.ARGON2_i,
      saltBytes,
      version: Argon2Parameters.ARGON2_VERSION_10,
      iterations: 2,
      memoryPowerOf2: 16,
    );

    var argon2 = Argon2BytesGenerator();
    argon2.init(parameters);

    var passwordBytes = parameters.converter.convert(inputPassword);
    var result = Uint8List(32);
    argon2.generateBytes(passwordBytes, result, 0, result.length);
    var resultHex = result.toHexString();

    return resultHex == storedHash;
  }
}
