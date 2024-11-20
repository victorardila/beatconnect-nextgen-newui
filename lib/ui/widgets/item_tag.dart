import 'package:beatconnect_app/imports.dart';

class ItemTag extends StatefulWidget {
  final String text; // Texto dentro del tag
  final VoidCallback onRemove; // Acción al hacer clic en el icono de eliminar

  const ItemTag({
    super.key,
    required this.text,
    required this.onRemove,
  });

  @override
  State<ItemTag> createState() => _ItemTagState();
}

class _ItemTagState extends State<ItemTag> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFF6BA5F2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              widget.text,
              style: const TextStyle(color: letterColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: widget.onRemove,
            child: Icon(
              FontAwesomeIcons.times, // Icono de la 'X' para eliminar
              size: 16,
              color: letterColor,
            ),
          ),
        ],
      ),
    );
  }
}
