import 'package:beatconnect_app/ui/widgets/item_tag.dart';
import 'package:beatconnect_app/ui/widgets/animated_dropdown.dart';
import 'package:beatconnect_app/ui/widgets/animated_textfield.dart';
import 'package:beatconnect_app/ui/widgets/button_gradient.dart';
import 'package:beatconnect_app/ui/widgets/logo_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';

class MusicalStyle {
  final int id;
  final String name;
  final String description;

  MusicalStyle({
    required this.id,
    required this.name,
    required this.description,
  });

  factory MusicalStyle.fromJson(Map<String, dynamic> json) {
    return MusicalStyle(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}

class ProfileView extends StatefulWidget {
  final VoidCallback onClose;
  ProfileView({super.key, required this.onClose});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late ScrollController _scrollController;

  TextEditingController name = TextEditingController();
  TextEditingController lastname = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode lastnameFocusNode = FocusNode();
  bool isPressedAvatar = false;
  bool isPressedCamera = false;
  bool isDropdownItemSelected = false;

  String? avatarImagePath; // Para la imagen de perfil
  String? coverImagePath; // Para la imagen de portada

  MusicalStyle? selectedMusicalStyle;
  List<MusicalStyle> musicalStyles = [];
  List<MusicalStyle> selectedStyles = []; // Lista de estilos seleccionados

  double _scrollOffset = 0; // Para rastrear el desplazamiento

  Future<void> loadMusicalStyles() async {
    try {
      final String response =
          await rootBundle.loadString('assets/json/musical_styles.json');
      final Map<String, dynamic> data = json.decode(response);

      setState(() {
        musicalStyles = (data['musical_styles'] as List)
            .map((style) => MusicalStyle.fromJson(style))
            .toList();

        if (musicalStyles.isNotEmpty) {
          selectedMusicalStyle = musicalStyles.first;
        }
      });
    } catch (e) {
      print("Error loading musical styles: $e");
    }
  }

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
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });

    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    loadMusicalStyles(); // Cargar los estilos musicales
  }

  @override
  void dispose() {
    _animationController.dispose();
    name.dispose();
    lastname.dispose();
    nameFocusNode.dispose();
    lastnameFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF262626),
      body: Stack(
        children: [
          // Contenido desplazable
          SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                                image: FileImage(File(coverImagePath!)),
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
                            onTap: _pickAvatarImage,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: isPressedAvatar
                                            ? Color.fromRGBO(0, 0, 0, 0.7)
                                            : Color.fromRGBO(0, 0, 0, 0.3),
                                        blurRadius: 12.0,
                                        spreadRadius: 4.0,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Color.fromRGBO(158, 158, 158, .2)
                                          .withOpacity(0.5),
                                      width: 1.0,
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
                                      color: isPressedAvatar
                                          ? const Color.fromRGBO(0, 0, 0, 0.08)
                                          : Color.fromRGBO(0, 0, 0, 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: EdgeInsets.all(6),
                                    child: Icon(
                                      FontAwesomeIcons.camera,
                                      color: isPressedAvatar
                                          ? Color.fromRGBO(255, 255, 255, .8)
                                          : Color.fromRGBO(0, 0, 0, 0.1),
                                      size: 26,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Imagen de portada
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
                            onTap: _pickCoverImage,
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
                        Text(
                          'Selecciona tu genero musical favorito',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        AnimatedDropdown(
                          hint: 'Seleccione tu estilo musical de preferencia',
                          items: musicalStyles,
                          selectedItem: selectedMusicalStyle,
                          onChanged: (value) {
                            setState(() {
                              selectedMusicalStyle = value;
                              isDropdownItemSelected = true;

                              // Añade el estilo seleccionado si aún no está en la lista
                              if (value != null &&
                                  !selectedStyles.contains(value)) {
                                selectedStyles.add(value);
                              }
                            });
                          },
                          itemLabelBuilder: (style) => style.name,
                        ),
                        if (isDropdownItemSelected)
                          if (isDropdownItemSelected &&
                              selectedStyles.isNotEmpty)
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              height: selectedStyles.isNotEmpty
                                  ? 100
                                  : 0, // Se oculta si está vacío
                              width: double.infinity,
                              margin: EdgeInsets.only(top: 10),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Wrap(
                                          spacing:
                                              8.0, // Espaciado entre los elementos del Wrap
                                          children: selectedStyles.map((style) {
                                            return ItemTag(
                                              text: style.name,
                                              onRemove: () {
                                                setState(() {
                                                  selectedStyles.remove(
                                                      style); // Eliminar estilo al hacer clic
                                                });
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        ButtonGradient(text: 'Crear', onPressed: () {}),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // IconButton con efecto BoxShadow
          Positioned(
            top: 20, // Ajusta la posición vertical según tus necesidades
            right: 20,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: _scrollOffset >
                        5 // Cambia 100 según el desplazamiento deseado
                    ? [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 8.0,
                          spreadRadius: 1.0,
                          offset: Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                onPressed: () {
                  widget.onClose();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
