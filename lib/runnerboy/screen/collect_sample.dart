import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:marketingapp/add_visit/model/marketing_person_model.dart';
import 'package:marketingapp/dashboard/my_visit_controller.dart';
import 'package:marketingapp/runnerboy/model/get_center_id_and_available_fund.dart';
import 'package:marketingapp/runnerboy/model/sample_collected_submitted_model.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/utils/debounce_ext.dart';
import 'package:marketingapp/utils/shared_pref_constants.dart';
import 'package:marketingapp/utils/shared_preference.dart';
import 'package:marketingapp/widgets/common_svg.dart';
import 'package:marketingapp/widgets/cust_toast.dart';
import 'package:marketingapp/widgets/custom_button.dart';
import 'package:marketingapp/widgets/custom_text.dart';
import 'package:marketingapp/widgets/custom_text_field.dart';
import 'package:marketingapp/widgets/my_custom_dropdown.dart';
import 'package:marketingapp/widgets/no_internet_connectivity.dart';
import 'package:marketingapp/widgets/view_image.dart';
import 'controller/sample_collection_controller.dart';

class CollectSample extends StatefulWidget {
  final CenterIdAndAvailableFundOutput? hospitalDetails;
  final SampleCollectedSubmitedOutput? sampleCollectionItem;
  final bool isEdit;

  const CollectSample({super.key,
    this.hospitalDetails,
    required this.isEdit,
    this.sampleCollectionItem});

  @override
  State<CollectSample> createState() => _CollectSampleState();
}

