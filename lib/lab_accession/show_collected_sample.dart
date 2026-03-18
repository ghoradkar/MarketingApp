import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:marketingapp/add_visit/model/marketing_person_model.dart';
import 'package:marketingapp/dashboard/my_visit_controller.dart';
import 'package:marketingapp/lab_accession/model/sample_pending_from_accession.dart';
import 'package:marketingapp/runnerboy/controller/sample_collection_controller.dart';
import 'package:marketingapp/runnerboy/model/get_center_id_and_available_fund.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/utils/shared_pref_constants.dart';
import 'package:marketingapp/utils/shared_preference.dart';
import 'package:marketingapp/widgets/common_svg.dart';
import 'package:marketingapp/widgets/custom_text.dart';
import 'package:marketingapp/widgets/custom_text_field.dart';
import 'package:marketingapp/widgets/my_custom_dropdown.dart';
import 'package:marketingapp/widgets/no_internet_connectivity.dart';
import 'package:marketingapp/widgets/view_image.dart';

class ShowCollectSample extends StatefulWidget {
  final CenterIdAndAvailableFundOutput? hospitalDetails;
  final AcceptedPendingOutput? sampleCollectionItem;
  final bool isEdit;

  const ShowCollectSample(
      {super.key,
      this.hospitalDetails,
      required this.isEdit,
      this.sampleCollectionItem});

  @override
  State<ShowCollectSample> createState() => _ShowCollectSampleState();
}

class _ShowCollectSampleState extends State<ShowCollectSample> {
  final SampleCollectionController collectSampleController =
      Get.find<SampleCollectionController>();
  final MyVisitControllerController myVisitControllerController = Get.find();

  // final CameraControllerX cameraController = Get.put(CameraControllerX());

  var userData;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? selectedMarketingPerson;

  List<MarketingOutput>? selectedMarketingVal;
  String? selectedServicesVal;

  @override
  void initState() {
    collectSampleController.pickedImage = null;
    // cameraController.pickedImage.clear();
    getUserData();
    super.initState();
  }

