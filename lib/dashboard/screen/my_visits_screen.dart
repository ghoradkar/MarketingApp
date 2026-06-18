import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get/get.dart';
import 'package:marketingapp/add_client/screen/add_client_screen.dart';
import 'package:marketingapp/add_visit/screen/add_visit_start_route_screen.dart';
import 'package:marketingapp/dashboard/controller/my_visit_controller.dart';
import 'package:marketingapp/todays_visit/controller/todays_visit_controller.dart';
import 'package:marketingapp/todays_visit/screen/todays_visit_details.dart';
import 'package:marketingapp/todays_visit/screen/todays_visit_screen.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/utils/shared_pref_constants.dart';
import 'package:marketingapp/utils/shared_preference.dart';
import 'package:marketingapp/widgets/common_svg.dart';
import 'package:marketingapp/widgets/custom_text.dart';
import 'package:marketingapp/widgets/dash_card.dart';
import 'package:marketingapp/widgets/dropdown_search.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../model/district_list_model.dart';

class MyVisitsScreen extends StatefulWidget {
  static const routeName = '/my-visits';

  const MyVisitsScreen({super.key});

  @override
  State<MyVisitsScreen> createState() => _MyVisitsScreenState();
}

class _MyVisitsScreenState extends State<MyVisitsScreen> {
  var appBarTitle = '';

  final MyVisitControllerController myVisitControllerController =
      Get.find<MyVisitControllerController>();

  final TodaysVisitController todaysVisitController =
      Get.put(TodaysVisitController());

  Map<String, dynamic>? userData;
  String? selectedDist = "All";
  DistrictOutput? selectedDistObj;

  // bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    appBarTitle = args['appBarTitle'];
    _initializeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyVisitControllerController>(
        init: myVisitControllerController,
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColor.primaryBackgroundColor.withValues(alpha: 0.3),
                        FlavorConfig.instance.name == 'Lifenity Operational'
                            ? AppColor.white
                            : AppColor.secondaryColor.withValues(alpha: 0.3)
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
                title: CustomText(
                  text: appBarTitle,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  textColor: AppColor.black,
                  textAlign: TextAlign.right,
                  fontFam: 'Nunito Sans',
                ),
                leading: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_back))),
            body: _buildBody(controller),
          );
        });
  }

  Future<void> _initializeScreen() async {
    setState(() {
      // isLoading = true;
      hasError = false;
    });

    try {
      // Always load user data from SharedPreferences first (works offline)
      await getUserData();

      // Check internet and fetch fresh data
      await checkInternetAndLoadData();
    } catch (e) {
      debugPrint("Screen initialization error: $e");
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

  Future<void> getUserData() async {
    try {
      userData = await SharedPref().read(const SharedPrefConstant().kUserData);
      debugPrint("User data loaded from SharedPreferences");
    } catch (e) {
      debugPrint("Error reading user data: $e");
      // Don't throw error, just log it
    }
  }

  Future<void> checkInternetAndLoadData() async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await Connectivity().checkConnectivity();

      if (connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi)) {
        myVisitControllerController.hasInternet = true;

        // Try to fetch fresh data from API
        if (myVisitControllerController.hasInternet && userData != null) {
          await fetchDashboardData();
        }
      } else {
        myVisitControllerController.hasInternet = false;
        debugPrint("No internet connection");
      }
    } catch (e) {
      debugPrint("Connectivity check error: $e");
      myVisitControllerController.hasInternet = false;
    }

    myVisitControllerController.update();
    setState(() {});
  }

  Future<void> fetchDashboardData() async {
    myVisitControllerController.isVisitLoading = true;
    myVisitControllerController.update();
    try {
      if (userData?['output']?[0]?['Designation'] == "Manager" ||
          userData?['output']?[0]?['Designation'] == "Lab Sales Manager") {
        await myVisitControllerController.getDashCount(
            "0",
            userData!['output'][0]['EmpCode'].toString(),
            FlavorConfig.instance.name!);

        await myVisitControllerController.getMonthlyTarget(
            "0", userData!['output'][0]['EmpCode'].toString());

        await myVisitControllerController
            .getDistrictList(userData!['output'][0]['STATELGDCODE'].toString());
      } else {
        await myVisitControllerController.getMonthlyTarget(
            userData!['output'][0]['DISTLGDCODE'].toString(),
            userData!['output'][0]['EmpCode'].toString());
      }
      myVisitControllerController.update();
    } catch (e) {
      debugPrint("Error fetching dashboard data: $e");
    } finally {
      myVisitControllerController.isVisitLoading = false;
      myVisitControllerController.update();
    }
  }

  Widget _buildBody(MyVisitControllerController controller) {
    // if (isLoading) {
    //   return const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }

    if (hasError) {
      return _buildErrorWidget();
    }

    if (controller.isVisitLoading) {
      return _buildSkeletonContent();
    }

    if (userData == null) {
      return _buildNoDataWidget();
    }

    return Column(
      children: [
        // Show offline banner if no internet (non-blocking)
        if (!controller.hasInternet) _buildOfflineBanner(),

        // Main content
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Visibility(
                  visible:
                      userData?['output']?[0]?['Designation'] == "Manager" ||
                          userData?['output']?[0]?['Designation'] ==
                              "Lab Sales Manager",
                  child: DropDownSearch(
                    selectedItem: selectedDist,
                    labelText:
                        (FlavorConfig.instance.name == "HindLab Operational" ||
                                FlavorConfig.instance.name ==
                                    "PlusCare Operational" ||
                                FlavorConfig.instance.name ==
                                    "Lifenity Operational" ||
                                FlavorConfig.instance.name == "CSC HealthCare")
                            ? 'District'
                            : "Emirates",
                    items: [
                      "All",
                      ...(controller.districtRespModel?.output
                              ?.map((e) => e.distname ?? '') ??
                          [])
                    ],
                    hint: '',
                    isRequired: true,
                    senValue: (value) async {
                      if (!controller.hasInternet) {
                        _showOfflineMessage();
                        return;
                      }

                      selectedDist = value;
                      myVisitControllerController.isVisitLoading = true;
                      myVisitControllerController.update();
                      try {
                        if (selectedDist == "All") {
                          await myVisitControllerController.getDashCount(
                              "0",
                              userData!['output'][0]['EmpCode'].toString(),
                              FlavorConfig.instance.name!);

                          await myVisitControllerController.getMonthlyTarget(
                              "0",
                              userData!['output'][0]['EmpCode'].toString());
                        } else {
                          selectedDistObj = controller.districtRespModel?.output
                              ?.firstWhere((e) => e.distname == value);

                          await myVisitControllerController.getDashCount(
                              selectedDistObj!.distlgdcode.toString(),
                              userData!['output'][0]['EmpCode'].toString(),
                              FlavorConfig.instance.name!);

                          await myVisitControllerController.getMonthlyTarget(
                              selectedDistObj!.distlgdcode.toString(),
                              userData!['output'][0]['EmpCode'].toString());
                        }
                      } finally {
                        myVisitControllerController.isVisitLoading = false;
                        myVisitControllerController.update();
                      }
                    },
                    filledColor: AppColor.white,
                    prefixIcon: Icon(
                      Icons.location_on_outlined,
                      color: AppColor.secondaryColor,
                    ),
                  ).paddingOnly(left: 10,right: 10),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Monthly Business\nTarget",
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          textColor: AppColor.black,
                          textAlign: TextAlign.start,
                          fontFam: 'Nunito Sans',
                        ),
                        Expanded(
                          flex: 3,
                          child: CustomText(
                            text: selectedDist == "All"
                                ? controller
                                    .getSumDouble(
                                        controller.monthlyBTarget?.output,
                                        'salesTarget')
                                    .toStringAsFixed(0)
                                : controller.monthlyBTarget?.output?.first
                                        .salesTarget
                                        ?.toInt()
                                        .toString() ??
                                    "0",
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            textColor: AppColor.black,
                            textAlign: TextAlign.center,
                            fontFam: 'Nunito Sans',
                          ),
                        ),
                        Center(
                          child: FlavorConfig.instance.name ==
                                  'Lifenity International'
                              ? CustomText(
                                  text: "د.إ",
                                  fontSize: 22,
                                  fontFam: "",
                                  fontWeight: FontWeight.bold,
                                  textColor: AppColor.black,
                                  textAlign: TextAlign.center,
                                )
                              : const Icon(
                                  Icons.currency_rupee,
                                  size: 26,
                                ),
                        ),
                      ],
                    ),
                  ),
                ).paddingOnly(top: 10, left: 8, right: 8, bottom: 8),
                ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: VisitDashCardCounts(
                            onClicked: () {
                              if (!controller.hasInternet) {
                                _showOfflineMessage();
                                return;
                              }

                              if (userData?['output']?[0]?['Designation'] ==
                                      "Manager" ||
                                  userData?['output']?[0]?['Designation'] ==
                                      "Lab Sales Manager") {
                                Get.to(TodaysVisitScreen(
                                  selectedDistrictId: selectedDist != "All"
                                      ? selectedDistObj!.distlgdcode.toString()
                                      : '0',
                                ));
                              } else if (userData?['output']?[0]
                                      ?['Designation'] ==
                                  "Marketing Executive") {
                                Get.to(const TodaysVisitDetails(
                                  todaysVisitItem: null,
                                ));
                              }
                            },
                            isTodaysVisit: true,
                            secondCountFontSize: 20,
                            secondCountTextFontSize: 14,
                            secondCount: (userData?['output']?[0]
                                            ?['Designation'] ==
                                        "Manager" ||
                                    userData?['output']?[0]?['Designation'] ==
                                        "Lab Sales Manager")
                                ? (selectedDist == "All"
                                    ? controller
                                        .getSumCount(
                                            controller.dashCountModel?.output,
                                            'todaysVisit')
                                        .toString()
                                    : controller.dashCountModel?.output?.first
                                            .todaysVisit
                                            .toString() ??
                                        "0")
                                : (selectedDist == "All"
                                    ? controller
                                        .getSumCount(
                                            controller.monthlyBTarget?.output,
                                            'todaysVisit')
                                        .toString()
                                    : controller.monthlyBTarget?.output?.first
                                            .todaysVisit
                                            .toString() ??
                                        '0'),
                            secondCountText: "Today's\nVisits",
                            iconPath: 'assets/addvisit.svg',
                            cardHeight: 100,
                            cardColor: const Color(0x80D5B3FF),
                          ).paddingSymmetric(vertical: 8, horizontal: 10),
                        ),
                        Expanded(
                          child: VisitDashCardCounts(
                            cardColor: const Color(0x80FFB3BA),
                            secondCountFontSize: 20,
                            secondCountTextFontSize: 14,
                            secondCount: (userData?['output']?[0]
                                            ?['Designation'] ==
                                        "Manager" ||
                                    userData?['output']?[0]?['Designation'] ==
                                        "Lab Sales Manager")
                                ? (selectedDist == "All"
                                    ? controller
                                        .getSumCount(
                                            controller.dashCountModel?.output,
                                            'totalVisit')
                                        .toString()
                                    : controller.dashCountModel?.output?.first
                                            .totalVisit
                                            .toString() ??
                                        "0")
                                : (selectedDist == "All"
                                    ? controller
                                        .getSumCount(
                                            controller.monthlyBTarget?.output,
                                            'totalVisit')
                                        .toString()
                                    : controller.monthlyBTarget?.output?.first
                                            .totalVisit
                                            .toString() ??
                                        '0'),
                            secondCountText: "Total\nVisits",
                            iconPath: 'assets/customer.svg',
                            cardHeight: 100,
                          ).paddingSymmetric(vertical: 8, horizontal: 10),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: VisitDashCardCounts(
                            cardColor: const Color(0x80FFDFBA),
                            secondCountFontSize: 20,
                            secondCountTextFontSize: 13,
                            secondCount: (userData?['output']?[0]
                                            ?['Designation'] ==
                                        "Manager" ||
                                    userData?['output']?[0]?['Designation'] ==
                                        "Lab Sales Manager")
                                ? (selectedDist == "All"
                                    ? controller
                                        .getSumCount(
                                            controller.dashCountModel?.output,
                                            'prospectiveClient')
                                        .toString()
                                    : controller.dashCountModel?.output?.first
                                            .prospectiveClient
                                            .toString() ??
                                        "0")
                                : (selectedDist == "All"
                                    ? controller
                                        .getSumCount(
                                            controller.monthlyBTarget?.output,
                                            'prospectiveClient')
                                        .toString()
                                    : controller.monthlyBTarget?.output?.first
                                            .prospectiveClient
                                            .toString() ??
                                        '0'),
                            secondCountText: "Prospective\nClients",
                            iconPath: 'assets/patients.svg',
                            cardHeight: 100,
                          ).paddingSymmetric(vertical: 8, horizontal: 10),
                        ),
                        Expanded(
                          child: VisitDashCardCounts(
                            cardColor: const Color(0x80FFFFBA),
                            secondCountFontSize: 20,
                            secondCountTextFontSize: 14,
                            secondCount: (userData?['output']?[0]
                                            ?['Designation'] ==
                                        "Manager" ||
                                    userData?['output']?[0]?['Designation'] ==
                                        "Lab Sales Manager")
                                ? (selectedDist == "All"
                                    ? controller
                                        .getSumCount(
                                            controller.dashCountModel?.output,
                                            'activeClient')
                                        .toString()
                                    : controller.dashCountModel?.output?.first
                                            .activeClient
                                            .toString() ??
                                        "0")
                                : (selectedDist == "All"
                                    ? controller
                                        .getSumCount(
                                            controller.monthlyBTarget?.output,
                                            'activeClient')
                                        .toString()
                                    : controller.monthlyBTarget?.output?.first
                                            .activeClient
                                            .toString() ??
                                        '0'),
                            secondCountText: "Active\nClients",
                            iconPath: 'assets/activeclient.svg',
                            cardHeight: 100,
                          ).paddingSymmetric(vertical: 8, horizontal: 10),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: VisitDashCardCounts(
                            cardColor: const Color(0x80BAFFC9),
                            secondCountFontSize: 20,
                            secondCountTextFontSize: 14,
                            secondCount: (userData?['output']?[0]
                                            ?['Designation'] ==
                                        "Manager" ||
                                    userData?['output']?[0]?['Designation'] ==
                                        "Lab Sales Manager")
                                ? (selectedDist == "All"
                                    ? controller
                                        .getSumCount(
                                            controller.dashCountModel?.output,
                                            'inActiveClient')
                                        .toString()
                                    : controller.dashCountModel?.output?.first
                                            .inActiveClient
                                            .toString() ??
                                        "0")
                                : (selectedDist == "All"
                                    ? controller
                                        .getSumCount(
                                            controller.monthlyBTarget?.output,
                                            'inActiveClient')
                                        .toString()
                                    : controller.monthlyBTarget?.output?.first
                                            .inActiveClient
                                            .toString() ??
                                        '0'),
                            secondCountText: "Inactive\nClients",
                            iconPath: 'assets/inactive.svg',
                            cardHeight: 100,
                          ).paddingSymmetric(vertical: 8, horizontal: 10),
                        ),
                        Expanded(
                          child: VisitDashCardCounts(
                            cardColor: const Color(0x80BAE1FF),
                            secondCountFontSize: 20,
                            secondCountTextFontSize: 14,
                            secondCount: (userData?['output']?[0]
                                            ?['Designation'] ==
                                        "Manager" ||
                                    userData?['output']?[0]?['Designation'] ==
                                        "Lab Sales Manager")
                                ? (selectedDist == "All"
                                    ? controller
                                        .getSumCount(
                                            controller.dashCountModel?.output,
                                            'closedClient')
                                        .toString()
                                    : controller.dashCountModel?.output?.first
                                            .closedClient
                                            .toString() ??
                                        "0")
                                : (selectedDist == "All"
                                    ? controller
                                        .getSumCount(
                                            controller.monthlyBTarget?.output,
                                            'closedClient')
                                        .toString()
                                    : controller.monthlyBTarget?.output?.first
                                            .closedClient
                                            .toString() ??
                                        '0'),
                            secondCountText: "Closed\nClients",
                            iconPath: 'assets/closeclient.svg',
                            cardHeight: 100,
                          ).paddingSymmetric(vertical: 8, horizontal: 10),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ).paddingSymmetric(horizontal: 10),
          ),
        ),

        // Bottom action bar
        SafeArea(
          bottom: true,
          top: false,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.primaryBackgroundColor,
                  AppColor.secondaryColor,
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    if (!controller.hasInternet) {
                      _showOfflineMessage();
                      return;
                    }
                    Get.toNamed(AddVisitStartRouteScreen.routeName);
                  },
                  child: Row(
                    children: [
                      CommonSvg(
                        path: "assets/addvisit.svg",
                        width: 32,
                        height: 32,
                        parentWidth: 32,
                        parentHeight: 32,
                        color: AppColor.white,
                      ).paddingOnly(right: 6),
                      CustomText(
                        text: 'Add Visit',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        textColor: AppColor.white,
                        textAlign: TextAlign.right,
                        fontFam: 'Nunito Sans',
                      )
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  width: 1.5,
                  color: AppColor.white,
                ),
                InkWell(
                  onTap: () {
                    if (!controller.hasInternet) {
                      _showOfflineMessage();
                      return;
                    }
                    Get.to(const AddClientScreen());
                  },
                  child: Row(
                    children: [
                      CommonSvg(
                        path: "assets/addclient.svg",
                        width: 32,
                        height: 32,
                        parentWidth: 32,
                        parentHeight: 32,
                        color: AppColor.white,
                      ).paddingOnly(right: 6),
                      CustomText(
                        text: 'Add Client',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        textColor: AppColor.white,
                        textAlign: TextAlign.right,
                        fontFam: 'Nunito Sans',
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSkeletonContent() {
    final cardColors = [
      const Color(0x80D5B3FF),
      const Color(0x80FFB3BA),
      const Color(0x80FFDFBA),
      const Color(0x80FFFFBA),
      const Color(0x80BAFFC9),
      const Color(0x80BAE1FF),
    ];
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Dropdown skeleton
                Shimmer(
                  colorOpacity: 0.6,
                  duration: const Duration(seconds: 2),
                  direction: const ShimmerDirection.fromLeftToRight(),
                  child: Container(
                    height: 56,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ).paddingOnly(left: 10,right: 10),
                ),
                // Monthly target card skeleton
                Shimmer(
                  colorOpacity: 0.6,
                  duration: const Duration(seconds: 2),
                  direction: const ShimmerDirection.fromLeftToRight(),
                  child: Container(
                    height: 72,
                    margin: const EdgeInsets.only(
                        top: 10, left: 8, right: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                // Stat cards skeleton (3 rows of 2)
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (_, row) => Row(
                    children: [
                      Expanded(
                        child: _buildSkeletonStatCard(cardColors[row * 2])
                            .paddingSymmetric(vertical: 8, horizontal: 10),
                      ),
                      Expanded(
                        child: _buildSkeletonStatCard(cardColors[row * 2 + 1])
                            .paddingSymmetric(vertical: 8, horizontal: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: 10),
          ),
        ),
        // Bottom bar skeleton
        SafeArea(
          bottom: true,
          top: false,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.primaryBackgroundColor.withValues(alpha: 0.8),
                  AppColor.secondaryColor.withValues(alpha: 0.8),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Shimmer(
                  colorOpacity: 0.3,
                  duration: const Duration(seconds: 2),
                  direction: const ShimmerDirection.fromLeftToRight(),
                  child: Container(
                    width: 120,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                Container(height: 40, width: 1.5, color: AppColor.white),
                Shimmer(
                  colorOpacity: 0.3,
                  duration: const Duration(seconds: 2),
                  direction: const ShimmerDirection.fromLeftToRight(),
                  child: Container(
                    width: 120,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonStatCard(Color cardColor) {
    return Shimmer(
      colorOpacity: 0.6,
      duration: const Duration(seconds: 2),
      direction: const ShimmerDirection.fromLeftToRight(),
      child: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: cardColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 34,
              height: 34,
              margin: const EdgeInsets.only(right: 20, left: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 20,
                    margin: const EdgeInsets.only(bottom: 10, left: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 14,
                    margin: const EdgeInsets.only(left: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
                text: "No internet connection. Showing cached data.",
                fontSize: 14,
                fontFam: "Nunito Sans",
                fontWeight: FontWeight.normal,
                textColor: AppColor.black.withValues(alpha: 0.5),
                textAlign: TextAlign.start),
          ),
          TextButton(
              onPressed: () {
                _initializeScreen();
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
                text: "Unable to load visit data",
                fontSize: 14,
                fontFam: "Nunito Sans",
                fontWeight: FontWeight.normal,
                textColor: AppColor.black.withValues(alpha: 0.5),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                _initializeScreen();
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

  Widget _buildNoDataWidget() {
    return Center(
      child: Padding(padding: EdgeInsets.all(24.0), child: Container()
          // CustomText(
          //     text: "No user data available",
          //     fontSize: 16,
          //     fontFam: "Nunito Sans",
          //     fontWeight: FontWeight.normal,
          //     textColor: AppColor.black.withValues(alpha: 0.5),
          //     textAlign: TextAlign.center),
          ),
    );
  }

  void _showOfflineMessage() {
    Get.snackbar(
      'Offline Mode',
      'This action requires internet connection',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.orange.withValues(alpha: 0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(10),
    );
  }
}

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_flavor/flutter_flavor.dart';
// import 'package:get/get.dart';
// import 'package:marketingapp/add_client/add_client_screen.dart';
// import 'package:marketingapp/add_visit/add_visit_start_route_screen.dart';
// import 'package:marketingapp/dashboard/my_visit_controller.dart';
// import 'package:marketingapp/todays_visit/todays_visit_controller.dart';
// import 'package:marketingapp/todays_visit/todays_visit_details.dart';
// import 'package:marketingapp/todays_visit/todays_visit_screen.dart';
// import 'package:marketingapp/utils/color_constants.dart';
// import 'package:marketingapp/utils/shared_pref_constants.dart';
// import 'package:marketingapp/utils/shared_preference.dart';
// import 'package:marketingapp/widgets/common_svg.dart';
// import 'package:marketingapp/widgets/custom_text.dart';
// import 'package:marketingapp/widgets/dash_card.dart';
// import 'package:marketingapp/widgets/dropdown_search.dart';
// import 'package:marketingapp/widgets/no_internet_connectivity.dart';
//
// import 'model/district_list_model.dart';
//
// class MyVisitsScreen extends StatefulWidget {
//   static const routeName = '/my-visits';
//
//   const MyVisitsScreen({super.key});
//
//   @override
//   State<MyVisitsScreen> createState() => _MyVisitsScreenState();
// }
//
// class _MyVisitsScreenState extends State<MyVisitsScreen> {
//   var appBarTitle = '';
//
//   final MyVisitControllerController myVisitControllerController =
//   Get.find<MyVisitControllerController>();
//
//   final TodaysVisitController todaysVisitController =
//   Get.put(TodaysVisitController());
//
//   var userData;
//
//   String? selectedDist = "All";
//
//   DistrictOutput? selectedDistObj;
//
//   @override
//   void initState() {
//     final args = Get.arguments as Map<String, dynamic>;
//     appBarTitle = args['appBarTitle'];
//     checkInternetAndLoadData();
//     super.initState();
//   }
//
//   Future<void> getUserData() async {
//     userData = await SharedPref().read(const SharedPrefConstant().kUserData);
//
//     if (userData?['output']?[0]?['Designation'] == "Manager") {
//       await myVisitControllerController.getDashCount(
//           "0",
//           userData['output'][0]['EmpCode'].toString(),
//           FlavorConfig.instance.name!);
//
//       await myVisitControllerController.getMonthlyTarget(
//           "0", userData['output'][0]['EmpCode'].toString());
//
//       await myVisitControllerController
//           .getDistrictList(userData['output'][0]['STATELGDCODE'].toString());
//
//       myVisitControllerController.update();
//     } else {
//       await myVisitControllerController.getMonthlyTarget(
//           userData['output'][0]['DISTLGDCODE'].toString(),
//           userData['output'][0]['EmpCode'].toString());
//
//       myVisitControllerController.update();
//     }
//   }
//
//   checkInternetAndLoadData() async {
//     final List<ConnectivityResult> connectivityResult =
//     await (Connectivity().checkConnectivity());
//     if (connectivityResult.contains(ConnectivityResult.mobile) ||
//         connectivityResult.contains(ConnectivityResult.wifi)) {
//       myVisitControllerController.hasInternet = true;
//     } else {
//       myVisitControllerController.hasInternet = false;
//     }
//     myVisitControllerController.update();
//     if (myVisitControllerController.hasInternet) {
//       await getUserData();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<MyVisitControllerController>(
//         init: myVisitControllerController,
//         builder: (controller) {
//           return Scaffold(
//               appBar: AppBar(
//                   flexibleSpace: Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           AppColor.primaryBackgroundColor
//                               .withValues(alpha: 0.3),
//                           FlavorConfig.instance.name == 'Lifenity Operational'
//                               ? AppColor.white
//                               : AppColor.secondaryColor.withValues(alpha: 0.3)
//                         ],
//                         // Change colors as needed
//                         begin: Alignment.centerLeft,
//                         end: Alignment.centerRight,
//                       ),
//                     ),
//                   ),
//                   title: CustomText(
//                     text: appBarTitle,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w500,
//                     textColor: AppColor.black,
//                     textAlign: TextAlign.right,
//                     fontFam: 'Nunito Sans',
//                   ),
//                   leading: IconButton(
//                       onPressed: () {
//                         Get.back();
//                       },
//                       icon: const Icon(Icons.arrow_back))),
//               body: controller.hasInternet
//                   ? Column(
//                 children: [
//                   Expanded(
//                     child: SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           Visibility(
//                             visible: userData?['output']?[0]
//                             ?['Designation'] ==
//                                 "Manager",
//                             child: DropDownSearch(
//                               selectedItem: selectedDist,
//                               labelText: (FlavorConfig.instance.name ==
//                                   "HindLab Operational" ||
//                                   FlavorConfig.instance.name ==
//                                       "PlusCare Operational" ||
//                                   FlavorConfig.instance.name ==
//                                       "Lifenity Operational" ||
//                                   FlavorConfig.instance.name ==
//                                       "CSC HealthCare")
//                                   ? 'District'
//                                   : "Emirates",
//                               items: [
//                                 "All",
//                                 ...(controller.districtRespModel?.output
//                                     ?.map((e) => e.distname ?? '') ??
//                                     [])
//                               ],
//                               hint: '',
//                               isRequired: true,
//                               senValue: (value) async {
//                                 selectedDist = value;
//                                 if (selectedDist == "All") {
//                                   await myVisitControllerController
//                                       .getDashCount(
//                                       "0",
//                                       userData['output'][0]['EmpCode']
//                                           .toString(),
//                                       FlavorConfig.instance.name!);
//
//                                   await myVisitControllerController
//                                       .getMonthlyTarget(
//                                       "0",
//                                       userData['output'][0]['EmpCode']
//                                           .toString());
//                                 } else {
//                                   selectedDistObj = controller
//                                       .districtRespModel?.output
//                                       ?.firstWhere(
//                                           (e) => e.distname == value);
//
//                                   await myVisitControllerController
//                                       .getDashCount(
//                                       selectedDistObj!.distlgdcode
//                                           .toString(),
//                                       userData['output'][0]['EmpCode']
//                                           .toString(),
//                                       FlavorConfig.instance.name!);
//
//                                   await myVisitControllerController
//                                       .getMonthlyTarget(
//                                       selectedDistObj!.distlgdcode
//                                           .toString(),
//                                       userData['output'][0]['EmpCode']
//                                           .toString());
//                                 }
//                                 controller.update();
//                               },
//                               filledColor: AppColor.white,
//                               prefixIcon: Icon(
//                                 Icons.location_on_outlined,
//                                 color: AppColor.secondaryColor,
//                               ),
//                             ),
//                           ),
//
//
//                           Card(
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 20, horizontal: 12),
//                               child: Row(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.center,
//                                 children: [
//                                   CustomText(
//                                     text: "Monthly Business\nTarget",
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.normal,
//                                     textColor: AppColor.black,
//                                     textAlign: TextAlign.start,
//                                     fontFam: 'Nunito Sans',
//                                   ),
//                                   Expanded(
//                                     flex: 3,
//                                     child: CustomText(
//                                       text: selectedDist == "All"
//                                           ? controller
//                                           .getSumDouble(
//                                           controller
//                                               .monthlyBTarget
//                                               ?.output,
//                                           'salesTarget')
//                                           .toStringAsFixed(0)
//                                           : controller
//                                           .monthlyBTarget
//                                           ?.output
//                                           ?.first
//                                           .salesTarget
//                                           ?.toInt()
//                                           .toString() ??
//                                           "0",
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                       textColor: AppColor.black,
//                                       textAlign: TextAlign.center,
//                                       fontFam: 'Nunito Sans',
//                                     ),
//                                   ),
//                                   Center(
//                                     child: FlavorConfig.instance.name ==
//                                         'Lifenity International'
//                                         ? CustomText(
//                                       text: "د.إ",
//                                       fontSize: 22,
//                                       fontFam: "",
//                                       fontWeight: FontWeight.bold,
//                                       textColor: AppColor.black,
//                                       textAlign: TextAlign.center,
//                                     )
//                                         : const Icon(
//                                       Icons.currency_rupee,
//                                       size: 26,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ).paddingOnly(
//                               top: 10, left: 8, right: 8, bottom: 8),
//                           ListView(
//                             physics: const NeverScrollableScrollPhysics(),
//                             // Disable inner scrolling
//                             shrinkWrap: true,
//                             children: [
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: VisitDashCardCounts(
//                                       onClicked: () {
//                                         if (userData?['output']?[0]
//                                         ?['Designation'] ==
//                                             "Manager") {
//                                           Get.to(TodaysVisitScreen(
//                                             selectedDistrictId:
//                                             selectedDist != "All"
//                                                 ? selectedDistObj!
//                                                 .distlgdcode
//                                                 .toString()
//                                                 : '0',
//                                           ));
//                                         } else if (userData?['output']?[0]
//                                         ?['Designation'] ==
//                                             "Marketing Executive") {
//                                           Get.to(const TodaysVisitDetails(
//                                             todaysVisitItem: null,
//                                           ));
//                                         }
//                                       },
//                                       isTodaysVisit: true,
//                                       secondCountFontSize: 20,
//                                       secondCountTextFontSize: 14,
//                                       secondCount: userData?['output']?[0]
//                                       ?['Designation'] ==
//                                           "Manager"
//                                           ? (selectedDist == "All"
//                                           ? controller
//                                           .getSumCount(
//                                           controller
//                                               .dashCountModel
//                                               ?.output,
//                                           'todaysVisit')
//                                           .toString()
//                                           : controller
//                                           .dashCountModel
//                                           ?.output
//                                           ?.first
//                                           .todaysVisit
//                                           .toString() ??
//                                           "0")
//                                           : (selectedDist == "All"
//                                           ? controller
//                                           .getSumCount(
//                                           controller
//                                               .monthlyBTarget
//                                               ?.output,
//                                           'todaysVisit')
//                                           .toString()
//                                           : controller
//                                           .monthlyBTarget
//                                           ?.output
//                                           ?.first
//                                           .todaysVisit
//                                           .toString() ??
//                                           '0'),
//                                       secondCountText: "Today's\nVisits",
//                                       iconPath: 'assets/addvisit.svg',
//                                       cardHeight: 100,
//                                       cardColor: const Color(0x80D5B3FF),
//                                     ).paddingSymmetric(
//                                         vertical: 8, horizontal: 10),
//                                   ),
//                                   Expanded(
//                                     child: VisitDashCardCounts(
//                                       cardColor: const Color(0x80FFB3BA),
//                                       secondCountFontSize: 20,
//                                       secondCountTextFontSize: 14,
//                                       secondCount: userData?['output']?[0]
//                                       ?['Designation'] ==
//                                           "Manager"
//                                           ? (selectedDist == "All"
//                                           ? controller
//                                           .getSumCount(
//                                           controller
//                                               .dashCountModel
//                                               ?.output,
//                                           'totalVisit')
//                                           .toString()
//                                           : controller
//                                           .dashCountModel
//                                           ?.output
//                                           ?.first
//                                           .totalVisit
//                                           .toString() ??
//                                           "0")
//                                           : (selectedDist == "All"
//                                           ? controller
//                                           .getSumCount(
//                                           controller
//                                               .monthlyBTarget
//                                               ?.output,
//                                           'totalVisit')
//                                           .toString()
//                                           : controller
//                                           .monthlyBTarget
//                                           ?.output
//                                           ?.first
//                                           .totalVisit
//                                           .toString() ??
//                                           '0'),
//                                       secondCountText: "Total\nVisits",
//                                       iconPath: 'assets/customer.svg',
//                                       cardHeight: 100,
//                                     ).paddingSymmetric(
//                                         vertical: 8, horizontal: 10),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: VisitDashCardCounts(
//                                       cardColor: const Color(0x80FFDFBA),
//                                       secondCountFontSize: 20,
//                                       secondCountTextFontSize: 13,
//                                       secondCount: userData?['output']?[0]
//                                       ?['Designation'] ==
//                                           "Manager"
//                                           ? (selectedDist == "All"
//                                           ? controller
//                                           .getSumCount(
//                                           controller
//                                               .dashCountModel
//                                               ?.output,
//                                           'prospectiveClient')
//                                           .toString()
//                                           : controller
//                                           .dashCountModel
//                                           ?.output
//                                           ?.first
//                                           .prospectiveClient
//                                           .toString() ??
//                                           "0")
//                                           : (selectedDist == "All"
//                                           ? controller
//                                           .getSumCount(
//                                           controller
//                                               .monthlyBTarget
//                                               ?.output,
//                                           'prospectiveClient')
//                                           .toString()
//                                           : controller
//                                           .monthlyBTarget
//                                           ?.output
//                                           ?.first
//                                           .prospectiveClient
//                                           .toString() ??
//                                           '0'),
//                                       secondCountText:
//                                       "Prospective\nClients",
//                                       iconPath: 'assets/patients.svg',
//                                       cardHeight: 100,
//                                     ).paddingSymmetric(
//                                         vertical: 8, horizontal: 10),
//                                   ),
//                                   Expanded(
//                                     child: VisitDashCardCounts(
//                                       cardColor: const Color(0x80FFFFBA),
//                                       secondCountFontSize: 20,
//                                       secondCountTextFontSize: 14,
//                                       secondCount: userData?['output']?[0]
//                                       ?['Designation'] ==
//                                           "Manager"
//                                           ? (selectedDist == "All"
//                                           ? controller
//                                           .getSumCount(
//                                           controller
//                                               .dashCountModel
//                                               ?.output,
//                                           'activeClient')
//                                           .toString()
//                                           : controller
//                                           .dashCountModel
//                                           ?.output
//                                           ?.first
//                                           .activeClient
//                                           .toString() ??
//                                           "0")
//                                           : (selectedDist == "All"
//                                           ? controller
//                                           .getSumCount(
//                                           controller
//                                               .monthlyBTarget
//                                               ?.output,
//                                           'activeClient')
//                                           .toString()
//                                           : controller
//                                           .monthlyBTarget
//                                           ?.output
//                                           ?.first
//                                           .activeClient
//                                           .toString() ??
//                                           '0'),
//                                       secondCountText: "Active\nClients",
//                                       iconPath: 'assets/activeclient.svg',
//                                       cardHeight: 100,
//                                     ).paddingSymmetric(
//                                         vertical: 8, horizontal: 10),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: VisitDashCardCounts(
//                                       cardColor: const Color(0x80BAFFC9),
//                                       secondCountFontSize: 20,
//                                       secondCountTextFontSize: 14,
//                                       secondCount: userData?['output']?[0]
//                                       ?['Designation'] ==
//                                           "Manager"
//                                           ? (selectedDist == "All"
//                                           ? controller
//                                           .getSumCount(
//                                           controller
//                                               .dashCountModel
//                                               ?.output,
//                                           'inActiveClient')
//                                           .toString()
//                                           : controller
//                                           .dashCountModel
//                                           ?.output
//                                           ?.first
//                                           .inActiveClient
//                                           .toString() ??
//                                           "0")
//                                           : (selectedDist == "All"
//                                           ? controller
//                                           .getSumCount(
//                                           controller
//                                               .monthlyBTarget
//                                               ?.output,
//                                           'inActiveClient')
//                                           .toString()
//                                           : controller
//                                           .monthlyBTarget
//                                           ?.output
//                                           ?.first
//                                           .inActiveClient
//                                           .toString() ??
//                                           '0'),
//                                       secondCountText:
//                                       "Inactive\nClients",
//                                       iconPath: 'assets/inactive.svg',
//                                       cardHeight: 100,
//                                     ).paddingSymmetric(
//                                         vertical: 8, horizontal: 10),
//                                   ),
//                                   Expanded(
//                                     child: VisitDashCardCounts(
//                                       cardColor: const Color(0x80BAE1FF),
//                                       secondCountFontSize: 20,
//                                       secondCountTextFontSize: 14,
//                                       secondCount: userData?['output']?[0]
//                                       ?['Designation'] ==
//                                           "Manager"
//                                           ? (selectedDist == "All"
//                                           ? controller
//                                           .getSumCount(
//                                           controller
//                                               .dashCountModel
//                                               ?.output,
//                                           'closedClient')
//                                           .toString()
//                                           : controller
//                                           .dashCountModel
//                                           ?.output
//                                           ?.first
//                                           .closedClient
//                                           .toString() ??
//                                           "0")
//                                           : (selectedDist == "All"
//                                           ? controller
//                                           .getSumCount(
//                                           controller
//                                               .monthlyBTarget
//                                               ?.output,
//                                           'closedClient')
//                                           .toString()
//                                           : controller
//                                           .monthlyBTarget
//                                           ?.output
//                                           ?.first
//                                           .closedClient
//                                           .toString() ??
//                                           '0'),
//                                       secondCountText: "Closed\nClients",
//                                       iconPath: 'assets/closeclient.svg',
//                                       cardHeight: 100,
//                                     ).paddingSymmetric(
//                                         vertical: 8, horizontal: 10),
//                                   )
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ).paddingSymmetric(horizontal: 10),
//                     ),
//                   ),
//                   SafeArea(
//                     bottom: true,
//                     top: false,
//                     child: Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             AppColor.primaryBackgroundColor,
//                             AppColor.secondaryColor,
//                           ],
//                           begin: Alignment.topRight,
//                           end: Alignment.bottomLeft,
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               // Get.to(const AddVisitStartRouteScreen());
//                               Get.toNamed(
//                                   AddVisitStartRouteScreen.routeName);
//                             },
//                             child: Row(
//                               children: [
//                                 // Image.asset("assets/addvisit.png")
//                                 //     .paddingOnly(right: 6),
//                                 CommonSvg(
//                                   path: "assets/addvisit.svg",
//                                   width: 32,
//                                   height: 32,
//                                   parentWidth: 32,
//                                   parentHeight: 32,
//                                   color: AppColor.white,
//                                 ).paddingOnly(right: 6),
//                                 CustomText(
//                                   text: 'Add Visit',
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.normal,
//                                   textColor: AppColor.white,
//                                   textAlign: TextAlign.right,
//                                   fontFam: 'Nunito Sans',
//                                 )
//                               ],
//                             ),
//                           ),
//                           Container(
//                             height: 40,
//                             width: 1.5,
//                             color: AppColor.white,
//                           ),
//                           InkWell(
//                             onTap: () {
//                               Get.to(const AddClientScreen());
//                             },
//                             child: Row(
//                               children: [
//                                 // Image.asset("assets/addclient.png")
//                                 //     .paddingOnly(right: 6),
//                                 CommonSvg(
//                                   path: "assets/addclient.svg",
//                                   width: 32,
//                                   height: 32,
//                                   parentWidth: 32,
//                                   parentHeight: 32,
//                                   color: AppColor.white,
//                                 ).paddingOnly(right: 6),
//                                 CustomText(
//                                   text: 'Add Client',
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.normal,
//                                   textColor: AppColor.white,
//                                   textAlign: TextAlign.right,
//                                   fontFam: 'Nunito Sans',
//                                 )
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               )
//                   : InternetIssue(
//                 onRetryPressed: () {
//                   checkInternetAndLoadData();
//                 },
//               ));
//         });
//   }
//
//
// }
