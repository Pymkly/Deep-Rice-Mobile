import 'package:deepricemobile/widgets/button/margin_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../utils/utils.dart';

class ImagePickerScreen extends StatefulWidget {
  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? _image; // Stocke l'image sélectionnée
  final ImagePicker _picker = ImagePicker();

  // Fonction pour sélectionner une image à partir de la galerie
  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Fonction pour prendre une photo avec la caméra
  Future<void> _takePhoto() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = 85;
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                  onPressed: _pickImageFromGallery,
                  color: DeepFarmUtils.blueColor,
                  padding: EdgeInsets.all(12.5),
                  height: width,
                  minWidth: width,
                  child: Icon(Icons.photo_library, size: 40, color: Colors.white,)
              ),
              const SizedBox(width: 20,),
              MaterialButton(
                // shape: CircleBorder(),
                  onPressed: _takePhoto,
                  color: DeepFarmUtils.blueColor,
                  padding: EdgeInsets.all(12.5),
                  height: width,
                  minWidth: width,
                  child: Icon(Icons.camera_alt, size: 40, color: Colors.white,)
              ),
            ],
          ),
        ),
        const SizedBox(height: 20,),
        if (_image != null) ...[
          Container(
            // margin: EdgeInsets.only(left: 0),
            child: Row(
              children: [
                const SizedBox(width: 20,),
                Image.file(
                  _image!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                )
              ],
            ),
          ),
        ],
      ],
    );
  }
}
