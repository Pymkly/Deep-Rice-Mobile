import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/utils.dart';
import '../../home/landing/service_component.dart';
import 'package:http/http.dart' as http;

class DroneReportsList extends StatefulWidget{
  final Function(int reportId) onReportSelected;
  DroneReportsList({required this.onReportSelected, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DroneReportsListState();
}

class _DroneReportsListState extends State<DroneReportsList> {
  List<dynamic> reports = []; // Liste des rapports
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReports(); // Récupère les rapports au démarrage
  }

  Future<void> fetchReports() async {
    try {

      var baseUrl = DeepFarmUtils.baseUrl();
      final response = await http.get(Uri.parse('$baseUrl/drone-reports'));

      if (response.statusCode == 200) {
        setState(() {
          reports = jsonDecode(response.body); // Parse le JSON
          isLoading = false; // Arrête le chargement
        });
      } else {
        throw Exception('Erreur lors de la récupération des rapports');
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Arrête le chargement même en cas d'erreur
      });
      print('Erreur : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Map service = {
      'title': 'Drone Reports',
      'link' : '/disease-detection',
      'illustration' : 'images/landing/services/drone-reports.jpg',
      'shortDescription' : 'Drone reports capture high-resolution images of rice fields, analyze plant health, and detect diseases. The data is processed to identify infected areas and generate a map highlighting affected parcels, enabling precise and efficient interventions for farmers.'
    };
    ServiceInfo info = ServiceInfo(service['illustration'], service['shortDescription'], service['link'], service['title']);
    return
        Column(
          children: [
            ServiceImageSection(info, isDetail: true,),
            const SizedBox(height: 30,),
            ServiceDetailsSection(info, isDetail: true,),
            // DiseaseImagePickerSection()
            Container(
              child: Column(
                children: [
                  Text("Drone Reports List", style: GoogleFonts.nunito(
                      fontSize: 18.6,
                      fontWeight: FontWeight.w800,
                      color: DeepFarmUtils.greenColor
                    )
                  )
                ]
              )
            ),
            SizedBox(
                height: 300, // Définissez la hauteur que vous voulez
                child: ListView.builder(
                itemCount: reports.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final report = reports[index];
                  final reportId = report[0];
                  final reportDate = report[1];
                  final description = report[2];
                  final createdAt = report[3];

                  return ListTile(
                    title: Text("Rapport #$reportId - $reportDate", style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w800,
                      fontSize: 14.6,
                    )),
                    subtitle: Text(description,  style: GoogleFonts.nunito(
                      fontSize: 12.6
                    )),
                    trailing: Text(createdAt.split('T')[0]), // Affiche uniquement la date
                    onTap: () => widget.onReportSelected(reportId), // Signale l'ID sélectionné
                  );
                },
              )
            )
          ],
    );
  }
}