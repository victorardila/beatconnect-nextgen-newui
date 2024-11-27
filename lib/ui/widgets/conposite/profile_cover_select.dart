import '../../../imports.dart';

class ProfileCoverSelect extends StatefulWidget {
  final Function(String? avatarPath, String? coverPath) onImagesSelected;
  const ProfileCoverSelect({
    required this.onImagesSelected,
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileCoverSelect> createState() => _ProfileCoverSelectState();
}

class _ProfileCoverSelectState extends State<ProfileCoverSelect> {
  bool isPressedAvatar = false;
  bool isPressedCamera = false;
  String? avatarImagePath; // Para la imagen de perfil
  String? coverImagePath; // Para la imagen de portada

  Future<void> _pickAvatarImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        avatarImagePath = pickedFile.path;
        _onImagesSelected();
      });
    } else {
      print("No avatar image selected."); // Debug log
    }
  }

  Future<void> _pickCoverImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        coverImagePath = pickedFile.path;
        _onImagesSelected();
      });
    } else {
      print("No cover image selected."); // Debug log
    }
  }

  // Callback para retornar las rutas de las imágenes seleccionadas
  void _onImagesSelected() {
    widget.onImagesSelected(avatarImagePath, coverImagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, .2),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          if (coverImagePath != null)
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(coverImagePath!)),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
          Positioned(
            top: 10,
            right: 10,
            child: Text(
              'Portada',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: GestureDetector(
              onTapDown: (_) {
                setState(() {
                  isPressedAvatar = true;
                });
              },
              onTapUp: (_) {
                setState(() {
                  isPressedAvatar = false;
                });
              },
              onTapCancel: () {
                setState(() {
                  isPressedAvatar = false;
                });
              },
              onTap: _pickAvatarImage,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color:
                              isPressedAvatar ? Colors.black54 : Colors.black26,
                          blurRadius: 12.0,
                          spreadRadius: 4.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color:
                            Color.fromRGBO(158, 158, 158, .2).withOpacity(0.5),
                        width: 1.0,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.height * 0.09,
                      backgroundImage: avatarImagePath != null
                          ? FileImage(File(avatarImagePath!))
                          : AssetImage('assets/img/user.png') as ImageProvider,
                    ),
                  ),
                  Positioned(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isPressedAvatar
                            ? const Color.fromRGBO(0, 0, 0, 0.08)
                            : Color.fromRGBO(0, 0, 0, 0.1),
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        Icons.camera_alt,
                        color: isPressedAvatar ? Colors.white : Colors.black54,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: GestureDetector(
              onTapDown: (_) {
                setState(() {
                  isPressedCamera = true;
                });
              },
              onTapUp: (_) {
                setState(() {
                  isPressedCamera = false;
                });
              },
              onTapCancel: () {
                setState(() {
                  isPressedCamera = false;
                });
              },
              onTap: _pickCoverImage,
              child: Container(
                decoration: BoxDecoration(
                  color: isPressedCamera
                      ? Color.fromRGBO(0, 0, 0, .8)
                      : Color.fromRGBO(0, 0, 0, .3),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(6),
                child: Icon(
                  Icons.camera_alt,
                  color: isPressedCamera ? Colors.white : Colors.white70,
                  size: 26,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
