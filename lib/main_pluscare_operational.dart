import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get/get.dart';
import 'package:marketingapp/login/login_controller.dart';
import 'myapp.dart';

void main() {
  FlavorConfig(
      name: "PlusCare Operational",
      color: const Color(0xff1573AF),
      location: BannerLocation.bottomStart,
      variables: {
        // "baseUrl": "http://beta.pluscares.com/webservice/pluscare.asmx",
        // //dev url
        // "baseUrl1":
        //     "http://beta.pluscares.com/webservice/PlusCareMarketingApp.asmx",
        // //dev url
        // "baseUrl2": "http://beta.pluscares.com/WEBSERVICE/Handler",
        //dev url
        "baseUrl": "https://pluscare.org/webservice/PlusCare.asmx",
        //prod url
        "baseUrl1": "https://pluscare.org/webservice/PlusCareMarketingApp.asmx",
        //prod url
        "baseUrl2": "https://pluscare.org/webservice/Handler",
        //prod url
        "aapLogo": "assets/pluscare_logo.png",
        "secondaryColor": "0xffF46E3B",
        "slider1": "assets/bannerplus1.png",
        "slider2": "assets/bannerplus2.png",
        "slider3": "assets/bannerplus3.png",
        "slider4": "assets/bannerplus4.png"
      });
  Get.put(LoginController());
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
