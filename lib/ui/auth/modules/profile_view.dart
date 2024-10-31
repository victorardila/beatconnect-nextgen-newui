import 'package:beatconnect_app/ui/widgets/animated_textfield.dart';
import 'package:beatconnect_app/ui/widgets/logotype.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileView extends StatefulWidget {
  final VoidCallback onClose;
  ProfileView({super.key, required this.onClose});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  TextEditingController name = TextEditingController();
  TextEditingController lastname = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode lastnameFocusNode = FocusNode();
  bool isPressedAvatar = false;
  bool isPressedCamera = false;
  String? avatarImagePath; // Para la imagen de perfil
  String? coverImagePath; // Para la imagen de portada

  Future<void> _pickAvatarImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        avatarImagePath = pickedFile.path;
        print("Avatar image path: $avatarImagePath"); // Debug log
      });
    } else {
      print("No avatar image selected."); // Debug log
    }
  }

  Future<void> _pickCoverImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        coverImagePath = pickedFile.path;
        print("Cover image path: $coverImagePath"); // Debug log
      });
    } else {
      print("No cover image selected."); // Debug log
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    name.dispose();
    lastname.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF262626),
      body: LayoutBuilder(
        builder: (context, raints) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: widget.onClose,
                    icon: Icon(
                      FontAwesomeIcons.caretDown,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: LogoType(
                        text: 'Crear Perfil',
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.height * 0.04,
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, .2),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        if (coverImagePath != null)
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(File(
                                    coverImagePath!)), // Cambia a FileImage
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                          ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: FadeTransition(
                            opacity: _animationController,
                            child: Text(
                              'Portada',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                        // Imagen del perfil
                        Positioned(
                          left: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTapDown: (_) {
                              setState(() {
                                isPressedAvatar = true;
                              });
                            },
                            onTapUp: (_) {
                              setState(() {
                                isPressedAvatar = false;
                              });
                            },
                            onTapCancel: () {
                              setState(() {
                                isPressedAvatar = false;
                              });
                            },
                            onTap:
                                _pickAvatarImage, // Cambia a _pickAvatarImage
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Contenedor que envuelve el CircleAvatar
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors
                                        .white, // Color de fondo del borde
                                    boxShadow: [
                                      BoxShadow(
                                        color: isPressedAvatar
                                            ? Color.fromRGBO(0, 0, 0,
                                                0.7) // Aumenta la opacidad de la sombra
                                            : Color.fromRGBO(0, 0, 0,
                                                0.3), // Aumenta la opacidad de la sombra
                                        blurRadius:
                                            12.0, // Aumenta el radio de difuminado
                                        spreadRadius:
                                            4.0, // Aumenta el tamaño de la sombra
                                        offset: Offset(0,
                                            4), // Aumenta la dirección de la sombra
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Color.fromRGBO(158, 158, 158, .2)
                                          .withOpacity(0.5), // Color del borde
                                      width: 1.0, // Ancho del borde
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: MediaQuery.of(context).size.height *
                                        0.09,
                                    backgroundImage: avatarImagePath != null
                                        ? FileImage(File(avatarImagePath!))
                                        : AssetImage('assets/img/user.png')
                                            as ImageProvider,
                                  ),
                                ),
                                Positioned(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors
                                          .transparent, // Asegúrate de establecer un color de fondo
                                      shape: BoxShape.circle,
                                    ),
                                    padding: EdgeInsets.all(6),
                                    child: Icon(
                                      FontAwesomeIcons.camera,
                                      color: isPressedAvatar
                                          ? Color.fromRGBO(255, 255, 255, .8)
                                          : Color.fromARGB(102, 252, 227, 227),
                                      size: 26,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //Imagen de portada
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: GestureDetector(
                            onTapDown: (_) {
                              setState(() {
                                isPressedCamera = true;
                              });
                            },
                            onTapUp: (_) {
                              setState(() {
                                isPressedCamera = false;
                              });
                            },
                            onTapCancel: () {
                              setState(() {
                                isPressedCamera = false;
                              });
                            },
                            onTap: _pickCoverImage, // Cambia a _pickCoverImage
                            child: Container(
                              decoration: BoxDecoration(
                                color: isPressedCamera
                                    ? Color.fromRGBO(0, 0, 0, .8)
                                    : Color.fromRGBO(0, 0, 0, .3),
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(6),
                              child: Icon(
                                FontAwesomeIcons.camera,
                                color: isPressedCamera
                                    ? Color.fromRGBO(255, 255, 255, .6)
                                    : Color.fromRGBO(255, 255, 255, .4),
                                size: 26,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          'Más información sobre tu perfil',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        AnimatedTextField(
                          controller: name,
                          labelText: 'Nombres',
                          prefixIcon: Icons.person,
                          isFocused: nameFocusNode.hasFocus,
                          onFocusChange: (hasFocus) {
                            setState(() {});
                          },
                        ),
                        SizedBox(height: 10),
                        AnimatedTextField(
                          controller: lastname,
                          labelText: 'Apellidos',
                          prefixIcon: Icons.person,
                          isFocused: lastnameFocusNode.hasFocus,
                          onFocusChange: (hasFocus) {
                            setState(() {});
                          },
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
