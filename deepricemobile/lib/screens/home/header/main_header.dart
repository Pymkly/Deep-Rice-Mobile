import 'package:deepricemobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

class MainHeader extends StatelessWidget implements PreferredSizeWidget {
  const MainHeader({super.key});

  @override
  Widget build(BuildContext context) {
    double iconSize = double.parse(dotenv.env['ICON_SIZE']?? '20');
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Couleur de l'ombre
            spreadRadius: 1, // Étendue de l'ombre
            blurRadius: 8,  // Flou de l'ombre
            offset: Offset(0, 3), // Déplacement horizontal et vertical
          ),
        ],
      ),
      child:
        AppBar(
          elevation: 0,
          leading: IconButton(onPressed: () {
            Navigator.pushNamed(context, "/");
          }, icon: Icon(Icons.arrow_back, color: Colors.grey[800], size: iconSize)),
          backgroundColor: Colors.transparent,
          title: Text(
            dotenv.env['APP_TITLE']?? 'Application',
            style: GoogleFonts.nunito(
              fontSize: double.parse(dotenv.env['TITLE_FONTSIZE']?? '20') ,
              fontWeight: FontWeight.w800
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(onPressed: null, icon: Icon(Icons.person, color: Colors.grey[800], size: iconSize)),
            SizedBox(width: 20)
          ],
        )
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);

}