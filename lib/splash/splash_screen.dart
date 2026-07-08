import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get/get.dart';
import 'package:marketingapp/dashboard/screen/dashboard_screen.dart';
import 'package:marketingapp/login/screen/login_screen.dart';
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

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  String? version;
  String? buildNumber;

  late AnimationController _controller;
  late Animation<double> _logoFade;
  late Animation<double> _logoScale;
  late Animation<double> _versionFade;
  late Animation<Offset> _versionSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _logoFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    );

    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _versionFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
    );

    _versionSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    getVersionName();
    Future.delayed(const Duration(seconds: 3), () {
      navigateToNextScreen();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            child: FadeTransition(
              opacity: _logoFade,
              child: ScaleTransition(
                scale: _logoScale,
                child: Image.asset(
                  FlavorConfig.instance.variables['aapLogo'],
                  width: 300,
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: true,
            top: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FadeTransition(
                opacity: _versionFade,
                child: SlideTransition(
                  position: _versionSlide,
                  child: CustomText(
                      text: (version != null) ? "Version : $version" : '',
                      fontSize: 16,
                      fontFam: 'Nunito Sans',
                      fontWeight: FontWeight.normal,
                      textColor: AppColor.black,
                      textAlign: TextAlign.center),
                ),
              ),
            ).paddingOnly(bottom: 8),
          )
        ],
      ),
    );
  }
}
