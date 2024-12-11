import 'package:flutter/material.dart';

import '../../../widgets/button/button_listener.dart';
import '../../../widgets/button/margin_button.dart';
import '../../../widgets/button/redirect_button.dart';
import '../../../widgets/textfield/textfield_labeled.dart';


class DiseaseClassificationScreen extends StatelessWidget {
  const DiseaseClassificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CustomMarginButton validationButton = CustomMarginButton(
        "valider", CustomDefaultListener());
    TextFieldLabeled textFieldLabeled = TextFieldLabeled("Nom de l'expérience");
    RedirectButton homeRd = RedirectButton(context, "Home", "/");
    return Center
    (
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          homeRd.build(),
          textFieldLabeled.build(),
          const SizedBox(height: 20),
          validationButton.build()
        ],
      )
    );
  }
}