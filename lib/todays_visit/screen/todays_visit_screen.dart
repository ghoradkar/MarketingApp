import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marketingapp/todays_visit/model/todays_visit_model.dart';
import 'package:marketingapp/todays_visit/controller/todays_visit_controller.dart';
import 'package:marketingapp/todays_visit/screen/todays_visit_details.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/utils/shared_pref_constants.dart';
import 'package:marketingapp/utils/shared_preference.dart';
import 'package:marketingapp/widgets/common_svg.dart';
import 'package:marketingapp/widgets/cust_table.dart';
import 'package:marketingapp/widgets/custom_button.dart';
import 'package:marketingapp/widgets/custom_text.dart';
import 'package:marketingapp/widgets/date_picker.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class TodaysVisitScreen extends StatefulWidget {
  final String? selectedDistrictId;

  const TodaysVisitScreen({super.key, this.selectedDistrictId});

  @override
  State<TodaysVisitScreen> createState() => _TodaysVisitScreenState();
}

class _TodaysVisitScreenState extends State<TodaysVisitScreen> {
  final TodaysVisitController todaysVisitController =
  Get.put(TodaysVisitController());

  Map<String, dynamic>? userData;
  // bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    setState(() {
      // isLoading = true;
      hasError = false;
    });

    try {
      // Always load user data from SharedPreferences first (works offline)
      await getUserData();

      // Check internet and load fresh data
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
      DateTime date = DateTime.now();
      todaysVisitController.formattedFromDate =
          DateFormat('yyyy-MM-dd').format(date);
      debugPrint("User data loaded from SharedPreferences");
    } catch (e) {
      debugPrint("Error reading user data: $e");
    }
  }

  Future<void> checkInternetAndLoadData() async {
    try {
      final List<ConnectivityResult> connectivityResult =
      await Connectivity().checkConnectivity();

      if (connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi)) {
        todaysVisitController.hasInternet = true;

        // Try to fetch fresh data from API
        if (todaysVisitController.hasInternet && userData != null) {
          await fetchVisitData();
        }
      } else {
        todaysVisitController.hasInternet = false;
        debugPrint("No internet connection");
      }
    } catch (e) {
      debugPrint("Connectivity check error: $e");
      todaysVisitController.hasInternet = false;
    }

    todaysVisitController.update();
    setState(() {});
  }

  Future<void> fetchVisitData() async {
    try {
      await todaysVisitController.getTodaysVisitList(
          widget.selectedDistrictId!,
          todaysVisitController.formattedFromDate!,
          userData!['output'][0]['EmpCode'].toString());
    } catch (e) {
      debugPrint("Error fetching visit data: $e");
      // Don't block UI if this fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    : AppColor.secondaryColor.withValues(alpha: 0.3)
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: CustomText(
          text: 'Customer Details',
          fontSize: 18,
          fontWeight: FontWeight.w500,
          textColor: AppColor.black,
          textAlign: TextAlign.start,
          fontFam: 'Nunito Sans',
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          CustomText(
            text: todaysVisitController.formattedFromDate ?? "",
            fontSize: 12,
            fontWeight: FontWeight.normal,
            textColor: AppColor.black,
            textAlign: TextAlign.start,
            fontFam: 'Nunito Sans',
          ),
          InkWell(
            onTap: () {
              if (!todaysVisitController.hasInternet) {
                _showOfflineMessage();
                return;
              }
              selectFromDate(context);
            },
            child: CommonSvg(
              path: "assets/calendar.svg",
              width: 30,
              height: 30,
              parentWidth: 30,
              parentHeight: 30,
              color: AppColor.primaryBackgroundColor,
            ).paddingOnly(left: 2, right: 8),
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (hasError) {
      return _buildErrorWidget();
    }

    return GetBuilder<TodaysVisitController>(
        init: todaysVisitController,
        builder: (controller) {
          if (controller.isTableLoading) {
            return _buildSkeletonTable();
          }

          if (userData == null) {
            return _buildNoDataWidget();
          }

          return Column(
            children: [
              if (!controller.hasInternet) _buildOfflineBanner(),
              controller.todaysVisitList != null
                  ? Expanded(
                      child: CustTable(
                        isClickable: true,
                        onCLick: (index) {
                          Get.to(TodaysVisitDetails(
                            todaysVisitItem: controller.todaysVisitList?[index],
                          ));
                        },
                        l1: List.generate(
                            controller.todaysVisitList?.length ?? 0,
                            (index) => (index + 1).toString()),
                        l2: controller.todaysVisitList
                                ?.map((e) => e.resourceName)
                                .toList() ??
                            [],
                        l3: controller.todaysVisitList
                                ?.map((e) => e.noOfVisit)
                                .toList() ??
                            [],
                        l4: controller.todaysVisitList
                                ?.map((e) => e.newCustomer)
                                .toList() ??
                            [],
                        tableHeader: const [
                          "Sr.\nNo",
                          "Resource\nName",
                          "No. of\nVisits",
                          "New\nCustomers"
                        ],
                      ).paddingOnly(left: 8, right: 8, top: 10),
                    )
                  : Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/nodata.png'),
                            const SizedBox(height: 20),
                            CustomText(
                                text: "Data Not Found",
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                textColor: AppColor.black,
                                textAlign: TextAlign.center,
                                fontFam: "Nunito Sans"),
                            const SizedBox(height: 20),
                            CustomText(
                                text: "Maybe go back and try different keyword?",
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                textColor: AppColor.borderGrey,
                                textAlign: TextAlign.center,
                                fontFam: "Nunito Sans"),
                            const SizedBox(height: 20),
                            CustomButton(
                              primColor: AppColor.primaryBackgroundColor,
                              secColor: AppColor.secondaryColor,
                              buttonText: "Ok",
                              path: 'assets/arrow_nav.svg',
                              callB: () {
                                Get.back();
                              },
                              textColor: Colors.white,
                              iconColor: Colors.white,
                              buttonFontSize: 16,
                              buttonWidth: 90,
                            )
                          ],
                        ),
                      ),
                    ),
            ],
          );
        });
  }

  Widget _buildSkeletonTable() {
    return Shimmer(
      colorOpacity: 0.6,
      duration: const Duration(seconds: 2),
      direction: const ShimmerDirection.fromLeftToRight(),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(2.8),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1.2),
          },
          children: [
            _skeletonHeaderRow(),
            for (int i = 0; i < 8; i++) _skeletonDataRow(),
          ],
        ),
      ),
    );
  }

  TableRow _skeletonHeaderRow() {
    return TableRow(
      children: List.generate(4, (index) {
        return TableCell(
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: AppColor.primaryBackgroundColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.only(
                topLeft: index == 0
                    ? const Radius.circular(10)
                    : Radius.zero,
                topRight: index == 3
                    ? const Radius.circular(10)
                    : Radius.zero,
              ),
            ),
            alignment: Alignment.center,
            child: Container(
              width: 40,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        );
      }),
    );
  }

  TableRow _skeletonDataRow() {
    return TableRow(
      children: List.generate(4, (index) {
        return TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Container(
            height: 60,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: Color(0xFFE0E0E0)),
                vertical: BorderSide(color: Color(0xFFE0E0E0)),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              width: double.infinity,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        );
      }),
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
                text: "No internet. Showing cached data.",
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
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Icon(Icons.warning_amber_rounded,
            //     size: 64, color: Colors.orange),
            // const SizedBox(height: 16),
            // CustomText(
            //     text: "No user data available",
            //     fontSize: 16,
            //     fontFam: "Nunito Sans",
            //     fontWeight: FontWeight.normal,
            //     textColor: AppColor.black.withValues(alpha: 0.5),
            //     textAlign: TextAlign.center),
          ],
        ),
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

  Widget cardDetails(String heading, String value, String path) {
    return Row(
      children: [
        SizedBox(
            width: 40,
            child: Image.asset(
              path,
              color: AppColor.primaryBackgroundColor,
            )),
        CustomText(
            text: "$heading : ",
            fontSize: 16,
            fontFam: "Nunito Sans",
            fontWeight: FontWeight.bold,
            textColor: Colors.black,
            textAlign: TextAlign.start),
        Expanded(
          child: CustomText(
              text: value,
              fontSize: 16,
              fontFam: "Nunito Sans",
              fontWeight: FontWeight.normal,
              textColor: Colors.black,
              textAlign: TextAlign.start),
        ),
      ],
    ).paddingOnly(top: 4, bottom: 4);
  }

  selectFromDate(context) async {
    if (!todaysVisitController.hasInternet) {
      _showOfflineMessage();
      return;
    }

    final DateTime? picked = await DatePickerHelper.selectDate(context);
    if (picked != null) {
      // Update the selected date
      todaysVisitController.selectedFromDate = picked;

      // Format the date as "yyyy-MM-dd"
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      todaysVisitController.formattedFromDate =
          formatter.format(todaysVisitController.selectedFromDate!);

      // Set the formatted date in the text field
      todaysVisitController.dateController.text =
      todaysVisitController.formattedFromDate!;
    }

    await todaysVisitController.getTodaysVisitList(
        widget.selectedDistrictId!,
        todaysVisitController.dateController.text,
        userData!['output'][0]['EmpCode'].toString());
    setState(() {});
  }
}

