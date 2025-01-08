import 'package:deepricemobile/widgets/button/button_listener.dart';
import 'package:deepricemobile/widgets/button/margin_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/utils.dart';

class ServiceList extends StatelessWidget {
  final List<Map> services = [
    {
      'title': 'Disease detection',
      'link' : '/disease-detection',
      'illustration' : 'images/landing/services/disease-detection.jpg',
      'shortDescription' : 'Disease classification identifies and categorizes plant diseases to improve diagnosis and treatment. It helps farmers protect crops effectively.'
    },
    {
      'title': 'Drone Reports',
      'link' : '/drone-reports',
      'illustration' : 'images/landing/services/drone-reports.jpg',
      'shortDescription' : 'Drone reports capture high-resolution images of rice fields, analyze plant health, and detect diseases. The data is processed to identify infected areas and generate a map highlighting affected parcels, enabling precise and efficient interventions for farmers.'
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20,0, 20),
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: Column(
        children: services.map((service) {
            ServiceInfo info = ServiceInfo(service['illustration'], service['shortDescription'], service['link'], service['title']);
            return ServiceComponent(info);
          }).toList(),
      )
    );
  }

}

class ServiceComponent extends StatelessWidget{
  final ServiceInfo service;
  const ServiceComponent(this.service, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(30, 15, 30, 15),
      // padding: configPadding(),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 4,
            blurRadius: 6,
            offset: const Offset(0, 3)
          )
        ]
      ),
      child: Column(
        children: [
          ServiceImageSection(service),
          ServiceDetailsSection(service),
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

class ServiceDetailsSection extends StatelessWidget {
  final ServiceInfo service;
  late bool isDetail = false;

  ServiceDetailsSection(this.service, {bool isDetail=false}) {
    this.isDetail = isDetail;
  }

  void redirect(BuildContext context) {
    Navigator.pushNamed(context, service.link);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 20),
              Expanded(
                child: Text(service.title, style: GoogleFonts.nunito(
                  fontSize: 18.6,
                  fontWeight: FontWeight.w800,
                  color: DeepFarmUtils.greenColor
                ))
              ),
              if (!isDetail)
                MaterialButton(
                  shape: CircleBorder(),
                  onPressed: (){
                    redirect(context);
                  },
                  color: DeepFarmUtils.greenColor,
                  padding: EdgeInsets.all(12.5),
                  child: Icon(Icons.touch_app, size: 30, color: Colors.white,)
                ),
              const SizedBox(width: 20)
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 20),
              Expanded(
                  child: Text(service.shortDescription, style: GoogleFonts.nunito(
                    fontSize: 14.6,
                  ))
              ),
              const SizedBox(width: 20)
            ],
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

}

class ServiceImageSection extends StatelessWidget {
  late ServiceInfo service;
  late bool isDetail = false;

  ServiceImageSection(this.service, {bool isDetail=false}) {
    this.isDetail = isDetail;
  }

  double borderRadiusValue() {
    return isDetail? 0 : 18;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isDetail? 250 : 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(borderRadiusValue()),
            topRight: Radius.circular(borderRadiusValue()),
          ),
          image: DecorationImage(
              image: AssetImage(service.illustration),
              fit: BoxFit.cover
          )
      ),
      child: Stack(
        children: [
        ],
      ),
    );
  }

}

class ServiceAccessButton extends CustomMarginButton {
  ServiceAccessButton(super.label, super.callback) {
    boxMaxWidth = double.infinity;
    minWidth = double.infinity;
    margin = 0;
    height = 30;
  }

}

class ServiceAccessListener extends ButtonListener {
  @override
  void onClick() {

  }

}

class ServiceInfo {
  late String illustration;
  late String shortDescription;
  late String link;
  late String title;

  ServiceInfo(this.illustration, this.shortDescription, this.link, this.title);
}