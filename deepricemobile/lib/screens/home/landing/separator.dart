import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/utils.dart';

class CustomSectionSeparator extends StatelessWidget {
  late String label;

  CustomSectionSeparator(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: DeepFarmUtils.extractDoubleConfig("SEPARATOR_HEIGHT"),
            // color: Colors.grey[DeepFarmUtils.extractIntConfig('BANNER_BG')],
      child: Row(
        children: [
          Expanded(child: Text("")),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Text(
                label,
                style: GoogleFonts.nunito(
                  fontSize: DeepFarmUtils.extractDoubleConfig("SEPARATOR_FS"),
                  fontWeight: FontWeight.w800,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 2, // Épaisseur de la bordure
                  color: Colors.black, // Couleur de la bordure
                ),
              ),
            ],
          ),
          Expanded(child: Text("")),
        ],
      ),
    );
  }

}