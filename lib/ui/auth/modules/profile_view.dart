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
  final bool isCompany; // Nuevo parámetro
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
  List<Widget> bussinesStepper = [];
  List<Widget> personalStepper = [];
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
          loadPersonalStepper();
          loadBusinessStepper();
        }
      });
    } catch (e) {
      print("Error loading musical styles: $e");
    }
  }

  void loadPersonalStepper() {
    personalStepper.add(
      Container(
        child: Column(
          children: [
            Text(
              'Datos básicos',
              style: TextStyle(
                  color: letterColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            // Contenedor de la portada y la imagen de perfil
            ProfileCoverSelect(
              onImagesSelected: (avatar, cover) {
                setState(() {
                  avatarImagePath = avatar;
                  coverImagePath = cover;
                });
              },
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
    personalStepper.add(Container(
      child: Column(
        children: [
          Text(
            'Preferencias',
            style: TextStyle(
                color: letterColor, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ListSelectionArea(
            musicalStyles: musicalStyles,
            onSelectedStylesChanged: (styles) {
              setState(() {
                selectedStyles = styles;
                // selectedMusicalStyle se actualiza implícitamente
              });
            },
          ),
        ],
      ),
    ));
  }

  void loadBusinessStepper() {
    bussinesStepper.add(
      Container(
        child: Column(
          children: [
            Text(
              'Datos básicos',
              style: TextStyle(
                  color: letterColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            // Contenedor de la portada y la imagen de perfil
            ProfileCoverSelect(
              onImagesSelected: (avatar, cover) {
                setState(() {
                  avatarImagePath = avatar;
                  coverImagePath = cover;
                });
              },
            ),
            Container(
              child: Column(
                children: [
                  Text(
                    'Más información sobre el perfil',
                    style: TextStyle(color: letterColor, fontSize: 16),
                  ),
                  AnimatedTextField(
                    controller: name,
                    labelText: 'Nombre del negocio',
                    prefixIcon: Icons.business,
                    isFocused: nameFocusNode.hasFocus,
                    onFocusChange: (hasFocus) {
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    bussinesStepper.add(Container(
      child: Column(
        children: [
          Text(
            'Preferencias',
            style: TextStyle(
                color: letterColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ListSelectionArea(
            musicalStyles: musicalStyles,
            onSelectedStylesChanged: (styles) {
              setState(() {
                selectedStyles = styles;
              });
            },
          ),
        ],
      ),
    ));

    bussinesStepper.add(Container(
      child: Column(
        children: [
          Text(
            'Ubicación',
            style: TextStyle(
                color: letterColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'Selecciona la ubicación',
            style: TextStyle(color: letterColor, fontSize: 16),
          ),
          MapContainer(), // Asegúrate de que este widget esté definido
        ],
      ),
    ));
  }

  void onEmojiSelected(String emoji) {
    setState(() {
      selectedEmoji = emoji; // Actualiza el emoji seleccionado en el estado
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
        if (_userAuthC.userMessage.contains('No hay conexión')) {
          SnackbarMessage.showSnackbar(
            context,
            'Error de conexión',
            'No hay conexión a Internet.',
            'failure',
          );
          return;
        } else {
          if (_userAuthC.validUser != null &&
              _userAuthC.userMessage.contains('exitosamente')) {
            SnackbarMessage.showSnackbar(context, 'Usuario creado exitosamente',
                _userAuthC.userMessage, 'success',
                route: '/root');
            widget.onClose();
            clearFields();
          } else {
            SnackbarMessage.showSnackbar(context, 'Ocurrió un error interno',
                _userAuthC.userMessage, 'failure');
          }
        }
      });
    } else {
      // Manejo de errores
      if (_userAuthC.userMessage.contains('existe')) {
        SnackbarMessage.showSnackbar(context, _userAuthC.userMessage,
            'Por favor verifique y vuelva a intentarlo', 'failure');
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

    // Cargar los estilos musicales una sola vez al iniciar la vista
    loadMusicalStyles();
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
        child: bussinesStepper.isNotEmpty
            ? StepByStepForm(
                iconsStep: [
                  Icons.person,
                  Icons.music_note,
                  Icons.location_on,
                ],
                steps: bussinesStepper,
                onSubmit: handleProfile,
              )
            : Container());
    final personProfileForm = Container(
        child: personalStepper.isNotEmpty
            ? StepByStepForm(
                iconsStep: [
                  Icons.person,
                  Icons.music_note,
                ],
                steps: personalStepper,
                onSubmit: handleProfile,
              )
            : Container());
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradientDark(1),
        ),
        child: Stack(
          children: [
            // Contenido desplazable
            Container(
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
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: widget.isCompany
                          ? businessProfileForm
                          : personProfileForm,
                    ),
                  ),
                ],
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
