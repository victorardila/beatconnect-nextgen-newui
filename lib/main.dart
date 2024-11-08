import 'dart:async';
import 'package:beatconnect_app/ui/root/views/error_view.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:beatconnect_app/ui/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/foundation.dart'; // Importa esta librería
import 'firebase_options.dart';

void main() async {
  runZonedGuarded(
    () async {
      // Inicializa GetStorage
      await GetStorage.init();

      // Asegura que los widgets estén inicializados
      WidgetsFlutterBinding.ensureInitialized();

      // Inicializa Firebase
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Activa Firebase App Check
      if (kReleaseMode) {
        await FirebaseAppCheck.instance.activate(
          androidProvider: AndroidProvider.playIntegrity,
        );
      } else {
        await FirebaseAppCheck.instance.activate(
          androidProvider: AndroidProvider.debug,
        );
      }

      // Inicializa la localización para fechas
      initializeDateFormatting('es');
      timeago.setLocaleMessages('es', timeago.EsMessages());

      // Configura el estilo de la barra de estado
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

      // Inicia la aplicación
      runApp(const App());
    },
    (error, stackTrace) {
      // Definir el mensaje que se mostrará al usuario según el tipo de error
      String userMessage = "Algo salió mal. Por favor, intenta de nuevo.";

      // Ejemplo: Manejo específico de errores
      if (error.toString().contains("Firebase")) {
        userMessage =
            "Hubo un problema con la conexión a los servicios. Intenta más tarde.";
      } else if (error.toString().contains("Network")) {
        userMessage = "Error de conexión. Verifica tu conexión a internet.";
      }

      // Inicia la aplicación mostrando un mensaje de error amigable
      runApp(MaterialApp(
        debugShowCheckedModeBanner: false, // Desactiva el banner de depuración
        home: ErrorView(
            message: userMessage), // Muestra un mensaje claro al usuario
      ));

      // Enviar el error a Firebase Crashlytics para análisis
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    },
  );
}
