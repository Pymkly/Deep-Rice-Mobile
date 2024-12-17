import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/utils.dart';
import '../../../widgets/button/margin_button.dart';
import '../../../widgets/custom_image_picker/custom_image_picker.dart';
import '../../home/landing/service_component.dart';
import 'disease_scan_listner.dart';

class DiseaseScanner extends StatefulWidget{
  const DiseaseScanner({super.key});

  @override
  State<StatefulWidget> createState() => _DiseaseScannerState();
}

class _DiseaseScannerState extends State<DiseaseScanner> {
  @override
  Widget build(BuildContext context) {
    Map service = {
      'link' : '/disease-detection',
      'illustration' : 'images/landing/services/disease-detection.jpg',
      'shortDescription' : 'Disease classification identifies and categorizes plant diseases to improve diagnosis and treatment. It helps farmers protect crops effectively.'
    };
    ServiceInfo info = ServiceInfo(service['illustration'], service['shortDescription'], service['link']);
    return Column(
      children: [
        Column(
          children: [
            ServiceImageSection(info, isDetail: true,),
            const SizedBox(height: 30,),
            ServiceDetailsSection(info, isDetail: true,),
            DiseaseImagePickerSection()
          ],
        )
      ],
    );
  }
}

class DiseaseImagePickerSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
            const SizedBox(width: 20),
              Expanded(
                  child: Text("Select or Capture an Image", style: GoogleFonts.nunito(
                      fontSize: 18.6,
                      fontWeight: FontWeight.w800,
                      color: DeepFarmUtils.greenColor
                  ))
              )
            ]
          ),
          ImagePickerScreen(),
          Container(
            // margin: EdgeInsets.only(left: 0),
            child: Row(
              children: [
                CustomMarginButton("Analyze Image", DiseaseScanListener()).build()
              ],
            ),
          )
        ],
      ),
    );
  }
}


