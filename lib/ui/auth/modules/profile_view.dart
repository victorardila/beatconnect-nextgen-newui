import 'package:beatconnect_app/ui/widgets/logotype.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileView extends StatefulWidget {
  final VoidCallback onClose; // Callback para cerrar la vista
  const ProfileView({super.key, required this.onClose});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF262626),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Cambiado para ajustar la altura
              children: [
                IconButton(
                  onPressed:
                      widget.onClose, // Llama al callback para cerrar la vista
                  icon: Icon(
                    FontAwesomeIcons.caretDown,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                Container(
                  // Eliminada la altura fija y sustituida por un margen
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: LogoType(
                            text: 'Crear Perfil',
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.height * 0.04,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
