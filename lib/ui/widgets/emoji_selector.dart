import 'package:flutter/material.dart';

class EmojiSelector extends StatefulWidget {
  final Function(String) onEmojiSelected;
  const EmojiSelector({Key? key, required this.onEmojiSelected})
      : super(key: key);

  @override
  _EmojiSelectorState createState() => _EmojiSelectorState();
}

class _EmojiSelectorState extends State<EmojiSelector> {
  String? selectedEmoji;

  // Lista de emojis disponibles
  final List<String> emojis = [
    '😀', '😂', '😍', '😎', '🥳', '😢', '😡', '🤔', '🤗', '🙌',
    // Agrega más emojis si lo deseas
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Contenedor que muestra el emoji seleccionado o el ícono de emoji
        GestureDetector(
          onTap: () => _showEmojiPicker(context),
          child: selectedEmoji != null
              ? Text(
                  selectedEmoji!,
                  style: TextStyle(fontSize: 30),
                )
              : Icon(
                  Icons.insert_emoticon,
                  color: const Color.fromARGB(255, 208, 208, 208),
                  size: 30,
                ),
        ),
      ],
    );
  }

  // Método para mostrar el selector de emojis
  void _showEmojiPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true, // Permite cerrar tocando fuera del modal
      enableDrag: true, // Permite deslizar para cerrar el modal
      builder: (context) {
        return Container(
          height: 200,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
            ),
            itemCount: emojis.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedEmoji = emojis[index];
                  });
                  widget.onEmojiSelected(emojis[index]); // Llama al callback
                  Navigator.pop(context); // Cierra el modal inmediatamente
                },
                child: Center(
                  child: Text(
                    emojis[index],
                    style: TextStyle(fontSize: 30), // Tamaño de los emojis
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
