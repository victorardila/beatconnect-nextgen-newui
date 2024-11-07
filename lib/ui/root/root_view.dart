import 'package:beatconnect_app/ui/constants.dart';
import 'package:beatconnect_app/ui/widgets/logo_image.dart';
import 'package:beatconnect_app/ui/widgets/logo_type.dart';
import 'package:beatconnect_app/ui/widgets/spinner_load.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class RootView extends StatefulWidget {
  const RootView({super.key});

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double xOffset = 0;
  double yOffset = 0;
  bool handedMode = true;
  bool isDrawerOpen = false;

  final List<Map<String, dynamic>> items = [
    {
      'titleitem': 'Amigos',
      'description': 'Lista de amigos',
      'icon': FontAwesomeIcons.beerMugEmpty,
    },
    {
      'titleitem': 'Grupos',
      'description': 'Tus grupos',
      'icon': FontAwesomeIcons.userGroup,
    },
    {
      'titleitem': 'Eventos',
      'description': 'Mis eventos',
      'icon': FontAwesomeIcons.calendar,
    },
    {
      'titleitem': 'Recomendaciones',
      'description': 'Recomendaciones basadas en tu actividad',
      'icon': FontAwesomeIcons.crown,
    },
    {
      'titleitem': 'Recientes',
      'description': 'Actividad reciente',
      'icon': FontAwesomeIcons.clockRotateLeft,
    },
    {
      'titleitem': 'Guardados',
      'description': 'Tus elementos guardados',
      'icon': FontAwesomeIcons.solidBookmark,
    },
    {
      'titleitem': 'Ayuda y soporte',
      'description': 'Conocer informacion y solitar datos de mi cuenta',
      'icon': FontAwesomeIcons.question,
    },
    {
      'titleitem': 'Sobre nosotros',
      'description': 'Conocenos y siguenos',
      'icon': FontAwesomeIcons.info
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Coponentes visuales del RootView
    final loadview = SpinnerLoad();
    final MenuSidebar = Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                "assets/img/bgApp.png",
              ),
              fit: BoxFit.cover)),
      child: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradientDark(0.96),
        ),
        child: Column(
          children: [
            Container(
              padding:
                  EdgeInsets.only(top: 50, left: 10, right: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: handedMode
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: <Widget>[
                  LogoImage(
                    assets: 'assets/icon/logo.png',
                    height: 50,
                    width: 50,
                  ),
                  SizedBox(width: 3),
                  LogoType(
                    text: 'Beatconnect',
                    color: letterColor,
                    fontSize: 20,
                  ),
                ],
              ),
            ),
            MenuItems(items: items, handedMode: handedMode),
          ],
        ),
      ),
    );
    final ChildContainer = AnimatedContainer(
        transform: handedMode
            ? Matrix4.translationValues(-xOffset, yOffset, 0.5)
            : Matrix4.translationValues(xOffset, yOffset, 0.5)
          ..scale(isDrawerOpen ? 1.12 : 1.00)
          ..rotateZ(isDrawerOpen ? 0 : 0),
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
            gradient: backgroundGradientLightOverlay(1),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.3),
                blurRadius: 12.0,
                spreadRadius: 4.0,
                offset: Offset(0, 4),
              ),
            ],
            borderRadius: BorderRadius.only(
              bottomRight:
                  isDrawerOpen ? Radius.circular(10) : Radius.circular(0),
              topRight: isDrawerOpen ? Radius.circular(10) : Radius.circular(0),
            ),
            border: Border.all(
                color: isDrawerOpen
                    ? const Color.fromRGBO(100, 100, 100, 0.4)
                    : Colors.transparent)),
        child: CustomPaint(
          painter: isDrawerOpen
              ? GradientBorderPainter(animation: _controller)
              : null,
          child: Container(
            child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    actions: [
                      Container(
                        child: isDrawerOpen
                            ? Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  child: AnimatedRotation(
                                    turns: isDrawerOpen ? 0.25 : 0.0,
                                    duration: Duration(milliseconds: 300),
                                    child: IconButton(
                                      icon: Icon(FontAwesomeIcons.bars),
                                      onPressed: () {
                                        setState(() {
                                          xOffset = 0;
                                          yOffset = 0;
                                          isDrawerOpen = false;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  child: AnimatedRotation(
                                    turns: isDrawerOpen ? 0.25 : 0.0,
                                    duration: Duration(milliseconds: 300),
                                    child: IconButton(
                                      icon: Icon(FontAwesomeIcons.bars),
                                      onPressed: () {
                                        setState(() {
                                          FocusScope.of(context)
                                              .unfocus(); // Cierra el teclado
                                          xOffset =
                                              290; // Cambié a 290, ajusta según lo necesites
                                          yOffset = 80;
                                          isDrawerOpen = true;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                      )
                    ])),
          ),
        ));
    return Scaffold(
      body: Container(
        child: Stack(
          children: [MenuSidebar, ChildContainer],
        ),
      ),
    );
  }
}

class MenuItems extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final bool handedMode; // Recibimos xOffset.

  MenuItems({Key? key, required this.items, required this.handedMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            CustomProfile(
              img: 'assets/img/user.png',
              username: 'Victor',
              handedMode: handedMode,
            ),
            Container(
              child: LayoutBuilder(builder: (context, constraints) {
                return SingleChildScrollView(
                  child: IntrinsicHeight(
                    child: Center(
                      child: Column(
                        children: [
                          ...items.map((option) => CustomRow(
                                icon: option['icon'],
                                textOne: option['titleitem'],
                                textTwo: option['description'],
                                handedMode:
                                    handedMode, // Pasamos handedMode aquí
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomRow extends StatelessWidget {
  final IconData icon;
  final String textOne;
  final String textTwo;
  final bool handedMode;

  CustomRow({
    Key? key,
    required this.icon,
    required this.textOne,
    required this.textTwo,
    required this.handedMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double paddingLeft = handedMode ? 140.0 : 0;
    double paddingRight = handedMode ? 0 : 140.0;

    return Container(
        margin: EdgeInsets.symmetric(vertical: 1),
        padding: EdgeInsets.only(left: paddingLeft, right: paddingRight),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(33, 33, 33, 0.4),
        ),
        child: TextButton(
          onPressed: () {
            // Lógica a ejecutar al presionar el botón
          },
          style: ButtonStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0), // Borde cuadrado
              ),
            ),
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  return Colors.grey
                      .withOpacity(0.2); // Color de toque cuadrado
                }
                return null; // Usar color predeterminado
              },
            ),
          ),
          child: Container(
              child: Column(
            children: [
              Row(
                mainAxisAlignment: handedMode
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.end,
                children: [
                  Icon(
                    icon,
                    color: colorApp,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  Expanded(
                    child: Text(
                      textOne,
                      style: TextStyle(
                        color: colorApp,
                        fontSize: MediaQuery.of(context).size.height * 0.025,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      textTwo,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ],
          )),
        ));
  }
}

class CustomProfile extends StatelessWidget {
  final String img;
  final String username;
  final bool handedMode; // Recibimos xOffset.

  CustomProfile(
      {Key? key,
      required this.img,
      required this.username,
      required this.handedMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment:
            handedMode ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Image.asset(
            img,
            width: MediaQuery.of(context).size.width * 0.22,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.02,
          ),
          Container(
            child: Column(
              children: [
                Text(
                  username,
                  style: TextStyle(
                    color: letterColor,
                    fontSize: 18,
                    decoration: TextDecoration.none,
                  ),
                ),
                Text(
                  'Ver mi Perfil',
                  style: TextStyle(
                    color: colorApp,
                    fontSize: 16,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(
            width: 10,
            thickness: 1, // Grosor de la línea
            color: colorApp,
          ),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                FontAwesomeIcons.signOutAlt,
              ))
        ],
      ),
    );
  }
}

class GradientBorderPainter extends CustomPainter {
  final Animation<double> animation;
  GradientBorderPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final double borderWidth = 0.5;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF333333),
        Color(0xFF0597F2),
        Color(0xCC0597F2),
        Color(0x990597F2),
        Color(0x660597F2),
        Color(0x330597F2),
        Color(0x00333333),
      ],
      stops: List.generate(7, (index) => index / 6),
      transform: GradientRotation(animation.value * 2 * pi),
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        rect.deflate(borderWidth /
            2), // Reduce el rect para que el borde esté dentro de los límites
        Radius.circular(10),
      ));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
