import 'package:beatconnect_nextgen_newui/imports.dart';
import 'package:timeago/timeago.dart' as timeago;

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
      await Hive.initFlutter();
      await Hive.openBox('sesion');

      // Registro de controladores
      Get.lazyPut<UserAuthController>(() => UserAuthController());
      // Registro de proveedores
      Get.put(ConnectivityProvider()); // Registra ConnectivityService aquí

      runApp(
        ChangeNotifierProvider(
          create: (_) => errorProvider,
          child: const App(),
        ),
      );

      // Cerrar las cajas al terminar la aplicación.
      WidgetsBinding.instance.addObserver(
        LifecycleEventHandler(onAppExit: () async {
          await Hive.close();
        }),
      );
    },
    (error, stackTrace) {
      final userMessage = getErrorMessage(error);

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

class LifecycleEventHandler extends WidgetsBindingObserver {
  final Future<void> Function()? onAppExit;

  LifecycleEventHandler({this.onAppExit});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      onAppExit?.call();
    }
  }
}
