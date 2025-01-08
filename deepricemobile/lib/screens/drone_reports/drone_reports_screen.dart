import 'package:deepricemobile/screens/drone_reports/menu/drone_report_detail.dart';
import 'package:deepricemobile/screens/home/header/main_header.dart';
import 'package:deepricemobile/screens/main_screen.dart';
import 'package:flutter/material.dart';

import 'menu/drone_reports_list.dart';


class DroneReportsScreen extends MainScreen {
  DroneReportsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DroneReportsScreenStateManager();
}

class _DroneReportsScreenStateManager extends State<DroneReportsScreen> {
  bool showDetails = false;
  int? selectedReportId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MainHeader(),
        body: SingleChildScrollView(
          // child: DroneReportsList(),
          child: showDetails
          ? DroneReportDetail(
            reportId: selectedReportId, // Passer l'ID sélectionné
            onBack: () => setState(() => showDetails = false), // Revenir à la liste
          )
          : DroneReportsList(
            onReportSelected: (reportId) {
              setState(() {
                showDetails = true; // Afficher le détail
                selectedReportId = reportId; // Stocker l'ID sélectionné
              });
            },
          ),
        )
    );
  }

}

