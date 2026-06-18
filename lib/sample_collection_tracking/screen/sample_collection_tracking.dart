import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marketingapp/sample_collection/screen/sample_collection.dart';
import 'package:marketingapp/sample_collection_tracking/controller/sample_collection_tracking_controller.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/utils/data_not_found.dart';
import 'package:marketingapp/utils/shared_pref_constants.dart';
import 'package:marketingapp/utils/shared_preference.dart';
import 'package:marketingapp/widgets/common_svg.dart';
import 'package:marketingapp/widgets/custom_date_field.dart';
import 'package:marketingapp/widgets/custom_text.dart';
import 'package:marketingapp/widgets/date_picker.dart';
import 'package:marketingapp/widgets/my_custom_dropdown.dart';
import 'package:marketingapp/widgets/no_internet_connectivity.dart';

class SampleCollectionTracking extends StatefulWidget {
  const SampleCollectionTracking({super.key});

  @override
  State<SampleCollectionTracking> createState() =>
      _SampleCollectionTrackingState();
}

class _SampleCollectionTrackingState extends State<SampleCollectionTracking> {
  final SampleCollectionTrackingController sampleCollectionTrackingController =
      Get.put(SampleCollectionTrackingController());

  var userData;

  @override
  void initState() {
    checkInternetAndLoadData();
    super.initState();
  }

  Future<void> getUserData() async {
    userData = await SharedPref().read(const SharedPrefConstant().kUserData);
    sampleCollectionTrackingController
        .getLabNameList(userData['output'][0]['DISTLGDCODE'].toString());
    sampleCollectionTrackingController.update();
  }

