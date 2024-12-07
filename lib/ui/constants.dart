import 'package:beatconnect_nextgen_newui/imports.dart';

// Gradientes
const LinearGradient gradientApp = LinearGradient(
  colors: [
    Color(0xFF333333),
    Color(0xFF0597F2),
    Color(0xCC0597F2),
    Color(0x990597F2),
    Color(0x660597F2),
    Color(0x330597F2),
    Color(0x00333333),
  ],
);
const LinearGradient buttonOtherLogins = LinearGradient(
  colors: [
    Color(0xFF262626),
    Color(0xFF1C1C1C),
    Color(0xFF131313),
    Color(0xFF0A0A0A),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

LinearGradient backgroundGradientLightOverlay(double opacity) {
  return LinearGradient(
    colors: [
      Color(0xFF2E2E2E).withOpacity(opacity),
      Color(0xFF272727).withOpacity(opacity),
      Color(0xFF222222).withOpacity(opacity),
      Color(0xFF1C1C1C).withOpacity(opacity),
      Color(0xFF181818).withOpacity(opacity),
      Color(0xFF141414).withOpacity(opacity),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

LinearGradient backgroundGradientDark(double opacity) {
  return LinearGradient(
    colors: [
      Color(0xFF262626).withOpacity(opacity),
      Color(0xFF1F1F1F).withOpacity(opacity),
      Color(0xFF1A1A1A).withOpacity(opacity),
      Color(0xFF141414).withOpacity(opacity),
      Color(0xFF101010).withOpacity(opacity),
      Color(0xFF0C0C0C).withOpacity(opacity),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// Colores basicos
const Color colorApp = Color(0xFF6BA5F2);
const Color colorSpotify = Color(0xFF08EB61);

// Dark Mode
const Color letterColor = Colors.white;
const Color letterColorUniform = Colors.white12;
const Color bgComponents = Color(0xFF3C3C3C);
