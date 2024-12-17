import 'package:deepricemobile/utils/utils.dart';
import 'package:deepricemobile/widgets/button/action_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomMarginButton extends ActionButton {
  static const double BOX_MIN_WIDTH = 200;
  static const double BOX_MAX_WIDTH = 200;
  static const double BOX_HEIGHT = 40;
  static const double MIN_WIDTH = 200;
  static const double MIN_HEIGHT = 200;
  static const double FS = 18;
  late double _margin;
  late double _fs;
  late double _boxMinWidth;
  late double _boxHeight;
  late double _boxMaxWidth;
  late double _minWidth;
  late double _minHeight;
  CustomMarginButton(super.label, super.callback, {
    double margin=DeepFarmUtils.DEFAULT_MARGIN,
    double boxMinWidth= BOX_MIN_WIDTH,
    double boxMaxWidth= BOX_MAX_WIDTH,
    double minWidth= MIN_WIDTH,
    double minHeight= MIN_HEIGHT,
    double boxHeight= BOX_HEIGHT,
    double fs= FS,
  }) {
    this.margin = margin;
    this.boxMinWidth = boxMinWidth;
    this.boxMaxWidth = boxMaxWidth;
    this.minWidth = minWidth;
    this.minHeight = minHeight;
    this.height = boxHeight;
    this.fs = fs;
  }

  @override
  Widget build() {
    Widget response = ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: boxMinWidth, // Largeur minimale globale
        maxWidth: boxMaxWidth, // Largeur maximale
        maxHeight: height
      ),
      child: ElevatedButton(
        onPressed: () {
          call();
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(minWidth, minHeight)
        ),
        child: Text(label,
          style: GoogleFonts.nunito(
            fontSize: fs
          ),
        ),
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

  double get height => _boxHeight;

  set height(double value) {
    _boxHeight = value;
  }

  double get fs => _fs;

  set fs(double value) {
    _fs = value;
  }

  double get margin => _margin;

  set margin(double value) {
    _margin = value;
  }
}