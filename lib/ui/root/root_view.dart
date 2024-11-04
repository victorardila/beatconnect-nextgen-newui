import 'package:beatconnect_app/ui/constants.dart';
import 'package:beatconnect_app/ui/widgets/logo_image.dart';
import 'package:beatconnect_app/ui/widgets/logo_type.dart';
import 'package:beatconnect_app/ui/widgets/spinner_load.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

class RootView extends StatefulWidget {
  const RootView({super.key});

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> menuOptions = [
    {
      'titleitem': 'Amigos',
      'subtitleitem': 'Lista de amigos',
      'icon': FontAwesomeIcons.beerMugEmpty,
    },
    {
      'titleitem': 'Grupos',
      'subtitleitem': 'Tus grupos',
      'icon': FontAwesomeIcons.userGroup,
    },
    {
      'titleitem': 'Recomendaciones',
      'subtitleitem': 'Recomendaciones basadas en tu actividad',
      'icon': FontAwesomeIcons.crown,
    },
    {
      'titleitem': 'Recientes',
      'subtitleitem': 'Actividad reciente',
      'icon': FontAwesomeIcons.clockRotateLeft,
    },
    {
      'titleitem': 'Guardados',
      'subtitleitem': 'Tus elementos guardados',
      'icon': FontAwesomeIcons.solidBookmark,
    },
  ];

  @override
  Widget build(BuildContext context) {
    const loadview = SpinnerLoad();
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Container(
                  padding: EdgeInsets.only(top: 50, left: 20, bottom: 70),
                  child: Column(
                    children: [
                      Row(
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
                      MenuSidebar(menuOptions: menuOptions),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MenuSidebar extends StatelessWidget {
  final List<Map<String, dynamic>> menuOptions;

  MenuSidebar({Key? key, required this.menuOptions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomProfile(
            img: 'assets/img/user.png',
            username: 'Victor',
          ),
          ...menuOptions.map((option) => CustomRow(
                icon: option['icon'],
                textOne: option['titleitem'],
                textTwo: option['subtitleitem'],
              )),
        ],
      ),
    );
  }
}

class CustomRow extends StatelessWidget {
  final IconData icon;
  final String textOne;
  final String textTwo;

  CustomRow({
    Key? key,
    required this.icon,
    required this.textOne,
    required this.textTwo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  // Lógica a ejecutar al presionar el botón
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              icon,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                textOne,
                                style: TextStyle(
                                  color: colorApp,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                textTwo,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomProfile extends StatelessWidget {
  final String img;
  final String username;
  final email;
  final controller;
  CustomProfile({
    Key? key,
    required this.img,
    required this.username,
    this.email,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
        ],
      ),
    );
  }
}
