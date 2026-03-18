import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get/get.dart';
import 'package:marketingapp/login/login_controller.dart';

import 'myapp.dart';

void main() {
  FlavorConfig(
      name: "HindLab Operational",
      color: const Color(0xff401F6E),
      location: BannerLocation.bottomStart,
      variables: {
        "baseUrl": "https://myhindlab.com/WebService/HindLab.asmx",
        //prod url
        "baseUrl1": "https://myhindlab.com/WebService/HindLabMarketing.asmx",
        //prod url
        "baseUrl2": "https://myhindlab.com/WebService/Handler",

        // "baseUrl": "https://test.myhindlab.com/Webservice/HindLab.asmx",
        // //dev url
        // "baseUrl1":
        //     "https://test.myhindlab.com/Webservice/HindLabMarketing.asmx",
        // //dev url
        // "baseUrl2": "https://test.myhindlab.com/Webservice/Handler",
        // //dev url

        "aapLogo": "assets/hindlab_logo.png",
        "secondaryColor": "0xff7342B7",
        "slider1": "assets/banner1.png",
        "slider2": "assets/banner2.png",
        "slider3": "assets/banner3.png",
        "slider4": "assets/banner2.png"
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
