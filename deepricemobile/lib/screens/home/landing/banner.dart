import 'package:deepricemobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBanner extends StatelessWidget {
  const CustomBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: DeepFarmUtils.extractDoubleConfig('BANNER_HEIGHT'),
      color: Colors.grey[DeepFarmUtils.extractIntConfig('BANNER_BG')],
      padding: EdgeInsets.fromLTRB(
          DeepFarmUtils.extractDoubleConfig('BANNER_PDL'),
          DeepFarmUtils.extractDoubleConfig('BANNER_PDT'),
          DeepFarmUtils.extractDoubleConfig('BANNER_PDR'),
          DeepFarmUtils.extractDoubleConfig('BANNER_PDB')
      ),
      child: Row(
        children: [
          Expanded(
              child: Container(
                // padding: EdgeInsets.all(5),
                child: Text(DeepFarmUtils.extractENV("BANNER_SLOGAN"),
                  style: GoogleFonts.nunito(
                      fontSize: DeepFarmUtils.extractDoubleConfig("SLOGAN_FS")
                  ),
                ),
              )
          ),
          SizedBox(width: 20),
          Container(
              width: DeepFarmUtils.extractDoubleConfig("FLAG_WIDTH"),
              height: DeepFarmUtils.extractDoubleConfig("FLAG_HEIGHT"),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(DeepFarmUtils.extractENV('FLAG_URL')),
                  fit: BoxFit.cover, // Ajuste l'image pour remplir le container
                ),
                borderRadius: BorderRadius.circular(10), // Coins arrondis
                border: Border.all(color: Color(0xFF74ae8a), width: 2), // Bordure
              )
          )
        ],
      ),
    );
  }

}