import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marketingapp/dashboard/my_visit_controller.dart';
import 'package:marketingapp/runnerboy/collect_sample.dart';
import 'package:marketingapp/runnerboy/model/sample_collected_submitted_model.dart';
import 'package:marketingapp/runnerboy/controller/sample_collection_controller.dart';
import 'package:marketingapp/runnerboy/sample_collection_district.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/utils/data_not_found.dart';
import 'package:marketingapp/utils/session_manager.dart';
import 'package:marketingapp/utils/shared_pref_constants.dart';
import 'package:marketingapp/utils/shared_preference.dart';
import 'package:marketingapp/widgets/cust_toast.dart';
import 'package:marketingapp/widgets/custom_button.dart';
import 'package:marketingapp/widgets/custom_popup.dart';
import 'package:marketingapp/widgets/custom_text.dart';
import 'package:marketingapp/widgets/no_internet_connectivity.dart';
import 'dart:convert';

class SampleCollectionStartRoute extends StatefulWidget {
  const SampleCollectionStartRoute({super.key});

  @override
  State<SampleCollectionStartRoute> createState() =>
      _SampleCollectionStartRouteState();
}

class _SampleCollectionStartRouteState extends State<SampleCollectionStartRoute>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final SampleCollectionController collectSampleController =
      Get.put(SampleCollectionController());

  final MyVisitControllerController myVisitControllerController =
      Get.put(MyVisitControllerController());

  late final TabController tabController;
  Timer? _debounceTimer;

  var userData;

  @override
  void initState() {
    checkStartRouteVisibility();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      collectSampleController.update();
      if (mounted) {
        setState(() {});
      }
    });

    checkInternetAndLoadData();
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  checkInternetAndLoadData() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      collectSampleController.hasInternet = true;
    } else {
      collectSampleController.hasInternet = false;
    }
    collectSampleController.update();
    if (collectSampleController.hasInternet) {
      await getUserData();
    }
  }

  void checkStartRouteVisibility() async {
    final result = await SessionManager.shouldShowStartRouteButton();
    collectSampleController.showStartRoute = result == 1;
    collectSampleController.update();
  }

  getUserData() async {
    userData = await SharedPref().read(const SharedPrefConstant().kUserData);

    // collectSampleController.isRouteStartedInitially =
    //     await SampleCollectionController.shouldShowStartRouteButton();

    await myVisitControllerController.getLocation();
    await collectSampleController
        .getSampleCollectedList(userData['output'][0]['EmpCode'].toString());
    await collectSampleController.startRouteSampleCollection(
        userData['output'][0]['EmpCode'].toString(),
        "1",
        myVisitControllerController.latitude.toString(),
        myVisitControllerController.longitude.toString(),
        DateFormat('yyyy-MM-dd').format(DateTime.now()),
        userData['output'][0]['EmpCode'].toString());
  }

  @override
  void dispose() {
    tabController.dispose();
    _debounceTimer?.cancel();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint("App state changed to: $state");
    if (state == AppLifecycleState.resumed) {
      checkStartRouteVisibility();
      // Cancel any existing timer
      _debounceTimer?.cancel();

      // Start a new debounce timer
      _debounceTimer = Timer(Duration(seconds: 1), () async {
        bool success = await fetchLocation();
        if (success) {
          myVisitControllerController.update(); // Force UI refresh

          setState(() {}); // If using StatefulWidget
        } else {
          debugPrint("Failed to get location after resume");
        }
      });
    }
  }

  Future<bool> fetchLocation() async {
    try {
      await myVisitControllerController.getLocation();
      return myVisitControllerController.latitude != null &&
          myVisitControllerController.longitude != null;
    } catch (e) {
      debugPrint("Location fetch error: $e");
      return false;
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
                AppColor.secondaryColor.withValues(alpha: 0.3)
              ],
              // Change colors as needed
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: CustomText(
          text: 'Sample Collection',
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          textColor: AppColor.black,
          textAlign: TextAlign.start,
          fontFam: 'Nunito Sans',
        ),
        actions: [
          if (tabController.index == 0)
            SizedBox(
              height: 36.h,
              child: CustomButton(
                  buttonText: "Collect Sample",
                  path: 'assets/arrow_nav.svg',
                  callB: () {
                    // if (collectSampleController.showStartRoute  &&
                    //     collectSampleController
                    //         .startRouteSampleCollectionModel?.status !=
                    //         'Success')

                    if (collectSampleController.showStartRoute) {
                      CustomPopup.takeConfirmationDialog(() {
                        Get.back();
                      }, () async {
                        Get.back();
                      }, "It is mandatory to 'Start Route' from starting point before sample collection",
                          'assets/destination.png', "Ok", 160.w);
                    } else {
                      Get.to(const SampleCollectionDistrict());
                    }
                  },
                  buttonWidth: 140.w,
                  primColor: AppColor.primaryBackgroundColor,
                  secColor: AppColor.secondaryColor,
                  textColor: AppColor.white,
                  iconColor: AppColor.white,
                  buttonFontSize: 10.sp),
            ).paddingOnly(right: 6.w)
        ],
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: GetBuilder<SampleCollectionController>(
          init: collectSampleController,
          builder: (controller) {
            return controller.hasInternet
                ? Column(
                    children: [
                      TabBar(
                        controller: tabController,
                        isScrollable: false,
                        // Ensures no extra space
                        dividerColor: Colors.transparent,
                        indicatorColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        indicatorPadding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.zero,
                        tabs: [
                          buildTab(0, "Collected"),
                          buildTab(1, "Submitted"),
                        ],
                      ).paddingSymmetric(vertical: 10.h, horizontal: 10.w),
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            SampleCollectionCollectedOrSubmitted(
                              collectedAndSubmittedList:
                                  controller.collectedList,
                              showStat: false,
                            ),
                            SampleCollectionCollectedOrSubmitted(
                              collectedAndSubmittedList:
                                  controller.submittedList,
                              showStat: true,
                            )
                          ],
                        ),
                      ),
                      Visibility(
                        visible: tabController.index == 0 &&
                            controller.collectedList != null &&
                            controller.collectedList!.isNotEmpty,
                        child: CustomButton(
                          buttonFontSize: 14.sp,
                          buttonText: 'Submit To Lab',
                          path: 'assets/arrow_nav.svg',
                          callB: () async {
                            if (myVisitControllerController.longitude != null &&
                                myVisitControllerController.longitude != null) {
                              submitTolab();
                            } else {
                              CustomMessage.showLoader();

                              await myVisitControllerController.getLocation();
                              CustomMessage.hideLoader();

                              await  submitTolab();
                            }
                          },
                          // buttonWidth: double.infinity,
                          primColor: AppColor.primaryBackgroundColor,
                          secColor: AppColor.secondaryColor,
                          textColor: AppColor.white,
                          iconColor: AppColor.white,
                          buttonWidth: 160.sp,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      if (tabController.index == 0 && controller.showStartRoute)
                        CustomButton(
                          buttonFontSize: 14.sp,
                          buttonText: 'Start Route',
                          path: 'assets/arrow_nav.svg',
                          callB: () async {
                            if (myVisitControllerController.longitude != null &&
                                myVisitControllerController.latitude != null) {
                              await SessionManager.markStartRouteTapped();
                              controller.showStartRoute = false;
                              controller.update();

                              await collectSampleController
                                  .startRouteSampleCollection(
                                      userData['output'][0]['EmpCode']
                                          .toString(),
                                      "1",
                                      myVisitControllerController.latitude
                                          .toString(),
                                      myVisitControllerController.longitude
                                          .toString(),
                                      DateFormat('yyyy-MM-dd')
                                          .format(DateTime.now()),
                                      userData['output'][0]['EmpCode']
                                          .toString());

                              // CustomPopup.showSuccessSiteSelectedDialog(
                              //   selectedSiteCount: 0,
                              //   onOkPressed: () {
                              //     Get.back();
                              //   },
                              //   imgPath: "assets/check.png",
                              //   message: 'Route Started Successfully',
                              // );
                            } else {
                              await myVisitControllerController.getLocation();
                            }
                          },
                          // buttonWidth: double.infinity,
                          primColor: AppColor.primaryBackgroundColor,
                          secColor: AppColor.secondaryColor,
                          textColor: AppColor.white,
                          iconColor: AppColor.white,
                          buttonWidth: 160,
                        ).paddingOnly(bottom: 30.h),
                    ],
                  )
                : InternetIssue(
                    onRetryPressed: () {
                      checkInternetAndLoadData();
                    },
                  );
          }),
    );
  }

  submitTolab() async {
    if (collectSampleController.collectedList != null &&
        collectSampleController.collectedList!.isNotEmpty) {
      for (int i = 0; i < collectSampleController.collectedList!.length; i++) {
        if (collectSampleController.collectedList![i].iSLabSubmit == "0") {
          await collectSampleController.submitToLab(
              collectSampleController.collectedList![i].locID.toString(),
              userData['output'][0]['EmpCode'].toString(),
              // userData['output'][0]['MaplabCode']
              //     .toString(),
              collectSampleController.collectedList![i].labCode.toString(),
              myVisitControllerController);
        }
      }
      await SessionManager.resetStartRouteByLab();
      collectSampleController.showStartRoute = true;

      collectSampleController.update();

      await collectSampleController.endRoute(
          collectSampleController.startRouteSampleCollectionModel?.message
                  .toString() ??
              '0',
          userData['output'][0]['EmpCode'].toString(),
          "2",
          myVisitControllerController.latitude.toString(),
          myVisitControllerController.longitude.toString(),
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
          userData['output'][0]['EmpCode'].toString());
      if (collectSampleController.collectedList == null ||
          collectSampleController.collectedList!.isEmpty) {
        CustomPopup.showSuccessSiteSelectedDialog(
          onOkPressed: () {
            Get.back();
          },
          imgPath: "assets/success-check.png",
          message: 'Sample Send To Lab Successfully',
        );
      }
    }
  }

  Widget buildTab(int index, String text) {
    bool isSelected = tabController.index == index;
    return Container(
      // width: MediaQuery.of(context).size.width * 0.45,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
                colors: [
                  AppColor.primaryBackgroundColor,
                  AppColor.secondaryColor
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
              )
            : const LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
              ),
        borderRadius: setBorderRadiusIndexWise(index),
        border: Border.all(color: const Color(0xffE1E1E1)),
      ),
      child: Center(
        child: CustomText(
          text: text,
          fontSize: 12.0,
          fontFam: 'Lato',
          fontWeight: FontWeight.normal,
          textColor: isSelected ? Colors.white : const Color(0xff777777),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  setBorderRadiusIndexWise(index) {
    if (index == 0) {
      return const BorderRadius.only(
          topLeft: Radius.circular(10), bottomLeft: Radius.circular(10));
    } else if (index == 1) {
      // return BorderRadius.zero;
      return const BorderRadius.only(
          topRight: Radius.circular(10), bottomRight: Radius.circular(10));
    }
  }
}

class SampleCollectionCollectedOrSubmitted extends StatelessWidget {
  final bool showStat;
  final List<SampleCollectedSubmitedOutput>? collectedAndSubmittedList;

  const SampleCollectionCollectedOrSubmitted(
      {super.key, required this.showStat, this.collectedAndSubmittedList});

  @override
  Widget build(BuildContext context) {
    return collectedAndSubmittedList != null &&
            collectedAndSubmittedList!.isNotEmpty
        ? ListView.builder(
            itemCount: collectedAndSubmittedList?.length ?? 0,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Get.to(CollectSample(
                    hospitalDetails: null,
                    sampleCollectionItem: collectedAndSubmittedList?[index],
                    isEdit: true,
                  ));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color:
                          collectedAndSubmittedList![index].iSLabSubmit == '1'
                              ? AppColor.green.withValues(alpha: 0.09)
                              : AppColor.borderGrey.withValues(alpha: 0.08),
                      border: Border.all(color: AppColor.borderGrey)),
                  child: Column(
                    children: [
                      clientDet("Client",
                          collectedAndSubmittedList?[index].facilityName ?? ''),
                      clientDet(
                          "Tube",
                          collectedAndSubmittedList?[index]
                                  .sampleCount
                                  .toString() ??
                              '0'),
                      clientDet(
                          "TRF’s",
                          collectedAndSubmittedList?[index]
                                  .tRFCount
                                  .toString() ??
                              ''),
                      clientDet(
                          "Temperature",
                          collectedAndSubmittedList?[index].sampleTempName !=
                                  null
                              ? fixEncoding(collectedAndSubmittedList![index]
                                  .sampleTempName!)
                              : ''),
                      clientDet(
                          "Time",
                          collectedAndSubmittedList?[index].sampleCollTime ??
                              ''),
                      Row(
                        children: [
                          Expanded(
                            child:
                                // clientDet(
                                //     "Amount",
                                //     NumberFormat('#,##0.##').format(
                                //         collectedAndSubmittedList?[index].amount ?? 0))

                                clientDet(
                                    "Amount",
                                    collectedAndSubmittedList?[index]
                                            .amount
                                            .toString() ??
                                        ''),
                          ),
                          if (showStat)
                            Container(
                              decoration: BoxDecoration(
                                  color: getColor(
                                      collectedAndSubmittedList![index]
                                          .iSSampleAccepted!),
                                  borderRadius: BorderRadius.circular(6)),
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 6),
                              child: CustomText(
                                  text: collectedAndSubmittedList![index]
                                              .iSSampleAccepted ==
                                          '1'
                                      ? "Sample Accepted"
                                      : "Acceptance Pending",
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  textColor: AppColor.white,
                                  textAlign: TextAlign.start,
                                  fontFam: "Nunito Sans"),
                            ).paddingOnly(bottom: 4)
                          else
                            Icon(
                              Icons.remove_red_eye_outlined,
                              color: AppColor.primaryBackgroundColor,
                            )
                        ],
                      ),
                    ],
                  ),
                ).paddingOnly(top: 8, bottom: 8, left: 16, right: 16),
              );
            })
        : const DataNotFound();
  }

  Color getColor(String stat) {
    if (stat == '1') {
      return AppColor.green;
    } else {
      return AppColor.orange;
    }
  }

  String fixEncoding(String input) {
    return utf8.decode(latin1.encode(input));
  }

  Widget clientDet(String heading, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$heading : ",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: "Nunito Sans",
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                fontFamily: "Nunito Sans",
              ),
              maxLines: 10,
              overflow: TextOverflow.visible,
              softWrap: true,
            ),
          )
        ],
      ),
    );
  }
}
