import 'package:deepricemobile/widgets/button/button_listener.dart';
import 'package:deepricemobile/widgets/button/margin_button.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/utils.dart';

class RedirectButton extends CustomMarginButton {
  RedirectButton(BuildContext contextParam, String label, String link, {
  double margin=DeepFarmUtils.DEFAULT_MARGIN,
  double boxMinWidth= CustomMarginButton.BOX_MIN_WIDTH,
  double boxMaxWidth= CustomMarginButton.BOX_MAX_WIDTH,
  double minWidth= CustomMarginButton.MIN_WIDTH,
  double minHeight= CustomMarginButton.MIN_HEIGHT
  }): super(label, RedirectionListener(contextParam, link), margin: margin,
    boxMinWidth: boxMinWidth, boxMaxWidth: boxMaxWidth, minWidth: minWidth, minHeight: minHeight
  );
}

class RedirectionListener extends ButtonListener{

  String _link = "/";
  late BuildContext _context;

  RedirectionListener(BuildContext contextParam, String linkParam) : super() {
    link = linkParam;
    context = contextParam;
  }

  @override
  void onClick() {
    Navigator.pushNamed(context, link);
  }

  // Getter pour accéder au contexte
  BuildContext get context => _context;

  // Setter pour modifier le contexte avec une validation optionnelle
  set context(BuildContext value) {
    _context = value;
  }

  String get link => _link;

  // Setter pour modifier la valeur de _link avec validation
  set link(String value) {
    if (value.isEmpty) {
      throw ArgumentError("Le lien ne peut pas être vide.");
    }
    _link = value;
  }

}