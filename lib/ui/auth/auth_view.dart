import 'package:beatconnect_app/ui/auth/modules/forgotpassword_view.dart';
import 'package:beatconnect_app/ui/auth/modules/signup_view.dart';
import 'package:beatconnect_app/ui/auth/modules/sigin_view.dart';
import 'package:beatconnect_app/ui/auth/modules/profile_view.dart';
import 'package:beatconnect_app/imports.dart';

class AuthenticationView extends StatefulWidget {
  const AuthenticationView({super.key});

  @override
  State<AuthenticationView> createState() => _AuthenticationViewState();
}

class _AuthenticationViewState extends State<AuthenticationView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isProfileViewVisible = false;
  bool _isForgotPasswordVisible = false;
  bool isCompany = false; // Variable para almacenar si es negocio

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

  void _showProfileView(bool isCompany) {
    setState(() {
      _isProfileViewVisible = true;
      _isForgotPasswordVisible = false;
      this.isCompany = isCompany; // Asigna el valor
    });
  }

  void _hideProfileView() {
    setState(() {
      _isProfileViewVisible = false;
    });
  }

  void _showForgotPasswordView() {
    setState(() {
      _isForgotPasswordVisible = true;
      _isProfileViewVisible = false; // Asegúrate de ocultar la otra vista
    });
  }

  void _hideForgotPasswordView() {
    setState(() {
      _isForgotPasswordVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: backgroundGradientDark(1),
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
            if (!_isProfileViewVisible && !_isForgotPasswordVisible)
              Stack(
                children: [
                  TabBar(
                    controller: _tabController,
                    labelColor: colorApp,
                    unselectedLabelColor: letterColor,
                    indicatorColor:
                        colorApp, // Oculta el indicador predeterminado
                    indicatorWeight: 3,
                    tabs: [
                      Tab(
                        child: LogoType(
                          text: 'Iniciar sesión',
                          color: _tabController.index == 0
                              ? colorApp
                              : letterColor,
                          fontSize: 15,
                        ),
                      ),
                      Tab(
                        child: LogoType(
                          text: 'Regístrarme',
                          color: _tabController.index == 1
                              ? colorApp
                              : letterColor,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0, // Coloca el gradiente en la parte inferior
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 1.0, // Altura del indicador
                      decoration: BoxDecoration(gradient: gradientApp),
                    ),
                  ),
                ],
              ),
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
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: SignupView(
                          onSignupSuccess: _showProfileView,
                        ),
                      ),
                    ],
                  ),
                  AnimatedContainerWidget(
                    child: ForgotPasswordView(
                      onClose: _hideForgotPasswordView,
                    ),
                    isVisible: _isForgotPasswordVisible,
                  ),
                  AnimatedContainerWidget(
                    child: ProfileView(
                      onClose: _hideProfileView,
                      isCompany: isCompany, // Pasa el valor a ProfileView
                    ),
                    isVisible: _isProfileViewVisible,
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
