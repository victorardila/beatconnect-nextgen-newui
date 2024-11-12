import 'dart:async';
import 'package:beatconnect_app/provider/error_provider.dart';
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
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

Future<void> initializeApp() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kReleaseMode) {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
    );
  } else {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
    );
  }

  initializeDateFormatting('es');
  timeago.setLocaleMessages('es', timeago.EsMessages());

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
}

String getErrorMessage(dynamic error) {
  if (error.toString().contains("Firebase")) {
    return "Hubo un problema con la conexión a los servicios. Intenta más tarde.";
  } else if (error.toString().contains("Network")) {
    return "Error de conexión. Verifica tu conexión a internet.";
  } else {
    return "Algo salió mal. Por favor, intenta de nuevo.";
  }
}

void main() {
  final errorProvider = ErrorProvider();

  runZonedGuarded(
    () async {
      await initializeApp();

      runApp(
        ChangeNotifierProvider(
          create: (_) => errorProvider,
          child: const App(),
        ),
      );
    },
    (error, stackTrace) {
      final userMessage =
          getErrorMessage(error); // Usar la función para obtener el mensaje

      errorProvider.setErrorMessage(userMessage);

      runApp(
        ChangeNotifierProvider.value(
          value: errorProvider,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: ErrorView(message: userMessage),
          ),
        ),
      );

      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    },
  );
}
