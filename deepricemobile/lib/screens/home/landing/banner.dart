import 'package:deepricemobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBanner extends StatelessWidget {
  const CustomBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: DeepFarmUtils.extractDoubleConfig('BANNER_HEIGHT'),
      color: Colors.white,
      // color: Colors.grey[DeepFarmUtils.extractIntConfig('BANNER_BG')],
      padding: configPadding(),
      child: Row(
        children: [
          CustomFlag(flagUrl: null),
          const SizedBox(width: 20),
          const Expanded(
              child: CustomSlogan()
          ),
        ],
      ),
    );
  }

  EdgeInsets configPadding() {
    return EdgeInsets.fromLTRB(
        DeepFarmUtils.extractDoubleConfig('BANNER_PDL'),
        DeepFarmUtils.extractDoubleConfig('BANNER_PDT'),
        DeepFarmUtils.extractDoubleConfig('BANNER_PDR'),
        DeepFarmUtils.extractDoubleConfig('BANNER_PDB')
    );
  }
}

class CustomSlogan extends StatelessWidget {
  const CustomSlogan({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(DeepFarmUtils.extractENV("BANNER_SLOGAN"),
      style: GoogleFonts.nunito(
          fontSize: DeepFarmUtils.extractDoubleConfig("SLOGAN_FS")
      ),
    );
  }

}

class CustomFlag extends StatelessWidget {
  late String flag = '';
  CustomFlag({super.key, String? flagUrl}) {
    changeFlag = flagUrl;
  }

  set changeFlag(String? flagUrl) {
    if (flagUrl != null) {
      flag = flagUrl;
    } else {
      flag = DeepFarmUtils.extractENV('FLAG_URL');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: DeepFarmUtils.extractDoubleConfig("FLAG_WIDTH"),
      height: DeepFarmUtils.extractDoubleConfig("FLAG_HEIGHT"),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(flag),
          fit: BoxFit.cover, // Ajuste l'image pour remplir le container
        ),
        borderRadius: BorderRadius.circular(10), // Coins arrondis
        border: Border.all(color: DeepFarmUtils.greenColor, width: 1), // Bordure
      )
    );
  }
}