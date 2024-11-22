import 'package:beatconnect_app/imports.dart';

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
  final bool isCompany; // Nuevo parámetroy
  ProfileView({super.key, required this.onClose, this.isCompany = false});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  final UserAuthController _userAuthC = Get.find<UserAuthController>();
  late AnimationController _animationController;
  late ScrollController _scrollController;
  var user;

  TextEditingController name = TextEditingController();
  TextEditingController lastname = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode lastnameFocusNode = FocusNode();
  bool isPressedAvatar = false;
  bool isPressedCamera = false;
  bool isDropdownItemSelected = false;

  String? avatarImagePath; // Para la imagen de perfil
  String? coverImagePath; // Para la imagen de portada
  String? selectedEmoji; // Agrega el estado para el emoji

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

  void onEmojiSelected(String emoji) {
    setState(() {
      selectedEmoji = emoji; // Actualiza el emoji seleccionado en el estado
      print(selectedEmoji);
    });
  }

  void clearFields() {
    name.clear();
    lastname.clear();
    avatarImagePath = null;
    coverImagePath = null;
    selectedEmoji = null;
    selectedMusicalStyle = null;
    selectedStyles.clear();
  }

  void handleProfile() {
    user = _userAuthC.validUser;
    // Asegúrate de que user no sea nulo
    if (user != null) {
      Map<String, dynamic> userFull = {
        'name': name.text,
        'lastname': lastname.text,
        'avatarImagePath': avatarImagePath ?? '',
        'coverImagePath': coverImagePath ?? '',
        'selectedEmoji': selectedEmoji ?? '',
        'musicalStyles': [
          ...selectedStyles.map((style) => {
                'id': style.id,
                'name': style.name,
                'description': style.description,
              })
        ],
      };
      _userAuthC
          .createUser(user['accountType'], user['username'], user['email'],
              user['password'], userFull)
          .then((value) {
        if (_userAuthC.validUser != null &&
            _userAuthC.userMessage.contains('exitosamente')) {
          SnackbarMessage.showSnackbar(context, 'Usuario creado exitosamente',
              _userAuthC.userMessage, 'success',
              route: '/root');
          widget.onClose();
          clearFields();
        }
      });
    } else {
      // Manejo de errores
      if (_userAuthC.userMessage.contains('existe')) {
        SnackbarMessage.showSnackbar(context, _userAuthC.userMessage,
            'Por favor verifique y vuelva a intentarlo', 'failure');
      } else {
        SnackbarMessage.showSnackbar(context, 'Ocurrió un error interno',
            _userAuthC.userMessage, 'failure');
      }
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
    final businessProfileForm = Container(
      child: Column(
        children: [
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
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: FadeTransition(
                    opacity: _animationController,
                    child: Text(
                      'Portada',
                      style: TextStyle(fontSize: 20, color: letterColor),
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
                            color: letterColor,
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
                            radius: MediaQuery.of(context).size.height * 0.09,
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
                // En ProfileView, dentro de `Stack`
                AnimatedTooltip(
                  tooltipText: "Selecciona un estado",
                  bottomOffset: MediaQuery.of(context).size.height * 0.01,
                  leftOffset: MediaQuery.of(context).size.width * 0.28,
                  child: EmojiSelector(
                    onEmojiSelected: (emoji) {
                      setState(() {
                        selectedEmoji = emoji;
                      });
                    },
                  ),
                ),
                // Selector de emojis sobre el avatar
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
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  'Más información sobre el perfil',
                  style: TextStyle(color: letterColor, fontSize: 16),
                ),
                AnimatedTextField(
                  controller: name,
                  labelText: 'Nombre del negocio',
                  prefixIcon: Icons.person,
                  isFocused: nameFocusNode.hasFocus,
                  onFocusChange: (hasFocus) {
                    setState(() {});
                  },
                ),
                SizedBox(height: 10),
                Text(
                  'Selecciona tus generos musicales favoritos',
                  style: TextStyle(color: letterColor, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                AnimatedDropdown(
                  hint: 'Seleccione tu estilo musical de preferencia',
                  items: musicalStyles,
                  selectedItem: selectedMusicalStyle,
                  enableScaleAnimation: false,
                  onChanged: (value) {
                    setState(() {
                      selectedMusicalStyle = value;
                      isDropdownItemSelected = true;

                      // Añade el estilo seleccionado si aún no está en la lista
                      if (value != null && !selectedStyles.contains(value)) {
                        selectedStyles.add(value);
                      }
                    });
                  },
                  itemLabelBuilder: (style) => style.name,
                ),
                if (isDropdownItemSelected)
                  if (isDropdownItemSelected && selectedStyles.isNotEmpty)
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: selectedStyles.isNotEmpty
                          ? 100
                          : 0, // Se oculta si está vacío
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: letterColorUniform,
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
                Text(
                  'Selecciona la ubicación',
                  style: TextStyle(color: letterColor, fontSize: 16),
                ),
                MapContainer()
              ],
            ),
          ),
        ],
      ),
    );
    final personProfileForm = Container(
      child: Column(
        children: [
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
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: FadeTransition(
                    opacity: _animationController,
                    child: Text(
                      'Portada',
                      style: TextStyle(fontSize: 20, color: letterColor),
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
                            color: letterColor,
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
                            radius: MediaQuery.of(context).size.height * 0.09,
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
                // En ProfileView, dentro de `Stack`
                AnimatedTooltip(
                  tooltipText: "Selecciona un estado",
                  bottomOffset: MediaQuery.of(context).size.height * 0.01,
                  leftOffset: MediaQuery.of(context).size.width * 0.28,
                  child: EmojiSelector(
                    onEmojiSelected: (emoji) {
                      setState(() {
                        selectedEmoji = emoji;
                      });
                    },
                  ),
                ),
                // Selector de emojis sobre el avatar
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
                  style: TextStyle(color: letterColor, fontSize: 16),
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
                  'Selecciona tus generos musicales favorito',
                  style: TextStyle(color: letterColor, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                AnimatedDropdown(
                  hint: 'Seleccione tu estilo musical de preferencia',
                  items: musicalStyles,
                  selectedItem: selectedMusicalStyle,
                  enableScaleAnimation: false,
                  onChanged: (value) {
                    setState(() {
                      selectedMusicalStyle = value;
                      isDropdownItemSelected = true;

                      // Añade el estilo seleccionado si aún no está en la lista
                      if (value != null && !selectedStyles.contains(value)) {
                        selectedStyles.add(value);
                      }
                    });
                  },
                  itemLabelBuilder: (style) => style.name,
                ),
                if (isDropdownItemSelected)
                  if (isDropdownItemSelected && selectedStyles.isNotEmpty)
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: selectedStyles.isNotEmpty
                          ? 100
                          : 0, // Se oculta si está vacío
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: letterColorUniform,
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
              ],
            ),
          ),
        ],
      ),
    );
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradientDark(1),
        ),
        child: Stack(
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
                          color: letterColor,
                          fontSize: MediaQuery.of(context).size.height * 0.04,
                        ),
                      ),
                    ),
                    // Formularios de registro de perfil
                    Stack(
                      children: [
                        // Mostrar el formulario dependiendo de isCompany
                        widget.isCompany
                            ? businessProfileForm
                            : personProfileForm,
                      ],
                    ),
                    // Boton de creacion de perfil
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 20),
                      child: ButtonGradient(
                        text: 'Crear',
                        onPressed: handleProfile,
                      ),
                    )
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
                  color: letterColor,
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
      ),
    );
  }
}
