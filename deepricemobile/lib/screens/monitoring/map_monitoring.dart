import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../utils/utils.dart';
import 'package:http/http.dart' as http;

import '../home/header/main_header.dart';
import '../home/landing/service_component.dart';
import '../main_screen.dart';
import 'monitoring_section.dart';

class MapMonitoringScreen extends MainScreen {
  MapMonitoringScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MapMonitoringScreenStateManager();
}

class _MapMonitoringScreenStateManager extends State<MapMonitoringScreen> {
  bool showDetails = false;
  int? selectedReportId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MainHeader(),
        body: SingleChildScrollView(
          // child: DroneReportsList(),
          child: showDetails ?
          MonitoringSection(potoId: selectedReportId!)
              :
          MapMonitoring(
            reportId: selectedReportId, // Passer l'ID sélectionné
            onBack: (poto_id) => {
              setState(() {
                showDetails = true; // Afficher le détail
                selectedReportId = poto_id; // Stocker l'ID sélectionné
              })
            }, // Revenir à la liste
          )
          ,
        )
    );
  }

}

class MapMonitoring extends StatefulWidget{
  final int? reportId; // ID du rapport sélectionné
  final Function(int reportId) onBack;
  MapMonitoring({required this.reportId, required this.onBack, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MapMonitoringState();
}

class _MapMonitoringState extends State<MapMonitoring> {
  Map<String, dynamic>? droneReportData ={
    "potos": [],
    "land": {
      "title": "",
      "boundary": [],
      "parcels": []
    }
  };

  @override
  void initState() {
    super.initState();
    fetchDroneReport();
  }

  Future<void> fetchDroneReport() async {
    try {
      var baseUrl = DeepFarmUtils.baseUrl();
      var landId = 1;
      final url = '$baseUrl/monitoring/${landId}'; // Remplacez par votre URL
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          droneReportData = jsonDecode(response.body); // Parse JSON
        });
      } else {
        print('Erreur : ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur de connexion : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.reportId);
    Map service = {
      'title': 'Sensor Data Monitoring',
      'link' : '/monitoring/map',
      'illustration' : 'images/landing/services/monitoring.png',
      'shortDescription' : 'A dedicated monitoring system that provides real-time visualization of sensor data collected from rice fields.'
    };
    ServiceInfo info = ServiceInfo(service['illustration'], service['shortDescription'], service['link'], service['title']);
    return Column(
      children: [
        Column(
          children: [
            // ServiceImageSection(info, isDetail: true,),
            const SizedBox(height: 30,),
            ServiceDetailsSection(info, isDetail: true,),
            // DiseaseImagePickerSection()
            SizedBox(
              height: 400, // Donnez une hauteur explicite à la carte
              child: MapScreen(
                parcels: droneReportData!["land"]["parcels"], // Passe les parcelles
                boundary: droneReportData!["land"]["boundary"],
                images: droneReportData!["potos"],
                onBack: widget.onBack// Passe les limites globales
              ),
            ),
          ],
        )
      ],
    );
  }
}

class MapScreen extends StatelessWidget {
  final LatLng initialLocation = LatLng(-19.022337,  47.531865 );
  final LatLng markerLocation = LatLng(-19.022337,  47.531865);
  final List<dynamic> parcels; // Liste des parcelles
  final List<dynamic> boundary; // Limites globales du terrain
  final List<dynamic> images;
  final Function(int reportId) onBack;

  MapScreen({required this.parcels, required this.boundary, required this.images, required this.onBack});

  void viewMore(int id) {
    print("clicked");
    onBack(id);
  }

  @override
  Widget build(BuildContext context) {
    // Convertir les limites globales en LatLng
    var opacity = 0.5;
    var bordColor = Colors.white.withOpacity(opacity);
    List<LatLng> boundaryPoints = boundary
        .map((coord) => LatLng(coord[1], coord[0])) // Inverser [long, lat] -> [lat, long]
        .toList();

    // Convertir les parcelles en objets Polygon
    List<Polygon> parcelPolygons = parcels.map((parcel) {
      List<LatLng> points = (parcel["boundary"] as List)
          .map((coord) => LatLng(coord[1], coord[0]))
          .toList();
      return Polygon(
        points: points,
        color: bordColor,
        borderColor: bordColor,
        borderStrokeWidth: 2.0,
      );
    }).toList();
    parcelPolygons.add(
      Polygon(
        points: boundaryPoints,
        color: bordColor,
        borderColor: bordColor,
        borderStrokeWidth: 3.0,
      ),
    );
    List<Marker> imageMarkers = images.map((image) {
      final location = image["location"];
      final LatLng point = LatLng(location["latitude"], location["longitude"]);
      final String imageClass = image["title"]; // Par exemple "Brownspot", "Blast", etc.
      // final String probability = (image["probability"] * 100).toStringAsFixed(1); // Probabilité en pourcentage
      return Marker(
        width: 150.0,
        height: 80.0,
        point: point,
        builder: (ctx) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => viewMore(image["id"]),
          child: SizedBox(
            width: 60, // Largeur suffisante pour détecter le tap
            height: 60,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "$imageClass",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const Icon(
                  Icons.settings_input_antenna,
                  color: Colors.green,
                  size: 30,
                ),
              ],
            )
          ),
        )
      );
    }).toList();
    return FlutterMap(
      options: MapOptions(
        center: initialLocation, // Latitude/Longitude (Paris, France)
        zoom: 17.0,
      ),
      children: [
        TileLayer(
          // urlTemplate:
          // "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            urlTemplate: "https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
            subdomains: ['a', 'b', 'c']
        ),
        PolygonLayer(
          polygons: parcelPolygons,
        ),
        MarkerLayer(
          markers: imageMarkers,
        ),
      ],
    );
  }
}