  checkInternetAndLoadData() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      sampleCollectionTrackingController.hasInternet = true;
    } else {
      sampleCollectionTrackingController.hasInternet = false;
    }
    sampleCollectionTrackingController.update();
    if (sampleCollectionTrackingController.hasInternet) {
      getUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SampleCollectionTrackingController>(
        init: sampleCollectionTrackingController,
        builder: (controller) {
          return Scaffold(
              appBar: AppBar(
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          // FlavorConfig.instance.name == "HindLab Operational"
                          //     ? AppColor.primaryBackgroundColor
                          //         .withValues(alpha: 0.1) :
                          AppColor.primaryBackgroundColor
                              .withValues(alpha: 0.3),
                          AppColor.secondaryColor.withValues(alpha: 0.3)
                          // AppColor.primaryBackgroundColor
                          //     .withValues(alpha: 0.3),
                          // AppColor.secondaryColor.withValues(alpha: 0.3)
                        ],
                        // Change colors as needed
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  title: CustomText(
                    text: "Sample Collection Tracking",
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
              body: controller.hasInternet
                  ? Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withValues(alpha: 0.4), // Shadow color
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(1, 1),
                              ),
                            ],
                            color: AppColor.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              CustomDateField(
                                labelText: 'Date',
                                hint: 'Select Date',
                                isRequired: true,
                                callB: () {
                                  selectFromDate();
                                },
                                selectedDate: sampleCollectionTrackingController
                                    .fDateController,
                                filledColor: Colors.white,
                                prefixIconColor:
                                    AppColor.primaryBackgroundColor,
                                dontDhowPrefix: false,
                              ),
                              MyCustomDropdown(
                                dropdownColor: AppColor.primaryBackgroundColor,
                                selectedItem: controller.selectedLab,
                                labelText: 'Lab',
                                prefixIcon: CommonSvg(
                                  path: 'assets/labs.svg',
                                  width: 20,
                                  height: 20,
                                  parentWidth: 30,
                                  parentHeight: 30,
                                  color: AppColor.primaryBackgroundColor,
                                ),
                                items: controller.labNameList?.output
                                        .map((e) => e.labName)
                                        .toList() ??
                                    [],
                                hint: '',
                                isRequired: true,
                                senValue: (value) async {
                                  controller.selectedLab = value;
                                },
                                filledColor: AppColor.white,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () async {
                                    controller.getSampleCollectionTrackingList(
                                        controller.labNameList!.output
                                            .firstWhere((e) =>
                                                e.labName ==
                                                controller.selectedLab)
                                            .labCode
                                            .toString(),
                                        controller.dateSendToApi!);
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      alignment: Alignment.center,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColor.primaryBackgroundColor,
                                            AppColor.secondaryColor
                                          ],
                                          // begin: Alignment.topLeft,
                                          // end: Alignment.bottomCenter,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const CustomText(
                                                  text: "Search",
                                                  fontSize: 16,
                                                  fontFam: "Lato",
                                                  fontWeight: FontWeight.normal,
                                                  textColor: Colors.white,
                                                  textAlign: TextAlign.start)
                                              .paddingOnly(right: 4),
                                          // Image.asset('assets/arrow_nav.svg'),
                                          CommonSvg(
                                            path: 'assets/arrow_nav.svg',
                                            width: 20,
                                            height: 20,
                                            parentWidth: 30,
                                            parentHeight: 30,
                                            color: AppColor.white,
                                          )
                                        ],
                                      )),
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                            ],
                          ),
                        ).paddingSymmetric(vertical: 10, horizontal: 10),
                        const SizedBox(
                          height: 10,
                        ),
                        controller.sampleCollectionTrackingList?.output !=
                                    null &&
                                controller.sampleCollectionTrackingList!.output
                                    .isNotEmpty
                            ? Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: controller
                                            .sampleCollectionTrackingList
                                            ?.output
                                            .length ??
                                        0,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        decoration: BoxDecoration(
                                            color: AppColor.borderGrey
                                                .withValues(alpha: 0.2),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                CustomText(
                                                    text: "Resource Name : ",
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    textColor: AppColor.black,
                                                    textAlign: TextAlign.start,
                                                    fontFam: "Nunito Sans"),
                                                CustomText(
                                                    text: controller
                                                            .sampleCollectionTrackingList
                                                            ?.output[index]
                                                            .resourcesName ??
                                                        '',
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    textColor: AppColor.black,
                                                    textAlign: TextAlign.start,
                                                    fontFam: "Nunito Sans"),
                                                const Spacer(),
                                                InkWell(
                                                    onTap: () {
                                                      Get.to(SampleCollection(
                                                        userId: controller
                                                            .sampleCollectionTrackingList!
                                                            .output[index]
                                                            .userid
                                                            .toString(),
                                                        uDate:
                                                            sampleCollectionTrackingController
                                                                .dateSendToApi!,
                                                        labCode: controller
                                                            .labNameList!.output
                                                            .firstWhere((e) =>
                                                                e.labName ==
                                                                controller
                                                                    .selectedLab)
                                                            .labCode
                                                            .toString(),
                                                        routeId: controller
                                                            .sampleCollectionTrackingList!
                                                            .output[index]
                                                            .routeId
                                                            .toString(),
                                                      ));
                                                    },
                                                    child: Image.asset(
                                                        "assets/map.png"))
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                CustomText(
                                                    text: "Sample : ",
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    textColor: AppColor.black,
                                                    textAlign: TextAlign.start,
                                                    fontFam: "Nunito Sans"),
                                                CustomText(
                                                    text: controller
                                                            .sampleCollectionTrackingList
                                                            ?.output[index]
                                                            .sampleTempName ??
                                                        '',
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    textColor: AppColor.black,
                                                    textAlign: TextAlign.start,
                                                    fontFam: "Nunito Sans"),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                CustomText(
                                                    text: "TRF’s : ",
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    textColor: AppColor.black,
                                                    textAlign: TextAlign.start,
                                                    fontFam: "Nunito Sans"),
                                                CustomText(
                                                    text: controller
                                                            .sampleCollectionTrackingList
                                                            ?.output[index]
                                                            .trfCount
                                                            .toString() ??
                                                        '',
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    textColor: AppColor.black,
                                                    textAlign: TextAlign.start,
                                                    fontFam: "Nunito Sans"),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                CustomText(
                                                    text: "Amount : ",
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    textColor: AppColor.black,
                                                    textAlign: TextAlign.start,
                                                    fontFam: "Nunito Sans"),
                                                CustomText(
                                                    text: controller
                                                            .sampleCollectionTrackingList
                                                            ?.output[index]
                                                            .collectedAmount
                                                            .toString() ??
                                                        '',
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    textColor: AppColor.black,
                                                    textAlign: TextAlign.start,
                                                    fontFam: "Nunito Sans"),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ).paddingSymmetric(
                                          vertical: 6, horizontal: 10);
                                    }),
                              )
                            : const DataNotFound()
                      ],
                    )
                  : InternetIssue(
                      onRetryPressed: () {
                        checkInternetAndLoadData();
                      },
                    ));
        });
  }

  selectFromDate() async {
    final DateTime? picked =
        await DatePickerHelper.futureDateWillBeDisable(context);
    if (picked != null) {
      // Update the selected date
      sampleCollectionTrackingController.selectedFromDate = picked;

      DateFormat formatter1 = DateFormat('yyyy-MM-dd');
      DateFormat formatter = DateFormat('dd-MM-yyyy');
      sampleCollectionTrackingController.formattedFromDate = formatter
          .format(sampleCollectionTrackingController.selectedFromDate!);
      sampleCollectionTrackingController.dateSendToApi = formatter1
          .format(sampleCollectionTrackingController.selectedFromDate!);
      // Set the formatted date in the text field
      sampleCollectionTrackingController.fDateController.text =
          sampleCollectionTrackingController.formattedFromDate!;

      // Refresh the UI
      setState(() {});
    }
  }
}
