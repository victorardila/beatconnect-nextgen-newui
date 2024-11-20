import 'package:beatconnect_app/ui/auth/auth_view.dart';
import 'package:beatconnect_app/ui/intro/intro_view.dart';
import 'package:beatconnect_app/ui/root/root_view.dart';
import 'package:beatconnect_app/ui/root/views/error_view.dart';
import 'package:beatconnect_app/imports.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beatconnect App',
      theme: ThemeData.dark(),
      initialRoute: '/',
      getPages: [
        GetPage(name: "/", page: () => IntroView()),
        GetPage(name: "/auth", page: () => AuthenticationView()),
        GetPage(name: "/root", page: () => RootView()),
        GetPage(name: "/error", page: () => ErrorView(message: Get.arguments)),
      ],
    );
  }
}