class CustomerVisitCard extends StatelessWidget {
  final Function? viewCallBack;
  final TodaysVisitOutput? todaysVisitItem;

  const CustomerVisitCard({super.key, this.viewCallBack, this.todaysVisitItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.4),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/user-square.png',
                color: AppColor.primaryBackgroundColor,
              ),
              const SizedBox(width: 10),
              const CustomText(
                  text: "Resource Name : ",
                  fontSize: 16,
                  fontFam: "Nunito Sans",
                  fontWeight: FontWeight.bold,
                  textColor: Colors.black,
                  textAlign: TextAlign.start),
              CustomText(
                  text: todaysVisitItem?.resourceName ?? "",
                  fontSize: 16,
                  fontFam: "Nunito Sans",
                  fontWeight: FontWeight.normal,
                  textColor: Colors.black,
                  textAlign: TextAlign.start),
              const Spacer(),
              InkWell(
                  onTap: () {
                    viewCallBack!(todaysVisitItem);
                  },
                  child: Image.asset("assets/eye.png",
                      color: AppColor.primaryBackgroundColor))
            ],
          ),
          Row(
            children: [
              Image.asset('assets/no_of_visit.png',
                  color: AppColor.primaryBackgroundColor),
              const SizedBox(width: 12),
              const CustomText(
                  text: "No Of Visit :",
                  fontSize: 16,
                  fontFam: "Nunito Sans",
                  fontWeight: FontWeight.bold,
                  textColor: Colors.black,
                  textAlign: TextAlign.start),
              CustomText(
                  text: todaysVisitItem?.noOfVisit.toString() ?? "",
                  fontSize: 16,
                  fontFam: "Nunito Sans",
                  fontWeight: FontWeight.normal,
                  textColor: Colors.black,
                  textAlign: TextAlign.start),
            ],
          ),
          Row(
            children: [
              Image.asset("assets/users.png",
                  color: AppColor.primaryBackgroundColor),
              const SizedBox(width: 12),
              const CustomText(
                  text: "New Customers :",
                  fontSize: 16,
                  fontFam: "Nunito Sans",
                  fontWeight: FontWeight.bold,
                  textColor: Colors.black,
                  textAlign: TextAlign.start),
              CustomText(
                  text: todaysVisitItem?.newCustomer.toString() ?? "",
                  fontSize: 16,
                  fontFam: "Nunito Sans",
                  fontWeight: FontWeight.normal,
                  textColor: Colors.black,
                  textAlign: TextAlign.start),
            ],
          )
        ],
      ),
    ).paddingSymmetric(vertical: 8, horizontal: 10);
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_flavor/flutter_flavor.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:marketingapp/todays_visit/model/todays_visit_model.dart';
// import 'package:marketingapp/todays_visit/todays_visit_controller.dart';
// import 'package:marketingapp/todays_visit/todays_visit_details.dart';
// import 'package:marketingapp/utils/color_constants.dart';
// import 'package:marketingapp/utils/shared_pref_constants.dart';
// import 'package:marketingapp/utils/shared_preference.dart';
// import 'package:marketingapp/widgets/common_svg.dart';
// import 'package:marketingapp/widgets/cust_table.dart';
// import 'package:marketingapp/widgets/custom_button.dart';
// import 'package:marketingapp/widgets/custom_text.dart';
// import 'package:marketingapp/widgets/date_picker.dart';
// import 'package:marketingapp/widgets/no_internet_connectivity.dart';
//
// class TodaysVisitScreen extends StatefulWidget {
//   final String? selectedDistrictId;
//
//   const TodaysVisitScreen({super.key, this.selectedDistrictId});
//
//   @override
//   State<TodaysVisitScreen> createState() => _TodaysVisitScreenState();
// }
//
// class _TodaysVisitScreenState extends State<TodaysVisitScreen> {
//   final TodaysVisitController todaysVisitController =
//       Get.put(TodaysVisitController());
//
//   var userData;
//
//   @override
//   void initState() {
//     getUserData();
//     super.initState();
//   }
//
//   Future<void> getUserData() async {
//     userData = await SharedPref().read(const SharedPrefConstant().kUserData);
//     DateTime date = DateTime.now();
//     todaysVisitController.formattedFromDate =
//         DateFormat('yyyy-MM-dd').format(date);
//     setState(() {});
//
//     //for manager
//     await todaysVisitController.getTodaysVisitList(
//         widget.selectedDistrictId!,
//         todaysVisitController.formattedFromDate!,
//         userData['output'][0]['EmpCode'].toString());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 FlavorConfig.instance.name == "HindLab Operational"
//                     ? AppColor.primaryBackgroundColor.withValues(alpha: 0.1)
//                     : AppColor.primaryBackgroundColor.withValues(alpha: 0.3),
//                 FlavorConfig.instance.name == 'Lifenity Operational'
//                     ? AppColor.white
//                     : AppColor.secondaryColor.withValues(alpha: 0.3)
//               ],
//               // Change colors as needed
//               begin: Alignment.centerLeft,
//               end: Alignment.centerRight,
//             ),
//           ),
//         ),
//         title: CustomText(
//           text: 'Customer Details',
//           fontSize: 18,
//           fontWeight: FontWeight.w500,
//           textColor: AppColor.black,
//           textAlign: TextAlign.start,
//           fontFam: 'Nunito Sans',
//         ),
//         leading: IconButton(
//             onPressed: () {
//               Get.back();
//             },
//             icon: const Icon(Icons.arrow_back)),
//         actions: [
//           CustomText(
//             text: todaysVisitController.formattedFromDate ?? "",
//             fontSize: 12,
//             fontWeight: FontWeight.normal,
//             textColor: AppColor.black,
//             textAlign: TextAlign.start,
//             fontFam: 'Nunito Sans',
//           ),
//           InkWell(
//             onTap: () {
//               selectFromDate(context);
//             },
//             child: CommonSvg(
//               path: "assets/calendar.svg",
//               width: 30,
//               height: 30,
//               parentWidth: 30,
//               parentHeight: 30,
//               color: AppColor.primaryBackgroundColor,
//             ).paddingOnly(left: 2, right: 8),
//           )
//         ],
//       ),
//       body: GetBuilder<TodaysVisitController>(
//           init: todaysVisitController,
//           builder: (controller) {
//             return controller.hasInternet
//                 ? Column(
//                     children: [
//                       controller.todaysVisitList != null
//                           ? Expanded(
//                               child: CustTable(
//                                 isClickable: true,
//                                 onCLick: (index) {
//                                   Get.to(TodaysVisitDetails(
//                                     todaysVisitItem:
//                                         controller.todaysVisitList?[index],
//                                   ));
//                                 },
//                                 l1: List.generate(
//                                     controller.todaysVisitList?.length ?? 0,
//                                     (index) => (index + 1).toString()),
//                                 l2: controller.todaysVisitList
//                                         ?.map((e) => e.resourceName)
//                                         .toList() ??
//                                     [],
//                                 l3: controller.todaysVisitList
//                                         ?.map((e) => e.noOfVisit)
//                                         .toList() ??
//                                     [],
//                                 l4: controller.todaysVisitList
//                                         ?.map((e) => e.newCustomer)
//                                         .toList() ??
//                                     [],
//                                 tableHeader: const [
//                                   "Sr.\nNo",
//                                   "Resource\nName",
//                                   "No. of\nVisits",
//                                   "New\nCustomers"
//                                 ],
//                               ).paddingOnly(left: 8, right: 8, top: 10),
//                             )
//                           : Center(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Image.asset('assets/nodata.png'),
//                                   const SizedBox(
//                                     height: 20,
//                                   ),
//                                   CustomText(
//                                       text: "Data Not Found",
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                       textColor: AppColor.black,
//                                       textAlign: TextAlign.center,
//                                       fontFam: "Nunito Sans"),
//                                   const SizedBox(
//                                     height: 20,
//                                   ),
//                                   CustomText(
//                                       text:
//                                           "Maybe go back and try different keyword?",
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.normal,
//                                       textColor: AppColor.borderGrey,
//                                       textAlign: TextAlign.center,
//                                       fontFam: "Nunito Sans"),
//                                   const SizedBox(
//                                     height: 20,
//                                   ),
//                                   CustomButton(
//                                     primColor: AppColor.primaryBackgroundColor,
//                                     secColor: AppColor.secondaryColor,
//                                     buttonText: "Ok",
//                                     path: 'assets/arrow_nav.svg',
//                                     callB: () {
//                                       // yesCallB();
//                                       Get.back();
//                                     },
//                                     textColor: Colors.white,
//                                     iconColor: Colors.white,
//                                     buttonFontSize: 16,
//                                     buttonWidth: 90,
//                                   )
//                                 ],
//                               ),
//                             ).paddingOnly(top: 200)
//                     ],
//                   )
//                 : InternetIssue(
//                     onRetryPressed: () {
//                       getUserData();
//                     },
//                   );
//           }),
//     );
//   }
//
//   Widget cardDetails(String heading, String value, String path) {
//     return Row(
//       children: [
//         SizedBox(
//             width: 40,
//             child: Image.asset(
//               path,
//               color: AppColor.primaryBackgroundColor,
//             )),
//         CustomText(
//             text: "$heading : ",
//             fontSize: 16,
//             fontFam: "Nunito Sans",
//             fontWeight: FontWeight.bold,
//             textColor: Colors.black,
//             textAlign: TextAlign.start),
//         Expanded(
//           child: CustomText(
//               text: value,
//               fontSize: 16,
//               fontFam: "Nunito Sans",
//               fontWeight: FontWeight.normal,
//               textColor: Colors.black,
//               textAlign: TextAlign.start),
//         ),
//       ],
//     ).paddingOnly(top: 4, bottom: 4);
//   }
//
//   selectFromDate(context) async {
//     final DateTime? picked = await DatePickerHelper.selectDate(context);
//     if (picked != null) {
//       // Update the selected date
//       todaysVisitController.selectedFromDate = picked;
//
//       // Format the date as "yyyy-MM-dd"
//       DateFormat formatter = DateFormat('yyyy-MM-dd');
//       todaysVisitController.formattedFromDate =
//           formatter.format(todaysVisitController.selectedFromDate!);
//
//       // Set the formatted date in the text field
//       todaysVisitController.dateController.text =
//           todaysVisitController.formattedFromDate!;
//     }
//     // Refresh the UI
//     // todaysVisitController.update();
//
//     await todaysVisitController.getTodaysVisitList(
//         widget.selectedDistrictId!,
//         // userData['output'][0]['DISTLGDCODE'].toString(),
//         todaysVisitController.dateController.text,
//         userData['output'][0]['EmpCode'].toString());
//     setState(() {});
//   }
// }
//
// // selectToDate() async {
// //   final DateTime? picked = await DatePickerHelper.selectDate(context);
// //   if (picked != null) {
// //     // Update the selected date
// //     todaysVisitController.selectedToDate = picked;
// //
// //     // Format the date for display as "16 Dec 24"
// //     DateFormat displayFormatter = DateFormat('d MMM yy');
// //     todaysVisitController.formattedToDate =
// //         displayFormatter.format(todaysVisitController.selectedToDate!);
// //
// //     // Set the formatted date in the text field
// //     todaysVisitController.tDateController.text =
// //         todaysVisitController.formattedToDate!;
// //
// //     // Refresh the UI
// //     todaysVisitController.update();
// //   }
// // }
//
// class CustomerVisitCard extends StatelessWidget {
//   final Function? viewCallBack;
//   final TodaysVisitOutput? todaysVisitItem;
//
//   const CustomerVisitCard({super.key, this.viewCallBack, this.todaysVisitItem});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         color: AppColor.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withValues(alpha: 0.4), // Shadow color
//             spreadRadius: 1,
//             blurRadius: 4,
//             offset: const Offset(1, 1),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Image.asset(
//                 'assets/user-square.png',
//                 color: AppColor.primaryBackgroundColor,
//               ),
//               const SizedBox(
//                 width: 10,
//               ),
//               const CustomText(
//                   text: "Resource Name : ",
//                   fontSize: 16,
//                   fontFam: "Nunito Sans",
//                   fontWeight: FontWeight.bold,
//                   textColor: Colors.black,
//                   textAlign: TextAlign.start),
//               CustomText(
//                   text: todaysVisitItem?.resourceName ?? "",
//                   fontSize: 16,
//                   fontFam: "Nunito Sans",
//                   fontWeight: FontWeight.normal,
//                   textColor: Colors.black,
//                   textAlign: TextAlign.start),
//               const Spacer(),
//               InkWell(
//                   onTap: () {
//                     viewCallBack!(todaysVisitItem);
//                   },
//                   child: Image.asset("assets/eye.png",
//                       color: AppColor.primaryBackgroundColor))
//             ],
//           ),
//           Row(
//             children: [
//               // Image.asset("assets/clock.png"),
//               // const SizedBox(
//               //   width: 6,
//               // ),
//               Image.asset('assets/no_of_visit.png',
//                   color: AppColor.primaryBackgroundColor),
//               const SizedBox(
//                 width: 12,
//               ),
//               const CustomText(
//                   text: "No Of Visit :",
//                   fontSize: 16,
//                   fontFam: "Nunito Sans",
//                   fontWeight: FontWeight.bold,
//                   textColor: Colors.black,
//                   textAlign: TextAlign.start),
//               CustomText(
//                   text: todaysVisitItem?.noOfVisit.toString() ?? "",
//                   fontSize: 16,
//                   fontFam: "Nunito Sans",
//                   fontWeight: FontWeight.normal,
//                   textColor: Colors.black,
//                   textAlign: TextAlign.start),
//             ],
//           ),
//           Row(
//             children: [
//               Image.asset("assets/users.png",
//                   color: AppColor.primaryBackgroundColor),
//               const SizedBox(
//                 width: 12,
//               ),
//               const CustomText(
//                   text: "New Customers :",
//                   fontSize: 16,
//                   fontFam: "Nunito Sans",
//                   fontWeight: FontWeight.bold,
//                   textColor: Colors.black,
//                   textAlign: TextAlign.start),
//               CustomText(
//                   text: todaysVisitItem?.newCustomer.toString() ?? "",
//                   fontSize: 16,
//                   fontFam: "Nunito Sans",
//                   fontWeight: FontWeight.normal,
//                   textColor: Colors.black,
//                   textAlign: TextAlign.start),
//             ],
//           )
//         ],
//       ),
//     ).paddingSymmetric(vertical: 8, horizontal: 10);
//   }
// }
