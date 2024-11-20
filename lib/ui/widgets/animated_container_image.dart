import 'package:beatconnect_app/imports.dart';

class AnimatedContainerImage extends StatefulWidget {
  final String image;
  final String text;
  final onTap;

  const AnimatedContainerImage({
    super.key,
    required this.image,
    required this.text,
    this.onTap,
  });

  @override
  State<AnimatedContainerImage> createState() => _AnimatedContainerImageState();
}

class _AnimatedContainerImageState extends State<AnimatedContainerImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: widget.onTap, // Ejecuta la función al presionar
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.grey.withOpacity(0.2);
                  }
                  return null;
                },
              ),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.image),
                  fit: BoxFit.cover,
                ),
                color: bgComponents,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
          Container(
            child: LogoType(
              text: widget.text,
              color: letterColor,
              fontSize: MediaQuery.of(context).size.height * 0.022,
            ),
          ),
        ],
      ),
    );
  }
}
