import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:marketingapp/dashboard/dashboard_screen.dart';
import 'package:marketingapp/dashboard/my_visits_screen.dart';
import 'package:marketingapp/login/login_controller.dart';
import 'package:marketingapp/splash/splash_screen.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'add_visit/add_visit_punch_out_screen.dart';
import 'add_visit/add_visit_start_route_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: GetMaterialApp(
        title: FlavorConfig.instance.name ?? "",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primaryBackgroundColor),
          useMaterial3: true,
        ),
        initialRoute: SplashScreen.routeName,
        builder: EasyLoading.init(),
        initialBinding: LoginBinding(),
        getPages: [
          GetPage(name: SplashScreen.routeName, page: () => SplashScreen()),
          GetPage(name: DashboardScreen.routeName, page: () => DashboardScreen()),
          GetPage(name: MyVisitsScreen.routeName, page: () => MyVisitsScreen()),
          GetPage(name: AddVisitStartRouteScreen.routeName, page: () => AddVisitStartRouteScreen()),
          GetPage(name: AddVisitPunchOutScreen.routeName, page: () => AddVisitPunchOutScreen()),
        ],
      ),
    );
  }
}

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}