import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get/get.dart';
import 'package:marketingapp/dashboard/dashboard_screen.dart';
import 'package:marketingapp/login/login_screen.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/utils/session_manager.dart';
import 'package:marketingapp/widgets/custom_text.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? version;

  String? buildNumber;

  @override
  void initState() {
    getVersionName();
    Future.delayed(const Duration(seconds: 3), () {
      navigateToNextScreen();
    });

    super.initState();
  }

  getVersionName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
    setState(() {});
  }

  void navigateToNextScreen() async {
    bool isLogin = await SessionManager().isLoggedIn();

    if (isLogin) {
      // Get.off(() => const DashboardScreen());
      Get.offNamed(DashboardScreen.routeName);
    } else {
      Get.off(() => const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Image.asset(
              FlavorConfig.instance.variables['aapLogo'],
              width: 300,
            ),
          ),
          SafeArea(
            bottom: true,
            top: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: CustomText(
                  text: (version != null) ? "Version : $version" : '',
                  fontSize: 16,
                  fontFam: 'Nunito Sans',
                  fontWeight: FontWeight.normal,
                  textColor: AppColor.black,
                  textAlign: TextAlign.center),
            ).paddingOnly(bottom: 8),
          )
        ],
      ),
    );
  }
}
