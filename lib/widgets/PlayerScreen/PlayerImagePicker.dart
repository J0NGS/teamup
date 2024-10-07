import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PlayerImagePicker extends StatelessWidget {
  final String photoUrl;
  final ValueChanged<String> onImagePicked;

  const PlayerImagePicker(
      {super.key, required this.photoUrl, required this.onImagePicked});

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      onImagePicked(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickImage(context),
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.green, width: 3),
          image: photoUrl.isNotEmpty
              ? DecorationImage(
                  image: FileImage(File(photoUrl)),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: photoUrl.isEmpty
            ? const Icon(Icons.person, color: Colors.green, size: 100)
            : null,
      ),
    );
  }
}
