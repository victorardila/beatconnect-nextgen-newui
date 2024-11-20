import 'package:beatconnect_app/imports.dart';

class SnackbarMessage {
  static void showSnackbar(
    BuildContext context,
    String title,
    String message,
    String typeMessage, {
    String? route, // Parámetro opcional
  }) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: typeMessage == 'success'
            ? ContentType.success
            : typeMessage == 'failure'
                ? ContentType.failure
                : typeMessage == 'help'
                    ? ContentType.help
                    : typeMessage == 'warning'
                        ? ContentType.warning
                        : ContentType.failure,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Navegación a la ruta opcional
    if (route != null) {
      Future.delayed(Duration(microseconds: 1), () {
        Navigator.pushNamed(context, route);
      });
    }
  }
}
