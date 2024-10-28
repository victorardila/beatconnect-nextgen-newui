import 'package:beatconnect_app/ui/auth/auth_view.dart';
import 'package:beatconnect_app/ui/intro/intro_view.dart';
import 'package:beatconnect_app/ui/root/root_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beactconnect App',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        "/": (context) => IntroView(),
        "/auth": (context) => AuthenticationView(),
        "/root": (context) => RootView(),
      },
    );
  }
}
