import 'package:flutter/material.dart';

import 'banner.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CustomBanner()
      ],
    );
  }
}