  Future<void> getUserData() async {
    userData = await SharedPref().read(const SharedPrefConstant().kUserData);

    await collectSampleController.getSampleTempList();

    if (widget.isEdit) {
      collectSampleController
          .setFieldOnEditOnAccessionTeam(widget.sampleCollectionItem);
    }
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
                    // Change colors as needed
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              title: CustomText(
                text: "Sample Collection",
                fontSize: 18,
                fontWeight: FontWeight.w500,
                textColor: AppColor.black,
                textAlign: TextAlign.start,
                fontFam: 'Nunito Sans',
              ),
              leading: IconButton(
                  onPressed: () {
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Card(
                            color: AppColor.white,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: Image.asset(
                                    "assets/location.png",
                                    color: AppColor.secondaryColor,
                                  ),
                                ),
                                Expanded(
                                  child: CustomTextRichText(
                                    textHeading: 'Current  Location',
                                    fontSize: 16,
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
                            ).paddingOnly(bottom: 8, top: 0, right: 16),
                          ),

                          Card(
                            color: AppColor.white,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: Image.asset(
                                    "assets/user-square.png",
                                    color: AppColor.secondaryColor,
                                  ),
                                ),
                                Expanded(
                                  child: CustomTextRichText(
                                    textHeading: 'Name',
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    textColor: Colors.black,
                                    textAlign: TextAlign.start,
                                    text: widget.isEdit
                                        ? widget
                                            .sampleCollectionItem!.customerName
                                        : widget.hospitalDetails
                                                ?.customerTypeName ??
                                            "",
                                    fontWeightHeading: FontWeight.bold,
                                    textColorHeading: AppColor.black,
                                  ),
                                )
                              ],
                            ).paddingOnly(bottom: 0, top: 8, right: 16),
                          ),
                          CustomTextField(
                            autofocus: false,
                            txtController: controller.tubeContainerCount,
                            labelText: 'Tube/Container Count',
                            hintText: 'Tube/Container Count',
                            isRequired: true,
                            keyBoardType: TextInputType.number,
                            fillColor: AppColor.white,
                            isReadOnly: true,
                            maxLines: 1,
                            fontSize: 16,
                            prefixIcon: CommonSvg(
                              path: 'assets/testtube.svg',
                              width: 26,
                              height: 26,
                              parentWidth: 30,
                              parentHeight: 30,
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
                          ),
                          Visibility(
                            visible: controller.showOtherTextField,
                            child: CustomTextField(
                              autofocus: false,
                              txtController: controller.trfCountTextField,
                              labelText: 'TRF Count',
                              hintText: 'TRF Count',
                              isRequired: true,
                              keyBoardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              fillColor: AppColor.white,
                              isReadOnly: true,
                              maxLines: 1,
                              fontSize: 16,
                              prefixIcon: Image.asset(
                                "assets/progress.png",
                                color: AppColor.secondaryColor,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  autofocus: false,
                                  txtController: controller.amountCollected,
                                  labelText: 'Amount Collected',
                                  hintText: 'Amount Collected',
                                  isRequired: true,
                                  keyBoardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*'),
                                    ),
                                  ],
                                  fillColor: AppColor.white,
                                  isReadOnly: true,
                                  maxLines: 1,
                                  fontSize: 16,
                                  prefixIcon: Image.asset(
                                    "assets/cash.png",
                                    color: AppColor.secondaryColor,
                                  ),
                                  onChanged: (value) {
                                    if (value.trim().isEmpty) {
                                      controller.showAmountFiled = true;
                                    } else {
                                      double amount =
                                          double.tryParse(value) ?? 0;
                                      controller.showAmountFiled = amount != 0;
                                    }
                                    controller.update();
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Visibility(
                                visible: controller.showAmountFiled,
                                child: Expanded(
                                  child: MyCustomDropdown(
                                    selectedItem: controller.paymentMode,
                                    isViewProfile: true,
                                    labelText: 'Payment Mode',
                                    prefixIcon: Image.asset(
                                      "assets/paymentMode.png",
                                      color: AppColor.secondaryColor,
                                    ),
                                    items: controller.paymentModeList
                                        .map((e) => e.mode)
                                        .toList(),
                                    hint: '',
                                    isRequired: true,
                                    senValue: (value) async {
                                      controller.paymentMode = value;
                                      controller.update();
                                    },
                                    filledColor: AppColor.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: (controller.paymentMode == "Online"),
                            child: CustomTextField(
                              autofocus: false,
                              txtController: controller.transactionNo,
                              labelText: 'Transaction No',
                              hintText: 'Transaction No',
                              isRequired: true,
                              keyBoardType: TextInputType.text,
                              fillColor: AppColor.white,
                              isReadOnly: true,
                              maxLines: 1,
                              fontSize: 16,
                              prefixIcon: Image.asset(
                                "assets/progress.png",
                                color: AppColor.secondaryColor,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: controller.showOtherTextField,
                            child: MyCustomDropdown(
                              selectedItem: controller.temp,
                              isViewProfile: true,
                              labelText: 'Temperature',
                              prefixIcon: Image.asset(
                                "assets/temperature.png",
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
                          ),
                          Visibility(
                            visible: controller.showOtherTextField,
                            child: CustomTextField(
                              autofocus: false,
                              txtController: controller.contactPersonName,
                              labelText: 'Contact Person Name',
                              hintText: 'Contact Person Name',
                              isRequired: true,
                              keyBoardType: TextInputType.text,
                              fillColor: AppColor.white,
                              isReadOnly: true,
                              maxLines: 1,
                              fontSize: 16,
                              prefixIcon: Image.asset(
                                "assets/user-circle.png",
                                color: AppColor.secondaryColor,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: controller.showOtherTextField,
                            child: MyCustomDropdown(
                              selectedItem: controller.sampleQtySufficient,
                              isViewProfile: true,
                              labelText: 'Sample Quantity Is Sufficient?',
                              prefixIcon: CommonSvg(
                                path: 'assets/testtube.svg',
                                width: 26,
                                height: 26,
                                parentWidth: 30,
                                parentHeight: 30,
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
                          ),
                          Visibility(
                            visible: controller.sampleQtySufficient == "Yes",
                            child: CustomTextField(
                              autofocus: false,
                              txtController: controller.tubeCountSampleQty,
                              labelText: 'Enter Tube Count',
                              hintText: 'Enter Tube Count',
                              isRequired: true,
                              keyBoardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              fillColor: AppColor.white,
                              isReadOnly: true,
                              maxLines: 1,
                              fontSize: 16,
                              prefixIcon: Image.asset(
                                "assets/file.png",
                                color: AppColor.secondaryColor,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: controller.showOtherTextField,
                            child: MyCustomDropdown(
                              selectedItem:
                                  controller.sampleCollectedNonPluscareTube,
                              isViewProfile: true,
                              labelText:
                                  'Sample Collected In Non Pluscare Tubes?',
                              prefixIcon: CommonSvg(
                                path: 'assets/testtube.svg',
                                width: 26,
                                height: 26,
                                parentWidth: 30,
                                parentHeight: 30,
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
                          ),
                          Visibility(
                            visible:
                                controller.sampleCollectedNonPluscareTube ==
                                    "Yes",
                            child: CustomTextField(
                              autofocus: false,
                              txtController: controller
                                  .tubeCountSampleCollectedNonPluscare,
                              labelText: 'Enter Tube Count',
                              hintText: 'Enter Tube Count',
                              isRequired: true,
                              keyBoardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              fillColor: AppColor.white,
                              isReadOnly: true,
                              maxLines: 1,
                              fontSize: 16,
                              prefixIcon: Image.asset(
                                "assets/file.png",
                                color: AppColor.secondaryColor,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: controller.showOtherTextField,
                            child: MyCustomDropdown(
                              selectedItem: controller.trfFilledAccurately,
                              isViewProfile: true,
                              labelText: 'TRFs Filled Accurately?',
                              prefixIcon: CommonSvg(
                                path: 'assets/testtube.svg',
                                width: 26,
                                height: 26,
                                parentWidth: 30,
                                parentHeight: 30,
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
                          ),
                          Visibility(
                            visible: controller.trfFilledAccurately == "Yes",
                            child: CustomTextField(
                              autofocus: false,
                              txtController:
                                  controller.tubeCounttrfFilledAccurately,
                              labelText: 'Enter Tube Count',
                              hintText: 'Enter Tube Count',
                              isRequired: true,
                              keyBoardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              fillColor: AppColor.white,
                              isReadOnly: true,
                              maxLines: 1,
                              fontSize: 16,
                              prefixIcon: Image.asset(
                                "assets/file.png",
                                color: AppColor.secondaryColor,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: controller.showOtherTextField,
                            child: MyCustomDropdown(
                              selectedItem: controller.barcodeNameMention,
                              isViewProfile: true,
                              labelText:
                                  'Barcode/Name, Age, Gender Mentioned on Tube?',
                              prefixIcon: CommonSvg(
                                path: 'assets/testtube.svg',
                                width: 26,
                                height: 26,
                                parentWidth: 30,
                                parentHeight: 30,
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
                          ),
                          Visibility(
                            visible: controller.barcodeNameMention == "Yes",
                            child: CustomTextField(
                              autofocus: false,
                              txtController:
                                  controller.tubeCountbarcodeNameMention,
                              labelText: 'Enter Tube Count',
                              hintText: 'Enter Tube Count',
                              isRequired: true,
                              keyBoardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              fillColor: AppColor.white,
                              isReadOnly: true,
                              maxLines: 1,
                              fontSize: 16,
                              prefixIcon: Image.asset(
                                "assets/file.png",
                                color: AppColor.secondaryColor,
                              ),
                            ),
                          ),
                          MyCustomDropdown(
                            selectedItem: controller.otherDocCollected,
                            isViewProfile: true,
                            labelText: 'Other Document Collected?',
                            prefixIcon: CommonSvg(
                              path: 'assets/testtube.svg',
                              width: 26,
                              height: 26,
                              parentWidth: 30,
                              parentHeight: 30,
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
                          Visibility(
                            visible: controller.otherDocCollected == "Yes",
                            child: CustomTextField(
                              autofocus: false,
                              txtController: controller.docName,
                              labelText: 'Document Name',
                              hintText: 'Document Name',
                              isRequired: true,
                              keyBoardType: TextInputType.text,
                              fillColor: AppColor.white,
                              isReadOnly: true,
                              maxLines: 1,
                              fontSize: 16,
                              prefixIcon: Image.asset(
                                "assets/file.png",
                                color: AppColor.secondaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),


                          Column(
                            children: [
                              Visibility(
                                visible:
                                    collectSampleController.pickedImage != null,
                                child: InkWell(
                                  onTap: () {
                                    Get.to(ImageViewer(
                                      imagePath: collectSampleController
                                          .pickedImage?.path,
                                      title: "View Report",
                                    ));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 6),
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
                                              width: 40,
                                            ).paddingSymmetric(horizontal: 8),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          CustomText(
                                              text: 'Report.png',
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              textColor: AppColor.black,
                                              textAlign: TextAlign.start,
                                              fontFam: "Nunito Sans"),
                                          Spacer(),
                                          Icon(
                                            Icons.remove_red_eye_outlined,
                                            color:
                                                AppColor.primaryBackgroundColor,
                                          )
                                        ],
                                      ),
                                    ),
                                  ).paddingSymmetric(
                                      vertical: 6, horizontal: 10),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ).paddingSymmetric(vertical: 4, horizontal: 10),
                    ),
                  )
                : InternetIssue(
                    onRetryPressed: () {
                      getUserData();
                    },
                  ),
          );
        });
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
