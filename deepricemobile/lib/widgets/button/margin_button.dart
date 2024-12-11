import 'package:deepricemobile/utils/utils.dart';
import 'package:deepricemobile/widgets/button/action_button.dart';
import 'package:flutter/material.dart';

class CustomMarginButton extends ActionButton {
  static const double BOX_MIN_WIDTH = 200;
  static const double BOX_MAX_WIDTH = 200;
  static const double MIN_WIDTH = 200;
  static const double MIN_HEIGHT = 200;
  late double _margin;
  late double _boxMinWidth;
  late double _boxMaxWidth;
  late double _minWidth;
  late double _minHeight;
  CustomMarginButton(super.label, super.callback, {
    double margin=DeepFarmUtils.DEFAULT_MARGIN,
    double boxMinWidth= BOX_MIN_WIDTH,
    double boxMaxWidth= BOX_MAX_WIDTH,
    double minWidth= MIN_WIDTH,
    double minHeight= MIN_HEIGHT
  }) {
    this.margin = margin;
    this.boxMinWidth = boxMinWidth;
    this.boxMaxWidth = boxMaxWidth;
    this.minWidth = minWidth;
    this.minHeight = minHeight;
  }

  @override
  Widget build() {
    Widget response = ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: boxMinWidth, // Largeur minimale globale
        maxWidth: boxMaxWidth, // Largeur maximale
        maxHeight: 50
      ),
      child: ElevatedButton(
        onPressed: () {
          call();
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(minWidth, minHeight)
        ),
        child: Text(label),
      ),
    );
    response = DeepFarmUtils.addBorder(response, margin);
    return response;
  }

  // Getter et Setter pour _boxMinWidth
  double get boxMinWidth => _boxMinWidth;
  set boxMinWidth(double value) {
    if (value < 0) {
      throw ArgumentError('La largeur minimale de la boîte ne peut pas être négative.');
    }
    _boxMinWidth = value;
  }

  // Getter et Setter pour _boxMaxWidth
  double get boxMaxWidth => _boxMaxWidth;
  set boxMaxWidth(double value) {
    if (value < _boxMinWidth) {
      throw ArgumentError('La largeur maximale doit être supérieure ou égale à la largeur minimale.');
    }
    _boxMaxWidth = value;
  }

  // Getter et Setter pour _minWidth
  double get minWidth => _minWidth;
  set minWidth(double value) {
    if (value < 0) {
      throw ArgumentError('La largeur minimale ne peut pas être négative.');
    }
    _minWidth = value;
  }

  // Getter et Setter pour _minHeight
  double get minHeight => _minHeight;
  set minHeight(double value) {
    if (value < 0) {
      throw ArgumentError('La hauteur minimale ne peut pas être négative.');
    }
    _minHeight = value;
  }

  double get margin => _margin;

  set margin(double value) {
    _margin = value;
  }
}