import 'package:deepricemobile/screens/main_screen.dart';
import 'package:flutter/material.dart';

import '../../../utils/utils.dart';
import '../../../widgets/button/redirect_button.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    double boxWidth = getBoxWidth(context);
    RedirectButton homeRd = RedirectButton(context, "Home", "/", boxMaxWidth: boxWidth, minWidth: boxWidth);
    RedirectButton diseaseClsRd = RedirectButton(context, "Disease Classification", "/disease-classification-screen", boxMaxWidth: boxWidth, minWidth: boxWidth);
    List<Widget> menus = [
      Center(child: homeRd.build()),
      Center(child: diseaseClsRd.build())
    ];
    Widget mobile = MainScreen.verticalLayout(menus);
    Widget desktop = MainScreen.horizontalLayout(menus);
    return Center
      (
        child: MainScreen.responsiveWidget(context, mobile, desktop)
    );
  }

  double getBoxWidth(BuildContext context) {
    return DeepFarmUtils.isMobile(context) ? 500 : 400;
  }
}