import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marketingapp/dashboard/my_visit_controller.dart';
import 'package:marketingapp/todays_visit/model/customer_visit_details.dart';
import 'package:marketingapp/todays_visit/model/todays_visit_model.dart';
import 'package:marketingapp/todays_visit/todays_visit_controller.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/utils/shared_pref_constants.dart';
import 'package:marketingapp/utils/shared_preference.dart';
import 'package:marketingapp/widgets/common_svg.dart';
import 'package:marketingapp/widgets/cust_toast.dart';
import 'package:marketingapp/widgets/custom_text.dart';
import 'package:marketingapp/widgets/custom_text_field.dart';
import 'package:marketingapp/widgets/customer_table.dart';
import 'package:marketingapp/widgets/date_picker.dart';

class TodaysVisitDetails extends StatefulWidget {
  final TodaysVisitOutput? todaysVisitItem;

  const TodaysVisitDetails({super.key, required this.todaysVisitItem});

  @override
  State<TodaysVisitDetails> createState() => _TodaysVisitDetailsState();
}

class _TodaysVisitDetailsState extends State<TodaysVisitDetails> {
  final TodaysVisitController todaysVisitController =
      Get.find<TodaysVisitController>();

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

      if (userData?['output']?[0]?['Designation'] == "Manager" ||
          userData?['output']?[0]?['Designation'] == "Lab Sales Manager") {
        todaysVisitController.formattedFromDate1 =
            todaysVisitController.formattedFromDate!;
      } else {
        DateTime date = DateTime.now();
        todaysVisitController.formattedFromDate1 =
            DateFormat('yyyy-MM-dd').format(date);
      }

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
      if (userData?['output']?[0]?['Designation'] == "Manager" ||
          userData?['output']?[0]?['Designation'] == "Lab Sales Manager") {
        await todaysVisitController.getTodaysVisitRouteTime(
            todaysVisitController.formattedFromDate1!,
            widget.todaysVisitItem!.resourceUserID.toString());
        await todaysVisitController.getTodaysVisitDetList(
            todaysVisitController.formattedFromDate1!,
            widget.todaysVisitItem!.resourceUserID.toString());
      } else {
        await todaysVisitController.getTodaysVisitRouteTime(
            todaysVisitController.formattedFromDate1!,
            userData!['output'][0]['EmpCode'].toString());
        await todaysVisitController.getTodaysVisitDetList(
            todaysVisitController.formattedFromDate1!,
            userData!['output'][0]['EmpCode'].toString());
      }
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
          text: 'Customer Visit Details',
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
            text: todaysVisitController.formattedFromDate1 ?? "",
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
          ),
        ],
      ),
      body: _buildBody(),
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

    if (userData == null) {
      return _buildNoDataWidget();
    }

    return GetBuilder<TodaysVisitController>(
        init: todaysVisitController,
        builder: (controller) {
          return Column(
            children: [
              // Show offline banner if no internet (non-blocking)
              if (!controller.hasInternet) _buildOfflineBanner(),

              // Main content
              Container(
                padding: const EdgeInsets.all(6),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [
                      AppColor.primaryBackgroundColor,
                      AppColor.secondaryColor,
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.topLeft,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomText(
                        text: "Route Started On ",
                        fontSize: 16,
                        fontFam: "Nunito Sans",
                        fontWeight: FontWeight.normal,
                        textColor: Colors.white,
                        textAlign: TextAlign.start),
                    CustomText(
                        text:
                            controller.todaysVisitRoute?.first.startRouteTime !=
                                    null
                                ? convertTo12Hour(controller
                                    .todaysVisitRoute!.first.startRouteTime!)
                                : "",
                        fontSize: 16,
                        fontFam: "Nunito Sans",
                        fontWeight: FontWeight.bold,
                        textColor: Colors.white,
                        textAlign: TextAlign.start),
                  ],
                ),
              ).paddingSymmetric(horizontal: 10, vertical: 10),

              Expanded(
                  child: CustomerTable(
                isOffline: controller.hasInternet,
                // NEW: Pass offline status
                onCLick: (index) async {
                  final List<ConnectivityResult> connectivityResult =
                      await Connectivity().checkConnectivity();

                  if (connectivityResult.contains(ConnectivityResult.mobile) ||
                      connectivityResult.contains(ConnectivityResult.wifi)) {
                    bool isTrue = false;
                    try {
                      isTrue = await controller.getCustomerVisitDet(
                        controller.todaysVisitDetList![index].visitID
                            .toString(),
                        todaysVisitController.formattedFromDate1 ?? "",
                      );
                    } catch (e) {
                      debugPrint("Error fetching visit details: $e");
                    }

                    if (isTrue) {
                      Get.to(CustDetailsScreen(
                        todaysVisitCustDet:
                            controller.todaysVisitCustDet?.first,
                      ));
                    }
                  } else {
                    controller.hasInternet = false;
                    controller.update();
                    _showOfflineMessage();
                    return;
                  }
                },
                l1: List.generate(controller.todaysVisitDetList?.length ?? 0,
                    (index) => (index + 1).toString()),
                l2: controller.todaysVisitDetList
                        ?.map((e) => e.firstname)
                        .toList() ??
                    [],
                l3: controller.todaysVisitDetList
                        ?.map((e) => e.punchInTime ?? "-")
                        .toList() ??
                    [],
                l4: controller.todaysVisitDetList
                        ?.map((e) => e.punchOutTime ?? "-")
                        .toList() ??
                    [],
                l5: List.generate(controller.todaysVisitDetList?.length ?? 0,
                    (index) => (index + 1).toString()),
                tableHeader: const [
                  "Sr.\nNo",
                  "Customer\nName",
                  "In\nTime",
                  "Out\nTime",
                  "View\n"
                ],
              ).paddingOnly(left: 10, right: 10, bottom: 10))
            ],
          );
        });
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

  String convertTo12Hour(String time24) {
    final time = DateFormat("HH:mm:ss").parse(time24);
    return DateFormat("h:mm:ss a").format(time);
  }

  selectFromDate(context) async {
    if (!todaysVisitController.hasInternet) {
      _showOfflineMessage();
      return;
    }

    final DateTime? picked = await DatePickerHelper.selectDate(context);
    if (picked != null) {
      // Update the selected date
      todaysVisitController.selectedFromDate1 = picked;

      // Format the date as "yyyy-MM-dd"
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      todaysVisitController.formattedFromDate1 =
          formatter.format(todaysVisitController.selectedFromDate1!);

      // Set the formatted date in the text field
      todaysVisitController.dateController1.text =
          todaysVisitController.formattedFromDate1!;

      if (userData?['output']?[0]?['Designation'] == "Manager" ||
          userData?['output']?[0]?['Designation'] == "Lab Sales Manager") {
        await todaysVisitController.getTodaysVisitRouteTime(
            todaysVisitController.formattedFromDate1!,
            widget.todaysVisitItem!.resourceUserID.toString());

        await todaysVisitController.getTodaysVisitDetList(
            todaysVisitController.formattedFromDate1!,
            widget.todaysVisitItem!.resourceUserID.toString());
      } else {
        await todaysVisitController.getTodaysVisitRouteTime(
            todaysVisitController.formattedFromDate1!,
            userData!['output'][0]['EmpCode'].toString());
        await todaysVisitController.getTodaysVisitDetList(
            todaysVisitController.formattedFromDate1!,
            userData!['output'][0]['EmpCode'].toString());
      }
    }
    setState(() {});
  }
}

