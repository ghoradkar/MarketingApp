import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get/get.dart';
import 'package:marketingapp/login/login_controller.dart';
import 'package:upgrader/upgrader.dart';

import 'myapp.dart';
import 'utils/app_upgrader_messages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Upgrader.clearSavedSettings();
  Get.put(Upgrader(messages: AppUpgraderMessages()));
  FlavorConfig(
      name: "Lifenity Operational",
      color: const Color(0xFF24ABE3),
      location: BannerLocation.bottomStart,
      variables: {
        "baseUrl":
            "https://betadiagnostics.lifenitywellness.com/WEBSERVICE/LifenityLab.asmx",
        //dev url
        "baseUrl1":
            "https://betadiagnostics.lifenitywellness.com/WEBSERVICE/LifenityLabMarketing.asmx",
        "baseUrl2":
            "https://betadiagnostics.lifenitywellness.com/WEBSERVICE/Handler",
        //dev url
        // "baseUrl":
        //     "https://diagnostics.lifenitywellness.com/webservice/LifenityLab.asmx",
        // //prod url
        // "baseUrl1":
        //     "https://diagnostics.lifenitywellness.com/webservice/LifenityLabMarketing.asmx",
        // //prod url,
        // "baseUrl2":
        //     "https://diagnostics.lifenitywellness.com/webservice/Handler",
        "aapLogo": "assets/logo_uae.png",
        "secondaryColor": "0xFF04B35A",
        "slider1": "assets/bannerLifenityOpe1.png",
        "slider2": "assets/bannerLifenityOpe2.png",
      });
  Get.put(LoginController());
  runApp(const MyApp());
}
