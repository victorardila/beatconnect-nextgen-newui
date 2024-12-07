import 'package:beatconnect_nextgen_newui/imports.dart';

class ListSelectionArea extends StatefulWidget {
  final List<MusicalStyle> musicalStyles;
  final ValueChanged<List<MusicalStyle>> onSelectedStylesChanged; // Callback

  const ListSelectionArea({
    Key? key,
    required this.musicalStyles,
    required this.onSelectedStylesChanged,
  }) : super(key: key);

  @override
  State<ListSelectionArea> createState() => _ListSelectionAreaState();
}

class _ListSelectionAreaState extends State<ListSelectionArea> {
  List<MusicalStyle> selectedStyles = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Selecciona tus géneros musicales favoritos',
          style: TextStyle(color: letterColor, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        AnimatedDropdown<MusicalStyle>(
          hint: 'Seleccione su estilo musical de preferencia',
          items: widget.musicalStyles,
          selectedItem: null, // No se selecciona un valor por defecto
          enableScaleAnimation: false,
          onChanged: (value) {
            setState(() {
              if (value != null) {
                if (selectedStyles.contains(value)) {
                  selectedStyles
                      .remove(value); // Eliminar si ya está seleccionado
                } else {
                  selectedStyles.add(value); // Agregar a la selección
                }
              }
              widget.onSelectedStylesChanged(selectedStyles);
            });
          },
          itemLabelBuilder: (style) => style.name,
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: selectedStyles.isNotEmpty ? 100 : 0,
          width: double.infinity,
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: letterColorUniform,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Wrap(
            spacing: 8.0,
            children: selectedStyles.map((style) {
              return ItemTag(
                text: style.name,
                onRemove: () {
                  setState(() {
                    selectedStyles.remove(style);
                    widget.onSelectedStylesChanged(selectedStyles);
                  });
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
