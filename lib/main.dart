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

void main() async {
  runZonedGuarded(
    () async {
      // Inicializa GetStorage
      await GetStorage.init();

      // Asegura que los widgets estén inicializados
      WidgetsFlutterBinding.ensureInitialized();

      // Inicializa Firebase
      await Firebase.initializeApp(
          // Puedes especificar opciones aquí si es necesario
          );

      // Activa Firebase App Check
      await FirebaseAppCheck.instance.activate(
        androidProvider:
            AndroidProvider.debug, // Cambia a producción en la app final
      );

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
      // Manejo de excepciones globales Enviar el error a Firebase Crashlytics
      // Cargar la vista de error
      runApp(MaterialApp(
        home: ErrorView(message: 'Ocurrió un error inesperado.'),
      ));
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    },
  );
}
