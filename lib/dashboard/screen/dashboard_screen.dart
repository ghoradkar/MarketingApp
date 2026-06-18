import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get/get.dart';
import 'package:marketingapp/dashboard/controller/my_visit_controller.dart';
import 'package:marketingapp/dashboard/screen/my_visits_screen.dart';
import 'package:marketingapp/dashboard/screen/pluscare_and_lifenity_dash.dart';
import 'package:marketingapp/dashboard/screen/uae_dash.dart';
import 'package:marketingapp/login/login_controller.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/utils/shared_pref_constants.dart';
import 'package:marketingapp/utils/shared_preference.dart';
import 'package:marketingapp/widgets/common_svg.dart';
import 'package:marketingapp/widgets/custom_drawer.dart';
import 'package:marketingapp/widgets/custom_text.dart';
import 'package:marketingapp/widgets/dash_card.dart';
import 'package:marketingapp/widgets/image_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:upgrader/upgrader.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final upgrader = Get.find<Upgrader>();
  final LoginController loginController = Get.find<LoginController>();
  final MyVisitControllerController myVisitControllerController = Get.put(
    MyVisitControllerController(),
  );
  Map<String, dynamic>? userData;
  String? designation;
  String? desig;
  String? version;
  String? buildNumber;

  // bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      upgrader: upgrader,
      showIgnore: false,
      showLater: false,
      showReleaseNotes: false,
      barrierDismissible: false,
      shouldPopScope: () => false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  FlavorConfig.instance.name == "HindLab Operational"
                      ? AppColor.primaryBackgroundColor.withValues(alpha: 0.1)
                      : AppColor.primaryBackgroundColor.withValues(alpha: 0.3),
                  FlavorConfig.instance.name == 'Lifenity Operational'
                      ? AppColor.white
                      : AppColor.secondaryColor.withValues(alpha: 0.3),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          title: appBarTitle(FlavorConfig.instance.name!),
          centerTitle: false,
          leading: Builder(
            builder: (BuildContext context) {
              return InkWell(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: CommonSvg(
                  path: 'assets/menu.svg',
                  width: 26,
                  height: 26,
                  parentWidth: 30,
                  parentHeight: 30,
                  color: AppColor.black,
                ),
              );
            },
          ),
        ),
        drawer: CustomDrawer(
          userData: userData ?? {},
          version: version,
          buildNumber: buildNumber,
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    // if (isLoading) {
    //   return const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }

    if (hasError) {
      return _buildErrorWidget();
    }

    return GetBuilder<LoginController>(
      init: loginController,
      builder: (controller) {
        return Column(
          children: [
            // Show offline banner if no internet (non-blocking)
            if (!loginController.hasInternet) _buildOfflineBanner(),

            // Image carousel
            ImageCarouselWithIndicator(list: getSliderImages())
                .paddingOnly(bottom: 4),

            // Main content
            Expanded(
              child: (desig == null || controller.isDashLoading)
                  ? _buildSkeletonBody()
                  : getWidgetBasedOnType(
                      FlavorConfig.instance.name!, desig!),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOfflineBanner() {
    return Container(
      width: double.infinity,
      color: AppColor.orange.withValues(alpha: 0.5),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Icon(Icons.wifi_off, color: AppColor.orange, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: CustomText(
                text: "No internet connection",
                fontSize: 14,
                fontFam: "Nunito Sans",
                fontWeight: FontWeight.normal,
                textColor: AppColor.black.withValues(alpha: 0.5),
                textAlign: TextAlign.start),
          ),
          TextButton(
              onPressed: () {
                _initializeDashboard();
              },
              child: CustomText(
                  text: "Retry",
                  fontSize: 14,
                  fontFam: "Nunito Sans",
                  fontWeight: FontWeight.bold,
                  textColor: AppColor.black,
                  textAlign: TextAlign.start)),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            CustomText(
                text: "Something went wrong",
                fontSize: 18,
                fontFam: "Nunito Sans",
                fontWeight: FontWeight.normal,
                textColor: AppColor.black,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            CustomText(
                text: "Unable to load dashboard",
                fontSize: 14,
                fontFam: "Nunito Sans",
                fontWeight: FontWeight.normal,
                textColor: AppColor.black.withValues(alpha: 0.5),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                _initializeDashboard();
              },
              icon: const Icon(Icons.refresh),
              label: CustomText(
                  text: "Retry",
                  fontSize: 14,
                  fontFam: "Nunito Sans",
                  fontWeight: FontWeight.normal,
                  textColor: AppColor.black,
                  textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonBody() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DashCardCounts(
                isLoading: true,
                secondCountFontSize: 14.sp,
                secondCountTextFontSize: 12.sp,
                iconPath: 'assets/patients.svg',
                cardHeight: 80.h,
              ).paddingSymmetric(vertical: 8.h, horizontal: 8.w),
            ),
            Expanded(
              child: DashCardCounts(
                isLoading: true,
                secondCountFontSize: 14.sp,
                secondCountTextFontSize: 12.sp,
                iconPath: 'assets/testtube.svg',
                cardHeight: 80.h,
              ).paddingSymmetric(vertical: 8.h, horizontal: 10.w),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: DashCardCounts(
                isLoading: true,
                secondCountFontSize: 14.sp,
                secondCountTextFontSize: 12.sp,
                iconPath: 'assets/customer.svg',
                cardHeight: 80.h,
              ).paddingSymmetric(vertical: 8.h, horizontal: 10.w),
            ),
            Expanded(
              child: DashCardCounts(
                isLoading: true,
                secondCountFontSize: 14.sp,
                secondCountTextFontSize: 12.sp,
                iconPath: 'assets/labs.svg',
                cardHeight: 80.h,
              ).paddingSymmetric(vertical: 8.h, horizontal: 10.w),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: DashCard(
                isLoading: true,
                backGroundColorIcon: AppColor.secondaryColor,
                secondCountFontSize: 18.sp,
                secondCountTextFontSize: 14.sp,
                iconPath: 'assets/addvisit.svg',
                cardHeight: 80.h,
                onTap: () {},
              ).paddingSymmetric(vertical: 8.h, horizontal: 10.w),
            ),
            Expanded(
              child: DashCard(
                isLoading: true,
                backGroundColorIcon: AppColor.secondaryColor,
                secondCountFontSize: 18.sp,
                secondCountTextFontSize: 14.sp,
                iconPath: 'assets/activeclient.svg',
                cardHeight: 80.h,
                onTap: () {},
              ).paddingSymmetric(vertical: 8.h, horizontal: 10.w),
            ),
          ],
        ),
      ],
    );
  }


  List<SliderImage> getSliderImages() {
    final sliderImages = <SliderImage>[];

    FlavorConfig.instance.variables.forEach((key, value) {
      if (key.startsWith('slider') && value is String && value.isNotEmpty) {
        sliderImages.add(SliderImage(value));
      }
    });

    sliderImages.sort((a, b) {
      int extractNumber(String s) =>
          int.tryParse(RegExp(r'\d+').stringMatch(s) ?? '0') ?? 0;
      return extractNumber(a.img).compareTo(extractNumber(b.img));
    });

    return sliderImages;
  }

  Widget getWidgetBasedOnType(String type, String designation) {
    switch (type) {
      case 'PlusCare Operational':
        return PlusCareAndLifenityDash(
          designation: designation,
          myVisitsCallB: () {
            Get.toNamed(
              MyVisitsScreen.routeName,
              arguments: {
                'appBarTitle': (designation == "Manager" ||
                        designation == "Lab Sales Manager")
                    ? "Visit Dashboard"
                    : 'My Visits',
              },
            );
          },
        );

      case 'Lifenity International':
        return UAEDash(designation: designation);

      case 'CSC HealthCare':
        return PlusCareAndLifenityDash(
          designation: designation,
          myVisitsCallB: () {
            Get.toNamed(
              MyVisitsScreen.routeName,
              arguments: {
                'appBarTitle': (designation == "Manager" ||
                        designation == "Lab Sales Manager")
                    ? "Visit Dashboard"
                    : 'My Visits',
              },
            );
          },
        );
      // return HindLabDash(
      //   designation: designation,
      //   myVisitsCallB: () {
      //     Get.toNamed(
      //       MyVisitsScreen.routeName,
      //       arguments: {
      //         'appBarTitle': (designation == "Manager" ||
      //                 designation == "Lab Sales Manager")
      //             ? "Visit Dashboard"
      //             : 'My Visits',
      //       },
      //     );
      //   },
      // );

      case 'Lifenity Operational':
        return PlusCareAndLifenityDash(
          designation: designation,
          myVisitsCallB: () {
            Get.toNamed(
              MyVisitsScreen.routeName,
              arguments: {
                'appBarTitle': (designation == "Manager" ||
                        designation == "Lab Sales Manager")
                    ? "Visit Dashboard"
                    : 'My Visits',
              },
            );
          },
        );

      case 'HindLab Operational':
        return PlusCareAndLifenityDash(
          designation: designation,
          myVisitsCallB: () {
            Get.toNamed(
              MyVisitsScreen.routeName,
              arguments: {
                'appBarTitle': (designation == "Manager" ||
                        designation == "Lab Sales Manager")
                    ? "Visit Dashboard"
                    : 'My Visits',
              },
            );
          },
        );

      // return HindLabDash(
      //   designation: designation,
      //   myVisitsCallB: () {
      //     Get.toNamed(
      //       MyVisitsScreen.routeName,
      //       arguments: {
      //         'appBarTitle': (designation == "Manager" ||
      //                 designation == "Lab Sales Manager")
      //             ? "Visit Dashboard"
      //             : 'My Visits',
      //       },
      //     );
      //   },
      // );

      default:
        return CustomText(
          text: 'Dashboard Not Found',
          fontSize: 18,
          fontWeight: FontWeight.w500,
          textColor: AppColor.black,
          textAlign: TextAlign.right,
          fontFam: 'Nunito Sans',
        );
    }
  }

  Widget appBarTitle(String type) {
    switch (type) {
      case 'Lifenity International':
        return CustomText(
          text: 'Lifenity',
          fontSize: 18,
          fontWeight: FontWeight.w500,
          textColor: AppColor.black,
          textAlign: TextAlign.right,
          fontFam: 'Nunito Sans',
        );

      case 'CSC HealthCare':
        return Image.asset('assets/csc_text_logo.png', width: 100);

      case 'PlusCare Operational':
        return Image.asset('assets/icon_toolbar_logo.png');

      case 'Lifenity Operational':
        return CustomText(
          text: 'Lifenity',
          fontSize: 18,
          fontWeight: FontWeight.w500,
          textColor: AppColor.black,
          textAlign: TextAlign.right,
          fontFam: 'Nunito Sans',
        );

      case 'HindLab Operational':
        return Image.asset('assets/hindlab_operational_logo.png', width: 30);

      default:
        return CustomText(
          text: '',
          fontSize: 18,
          fontWeight: FontWeight.w500,
          textColor: AppColor.black,
          textAlign: TextAlign.right,
          fontFam: 'Nunito Sans',
        );
    }
  }

  Future<void> _initializeDashboard() async {
    setState(() {
      // isLoading = true;
      hasError = false;
    });

    try {
      // Always load user data from SharedPreferences first (works offline)
      await getUserData();
      await getVersionName();

      // Check internet connectivity
      await checkInternetAndLoadData();
    } catch (e) {
      debugPrint("Dashboard initialization error: $e");
      setState(() {
        hasError = true;
      });
    }
    // finally {
    //   setState(() {
    //     isLoading = false;
    //   });
    // }
  }

  Future<void> checkInternetAndLoadData() async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await Connectivity().checkConnectivity();

      if (connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi)) {
        loginController.hasInternet = true;

        // Try to fetch fresh data from API
        if (loginController.hasInternet) {
          await fetchLocation();

          // Only fetch dashboard count if needed
          if ([
            "HindLab Operational",
            "PlusCare Operational",
            "CSC HealthCare",
            "Lifenity Operational"
          ].contains(FlavorConfig.instance.name)) {
            try {
              await loginController.getMainDashCount();
            } catch (e) {
              debugPrint("Failed to fetch dashboard count: $e");
              // Don't block UI if this fails
            }
          }
        }
      } else {
        loginController.hasInternet = false;
        debugPrint("No internet connection");
      }
    } catch (e) {
      debugPrint("Connectivity check error: $e");
      loginController.hasInternet = false;
    }

    setState(() {});
  }

  Future<void> getVersionName() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
      debugPrint("version.....$version$buildNumber");
    } catch (e) {
      debugPrint("Error getting version: $e");
      version = "1.0.0";
      buildNumber = "1";
    }
  }

  Future<void> getUserData() async {
    try {
      userData = await SharedPref().read(const SharedPrefConstant().kUserData);
      final output = userData?['output'];

      if (output is List && output.isNotEmpty) {
        desig = output[0]['Designation'];
        debugPrint("User designation: $desig");
      } else {
        debugPrint("No user data found in output");
      }
    } catch (e) {
      debugPrint("Error reading user data: $e");
      // Don't throw error, just log it
    }
  }

  Future<void> fetchLocation() async {
    try {
      await myVisitControllerController.getLocation();
    } catch (e) {
      debugPrint("Error fetching location: $e");
      // Don't block UI if location fails
    }
  }
}

class SliderImage {
  String img;

  SliderImage(this.img);
}
