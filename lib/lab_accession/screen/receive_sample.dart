import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marketingapp/lab_accession/screen/accept_pending_sample.dart';
import 'package:marketingapp/lab_accession/controller/receive_sample_controller.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/utils/shared_pref_constants.dart';
import 'package:marketingapp/utils/shared_preference.dart';
import 'package:marketingapp/widgets/common_svg.dart';
import 'package:marketingapp/widgets/custom_button.dart';
import 'package:marketingapp/widgets/custom_date_field.dart';
import 'package:marketingapp/widgets/custom_text.dart';
import 'package:marketingapp/widgets/date_picker.dart';
import 'package:marketingapp/widgets/dropdown_search.dart';
import 'package:marketingapp/widgets/no_internet_connectivity.dart';

class ReceiveSampleScreen extends StatefulWidget {
  const ReceiveSampleScreen({super.key});

  @override
  State<ReceiveSampleScreen> createState() => _ReceiveSampleScreenState();
}

class _ReceiveSampleScreenState extends State<ReceiveSampleScreen>
    with TickerProviderStateMixin {
  final ReceiveSampleController receiveSampleController =
  Get.put(ReceiveSampleController());
  var userData;

  late final TabController tabController;

  String? selectedLabCode;

  String? selectedUserId;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    checkInternetAndLoadData();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      // setState(() {}); // Update the UI when the tab changes
      receiveSampleController.update();
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<void> getUserData() async {
    userData = await SharedPref().read(const SharedPrefConstant().kUserData);
    receiveSampleController
        .getLabNameList(userData['output'][0]['EmpCode'].toString());
    receiveSampleController.update();
  }

  checkInternetAndLoadData() async {
    final List<ConnectivityResult> connectivityResult =
    await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      receiveSampleController.hasInternet = true;
    } else {
      receiveSampleController.hasInternet = false;
    }
    receiveSampleController.update();
    if (receiveSampleController.hasInternet) {
      getUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReceiveSampleController>(
        init: receiveSampleController,
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
                        ],
                        // Change colors as needed
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  title: CustomText(
                    text: "Receive Samples",
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
                  ? Form(
                key: formKey,
                child: Column(
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
                            callB: () async {
                              // Reset all selections and lists
                              controller.selectedLab = null;
                              controller.selectedRunnerBoy = null;
                              selectedLabCode = null;
                              selectedUserId = null;

                              controller.labNameList = null;
                              controller.resourceNameListModel = null;

                              controller.fDateController.clear();
                              controller.update();

                              await selectFromDate();

                              // Load labs again based on new date
                              if (receiveSampleController.hasInternet) {
                                await getUserData();
                              }
                              // controller.selectedLab = null;
                              // selectedLabCode = null;
                              // controller.selectedRunnerBoy = null;
                              // selectedUserId = null;
                              // controller.update();
                              // selectFromDate();
                            },
                            selectedDate:
                            receiveSampleController.fDateController,
                            filledColor: Colors.white,
                            prefixIconColor:
                            AppColor.primaryBackgroundColor,
                            dontDhowPrefix: false,
                          ),

                          DropDownSearch(
                            selectedItem: controller.selectedLab,
                            labelText: 'Lab Name',
                            items: controller.labNameList?.output
                                .map((e) => e.labName)
                                .toList() ??
                                [],
                            hint: '',
                            isRequired: true,
                            senValue: (value) async {
                              controller.selectedLab = value;

                              // Get Lab Code
                              selectedLabCode = controller.labNameList?.output
                                  .firstWhere((e) => e.labName == value)
                                  .labCode
                                  .toString();

                              // ✅ Clear Runner Boy data immediately before fetching
                              controller.selectedRunnerBoy = null;
                              controller.resourceNameListModel =
                              null; // clear old data
                              controller.update();

                              // Fetch new runner boys for the selected lab
                              await controller.getResourceList(
                                  selectedLabCode!);
                              // controller.selectedLab = value;
                              //
                              // selectedLabCode = controller
                              //     .labNameList?.output
                              //     .firstWhere((e) => e.labName == value)
                              //     .labCode
                              //     .toString();
                              //
                              // await controller
                              //     .getResourceList(selectedLabCode!);
                              //
                              // controller.update();
                            },
                            filledColor: AppColor.white,
                            prefixIcon: CommonSvg(
                              path: "assets/labs.svg",
                              width: 26,
                              height: 26,
                              parentWidth: 30,
                              parentHeight: 30,
                              color: AppColor.primaryBackgroundColor,
                            ),
                          ).paddingSymmetric(horizontal: 6),

                          DropDownSearch(
                            selectedItem: controller.selectedRunnerBoy,
                            labelText: 'Runner Boy',
                            items: controller
                                .resourceNameListModel?.output
                                .map((e) => e.name)
                                .toList() ??
                                [],
                            hint: '',
                            isRequired: true,
                            senValue: (value) async {
                              controller.selectedRunnerBoy = value;

                              selectedUserId = controller
                                  .resourceNameListModel?.output
                                  .firstWhere((e) => e.name == value)
                                  .userid
                                  .toString();
                              controller.update();
                            },
                            filledColor: AppColor.white,
                            prefixIcon: CommonSvg(
                              path: "assets/username.svg",
                              width: 26,
                              height: 26,
                              parentWidth: 30,
                              parentHeight: 30,
                              color: AppColor.primaryBackgroundColor,
                            ),
                          ).paddingSymmetric(horizontal: 6),

                          // MyCustomDropdown(
                          //   // shouldValidate:true,
                          //   dropdownColor:
                          //       AppColor.primaryBackgroundColor,
                          //   selectedItem: controller.selectedRunnerBoy,
                          //   labelText: 'Runner Boy',
                          //   prefixIcon: CommonSvg(
                          //     path: "assets/username.svg",
                          //     width: 26,
                          //     height: 26,
                          //     parentWidth: 30,
                          //     parentHeight: 30,
                          //     color: AppColor.primaryBackgroundColor,
                          //   ),
                          //   items: controller
                          //           .resourceNameListModel?.output
                          //           .map((e) => e.name)
                          //           .toList() ??
                          //       [],
                          //   hint: '',
                          //   isRequired: true,
                          //   senValue: (value) async {
                          //     controller.selectedRunnerBoy = value;
                          //
                          //     selectedUserId = controller
                          //         .resourceNameListModel?.output
                          //         .firstWhere((e) => e.name == value)
                          //         .userid
                          //         .toString();
                          //   },
                          //   filledColor: AppColor.white,
                          // ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomButton(
                            buttonFontSize: 16,
                            buttonText: 'Search',
                            path: 'assets/arrow_nav.svg',
                            callB: () {
                              if (formKey.currentState?.validate() ??
                                  false) {
                                Get.to(AcceptPendingSample(
                                  date: receiveSampleController
                                      .dateSendToApi!,
                                  userId: selectedUserId!,
                                  labCode: selectedLabCode!,
                                ));
                              }
                            },
                            // buttonWidth: double.infinity,
                            primColor: AppColor.primaryBackgroundColor,
                            secColor: AppColor.secondaryColor,
                            textColor: AppColor.white,
                            iconColor: AppColor.white,
                            buttonWidth: 170,
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
                  ],
                ),
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
    await DatePickerHelper.visiableCurrentAndYesturdaysDateOnly(context);
    if (picked != null) {
      // Update the selected date
      receiveSampleController.selectedFromDate = picked;

      DateFormat formatter1 = DateFormat('yyyy/MM/dd');
      DateFormat formatter = DateFormat('dd-MM-yyyy');
      receiveSampleController.formattedFromDate =
          formatter.format(receiveSampleController.selectedFromDate!);
      receiveSampleController.dateSendToApi =
          formatter1.format(receiveSampleController.selectedFromDate!);
      // Set the formatted date in the text field
      receiveSampleController.fDateController.text =
      receiveSampleController.formattedFromDate!;

      // Refresh the UI
      setState(() {});
    }
  }
}
