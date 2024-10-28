import 'package:beatconnect_app/ui/auth/modules/signup_view.dart';
import 'package:beatconnect_app/ui/auth/modules/sigin_view.dart';
import 'package:beatconnect_app/ui/widgets/logotype.dart';
import 'package:flutter/material.dart';

class AuthenticationView extends StatefulWidget {
  const AuthenticationView({super.key});

  @override
  State<AuthenticationView> createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Escuchar cambios en el índice del TabController
    _tabController.addListener(() {
      setState(() {}); // Actualiza el estado cuando se cambia de pestaña
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xFF262626), // Color de fondo
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: ClipRRect(
        child: Column(
          children: [
            // TabBar para el cambio de vista
            TabBar(
              controller: _tabController,
              labelColor: Color(0xFF6BA5F2),
              unselectedLabelColor: Colors.white,
              indicatorColor: Color(0xFF6BA5F2), // Color de la línea inferior
              indicatorWeight: 3, // Grosor de la línea inferior
              dividerHeight: 0,
              dividerColor: Colors.transparent,
              tabs: [
                Tab(
                  child: LogoType(
                    text: 'Iniciar sesión',
                    color: _tabController.index == 0
                        ? Color(0xFF6BA5F2)
                        : Colors.white,
                    fontSize: 15,
                  ),
                ),
                Tab(
                  child: LogoType(
                    text: 'Regístrame',
                    color: _tabController.index == 1
                        ? Color(0xFF6BA5F2)
                        : Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            // Vista de inicio de sesión o registro
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: SigninView(), // Vista de inicio de sesión
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: SignupView(), // Vista de registro
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
