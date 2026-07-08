import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get/get.dart';
import 'package:marketingapp/login/controller/login_controller.dart';
import 'package:upgrader/upgrader.dart';

import 'myapp.dart';
import 'utils/app_upgrader_messages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Upgrader.clearSavedSettings();
  Get.put(Upgrader(messages: AppUpgraderMessages()));
  FlavorConfig(
      name: "Lifenity International",
      color: const Color(0xFF24ABE3),
      location: BannerLocation.bottomStart,
      variables: {
        // "baseUrl":
        //       "http://betaae.lifenitycare.com/webservice/UAEOpreational.asmx",//dev
        // "baseUrl1":
        //     "http://betaae.lifenitycare.com/webservice/UAEMarketingExApp.asmx",//dev
        "baseUrl":"https://registration.lifenity.ae/webservice/UAEOpreational.asmx",
        //prod
        "baseUrl1":
            "https://registration.lifenity.ae/webservice/UAEMarketingExApp.asmx",
        // prod
        "aapLogo": "assets/uae.png",
        "secondaryColor": "0xFF04B35A",
        "slider1": "assets/slider1.png",
        "slider2": "assets/slider2.png",
        "slider3": "assets/slider3.png",
        "slider4": "assets/slider4.png",
      },

    );
  Get.put(LoginController());
  runApp(const MyApp());
}