class CustDetailsScreen extends StatefulWidget {
  final OutputCustDet? todaysVisitCustDet;

  const CustDetailsScreen({super.key, this.todaysVisitCustDet});

  @override
  State<CustDetailsScreen> createState() => _CustDetailsScreenState();
}

class _CustDetailsScreenState extends State<CustDetailsScreen> {
  final MyVisitControllerController myVisitControllerController =
      Get.put(MyVisitControllerController());

  String? fullAddress;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      // Check internet connectivity
      await checkInternetAndLoadData();
    } catch (e) {
      debugPrint("Screen initialization error: $e");
      setState(() {
        hasError = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> checkInternetAndLoadData() async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await Connectivity().checkConnectivity();

      if (connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi)) {
        myVisitControllerController.hasInternet = true;

        // Try to fetch location from API
        if (myVisitControllerController.hasInternet &&
            widget.todaysVisitCustDet != null) {
          await getLocationNameFromOSM(
              double.parse(widget.todaysVisitCustDet!.punchOutLatitude!),
              double.parse(widget.todaysVisitCustDet!.punchOutLogitude!));
        }
      } else {
        myVisitControllerController.hasInternet = false;
        fullAddress = "Location unavailable (offline)";
        debugPrint("No internet connection");
      }
    } catch (e) {
      debugPrint("Connectivity check error: $e");
      myVisitControllerController.hasInternet = false;
      fullAddress = "Location unavailable (offline)";
    }

    setState(() {});
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
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: CustomText(
          text: widget.todaysVisitCustDet?.firstname ?? "",
          fontSize: 18,
          fontFam: "Nunito Sans",
          fontWeight: FontWeight.bold,
          textColor: Colors.black,
          textAlign: TextAlign.start,
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (hasError) {
      return _buildErrorWidget();
    }

    return Column(
      children: [
        // Show offline banner if no internet (non-blocking)
        if (!myVisitControllerController.hasInternet) _buildOfflineBanner(),

        // Main content
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  color: AppColor.white,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 50,
                        child: CommonSvg(
                          path: "assets/location.svg",
                          width: 30,
                          height: 30,
                          parentWidth: 30,
                          parentHeight: 30,
                          color: AppColor.secondaryColor,
                        ),
                      ),
                      Expanded(
                        child: CustomTextRichText(
                          textHeading: 'Visit Location',
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          textColor: Colors.black,
                          textAlign: TextAlign.start,
                          text: fullAddress ?? 'Loading location...',
                          fontWeightHeading: FontWeight.bold,
                          textColorHeading: AppColor.black,
                          maxLines: null,
                        ),
                      )
                    ],
                  ).paddingOnly(bottom: 8, top: 8, right: 16),
                ),
                CustomTextField(
                  initialValue: widget.todaysVisitCustDet?.visitType ?? "",
                  labelText: "Visit Type",
                  hintText: "",
                  isRequired: false,
                  keyBoardType: TextInputType.text,
                  fillColor: AppColor.white,
                  isReadOnly: true,
                  maxLines: 1,
                  fontSize: 16,
                  autofocus: false,
                  prefixIcon: CommonSvg(
                    path: "assets/addvisit.svg",
                    width: 30,
                    height: 30,
                    parentWidth: 30,
                    parentHeight: 30,
                    color: AppColor.secondaryColor,
                  ),
                ),
                CustomTextField(
                    initialValue: widget.todaysVisitCustDet?.clientStatus ?? "",
                    labelText: "Client Status",
                    hintText: "",
                    isRequired: false,
                    keyBoardType: TextInputType.text,
                    fillColor: AppColor.white,
                    isReadOnly: true,
                    maxLines: 1,
                    fontSize: 16,
                    autofocus: false,
                    prefixIcon: CommonSvg(
                      path: "assets/progress.svg",
                      width: 30,
                      height: 30,
                      parentWidth: 30,
                      parentHeight: 30,
                      color: AppColor.secondaryColor,
                    )),
                CustomTextField(
                    initialValue: widget.todaysVisitCustDet?.mVisitAction ?? "",
                    labelText: "Purpose of Visit",
                    hintText: "",
                    isRequired: false,
                    keyBoardType: TextInputType.text,
                    fillColor: AppColor.white,
                    isReadOnly: true,
                    maxLines: 1,
                    fontSize: 16,
                    autofocus: false,
                    prefixIcon: CommonSvg(
                      path: "assets/addvisit.svg",
                      width: 30,
                      height: 30,
                      parentWidth: 30,
                      parentHeight: 30,
                      color: AppColor.secondaryColor,
                    )),
                CustomTextField(
                    initialValue: widget.todaysVisitCustDet?.statusName ?? "",
                    labelText: "Contact Person Status",
                    hintText: "",
                    isRequired: false,
                    keyBoardType: TextInputType.text,
                    fillColor: AppColor.white,
                    isReadOnly: true,
                    maxLines: 1,
                    fontSize: 16,
                    autofocus: false,
                    prefixIcon: CommonSvg(
                      path: "assets/contactPerson.svg",
                      width: 30,
                      height: 30,
                      parentWidth: 30,
                      parentHeight: 30,
                      color: AppColor.secondaryColor,
                    )),
                CustomTextField(
                    initialValue: widget.todaysVisitCustDet?.cPName ?? "",
                    labelText: "Contact Person",
                    hintText: "",
                    isRequired: false,
                    keyBoardType: TextInputType.text,
                    fillColor: AppColor.white,
                    isReadOnly: true,
                    maxLines: 1,
                    fontSize: 16,
                    autofocus: false,
                    prefixIcon: CommonSvg(
                      path: "assets/user-circle.svg",
                      width: 30,
                      height: 30,
                      parentWidth: 30,
                      parentHeight: 30,
                      color: AppColor.secondaryColor,
                    )),
                CustomTextField(
                    initialValue: widget.todaysVisitCustDet?.designation ?? "",
                    labelText: "Contact Person Designation",
                    hintText: "",
                    isRequired: false,
                    keyBoardType: TextInputType.text,
                    fillColor: AppColor.white,
                    isReadOnly: true,
                    maxLines: 1,
                    fontSize: 16,
                    autofocus: false,
                    prefixIcon: CommonSvg(
                      path: "assets/briefcase.svg",
                      width: 30,
                      height: 30,
                      parentWidth: 30,
                      parentHeight: 30,
                      color: AppColor.secondaryColor,
                    )),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                          text: "Consultant Marketing Person",
                          fontSize: 16,
                          fontFam: "Nunito Sans",
                          fontWeight: FontWeight.normal,
                          textColor: AppColor.black,
                          textAlign: TextAlign.start)
                      .paddingOnly(top: 6, bottom: 6),
                ),
                Container(
                  constraints: const BoxConstraints(minHeight: 50),
                  decoration: BoxDecoration(
                      color: AppColor.white,
                      border: Border.all(color: AppColor.borderGrey),
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(children: [
                    CommonSvg(
                      path: "assets/username.svg",
                      width: 30,
                      height: 30,
                      parentWidth: 30,
                      parentHeight: 30,
                      color: AppColor.secondaryColor,
                    ),
                    Expanded(
                        child: Text(
                      widget.todaysVisitCustDet?.marketingUsers ?? "",
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                ),
                CustomTextField(
                  initialValue: widget.todaysVisitCustDet?.disscussionPoint ?? "",
                  labelText: "Discussion Points",
                  hintText: "",
                  isRequired: false,
                  keyBoardType: TextInputType.multiline,
                  fillColor: AppColor.white,
                  isReadOnly: true,
                  maxLines: null,
                  fontSize: 16,
                  autofocus: false,
                  prefixIcon: CommonSvg(
                    path: "assets/list-check.svg",
                    width: 30,
                    height: 30,
                    parentWidth: 30,
                    parentHeight: 30,
                    color: AppColor.secondaryColor,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                          text: "Services",
                          fontSize: 16,
                          fontFam: "Nunito Sans",
                          fontWeight: FontWeight.normal,
                          textColor: AppColor.black,
                          textAlign: TextAlign.start)
                      .paddingOnly(top: 6, bottom: 6),
                ),
                Container(
                  constraints: const BoxConstraints(minHeight: 50),
                  decoration: BoxDecoration(
                      color: AppColor.white,
                      border: Border.all(color: AppColor.borderGrey),
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(children: [
                    CommonSvg(
                      path: "assets/clipboard.svg",
                      width: 30,
                      height: 30,
                      parentWidth: 30,
                      parentHeight: 30,
                      color: AppColor.secondaryColor,
                    ),
                    Expanded(
                        child: Text(
                      widget.todaysVisitCustDet?.visitService ?? "",
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    )),
                  ]),
                )
              ],
            ).paddingSymmetric(vertical: 8, horizontal: 16),
          ),
        ),
      ],
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
                text: "Offline - Location unavailable",
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
                text: "Unable to load customer details",
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

  Widget cardDetails(String heading, String value, String path) {
    return Row(
      children: [
        SizedBox(
            width: 40,
            child: Image.asset(
              path,
              color: AppColor.primaryBackgroundColor,
            )),
        Expanded(
          child: CustomTextRichText(
            textHeading: "$heading ",
            fontSize: 16,
            fontWeight: FontWeight.normal,
            textColor: Colors.black,
            textAlign: TextAlign.start,
            text: value,
            fontWeightHeading: FontWeight.bold,
            textColorHeading: AppColor.black,
          ),
        ),
      ],
    ).paddingOnly(top: 4, bottom: 4);
  }

  getLocationNameFromOSM(double lat, double lng) async {
    if (!myVisitControllerController.hasInternet) {
      fullAddress = "Location unavailable (offline)";
      setState(() {});
      return;
    }

    CustomMessage.showLoader();
    try {
      await setLocaleIdentifier('en_US');
      final List<Placemark> placemarks =
          await placemarkFromCoordinates(lat, lng);

      CustomMessage.hideLoader();

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        final List<String> parts = [
          place.name,
          place.subThoroughfare,
          place.thoroughfare,
          place.subLocality,
          place.locality,
          place.postalCode,
          place.administrativeArea,
          place.country,
        ]
            .where((p) => p != null && p.trim().isNotEmpty)
            .cast<String>()
            .toList();

        fullAddress = parts.join(', ');
        debugPrint(fullAddress);
      } else {
        fullAddress = "No address found";
      }

      setState(() {});
    } catch (e) {
      CustomMessage.hideLoader();
      fullAddress = "Error fetching address";
      setState(() {});
      debugPrint("Error fetching address: $e");
    }
  }

  bool containsArabic(String text) {
    return RegExp(
            r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]')
        .hasMatch(text);
  }
}

// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_flavor/flutter_flavor.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:marketingapp/dashboard/my_visit_controller.dart';
// import 'package:marketingapp/todays_visit/model/customer_visit_details.dart';
// import 'package:marketingapp/todays_visit/model/todays_visit_model.dart';
// import 'package:marketingapp/todays_visit/todays_visit_controller.dart';
// import 'package:marketingapp/utils/color_constants.dart';
// import 'package:marketingapp/utils/shared_pref_constants.dart';
// import 'package:marketingapp/utils/shared_preference.dart';
// import 'package:marketingapp/widgets/common_svg.dart';
// import 'package:marketingapp/widgets/cust_toast.dart';
// import 'package:marketingapp/widgets/custom_text.dart';
// import 'package:marketingapp/widgets/custom_text_field.dart';
// import 'package:marketingapp/widgets/customer_table.dart';
// import 'package:marketingapp/widgets/date_picker.dart';
// import 'package:marketingapp/widgets/no_internet_connectivity.dart';
// import 'package:http/http.dart' as http;
//
// class TodaysVisitDetails extends StatefulWidget {
//   final TodaysVisitOutput? todaysVisitItem;
//
//   const TodaysVisitDetails({super.key, required this.todaysVisitItem});
//
//   @override
//   State<TodaysVisitDetails> createState() => _TodaysVisitDetailsState();
// }
//
// class _TodaysVisitDetailsState extends State<TodaysVisitDetails> {
//   final TodaysVisitController todaysVisitController =
//       Get.find<TodaysVisitController>();
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
//
//     if (userData?['output']?[0]?['Designation'] == "Manager") {
//       todaysVisitController.formattedFromDate1 =
//           todaysVisitController.formattedFromDate!;
//       setState(() {});
//       await todaysVisitController.getTodaysVisitRouteTime(
//           todaysVisitController.formattedFromDate1!,
//           widget.todaysVisitItem!.resourceUserID.toString());
//       await todaysVisitController.getTodaysVisitDetList(
//           todaysVisitController.formattedFromDate1!,
//           widget.todaysVisitItem!.resourceUserID.toString());
//     } else {
//       DateTime date = DateTime.now();
//
//       todaysVisitController.formattedFromDate1 =
//           DateFormat('yyyy-MM-dd').format(date);
//
//       setState(() {});
//
//       await todaysVisitController.getTodaysVisitRouteTime(
//           todaysVisitController.formattedFromDate1!,
//           userData['output'][0]['EmpCode'].toString());
//       await todaysVisitController.getTodaysVisitDetList(
//           todaysVisitController.formattedFromDate1!,
//           userData['output'][0]['EmpCode'].toString());
//     }
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
//           text: 'Customer Visit Details',
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
//             text: todaysVisitController.formattedFromDate1 ?? "",
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
//           ),
//         ],
//       ),
//       body: GetBuilder<TodaysVisitController>(
//           init: todaysVisitController,
//           builder: (controller) {
//             return controller.hasInternet
//                 ? Column(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(6),
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           gradient: LinearGradient(
//                             colors: [
//                               AppColor.primaryBackgroundColor,
//                               AppColor.secondaryColor,
//                             ],
//                             begin: Alignment.topRight,
//                             end: Alignment.topLeft,
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const CustomText(
//                                 text: "Route Started On ",
//                                 fontSize: 16,
//                                 fontFam: "Nunito Sans",
//                                 fontWeight: FontWeight.normal,
//                                 textColor: Colors.white,
//                                 textAlign: TextAlign.start),
//                             CustomText(
//                                 text: controller.todaysVisitRoute?.first
//                                             .startRouteTime !=
//                                         null
//                                     ? convertTo12Hour(controller
//                                         .todaysVisitRoute!
//                                         .first
//                                         .startRouteTime!)
//                                     : "",
//                                 fontSize: 16,
//                                 fontFam: "Nunito Sans",
//                                 fontWeight: FontWeight.bold,
//                                 textColor: Colors.white,
//                                 textAlign: TextAlign.start),
//                           ],
//                         ),
//                       ).paddingSymmetric(horizontal: 10, vertical: 10),
//                       Expanded(
//                           child: CustomerTable(
//                         isClickable: true,
//                         onCLick: (index) async {
//                           bool isTrue = false;
//                           try {
//                             isTrue = await controller.getCustomerVisitDet(
//                               controller.todaysVisitDetList![index].visitID
//                                   .toString(),
//                               todaysVisitController.formattedFromDate1 ?? "",
//                             );
//                           } catch (e) {
//                             debugPrint("Error fetching visit details: $e");
//                           }
//
//                           if (isTrue) {
//                             Get.to(CustDetailsScreen(
//                               todaysVisitCustDet:
//                                   controller.todaysVisitCustDet?.first,
//                             ));
//                           }
//                         },
//                         l1: List.generate(
//                             controller.todaysVisitDetList?.length ?? 0,
//                             (index) => (index + 1).toString()),
//                         l2: controller.todaysVisitDetList
//                                 ?.map((e) => e.firstname)
//                                 .toList() ??
//                             [],
//                         l3: controller.todaysVisitDetList
//                                 ?.map((e) => e.punchInTime ?? "-")
//                                 .toList() ??
//                             [],
//                         l4: controller.todaysVisitDetList
//                                 ?.map((e) => e.punchOutTime ?? "-")
//                                 .toList() ??
//                             [],
//                         l5: List.generate(
//                             controller.todaysVisitDetList?.length ?? 0,
//                             (index) => (index + 1).toString()),
//                         tableHeader: const [
//                           "Sr.\nNo",
//                           "Customer\nName",
//                           "In\nTime",
//                           "Out\nTime",
//                           "View\n"
//                         ],
//                       ).paddingOnly(left: 10, right: 10, bottom: 10))
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
//   String convertTo12Hour(String time24) {
//     final time = DateFormat("HH:mm:ss").parse(time24);
//     return DateFormat("h:mm:ss a").format(time);
//   }
//
//   selectFromDate(context) async {
//     final DateTime? picked = await DatePickerHelper.selectDate(context);
//     if (picked != null) {
//       // Update the selected date
//       todaysVisitController.selectedFromDate1 = picked;
//
//       // Format the date as "yyyy-MM-dd"
//       DateFormat formatter = DateFormat('yyyy-MM-dd');
//       todaysVisitController.formattedFromDate1 =
//           formatter.format(todaysVisitController.selectedFromDate1!);
//
//       // Set the formatted date in the text field
//       todaysVisitController.dateController1.text =
//           todaysVisitController.formattedFromDate1!;
//       if (userData?['output']?[0]?['Designation'] == "Manager") {
//         await todaysVisitController.getTodaysVisitRouteTime(
//             todaysVisitController.formattedFromDate1!,
//             widget.todaysVisitItem!.resourceUserID.toString());
//
//         await todaysVisitController.getTodaysVisitDetList(
//             todaysVisitController.formattedFromDate1!,
//             widget.todaysVisitItem!.resourceUserID.toString());
//       } else {
//         await todaysVisitController.getTodaysVisitRouteTime(
//             todaysVisitController.formattedFromDate1!,
//             userData['output'][0]['EmpCode'].toString());
//         await todaysVisitController.getTodaysVisitDetList(
//             todaysVisitController.formattedFromDate1!,
//             userData['output'][0]['EmpCode'].toString());
//       }
//     }
//     // Refresh the UI
//     // todaysVisitController.update();
//     setState(() {});
//   }
// }
//
// class CustDetailsScreen extends StatefulWidget {
//   final OutputCustDet? todaysVisitCustDet;
//
//   const CustDetailsScreen({super.key, this.todaysVisitCustDet});
//
//   @override
//   State<CustDetailsScreen> createState() => _CustDetailsScreenState();
// }
//
// class _CustDetailsScreenState extends State<CustDetailsScreen> {
//   final MyVisitControllerController myVisitControllerController =
//       Get.put(MyVisitControllerController());
//
//   String? fullAddress;
//
//   @override
//   void initState() {
//     getLocationNameFromOSM(
//         double.parse(widget.todaysVisitCustDet!.punchOutLatitude!),
//         double.parse(widget.todaysVisitCustDet!.punchOutLogitude!));
//     super.initState();
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
//                 AppColor.secondaryColor.withValues(alpha: 0.3)
//                 // AppColor.primaryBackgroundColor.withValues(alpha: 0.3),
//                 // AppColor.secondaryColor.withValues(alpha: 0.3)
//               ],
//               // Change colors as needed
//               begin: Alignment.centerLeft,
//               end: Alignment.centerRight,
//             ),
//           ),
//         ),
//         title: CustomText(
//           text: widget.todaysVisitCustDet?.firstname ?? "",
//           fontSize: 18,
//           fontFam: "Nunito Sans",
//           fontWeight: FontWeight.bold,
//           textColor: Colors.black,
//           textAlign: TextAlign.start,
//         ),
//         leading: IconButton(
//             onPressed: () {
//               Get.back();
//             },
//             icon: const Icon(Icons.arrow_back)),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Card(
//               color: AppColor.white,
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: 50,
//                     child: CommonSvg(
//                       path: "assets/location.svg",
//                       width: 30,
//                       height: 30,
//                       parentWidth: 30,
//                       parentHeight: 30,
//                       color: AppColor.secondaryColor,
//                     ),
//                   ),
//                   Expanded(
//                     child: CustomTextRichText(
//                       textHeading: 'Visit Location',
//                       fontSize: 16,
//                       fontWeight: FontWeight.normal,
//                       textColor: Colors.black,
//                       textAlign: TextAlign.start,
//                       text: fullAddress ?? '',
//                       fontWeightHeading: FontWeight.bold,
//                       textColorHeading: AppColor.black,
//                     ),
//                   )
//                 ],
//               ).paddingOnly(bottom: 8, top: 8, right: 16),
//             ),
//
//             CustomTextField(
//               initialValue: widget.todaysVisitCustDet?.visitType ?? "",
//               labelText: "Visit Type",
//               hintText: "",
//               isRequired: false,
//               keyBoardType: TextInputType.text,
//               fillColor: AppColor.white,
//               isReadOnly: true,
//               maxLines: 1,
//               fontSize: 16,
//               autofocus: false,
//               prefixIcon: CommonSvg(
//                 path: "assets/addvisit.svg",
//                 width: 30,
//                 height: 30,
//                 parentWidth: 30,
//                 parentHeight: 30,
//                 color: AppColor.secondaryColor,
//               ),
//             ),
//
//             CustomTextField(
//                 initialValue: widget.todaysVisitCustDet?.clientStatus ?? "",
//                 labelText: "Client Status",
//                 hintText: "",
//                 isRequired: false,
//                 keyBoardType: TextInputType.text,
//                 fillColor: AppColor.white,
//                 isReadOnly: true,
//                 maxLines: 1,
//                 fontSize: 16,
//                 autofocus: false,
//                 prefixIcon: CommonSvg(
//                   path: "assets/progress.svg",
//                   width: 30,
//                   height: 30,
//                   parentWidth: 30,
//                   parentHeight: 30,
//                   color: AppColor.secondaryColor,
//                 )),
//
//             CustomTextField(
//                 initialValue: widget.todaysVisitCustDet?.mVisitAction ?? "",
//                 labelText: "Purpose of Visit",
//                 hintText: "",
//                 isRequired: false,
//                 keyBoardType: TextInputType.text,
//                 fillColor: AppColor.white,
//                 isReadOnly: true,
//                 maxLines: 1,
//                 fontSize: 16,
//                 autofocus: false,
//                 prefixIcon: CommonSvg(
//                   path: "assets/addvisit.svg",
//                   width: 30,
//                   height: 30,
//                   parentWidth: 30,
//                   parentHeight: 30,
//                   color: AppColor.secondaryColor,
//                 )),
//
//             CustomTextField(
//                 initialValue: widget.todaysVisitCustDet?.statusName ?? "",
//                 labelText: "Contact Person Status",
//                 hintText: "",
//                 isRequired: false,
//                 keyBoardType: TextInputType.text,
//                 fillColor: AppColor.white,
//                 isReadOnly: true,
//                 maxLines: 1,
//                 fontSize: 16,
//                 autofocus: false,
//                 prefixIcon: CommonSvg(
//                   path: "assets/contactPerson.svg",
//                   width: 30,
//                   height: 30,
//                   parentWidth: 30,
//                   parentHeight: 30,
//                   color: AppColor.secondaryColor,
//                 )),
//
//             CustomTextField(
//                 initialValue: widget.todaysVisitCustDet?.cPName ?? "",
//                 labelText: "Contact Person",
//                 hintText: "",
//                 isRequired: false,
//                 keyBoardType: TextInputType.text,
//                 fillColor: AppColor.white,
//                 isReadOnly: true,
//                 maxLines: 1,
//                 fontSize: 16,
//                 autofocus: false,
//                 prefixIcon: CommonSvg(
//                   path: "assets/user-circle.svg",
//                   width: 30,
//                   height: 30,
//                   parentWidth: 30,
//                   parentHeight: 30,
//                   color: AppColor.secondaryColor,
//                 )),
//
//             CustomTextField(
//                 initialValue: widget.todaysVisitCustDet?.designation ?? "",
//                 labelText: "Contact Person Designation",
//                 hintText: "",
//                 isRequired: false,
//                 keyBoardType: TextInputType.text,
//                 fillColor: AppColor.white,
//                 isReadOnly: true,
//                 maxLines: 1,
//                 fontSize: 16,
//                 autofocus: false,
//                 prefixIcon: CommonSvg(
//                   path: "assets/briefcase.svg",
//                   width: 30,
//                   height: 30,
//                   parentWidth: 30,
//                   parentHeight: 30,
//                   color: AppColor.secondaryColor,
//                 )),
//
//             Align(
//               alignment: Alignment.centerLeft,
//               child: CustomText(
//                       text: "Consultant Marketing Person",
//                       fontSize: 16,
//                       fontFam: "Nunito Sans",
//                       fontWeight: FontWeight.normal,
//                       textColor: AppColor.black,
//                       textAlign: TextAlign.start)
//                   .paddingOnly(top: 6, bottom: 6),
//             ),
//             Container(
//               constraints: const BoxConstraints(minHeight: 50),
//               decoration: BoxDecoration(
//                   color: AppColor.white,
//                   border: Border.all(color: AppColor.borderGrey),
//                   borderRadius: BorderRadius.circular(12)),
//               child: Row(children: [
//                 // Image.asset(
//                 //   "assets/user-square.png",
//                 //   color: AppColor.secondaryColor,
//                 // ).paddingOnly(left: 12, right: 8),
//                 CommonSvg(
//                   path: "assets/username.svg",
//                   width: 30,
//                   height: 30,
//                   parentWidth: 30,
//                   parentHeight: 30,
//                   color: AppColor.secondaryColor,
//                 ),
//                 Expanded(
//                     child: Text(
//                   widget.todaysVisitCustDet?.marketingUsers ?? "",
//                   softWrap: true, // Allow text wrapping
//                   overflow: TextOverflow.visible, // Ensure it expands
//                 )),
//               ]),
//             ),
//
//             CustomTextField(
//                 initialValue: widget.todaysVisitCustDet?.disscussionPoint ?? "",
//                 labelText: "Discussion Points",
//                 hintText: "",
//                 isRequired: false,
//                 keyBoardType: TextInputType.text,
//                 fillColor: AppColor.white,
//                 isReadOnly: true,
//                 maxLines: null,
//                 fontSize: 16,
//                 autofocus: false,
//                 prefixIcon: CommonSvg(
//                   path: "assets/list-check.svg",
//                   width: 30,
//                   height: 30,
//                   parentWidth: 30,
//                   parentHeight: 30,
//                   color: AppColor.secondaryColor,
//                 )),
//
//             Align(
//               alignment: Alignment.centerLeft,
//               child: CustomText(
//                       text: "Services",
//                       fontSize: 16,
//                       fontFam: "Nunito Sans",
//                       fontWeight: FontWeight.normal,
//                       textColor: AppColor.black,
//                       textAlign: TextAlign.start)
//                   .paddingOnly(top: 6, bottom: 6),
//             ),
//             Container(
//               constraints: const BoxConstraints(minHeight: 50),
//               decoration: BoxDecoration(
//                   color: AppColor.white,
//                   border: Border.all(color: AppColor.borderGrey),
//                   borderRadius: BorderRadius.circular(12)),
//               child: Row(children: [
//                 CommonSvg(
//                   path: "assets/clipboard.svg",
//                   width: 30,
//                   height: 30,
//                   parentWidth: 30,
//                   parentHeight: 30,
//                   color: AppColor.secondaryColor,
//                 ),
//                 Expanded(
//                     child: Text(
//                   widget.todaysVisitCustDet?.visitService ?? "",
//                   softWrap: true, // Allow text wrapping
//                   overflow: TextOverflow.visible, // Ensure it expands
//                 )),
//               ]),
//             )
//
//             // cardDetails(
//             //     "Visit Location",
//             //     myVisitControllerController.locationMessage ??
//             //         "location not found",
//             //     "assets/location.png"),
//             // cardDetails("Visit Type", todaysVisitCustDet?.visitType ?? "",
//             //     "assets/addvisit.png"),
//             // cardDetails("Client Status", todaysVisitCustDet?.clientStatus ?? "",
//             //     "assets/progress.png"),
//             // cardDetails("Purpose of Visit",
//             //     todaysVisitCustDet?.mVisitAction ?? "", "assets/clipboard.png"),
//             // cardDetails("Contact Person Status",
//             //     todaysVisitCustDet?.statusName ?? "", "assets/user-circle.png"),
//             // cardDetails("Contact Person", todaysVisitCustDet?.cPName ?? "",
//             //     "assets/contact.png"),
//             // cardDetails("Contact Person Designation",
//             //     todaysVisitCustDet?.designation ?? "", "assets/briefcase.png"),
//             // cardDetails(
//             //     "Marketing Person",
//             //     todaysVisitCustDet?.marketingUsers ?? "",
//             //     "assets/user-square.png"),
//             // cardDetails(
//             //     "Discussion Points",
//             //     todaysVisitCustDet?.disscussionPoint ?? "",
//             //     "assets/list-check.png"),
//             // cardDetails("Services", todaysVisitCustDet?.visitService ?? "",
//             //     "assets/briefcase.png"),
//           ],
//         ).paddingSymmetric(vertical: 8, horizontal: 16),
//
//         // child: Column(
//         //   mainAxisSize: MainAxisSize.min,
//         //   children: [
//         //     cardDetails(
//         //         "Visit Location",
//         //         myVisitControllerController.locationMessage ??
//         //             "location not found",
//         //         "assets/location.png"),
//         //     cardDetails("Visit Type", todaysVisitCustDet?.visitType ?? "",
//         //         "assets/addvisit.png"),
//         //     cardDetails(
//         //         "Client Status",
//         //         todaysVisitCustDet?.clientStatus ?? "",
//         //         "assets/progress.png"),
//         //     cardDetails(
//         //         "Purpose of Visit",
//         //         todaysVisitCustDet?.mVisitAction ?? "",
//         //         "assets/clipboard.png"),
//         //     cardDetails(
//         //         "Contact Person Status",
//         //         todaysVisitCustDet?.statusName ?? "",
//         //         "assets/user-circle.png"),
//         //     cardDetails("Contact Person", todaysVisitCustDet?.cPName ?? "",
//         //         "assets/contact.png"),
//         //     cardDetails(
//         //         "Contact Person Designation",
//         //         todaysVisitCustDet?.designation ?? "",
//         //         "assets/briefcase.png"),
//         //     cardDetails(
//         //         "Marketing Person",
//         //         todaysVisitCustDet?.marketingUsers ?? "",
//         //         "assets/user-square.png"),
//         //     cardDetails(
//         //         "Discussion Points",
//         //         todaysVisitCustDet?.disscussionPoint ?? "",
//         //         "assets/list-check.png"),
//         //     cardDetails("Services", todaysVisitCustDet?.visitService ?? "",
//         //         "assets/briefcase.png"),
//         //   ],
//         // ),
//       ),
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
//         Expanded(
//           child: CustomTextRichText(
//             textHeading: "$heading ",
//             fontSize: 16,
//             fontWeight: FontWeight.normal,
//             textColor: Colors.black,
//             textAlign: TextAlign.start,
//             text: value,
//             fontWeightHeading: FontWeight.bold,
//             textColorHeading: AppColor.black,
//           ),
//         ),
//       ],
//     ).paddingOnly(top: 4, bottom: 4);
//   }
//
//   getLocationNameFromOSM(double lat, double lng) async {
//     CustomMessage.showLoader();
//     try {
//       final String url =
//           'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lng&format=json&accept-language=en&addressdetails=1';
//
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'User-Agent': 'YourAppName/1.0', // Required by OSM
//         },
//       );
//
//       if (response.statusCode == 200) {
//         CustomMessage.hideLoader();
//
//         final data = json.decode(response.body);
//
//         if (data['display_name'] != null) {
//           String address = data['display_name'];
//
//           // Also try to build from components for better formatting
//           if (data['address'] != null) {
//             final addr = data['address'];
//             final parts = [
//               addr['village'],
//               addr['county'],
//               addr['state_district'],
//               addr['road'],
//               addr['neighbourhood'] ?? addr['suburb'],
//               addr['city'] ?? addr['town'],
//               addr['state'],
//               addr['postcode'],
//               addr['country']
//             ]
//                 .where((s) => s != null && s.toString().trim().isNotEmpty)
//                 .join(', ');
//
//             if (parts.isNotEmpty) {
//               address = parts;
//             }
//           }
//
//           fullAddress = address;
//           setState(() {});
//           return address;
//         }
//       }
//
//       fullAddress = "No address found";
//     } catch (e) {
//       return "Error fetching address: $e";
//     }
//   }
//
//   bool containsArabic(String text) {
//     return RegExp(
//             r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]')
//         .hasMatch(text);
//   }
//
// // getLocationName(double latitude, double longitude) async {
// //   try {
// //     await setLocaleIdentifier('en_US');
// //
// //     List<Placemark> placemarks =
// //         await placemarkFromCoordinates(latitude, longitude,);
// //
// //     if (placemarks.isNotEmpty) {
// //       Placemark place = placemarks[0];
// //
// //       // Create a list of non-null, non-empty parts
// //       List<String> addressParts = [
// //         place.name,
// //         place.subThoroughfare,
// //         place.thoroughfare,
// //         place.subLocality,
// //         place.locality,
// //         place.postalCode,
// //         place.administrativeArea,
// //         place.country
// //       ]
// //           .where((part) => part != null && part.trim().isNotEmpty)
// //           .cast<String>()
// //           .toList();
// //
// //       // Join with comma
// //       fullAddress = addressParts.join(', ');
// //       debugPrint('fullAddress : $fullAddress');
// //       setState(() {});
// //     } else {
// //       return "No address found";
// //     }
// //   } catch (e) {
// //     debugPrint("Error in reverse geocoding: $e");
// //     return "Error fetching address";
// //   }
// // }
// }
