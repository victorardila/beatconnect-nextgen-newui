import 'package:beatconnect_app/ui/auth/modules/forgotpassword_view.dart';
import 'package:beatconnect_app/ui/auth/modules/signup_view.dart';
import 'package:beatconnect_app/ui/auth/modules/sigin_view.dart';
import 'package:beatconnect_app/ui/auth/modules/profile_view.dart';
import 'package:beatconnect_app/ui/widgets/animated_container_widget.dart';
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
  bool _isProfileViewVisible = false;
  bool _isForgotPasswordVisible = false;

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
      _isProfileViewVisible = true;
      _isForgotPasswordVisible = false; // Asegúrate de ocultar la otra vista
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
        gradient: LinearGradient(
          colors: [
            Color(0xFF262626),
            Color(0xFF1F1F1F),
            Color(0xFF1A1A1A),
            Color(0xFF141414),
            Color(0xFF101010),
            Color(0xFF0C0C0C),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
              TabBar(
                controller: _tabController,
                labelColor: Color(0xFF6BA5F2),
                unselectedLabelColor: Colors.white,
                indicatorColor: Color(0xFF6BA5F2),
                indicatorWeight: 3,
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
