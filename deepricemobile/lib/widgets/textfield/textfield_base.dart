import 'package:deepricemobile/widgets/printable_widget.dart';
import 'package:flutter/material.dart';

class TextFieldBase implements PrintableWidget{
  late TextEditingController _controller;


  TextFieldBase() {
    init();
  }

  void init() {
    controller = TextEditingController();
  }


  // Getter pour accéder au contrôleur
  TextEditingController get controller => _controller;

  // Setter pour initialiser ou modifier le contrôleur
  set controller(TextEditingController controller) {
    _controller = controller;
  }

  @override
  Widget build() {
    // TODO: implement build
    throw UnimplementedError();
  }

}