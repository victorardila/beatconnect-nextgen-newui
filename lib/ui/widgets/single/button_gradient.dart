import 'package:beatconnect_nextgen_newui/imports.dart';

class ButtonGradient extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final String? iconDirection;
  final VoidCallback onPressed;
  final double? width; // Ancho opcional
  final double? height; // Alto opcional
  final double? fontSIze;

  const ButtonGradient({
    this.text,
    required this.onPressed,
    this.icon,
    this.iconDirection = 'left',
    this.width, // Ancho opcional en el constructor
    this.height, // Alto opcional en el constructor
    this.fontSIze = 18,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtener tamaño de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Establecer valores predeterminados si no se proporcionan
    final buttonWidth =
        width ?? screenWidth * 0.5; // 50% del ancho de la pantalla
    final buttonHeight =
        height ?? screenHeight * 0.05; // 5% del alto de la pantalla

    return Container(
      width: buttonWidth, // Usar ancho proporcionado o predeterminado
      height: buttonHeight, // Usar alto proporcionado o predeterminado
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF333333), // rgba(51, 51, 51, 1)
            Color(0xFF0597F2), // rgba(5, 151, 242, 1)
            Color(0xCC0597F2), // rgba(5, 151, 242, 0.8)
            Color(0x990597F2), // rgba(5, 151, 242, 0.6)
            Color(0x660597F2), // rgba(5, 151, 242, 0.4)
            Color(0x330597F2), // rgba(5, 151, 242, 0.2)
            Color(0x00333333), // rgba(51, 51, 51, 0)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // #0000001a
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 0), // Sombra sin desplazamiento
          ),
        ],
        borderRadius: BorderRadius.circular(5), // borderRadius: "5px"
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.transparent, // Fondo transparente (se usa el container)
          shadowColor:
              Colors.transparent, // Quitar sombra del botón predeterminada
          padding: EdgeInsets.symmetric(
              horizontal: 15, vertical: 10), // padding: "10px 15px"
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // borderRadius: "5px"
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Ajustar al contenido
          children: [
            if (iconDirection == 'left')
              Icon(
                icon,
                color: Colors.white, // color: "white"
                size: buttonWidth * 0.12, // size: "12px"
              ),
            SizedBox(width: 8), // Espacio entre ícono y texto
            if (text != null)
              Flexible(
                // Permitir que el texto se ajuste
                child: Text(
                  text!,
                  style: TextStyle(
                    color: Colors.white, // color: "white"
                    fontWeight: FontWeight.bold, // fontWeight: "bold"
                    fontSize: width != null ? (buttonWidth * 0.12) : fontSIze,
                  ),
                  overflow: TextOverflow.ellipsis, // Cortar si es muy largo
                  maxLines: 1, // Limitar a una línea
                ),
              ),
            SizedBox(width: 8), // Espacio entre ícono y texto
            if (iconDirection == 'right')
              Icon(
                icon,
                color: Colors.white, // color: "white"
                size: buttonWidth * 0.12, // size: "12px"
              ),
          ],
        ),
      ),
    );
  }
}