class _CollectSampleState extends State<CollectSample>
    with WidgetsBindingObserver {
  final SampleCollectionController collectSampleController =
  Get.find<SampleCollectionController>();
  final MyVisitControllerController myVisitControllerController = Get.find();

  var userData;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? selectedMarketingPerson;
  List<MarketingOutput>? selectedMarketingVal;
  String? selectedServicesVal;
  Timer? _debounceTimer;
  late final StreamSubscription _sub;

  @override
  void initState() {
    connectivityListener();
    checkInternetAndLoadData();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint("App state changed to: $state");
    if (state == AppLifecycleState.resumed) {
      // Cancel any existing timer
      _debounceTimer?.cancel();

      // Start a new debounce timer
      _debounceTimer = Timer(Duration(seconds: 1), () async {
        bool success = await fetchLocation();
        if (success) {
          myVisitControllerController.update();
        } else {
          debugPrint("Failed to get location after resume");
        }
      });
    }
  }

  @override
  void dispose() {
    _sub.cancel();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: collectSampleController,
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColor.primaryBackgroundColor.withValues(alpha: 0.3),
                      AppColor.secondaryColor.withValues(alpha: 0.3)
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              title: CustomText(
                text: "Collect Sample",
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                textColor: AppColor.black,
                textAlign: TextAlign.start,
                fontFam: 'Nunito Sans',
              ),
              leading: IconButton(
                  onPressed: () {
                    // controller.punchInDetailsModel = null;
                    controller.tubeContainerCount.clear();
                    controller.trfCountTextField.clear();
                    controller.amountCollected.clear();
                    controller.paymentMode = null;
                    controller.temp = null;
                    controller.contactPersonName.clear();
                    controller.sampleQtySufficient = null;
                    controller.sampleCollectedNonPluscareTube = null;
                    controller.trfFilledAccurately = null;
                    controller.barcodeNameMention = null;
                    controller.barcodeNameMention = null;
                    controller.otherDocCollected = null;
                    controller.docName.clear();
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back)),
            ),
            body: controller.hasInternet
                ? Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      color: AppColor.white,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 50.w,
                            child: CommonSvg(
                              path: "assets/location.svg",
                              width: 26.w,
                              height: 26.h,
                              parentWidth: 30.w,
                              parentHeight: 30.h,
                              color: AppColor.secondaryColor,
                            ),
                          ),
                          Expanded(
                            child: CustomTextRichText(
                              textHeading: 'Current  Location',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.normal,
                              textColor: Colors.black,
                              textAlign: TextAlign.start,
                              text: myVisitControllerController
                                  .locationMessage ??
                                  "location not found",
                              fontWeightHeading: FontWeight.bold,
                              textColorHeading: AppColor.black,
                            ),
                          )
                        ],
                      ).paddingOnly(bottom: 8, top: 0, right: 16.w),
                    ),
                    Card(
                      color: AppColor.white,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 50,
                            child: CommonSvg(
                              path: "assets/username.svg",
                              width: 26.w,
                              height: 26.h,
                              parentWidth: 30.w,
                              parentHeight: 30.h,
                              color: AppColor.secondaryColor,
                            ),
                          ),
                          Expanded(
                            child: CustomTextRichText(
                              textHeading: 'Name',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.normal,
                              textColor: Colors.black,
                              textAlign: TextAlign.start,
                              text: widget.isEdit
                                  ? widget
                                  .sampleCollectionItem!.facilityName!
                                  : widget.hospitalDetails
                                  ?.facilityName ??
                                  "",
                              fontWeightHeading: FontWeight.bold,
                              textColorHeading: AppColor.black,
                            ),
                          )
                        ],
                      ).paddingOnly(bottom: 0, top: 8.h, right: 16.w),
                    ),
                    CustomTextField(
                      mazLenght: 5,
                      autofocus: false,
                      txtController: controller.tubeContainerCount,
                      labelText: 'Tube/Container Count',
                      hintText: 'Tube/Container Count',
                      isRequired: true,
                      keyBoardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      fillColor: AppColor.white,
                      isReadOnly:
                      widget.sampleCollectionItem?.iSSampleAccepted ==
                          '1'
                          ? true
                          : false,
                      maxLines: 1,
                      fontSize: 12.sp,
                      prefixIcon: CommonSvg(
                        path: "assets/testtube.svg",
                        width: 26.w,
                        height: 26.h,
                        parentWidth: 30.w,
                        parentHeight: 30.h,
                        color: AppColor.secondaryColor,
                      ),
                      onChanged: (value) {
                        if (value == "0") {
                          controller.showOtherTextField = false;
                        } else {
                          controller.showOtherTextField = true;
                        }
                        controller.update();
                      },
                    ).paddingOnly(top: 6.h),
                    if (controller.showOtherTextField)
                      CustomTextField(
                        mazLenght: 5,
                        autofocus: false,
                        txtController: controller.trfCountTextField,
                        labelText: 'TRF Count',
                        hintText: 'TRF Count',
                        isRequired: true,
                        keyBoardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        fillColor: AppColor.white,
                        isReadOnly: widget.sampleCollectionItem
                            ?.iSSampleAccepted ==
                            '1'
                            ? true
                            : false,
                        maxLines: 1,
                        fontSize: 12.sp,
                        prefixIcon: CommonSvg(
                          path: "assets/progress.svg",
                          width: 26.w,
                          height: 26.h,
                          parentWidth: 30.w,
                          parentHeight: 30.h,
                          color: AppColor.secondaryColor,
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            mazLenght: 7,
                            autofocus: false,
                            txtController: controller.amountCollected,
                            labelText: 'Amount Collected',
                            hintText: 'Amount Collected',
                            isRequired: true,
                            keyBoardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.,]'),
                              )
                            ],
                            fillColor: AppColor.white,
                            isReadOnly: widget.sampleCollectionItem
                                ?.iSSampleAccepted ==
                                '1'
                                ? true
                                : false,
                            maxLines: 1,
                            fontSize: 12.sp,
                            prefixIcon: CommonSvg(
                              path: "assets/cash.svg",
                              width: 26.w,
                              height: 26.h,
                              parentWidth: 30.w,
                              parentHeight: 30.h,
                              color: AppColor.secondaryColor,
                            ),
                            onChanged: (value) {
                              final cleaned =
                                  value.replaceAll(',', '').trim();
                              if (cleaned.isEmpty) {
                                controller.showAmountFiled = true;
                              } else {
                                double amount =
                                    double.tryParse(cleaned) ?? 0;
                                controller.showAmountFiled = amount != 0;
                              }
                              controller.update();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        controller.showAmountFiled
                            ? Expanded(
                          child: MyCustomDropdown(
                            selectedItem: controller.paymentMode,
                            isViewProfile: widget
                                .sampleCollectionItem
                                ?.iSSampleAccepted ==
                                '1'
                                ? true
                                : false,
                            labelText: 'Payment Mode',
                            prefixIcon: CommonSvg(
                              path: "assets/cash.svg",
                              width: 26.w,
                              height: 26.h,
                              parentWidth: 30.w,
                              parentHeight: 30.h,
                              color: AppColor.secondaryColor,
                            ),
                            items: controller.paymentModeList
                                .map((e) => e.mode)
                                .toList(),
                            hint: '',
                            isRequired: true,
                            senValue: (value) async {
                              controller.paymentMode = value;
                              controller.transactionNo.clear();
                              controller.update();
                            },
                            filledColor: AppColor.white,
                          ).paddingOnly(bottom: 16.h),
                        )
                            : SizedBox.shrink(),
                      ],
                    ),
                    if (controller.paymentMode == "Online" &&
                        controller.showAmountFiled)
                      CustomTextField(
                        // shouldValidate: controller.shouldValidate,
                        autofocus: false,
                        txtController: controller.transactionNo,
                        labelText: 'Transaction No',
                        hintText: 'Transaction No',
                        isRequired: true,
                        keyBoardType: TextInputType.text,
                        fillColor: AppColor.white,
                        isReadOnly: widget.sampleCollectionItem
                            ?.iSSampleAccepted ==
                            '1'
                            ? true
                            : false,
                        maxLines: 1,
                        fontSize: 12.sp,
                        prefixIcon: CommonSvg(
                          path: "assets/progress.svg",
                          width: 26.w,
                          height: 26.h,
                          parentWidth: 30.w,
                          parentHeight: 30.h,
                          color: AppColor.secondaryColor,
                        ),
                      ),
                    if (controller.showOtherTextField)
                      MyCustomDropdown(
                        // shouldValidate: controller.shouldValidate,
                        selectedItem: controller.temp,
                        isViewProfile: widget.sampleCollectionItem
                            ?.iSSampleAccepted ==
                            '1'
                            ? true
                            : false,
                        labelText: 'Temperature',
                        prefixIcon: CommonSvg(
                          path: "assets/temperature.svg",
                          width: 26.w,
                          height: 26.h,
                          parentWidth: 30.w,
                          parentHeight: 30.h,
                          color: AppColor.secondaryColor,
                        ),
                        items: controller.tempList
                            ?.map((e) => e.sampleTempName)
                            .toList() ??
                            [],
                        hint: '',
                        isRequired: true,
                        senValue: (value) async {
                          controller.temp = value;

                          controller.update();
                        },
                        filledColor: AppColor.white,
                      ),
                    if (controller.showOtherTextField)
                      CustomTextField(
                        // shouldValidate: controller.shouldValidate,
                        autofocus: false,
                        txtController: controller.contactPersonName,
                        labelText: 'Contact Person Name',
                        hintText: 'Contact Person Name',
                        isRequired: true,
                        keyBoardType: TextInputType.text,
                        fillColor: AppColor.white,
                        isReadOnly: widget.sampleCollectionItem
                            ?.iSSampleAccepted ==
                            '1'
                            ? true
                            : false,
                        maxLines: 1,
                        fontSize: 12.sp,
                        prefixIcon: CommonSvg(
                          path: "assets/contactPerson.svg",
                          width: 26.w,
                          height: 26.h,
                          parentWidth: 30.w,
                          parentHeight: 30.h,
                          color: AppColor.secondaryColor,
                        ),
                      ),
                    if (controller.showOtherTextField)
                      MyCustomDropdown(
                        // shouldValidate: controller.shouldValidate,
                        selectedItem: controller.sampleQtySufficient,
                        isViewProfile: widget.sampleCollectionItem
                            ?.iSSampleAccepted ==
                            '1'
                            ? true
                            : false,
                        labelText: 'Sample Quantity Not Sufficient?',
                        prefixIcon: CommonSvg(
                          path: 'assets/testtube.svg',
                          width: 26.w,
                          height: 26.h,
                          parentWidth: 30.w,
                          parentHeight: 30.h,
                          color: AppColor.secondaryColor,
                        ),
                        items: controller.allQuestionList
                            .map((e) => e.answer)
                            .toList(),
                        hint: '',
                        isRequired: true,
                        senValue: (value) {
                          controller.sampleQtySufficient = value;

                          controller.update();
                        },
                        filledColor: AppColor.white,
                      ),
                    if (controller.sampleQtySufficient == "Yes" &&
                        controller.showOtherTextField)
                      TubeCountCustomTextField(
                        validator: (value) =>
                            tubeCountValidator(
                                value, controller.tubeContainerCount.text),
                        autofocus: false,
                        txtController: controller.tubeCountSampleQty,
                        labelText: 'Enter Tube Count',
                        hintText: 'Enter Tube Count',
                        isRequired: true,
                        keyBoardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        fillColor: AppColor.white,
                        isReadOnly: widget.sampleCollectionItem
                            ?.iSSampleAccepted ==
                            '1'
                            ? true
                            : false,
                        maxLines: 1,
                        fontSize: 12.sp,
                        prefixIcon: CommonSvg(
                          path: 'assets/file.svg',
                          width: 26.w,
                          height: 26.h,
                          parentWidth: 30.w,
                          parentHeight: 30.h,
                          color: AppColor.secondaryColor,
                        ),
                      ),
                    if (controller.showOtherTextField)
                      MyCustomDropdown(
                        // shouldValidate: controller.shouldValidate,
                        selectedItem:
                        controller.sampleCollectedNonPluscareTube,
                        isViewProfile: widget.sampleCollectionItem
                            ?.iSSampleAccepted ==
                            '1'
                            ? true
                            : false,
                        labelText: FlavorConfig.instance.name ==
                            "HindLab Operational"
                            ? "Sample Collected In Non HindLab Tubes?"
                            : FlavorConfig.instance.name ==
                            "Lifenity International"
                            ? "Sample Collected In Non Lifenity International Tubes?"
                            : FlavorConfig.instance.name ==
                            "CSC HealthCare"
                            ? "Sample Collected In Non CSC HealthCare Tubes?"
                            : FlavorConfig.instance.name ==
                            "Lifenity Operational"
                            ? "Sample Collected In Non Lifenity Operational Tubes?"
                            : FlavorConfig.instance.name ==
                            "PlusCare Operational"
                            ? "Sample Collected In Non PlusCare Operational Tubes?"
                            : "",
                        prefixIcon: CommonSvg(
                          path: 'assets/testtube.svg',
                          width: 26.w,
                          height: 26.h,
                          parentWidth: 30.w,
                          parentHeight: 30.h,
                          color: AppColor.secondaryColor,
                        ),
                        items: controller.allQuestionList
                            .map((e) => e.answer)
                            .toList(),
                        hint: '',
                        isRequired: true,
                        senValue: (value) {
                          controller.sampleCollectedNonPluscareTube =
                              value;

                          controller.update();
                        },
                        filledColor: AppColor.white,
                      ),
                    if (controller.sampleCollectedNonPluscareTube ==
                        "Yes" &&
                        controller.showOtherTextField)
                      TubeCountCustomTextField(
                        validator: (value) =>
                            tubeCountValidator(
                                value, controller.tubeContainerCount.text),
                        autofocus: false,
                        txtController: controller
                            .tubeCountSampleCollectedNonPluscare,
                        labelText: 'Enter Tube Count',
                        hintText: 'Enter Tube Count',
                        isRequired: true,
                        keyBoardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        fillColor: AppColor.white,
                        isReadOnly: widget.sampleCollectionItem
                            ?.iSSampleAccepted ==
                            '1'
                            ? true
                            : false,
                        maxLines: 1,
                        fontSize: 12.sp,
                        prefixIcon: CommonSvg(
                          path: 'assets/file.svg',
                          width: 26.w,
                          height: 26.h,
                          parentWidth: 30.w,
                          parentHeight: 30.h,
                          color: AppColor.secondaryColor,
                        ),
                      ),
                    if (controller.showOtherTextField)
                      MyCustomDropdown(
                        selectedItem: controller.trfFilledAccurately,
                        isViewProfile: widget.sampleCollectionItem
                            ?.iSSampleAccepted ==
                            '1'
                            ? true
                            : false,
                        labelText: 'TRFs Not Filled Accurately?',
                        prefixIcon: CommonSvg(
                          path: 'assets/testtube.svg',
                          width: 26.w,
                          height: 26.h,
                          parentWidth: 30.w,
                          parentHeight: 30.h,
                          color: AppColor.secondaryColor,
                        ),
                        items: controller.allQuestionList
                            .map((e) => e.answer)
                            .toList(),
                        hint: '',
                        isRequired: true,
                        senValue: (value) {
                          controller.trfFilledAccurately = value;
                          controller.update();
                        },
                        filledColor: AppColor.white,
                      ),
                    if (controller.trfFilledAccurately == "Yes" &&
                        controller.showOtherTextField)
                      TubeCountCustomTextField(
                        validator: (value) =>
                            trfCountValidator(
                                value, controller.trfCountTextField.text),
                        autofocus: false,
                        txtController:
                        controller.tubeCounttrfFilledAccurately,
                        labelText: 'Enter Tube Count',
                        hintText: 'Enter Tube Count',
                        isRequired: true,
                        keyBoardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        fillColor: AppColor.white,
                        isReadOnly: widget.sampleCollectionItem
                            ?.iSSampleAccepted ==
                            '1'
                            ? true
                            : false,
                        maxLines: 1,
                        fontSize: 12.sp,
                        prefixIcon: CommonSvg(
                          path: 'assets/file.svg',
                          width: 26.w,
                          height: 26.h,
                          parentWidth: 30.w,
                          parentHeight: 30.h,
                          color: AppColor.secondaryColor,
                        ),
                      ),
                    if (controller.showOtherTextField)
                      MyCustomDropdown(
                        // shouldValidate: controller.shouldValidate,
                        selectedItem: controller.barcodeNameMention,
                        isViewProfile: widget.sampleCollectionItem
                            ?.iSSampleAccepted ==
                            '1'
                            ? true
                            : false,
                        labelText:
                        'Barcode/Name, Age, Gender Not Mentioned on Tube?',
                        prefixIcon: CommonSvg(
                          path: 'assets/testtube.svg',
                          width: 26.w,
                          height: 26.h,
                          parentWidth: 30.w,
                          parentHeight: 30.h,
                          color: AppColor.secondaryColor,
                        ),
                        items: controller.allQuestionList
                            .map((e) => e.answer)
                            .toList(),
                        hint: '',
                        isRequired: true,
                        senValue: (value) {
                          controller.barcodeNameMention = value;
                          controller.update();
                        },
                        filledColor: AppColor.white,
                      ),
                    if (controller.barcodeNameMention == "Yes" &&
                        controller.showOtherTextField)
                      TubeCountCustomTextField(
                        validator: (value) =>
                            tubeCountValidator(
                                value, controller.tubeContainerCount.text),
                        autofocus: false,
                        txtController:
                        controller.tubeCountbarcodeNameMention,
                        labelText: 'Enter Tube Count',
                        hintText: 'Enter Tube Count',
                        isRequired: true,
                        keyBoardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        fillColor: AppColor.white,
                        isReadOnly: widget.sampleCollectionItem
                            ?.iSSampleAccepted ==
                            '1'
                            ? true
                            : false,
                        maxLines: 1,
                        fontSize: 12.sp,
                        prefixIcon: CommonSvg(
                          path: 'assets/file.svg',
                          width: 26.w,
                          height: 26.h,
                          parentWidth: 30.w,
                          parentHeight: 30.h,
                          color: AppColor.secondaryColor,
                        ),
                      ),
                    MyCustomDropdown(
                      // shouldValidate: controller.shouldValidate,
                      selectedItem: controller.otherDocCollected,
                      isViewProfile:
                      widget.sampleCollectionItem?.iSSampleAccepted ==
                          '1'
                          ? true
                          : false,
                      labelText: 'Other Document Collected?',
                      prefixIcon: CommonSvg(
                        path: 'assets/testtube.svg',
                        width: 26.w,
                        height: 26.h,
                        parentWidth: 30.w,
                        parentHeight: 30.h,
                        color: AppColor.secondaryColor,
                      ),
                      items: controller.allQuestionList
                          .map((e) => e.answer)
                          .toList(),
                      hint: '',
                      isRequired: true,
                      senValue: (value) {
                        controller.otherDocCollected = value;
                        controller.update();
                      },
                      filledColor: AppColor.white,
                    ),
                    if (controller.otherDocCollected == "Yes")
                      CustomTextField(
                        // shouldValidate: controller.shouldValidate,
                        autofocus: false,
                        txtController: controller.docName,
                        labelText: 'Document Name',
                        hintText: 'Document Name',
                        isRequired: true,
                        keyBoardType: TextInputType.text,
                        fillColor: AppColor.white,
                        isReadOnly: widget.sampleCollectionItem
                            ?.iSSampleAccepted ==
                            '1'
                            ? true
                            : false,
                        maxLines: 1,
                        fontSize: 12.sp,
                        prefixIcon: CommonSvg(
                          path: 'assets/file.svg',
                          width: 26.w,
                          height: 26.h,
                          parentWidth: 30.w,
                          parentHeight: 30.h,
                          color: AppColor.secondaryColor,
                        ),
                      ),
                    Column(
                      children: [
                        Row(
                          children: [
                            CustomText(
                                text: 'Upload Photo',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.normal,
                                textColor: AppColor.black,
                                textAlign: TextAlign.center,
                                fontFam: "Nunito Sans"),
                            CustomText(
                                text: ' *',
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                textColor: AppColor.red,
                                textAlign: TextAlign.center,
                                fontFam: "Nunito Sans"),
                          ],
                        ).paddingOnly(
                            top: 4.h, bottom: 0, left: 10.w, right: 10.h),
                        InkWell(
                          onTap: () {
                            if (widget.sampleCollectionItem
                                ?.iSSampleAccepted ==
                                '1') {} else {
                              collectSampleController.captureImage();
                            }
                          },
                          child: Container(
                            height: 100.h,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColor.borderGrey),
                                borderRadius: BorderRadius.circular(14),
                                color: AppColor.borderGrey
                                    .withValues(alpha: 0.2)),
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/upload_doc.png'),
                                  SizedBox(
                                    height: 6.h,
                                  ),
                                  CustomText(
                                      text: 'Click To Upload Photo',
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      textColor:
                                      AppColor.primaryBackgroundColor,
                                      textAlign: TextAlign.center,
                                      fontFam: "Nunito Sans")
                                ],
                              ),
                            ),
                          ).paddingOnly(
                              top: 4.h,
                              bottom: 14.h,
                              left: 10.w,
                              right: 10.w),
                        ),
                        Visibility(
                          visible:
                          collectSampleController.pickedImage != null,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 6.h, horizontal: 6.w),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColor.borderGrey),
                                borderRadius: BorderRadius.circular(14),
                                color: AppColor.borderGrey
                                    .withValues(alpha: 0.2)),
                            child: Center(
                              child: Row(
                                children: [
                                  if (collectSampleController
                                      .pickedImage !=
                                      null)
                                    Image.file(
                                      collectSampleController
                                          .pickedImage!,
                                      width: 40.w,
                                    ).paddingSymmetric(horizontal: 8.h),
                                  SizedBox(
                                    width: 6.w,
                                  ),
                                  Expanded(
                                    child: CustomText(
                                        text: 'Report',
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.normal,
                                        textColor: AppColor.black,
                                        textAlign: TextAlign.start,
                                        fontFam: "Nunito Sans"),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () {
                                        Get.to(ImageViewer(
                                          imagePath:
                                          collectSampleController
                                              .pickedImage?.path,
                                          title: "View Report",
                                        ));
                                      },
                                      icon: Icon(
                                        Icons.remove_red_eye_outlined,
                                        color: AppColor
                                            .primaryBackgroundColor,
                                      )),
                                  Visibility(
                                    visible: widget.sampleCollectionItem
                                        ?.iSSampleAccepted ==
                                        null ||
                                        widget.sampleCollectionItem
                                            ?.iSSampleAccepted ==
                                            '',
                                    child: IconButton(
                                        onPressed: () {
                                          collectSampleController
                                              .clearImage();
                                        },
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: AppColor
                                              .primaryBackgroundColor,
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ).paddingSymmetric(
                              vertical: 6.h, horizontal: 10.w),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Visibility(
                      visible:
                      widget.sampleCollectionItem?.iSSampleAccepted !=
                          '1',
                      child: CustomButton(
                        buttonFontSize: 12.sp,
                        buttonText: widget.isEdit ? 'Update' : 'Save',
                        path: 'assets/arrow_nav.svg',
                        callB: controller.isSubmitting
                            ? null
                            : () async {
                          if (formKey.currentState?.validate() ??
                              false) {
                            if (collectSampleController
                                .pickedImage !=
                                null) {
                              if (myVisitControllerController
                                  .latitude !=
                                  null &&
                                  myVisitControllerController
                                      .longitude !=
                                      null) {
                                if (widget.isEdit == false) {
                                  controller.submitSampleCollection(
                                      locId: controller
                                          .startRouteSampleCollectionModel
                                          ?.message
                                          .toString() ??
                                          '0',
                                      userId: userData['output'][0]['EmpCode']
                                          .toString(),
                                      sampleCount: controller
                                          .tubeContainerCount.text,
                                      amount: controller
                                          .amountCollected.text,
                                      submittedBy: userData['output']
                                      [0]['EmpCode']
                                          .toString(),
                                      createdBy: userData['output'][0]['EmpCode']
                                          .toString(),
                                      trfCount: controller.showOtherTextField ==
                                          false
                                          ? "0"
                                          : controller.trfCountTextField.text,
                                      receiptNo: '',
                                      centerId: widget.hospitalDetails!
                                          .facilityCode.toString(),
                                      latitude: myVisitControllerController
                                          .latitude.toString(),
                                      longitude: myVisitControllerController
                                          .longitude.toString(),
                                      mapFlag: '0',
                                      isPhotoEdit: '0',
                                      uploadedFile: File(
                                          collectSampleController.pickedImage!
                                              .path),
                                      temperature: controller
                                          .showOtherTextField == false
                                          ? "0"
                                          : controller.tempList!
                                          .firstWhere((e) =>
                                      e.sampleTempName == controller.temp)
                                          .sampleTempId.toString(),
                                      sampleId: '',
                                      pTypeId: widget.hospitalDetails!
                                          .customerType.toString(),
                                      availableFund: widget.hospitalDetails!
                                          .availableFund.toString(),
                                      paymentModeId: controller
                                          .showAmountFiled == false
                                          ? "0"
                                          : controller.paymentModeList
                                          .firstWhere((e) =>
                                      e.mode == controller.paymentMode)
                                          .paymentId
                                          .toString(),
                                      transactionNo: controller.transactionNo
                                          .text,
                                      contactPerson: controller
                                          .contactPersonName.text,
                                      sampleRemark: controller
                                          .showOtherTextField == false
                                          ? ""
                                          : controller
                                          .tubeCountSampleCollectedNonPluscare
                                          .text,
                                      sufficientTubeRemark: controller
                                          .tubeCountSampleQty.text,
                                      allSampleBarcodeRemark: controller
                                          .tubeCountbarcodeNameMention.text,
                                      otherDocumentRemark: controller.docName
                                          .text,
                                      sampleTubeId: controller
                                          .showOtherTextField == false
                                          ? "1"
                                          : controller.allQuestionList
                                          .firstWhere((e) =>
                                      e.answer == controller
                                          .sampleCollectedNonPluscareTube)
                                          .id
                                          .toString(),
                                      otherDocumentCollectedId: controller
                                          .allQuestionList
                                          .firstWhere((e) =>
                                      e.answer == controller.otherDocCollected)
                                          .id
                                          .toString(),
                                      sufficientTubeId: controller
                                          .showOtherTextField == false
                                          ? "1"
                                          : controller.allQuestionList
                                          .firstWhere((e) =>
                                      e.answer ==
                                          controller.sampleQtySufficient)
                                          .id
                                          .toString(),
                                      allSampleBarcodeId: controller
                                          .showOtherTextField == false
                                          ? "1"
                                          : controller.allQuestionList
                                          .firstWhere((e) =>
                                      e.answer == controller.barcodeNameMention)
                                          .id
                                          .toString(),
                                      detailsOnTrfRemark: controller
                                          .tubeCounttrfFilledAccurately.text,
                                      detailsOnTrfId: controller
                                          .showOtherTextField == false
                                          ? "1"
                                          : controller.allQuestionList
                                          .firstWhere((e) =>
                                      e.answer ==
                                          controller.trfFilledAccurately)
                                          .id
                                          .toString(),
                                      isEdit: false);
                                } else {
                                  controller.submitSampleCollection(
                                      locId: widget
                                          .sampleCollectionItem!
                                          .locID
                                          .toString(),
                                      userId: userData['output'][0]
                                      ['EmpCode']
                                          .toString(),
                                      sampleCount: controller
                                          .tubeContainerCount.text,
                                      amount: controller
                                          .amountCollected.text,
                                      submittedBy: userData['output']
                                      [0]['EmpCode']
                                          .toString(),
                                      createdBy: userData['output']
                                      [0]['EmpCode']
                                          .toString(),
                                      trfCount: controller.showOtherTextField ==
                                          false
                                          ? "0"
                                          : controller.trfCountTextField.text,
                                      receiptNo: '',
                                      centerId: widget.sampleCollectionItem!
                                          .facilityCode.toString(),
                                      latitude: widget.sampleCollectionItem
                                          ?.latitude ??
                                          myVisitControllerController.latitude
                                              .toString(),
                                      longitude: widget.sampleCollectionItem
                                          ?.longitude ??
                                          myVisitControllerController.longitude
                                              .toString(),
                                      mapFlag: '0',
                                      isPhotoEdit: '1',
                                      uploadedFile: File(
                                          collectSampleController.pickedImage!
                                              .path),
                                      temperature: controller
                                          .showOtherTextField == false
                                          ? "0"
                                          : controller.tempList!
                                          .firstWhere((e) =>
                                      e.sampleTempName == controller.temp)
                                          .sampleTempId.toString(),
                                      sampleId: widget.sampleCollectionItem!
                                          .sampleID.toString(),
                                      pTypeId: widget.sampleCollectionItem!
                                          .customerType.toString(),
                                      availableFund: widget
                                          .sampleCollectionItem!.availableFund
                                          .toString(),
                                      paymentModeId: controller
                                          .showAmountFiled == false
                                          ? "0"
                                          : controller.paymentModeList
                                          .firstWhere((e) =>
                                      e.mode == controller.paymentMode)
                                          .paymentId
                                          .toString(),
                                      transactionNo: controller.transactionNo
                                          .text,
                                      contactPerson: controller
                                          .contactPersonName.text,
                                      sampleRemark: controller
                                          .showOtherTextField == false
                                          ? ""
                                          : controller
                                          .tubeCountSampleCollectedNonPluscare
                                          .text,
                                      sufficientTubeRemark: controller
                                          .tubeCountSampleQty.text,
                                      allSampleBarcodeRemark: controller
                                          .tubeCountbarcodeNameMention.text,
                                      otherDocumentRemark: controller.docName
                                          .text,
                                      sampleTubeId: controller
                                          .showOtherTextField == false
                                          ? "1"
                                          : controller.allQuestionList
                                          .firstWhere((e) =>
                                      e.answer == controller
                                          .sampleCollectedNonPluscareTube)
                                          .id
                                          .toString(),
                                      otherDocumentCollectedId: controller
                                          .allQuestionList
                                          .firstWhere((e) =>
                                      e.answer == controller.otherDocCollected)
                                          .id
                                          .toString(),
                                      sufficientTubeId: controller
                                          .showOtherTextField == false
                                          ? "1"
                                          : controller.allQuestionList
                                          .firstWhere((e) =>
                                      e.answer ==
                                          controller.sampleQtySufficient)
                                          .id
                                          .toString(),
                                      allSampleBarcodeId: controller
                                          .showOtherTextField == false
                                          ? "1"
                                          : controller.allQuestionList
                                          .firstWhere((e) =>
                                      e.answer == controller.barcodeNameMention)
                                          .id
                                          .toString(),
                                      detailsOnTrfRemark: controller
                                          .tubeCounttrfFilledAccurately.text,
                                      detailsOnTrfId: controller
                                          .showOtherTextField == false
                                          ? "1"
                                          : controller.allQuestionList
                                          .firstWhere((e) =>
                                      e.answer ==
                                          controller.trfFilledAccurately)
                                          .id
                                          .toString(),
                                      isEdit: true);
                                }
                              } else {
                                await fetchLocation();
                              }
                            } else {
                              CustomMessage.toast(
                                  "Please upload photo");
                            }
                          } else {
                            CustomMessage.toast(
                                "Please fill mandatory fields");
                          }
                        },
                        // buttonWidth: double.infinity,
                        primColor: AppColor.primaryBackgroundColor,
                        secColor: AppColor.secondaryColor,
                        textColor: AppColor.white,
                        iconColor: AppColor.white,
                        buttonWidth: 120.w,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ).paddingSymmetric(vertical: 4.h, horizontal: 10.w),
              ),
            )
                : InternetIssue(
              onRetryPressed: () {
                checkInternetAndLoadData();
              },
            ),
          );
        });
  }

  resetFiled() {
    collectSampleController.showOtherTextField = true;
    collectSampleController.showAmountFiled = true;
    collectSampleController.pickedImage = null;
    collectSampleController.tubeContainerCount.clear();
    collectSampleController.trfCountTextField.clear();
    collectSampleController.amountCollected.clear();
    collectSampleController.paymentMode = null;
    collectSampleController.transactionNo.clear();
    collectSampleController.temp = null;
    collectSampleController.contactPersonName.clear();
    collectSampleController.tubeCountSampleQty.clear();
    collectSampleController.tubeCountSampleCollectedNonPluscare.clear();
    collectSampleController.tubeCounttrfFilledAccurately.clear();
    collectSampleController.tubeCountbarcodeNameMention.clear();
    collectSampleController.sampleQtySufficient = null;
    collectSampleController.sampleCollectedNonPluscareTube = null;
    collectSampleController.trfFilledAccurately = null;
    collectSampleController.barcodeNameMention = null;
    collectSampleController.otherDocCollected = null;
    collectSampleController.filteredCustomerList.clear();
    collectSampleController.docName.clear();
  }

  Future<void> getUserData() async {
    userData = await SharedPref().read(const SharedPrefConstant().kUserData);
    await fetchLocation();
    await collectSampleController.getSampleTempList();
    collectSampleController.update();
    if (widget.isEdit) {
      collectSampleController
          .setFieldOnEditOnRunnerBoy(widget.sampleCollectionItem);
    } else {
      resetFiled();
    }
  }

  void connectivityListener() async {
    _sub = Connectivity()
        .onConnectivityChanged
        .map((list) =>
        list.any((r) =>
        r == ConnectivityResult.wifi ||
            r == ConnectivityResult.mobile ||
            r == ConnectivityResult.ethernet))
        .distinct()
        .debounce(const Duration(milliseconds: 300))
        .listen((hasNetwork) {
      collectSampleController.hasInternet = hasNetwork;
      collectSampleController.update();
    });
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
      getUserData();
    }
  }

  Future<bool> fetchLocation() async {
    try {
      await myVisitControllerController.getLocation();
      return myVisitControllerController.latitude != null &&
          myVisitControllerController.longitude != null;
    } catch (e) {
      debugPrint("Location fetch error: $e");
      CustomMessage.toast("Location fetch error: $e");
      return false;
    }
  }

  String? tubeCountValidator(String? value, String maxAllowed) {
    int maxAllowedCount = maxAllowed.isEmpty ? 0 : int.parse(maxAllowed);
    if (value == null || value.isEmpty) return 'Required';
    int entered = int.tryParse(value) ?? 0;
    if (entered > maxAllowedCount) {
      return 'Cannot exceed Tube/Container Count ($maxAllowedCount)';
    }
    return null;
  }

  String? trfCountValidator(String? value, String maxAllowed) {
    int maxAllowedCount = maxAllowed.isEmpty ? 0 : int.parse(maxAllowed);
    if (value == null || value.isEmpty) return 'Required';
    int entered = int.tryParse(value) ?? 0;
    if (entered > maxAllowedCount) {
      return 'Cannot exceed TRF Count ($maxAllowedCount)';
    }
    return null;
  }
}

class PaymentMode {
  String? mode;
  int? paymentId;

  PaymentMode({this.mode, this.paymentId});
}

class AllQuestions {
  String? answer;
  int? id;

  AllQuestions({this.answer, this.id});
}
