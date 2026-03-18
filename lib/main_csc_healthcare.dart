import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get/get.dart';
import 'package:marketingapp/login/login_controller.dart';

import 'myapp.dart';

void main() {

  FlavorConfig(
      name: "CSC HealthCare",
      color: const Color(0xff1156A6),
      location: BannerLocation.bottomStart,
      variables: {
        "baseUrl": "https://diagnostics.cschealthcare.in/webservice/LifenityLab.asmx", //prod url
        "baseUrl1": "https://diagnostics.cschealthcare.in/webservice/LifenityLabMarketing.asmx", //prod url
        "baseUrl2": "https://diagnostics.cschealthcare.in/webservice/Handler",

        // "baseUrl": "https://betadiagnostics.cschealthcare.in/WebService/LifenityLab.asmx", //dev url
        // "baseUrl1": "https://betadiagnostics.cschealthcare.in/webservice/LifenityLabMarketing.asmx", //dev url
        // "baseUrl2": "https://betadiagnostics.cschealthcare.in/WEBSERVICE/Handler",//dev url
        "aapLogo": "assets/csc_logo.png",
        "secondaryColor": "0xff09B6AE",
        "slider1": "assets/cscbanner1.png",
        "slider2": "assets/cscbanner2.png",
        "slider3": "assets/cscbanner3.png",
        "slider4": "assets/cscbanner4.png"
      });
  Get.put(LoginController());
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//
//       title: FlavorConfig.instance.name ?? "",
//       theme: ThemeData(
//         colorScheme:
//             ColorScheme.fromSeed(seedColor: AppColor.primaryBackgroundColor),
//         useMaterial3: true,
//       ),
//       home: const SplashScreen(),
//       builder: EasyLoading.init(),
//     );
//   }
// }
