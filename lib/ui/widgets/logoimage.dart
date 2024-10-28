import 'package:flutter/cupertino.dart';

class LogoImage extends StatefulWidget {
  final double? height; // Cambiado a nullable
  final double? width; // Cambiado a nullable
  final String assets;

  const LogoImage({
    super.key,
    this.height, // Permitir que sea nullable
    this.width, // Permitir que sea nullable
    required this.assets,
  });

  @override
  State<LogoImage> createState() => _LogoImageState();
}

class _LogoImageState extends State<LogoImage> {
  @override
  Widget build(BuildContext context) {
    // Si height no se proporciona, usar MediaQuery
    double effectiveHeight =
        widget.height ?? MediaQuery.of(context).size.height * 0.15;
    double effectiveWidth =
        widget.width ?? 100.0; // Valor por defecto para width

    return Container(
      width: effectiveWidth,
      height: effectiveHeight,
      child: Image.asset(
        widget.assets,
        fit: BoxFit
            .contain, // Asegúrate de que la imagen se ajuste correctamente
      ),
    );
  }
}
