import 'package:beatconnect_app/ui/auth/modules/forgotpassword_view.dart';
import 'package:beatconnect_app/ui/auth/modules/signup_view.dart';
import 'package:beatconnect_app/ui/auth/modules/sigin_view.dart';
import 'package:beatconnect_app/ui/auth/modules/profile_view.dart';
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
  bool _isProfileViewVisible = false; // Estado para mostrar ProfileView
  bool _isForgotPasswordVisible =
      false; // Estado para mostrar ForgotPasswordView

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showProfileView() {
    setState(() {
      _isProfileViewVisible =
          true; // Cambiar el estado para mostrar ProfileView
    });
  }

  void _hideProfileView() {
    setState(() {
      _isProfileViewVisible =
          false; // Cambiar el estado para ocultar ProfileView
    });
  }

  void _showForgotPasswordView() {
    setState(() {
      _isForgotPasswordVisible = true; // Mostrar ForgotPasswordView
    });
  }

  void _hideForgotPasswordView() {
    setState(() {
      _isForgotPasswordVisible = false; // Ocultar ForgotPasswordView
    });
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
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: Column(
          children: [
            // Solo muestra el TabBar si no se está mostrando ninguna de las vistas especiales
            if (!_isProfileViewVisible && !_isForgotPasswordVisible)
              TabBar(
                controller: _tabController,
                labelColor: Color(0xFF6BA5F2),
                unselectedLabelColor: Colors.white,
                indicatorColor: Color(0xFF6BA5F2),
                indicatorWeight: 3,
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
                      text: 'Regístrarme',
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
              child: Stack(
                children: [
                  TabBarView(
                    controller: _tabController,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: SigninView(
                          onForgotPassword: _showForgotPasswordView,
                        ), // Vista de inicio de sesión
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: SignupView(
                          onSignupSuccess: _showProfileView,
                        ), // Vista de registro
                      ),
                    ],
                  ),
                  if (_isForgotPasswordVisible) // Mostrar ForgotPasswordView si es visible
                    ForgotPasswordView(
                      onClose:
                          _hideForgotPasswordView, // Callback para cerrar ForgotPasswordView
                    ),
                  if (_isProfileViewVisible) // Mostrar ProfileView si es visible
                    ProfileView(
                        // onClose:
                        //     _hideProfileView, // Callback para cerrar ProfileView
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
