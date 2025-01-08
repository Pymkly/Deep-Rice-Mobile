import 'package:deepricemobile/widgets/button/margin_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../utils/utils.dart';

class ImagePickerScreen extends StatefulWidget {
  // final Function(File?) onImagePicked;
  final Function(List<File>?) onImagesPicked; // Callback pour remonter les images
  // ImagePickerScreen({super.key, required this.onImagePicked});
  ImagePickerScreen({super.key, required this.onImagesPicked});

  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  // File? _image; // Stocke l'image sélectionnée
  List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImagesFromGallery() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        // _images = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
        _images.addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)));
      });
      widget.onImagesPicked(_images); // Notifie la classe parente
    }
  }

  void _removeImage(File image) {
    setState(() {
      _images.remove(image); // Retire l'image sélectionnée
    });
    widget.onImagesPicked(_images);
  }
  // Fonction pour prendre une photo avec la caméra
  Future<void> _takePhoto() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
      widget.onImagesPicked(_images);
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
                  // onPressed: _pickImageFromGallery,
                  onPressed: _pickImagesFromGallery,
                  color: DeepFarmUtils.blueColor,
                  padding: const EdgeInsets.all(12.5),
                  height: width,
                  minWidth: width,
                  child: const Icon(Icons.photo_library, size: 40, color: Colors.white,)
              ),
              const SizedBox(width: 20,),
              MaterialButton(
                // shape: CircleBorder(),
                  onPressed: _takePhoto,
                  color: DeepFarmUtils.blueColor,
                  padding: const EdgeInsets.all(12.5),
                  height: width,
                  minWidth: width,
                  child: const Icon(Icons.camera_alt, size: 40, color: Colors.white,)
              ),
            ],
          ),
        ),
        const SizedBox(height: 20,),
        if (_images.isNotEmpty)
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.start,
            children: _images.map((image) {
              return Stack(
                children: [
                  Image.file(
                    image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () {
                        _removeImage(image);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    )
                  )
                ]
              );
            }).toList(),
          )
      ],
    );
  }
}
