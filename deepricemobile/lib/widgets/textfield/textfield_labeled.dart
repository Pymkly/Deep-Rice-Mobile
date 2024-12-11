import 'package:deepricemobile/widgets/textfield/textfield_base.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class TextFieldLabeled extends TextFieldBase {
  late String _label;
  late double _margin;

  TextFieldLabeled(String label, {double margin = DeepFarmUtils.DEFAULT_MARGIN}) {
    this.label = label;
    this.margin = margin;
  }

  @override
  Widget build() {
    Widget response = TextField(
      controller: controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label
      ),
    );
    response = DeepFarmUtils.addBorder(response, margin);
    return response;
  }

  String get label => _label;

  // Setter pour _label avec validation
  set label(String value) {
    if (value.isEmpty) {
      throw ArgumentError("Le label ne peut pas être vide.");
    }
    _label = value;
  }

  // Getter pour _margin
  double get margin => _margin;

  // Setter pour _margin avec validation
  set margin(double value) {
    if (value < 0) {
      throw ArgumentError("La marge ne peut pas être négative.");
    }
    _margin = value;
  }
}