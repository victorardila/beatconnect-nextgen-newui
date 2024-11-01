import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              widget.text,
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: widget.onRemove,
            child: Icon(
              FontAwesomeIcons.times, // Icono de la 'X' para eliminar
              size: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
