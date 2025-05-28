import 'package:deepricemobile/screens/home/landing/separator.dart';
import 'package:deepricemobile/screens/home/landing/service_component.dart';
import 'package:deepricemobile/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../monitoring/monitoring_section.dart';
import 'banner.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomBanner(),
        const SizedBox(height: 20),
        // MonitoringSection(),
        const SizedBox(height: 20),
        CustomSectionSeparator(DeepFarmUtils.extractENV("BANNER_OFFERS_SEPARATOR")),
        const SizedBox(height: 20),
        ServiceList()
      ],
    );
  }
}

