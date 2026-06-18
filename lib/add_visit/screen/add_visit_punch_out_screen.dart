import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get/get.dart';
import 'package:marketingapp/add_visit/controller/add_visit_controller.dart';
import 'package:marketingapp/add_visit/model/customer_list_model.dart';
import 'package:marketingapp/add_visit/model/marketing_person_model.dart';
import 'package:marketingapp/add_visit/model/services_model.dart';
import 'package:marketingapp/dashboard/controller/my_visit_controller.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/utils/shared_pref_constants.dart';
import 'package:marketingapp/utils/shared_preference.dart';
import 'package:marketingapp/widgets/common_svg.dart';
import 'package:marketingapp/widgets/cust_toast.dart';
import 'package:marketingapp/widgets/custom_button.dart';
import 'package:marketingapp/widgets/custom_popup.dart';
import 'package:marketingapp/widgets/custom_text.dart';
import 'package:marketingapp/widgets/custom_text_field.dart';
import 'package:marketingapp/widgets/my_custom_dropdown.dart';

class AddVisitPunchOutScreen extends StatefulWidget {
  static const routeName = '/add-visit-punch-out';

  const AddVisitPunchOutScreen({super.key});

  @override
  State<AddVisitPunchOutScreen> createState() => _AddVisitPunchOutScreenState();
}

class _AddVisitPunchOutScreenState extends State<AddVisitPunchOutScreen>
    with WidgetsBindingObserver {
  OutputCustomer? hospitalDetails;
  final AddVisitController addVisitController = Get.find<AddVisitController>();
  final MyVisitControllerController myVisitControllerController =
      Get.find<MyVisitControllerController>();

  Map<String, dynamic>? userData;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();

  String? selectedMarketingPerson;
  List<MarketingOutput>? selectedMarketingVal;
  List<SelectedServiceModel>? selectedServices;
  String? selectedServicesVal;
  Timer? _debounceTimer;

  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    hospitalDetails = Get.arguments as OutputCustomer?;
    _resetControllerState();
    WidgetsBinding.instance.addObserver(this);
    _initializeScreen();
  }

  void _resetControllerState() {
    addVisitController.selectedDist = null;
    addVisitController.filteredCustomerList.clear();
    addVisitController.customerListModel?.output?.clear();
    addVisitController.searchController.clear();
    formKey.currentState?.reset();
    addVisitController.discussionPoints.clear();
    addVisitController.shouldValidateFields = false;
  }

  Future<void> _initializeScreen() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      await getUserData();
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

  Future<void> getUserData() async {
    try {
      userData = await SharedPref().read(const SharedPrefConstant().kUserData);
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
        addVisitController.hasInternet = true;

        // Try to fetch fresh data from API
        if (addVisitController.hasInternet && userData != null) {
          await fetchLocation();
          await fetchAllData();
        }
      } else {
        addVisitController.hasInternet = false;
        debugPrint("No internet connection");
      }
    } catch (e) {
      debugPrint("Connectivity check error: $e");
      addVisitController.hasInternet = false;
    }

    addVisitController.update();
    setState(() {});
  }

  Future<void> fetchAllData() async {
    try {
      Iterable<Future> futureList = [
        if (myVisitControllerController.latitude == null &&
            myVisitControllerController.longitude == null)
          fetchLocation(),
        addVisitController.getPunchInDetails(
          userData!['output'][0]['EmpCode'].toString(),
          hospitalDetails!.userid.toString(),
        ),
        addVisitController.getVisitType(),
        addVisitController.getClientStatus(),
        addVisitController.getContactPersonDesig(),
        addVisitController.getContactPersonStatus(),
        addVisitController.getServicesList(),
        addVisitController.getMarketingPersons(
          userData!['output'][0]['EmpCode'].toString(),
        ),
      ];

      await Future.wait(futureList);
    } catch (e) {
      debugPrint("Error fetching data: $e");
      // Don't block UI if this fails
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint("App state changed to: $state");
    if (state == AppLifecycleState.resumed) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(seconds: 1), () async {
        bool success = await fetchLocation();
        if (success) {
          myVisitControllerController.update();
          setState(() {});
        } else {
          debugPrint("Failed to get location after resume");
        }
      });
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: addVisitController,
        builder: (controller) {
          return PopScope(
            canPop: false,
            onPopInvoked: (bool didPop) async {
              if (didPop) return;
              return;
            },
            child: Scaffold(
              appBar: AppBar(
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        FlavorConfig.instance.name == "HindLab Operational"
                            ? AppColor.primaryBackgroundColor
                                .withValues(alpha: 0.1)
                            : AppColor.primaryBackgroundColor
                                .withValues(alpha: 0.3),
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
                  text: hospitalDetails?.firstname ?? "",
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  textColor: AppColor.black,
                  textAlign: TextAlign.start,
                  fontFam: 'Nunito Sans',
                  maxLine: 2,
                ),
                leading: IconButton(
                    onPressed: () {
                      _clearControllerData();
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_back)),
                actions: [
                  Visibility(
                    visible: controller.punchInDetailsModel?.message ==
                        "Customer Visit Punching Details not found",
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CustomButton(
                        buttonText: 'Punch In',
                        path: 'assets/arrow_nav.svg',
                        callB: () async {
                          if (!controller.hasInternet) {
                            _showOfflineMessage();
                            return;
                          }

                          if (myVisitControllerController.latitude != null &&
                              myVisitControllerController.longitude != null) {
                            CustomPopup.yesNoConfirmationDialog(
                                () {
                                  Get.back();
                                },
                                () async {
                                  Get.back();

                                  await addVisitController.insetPunchIn(
                                      hospitalDetails!.userid.toString(),
                                      userData!['output'][0]['EmpCode']
                                          .toString(),
                                      myVisitControllerController.latitude
                                          .toString(),
                                      myVisitControllerController.longitude
                                          .toString());

                                  await addVisitController.getPunchInDetails(
                                      userData!['output'][0]['EmpCode']
                                          .toString(),
                                      hospitalDetails!.userid.toString());
                                },
                                "Are you sure you want to\nPunch In ?",
                                'assets/pointing-down.png',
                                "Yes",
                                100,
                                () {
                                  Get.back();
                                },
                                "No");
                          } else {
                            await fetchLocation();
                          }
                        },
                        primColor: AppColor.primaryBackgroundColor,
                        secColor: AppColor.secondaryColor,
                        textColor: AppColor.white,
                        iconColor: AppColor.white,
                        buttonFontSize: 14,
                        buttonWidth: 120,
                      ),
                    ),
                  ),
                ],
              ),
              body: _buildBody(controller),
            ),
          );
        });
  }

  Widget _buildBody(AddVisitController controller) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (hasError) {
      return _buildErrorWidget();
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
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    color: AppColor.white,
                    child: const Row(
                      children: [
                        Expanded(
                          child: CustomTextRichText(
                            textHeading: 'Note',
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            textColor: Colors.red,
                            textAlign: TextAlign.start,
                            text:
                                "Punch in upon arrival at the customer's location, record the visit, and punch out upon departure.",
                            fontWeightHeading: FontWeight.bold,
                            textColorHeading: Colors.red,
                          ),
                        ),
                      ],
                    ).paddingOnly(left: 16, right: 16, bottom: 8, top: 8),
                  ),
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
                            textHeading: 'Google Location Approx',
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            textColor: Colors.black,
                            textAlign: TextAlign.start,
                            text: myVisitControllerController.locationMessage ??
                                "location not found",
                            fontWeightHeading: FontWeight.bold,
                            textColorHeading: AppColor.black,
                          ),
                        )
                      ],
                    ).paddingOnly(bottom: 8, top: 8, right: 16),
                  ),
                  MyCustomDropdown(
                    selectedItem: controller.selectedVisitType,
                    isViewProfile: controller.punchInDetailsModel?.output?.first
                            .punchingStatus !=
                        1,
                    labelText: 'Visit Type',
                    prefixIcon: CommonSvg(
                      path: "assets/addvisit.svg",
                      width: 30,
                      height: 30,
                      parentWidth: 30,
                      parentHeight: 30,
                      color: AppColor.secondaryColor,
                    ),
                    items: controller.visitTypeModel?.output
                            ?.map((e) => e.visitType)
                            .toList() ??
                        [],
                    hint: '',
                    isRequired: true,
                    senValue: (value) {
                      if (value != null) {
                        controller.selectedVisitType = value;
                        controller.selectedVisit = controller
                            .visitTypeModel?.output
                            ?.firstWhere((e) => e.visitType == value);
                        controller.update();
                      }
                    },
                    filledColor: AppColor.white,
                  ),
                  MyCustomDropdown(
                    selectedItem: controller.selectedClientStat,
                    isViewProfile: controller.punchInDetailsModel?.output?.first
                            .punchingStatus !=
                        1,
                    labelText: 'Client Status',
                    prefixIcon: CommonSvg(
                      path: "assets/progress.svg",
                      width: 30,
                      height: 30,
                      parentWidth: 30,
                      parentHeight: 30,
                      color: AppColor.secondaryColor,
                    ),
                    items: addVisitController.clientStatusModel?.output
                            ?.map((e) => e.clientStatus)
                            .toList() ??
                        [],
                    hint: '',
                    isRequired: true,
                    senValue: (value) async {
                      if (!controller.hasInternet) {
                        _showOfflineMessage();
                        return;
                      }

                      controller.selectedPurposeVisit = null;
                      controller.purposeOfVisitModel = null;
                      controller.update();

                      controller.selectedClientStat = value;
                      controller.clientStatus = addVisitController
                          .clientStatusModel?.output
                          ?.firstWhere((e) => e.clientStatus == value);
                      await controller.getPurposeOfVisit(
                          controller.clientStatus!.clientStatusId.toString());
                      controller.update();
                    },
                    filledColor: AppColor.white,
                  ),
                  MyCustomDropdown(
                    selectedItem: controller.selectedContPersonDesig,
                    isViewProfile: controller.punchInDetailsModel?.output?.first
                            .punchingStatus !=
                        1,
                    labelText: 'Contact Person Designation',
                    prefixIcon: CommonSvg(
                      path: "assets/briefcase.svg",
                      width: 30,
                      height: 30,
                      parentWidth: 30,
                      parentHeight: 30,
                      color: AppColor.secondaryColor,
                    ),
                    items: controller.contactPersonDesignationModel?.output
                            ?.map((e) => e.designation)
                            .toList() ??
                        [],
                    hint: '',
                    isRequired: true,
                    senValue: (value) async {
                      if (!controller.hasInternet) {
                        _showOfflineMessage();
                        return;
                      }

                      controller.selectedContactPersonName = null;
                      controller.selectedContName = null;
                      controller.update();
                      controller.selectedContPersonDesig = value;
                      controller.selectedDesig = controller
                          .contactPersonDesignationModel?.output
                          ?.firstWhere((e) => e.designation == value);
                      await controller.contactPersonName(
                          hospitalDetails!.userid.toString(),
                          controller.selectedDesig!.desgID.toString());
                      controller.update();
                    },
                    filledColor: AppColor.white,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MyCustomDropdown(
                          selectedItem: controller.selectedContactPersonName,
                          isViewProfile: controller.punchInDetailsModel?.output
                                  ?.first.punchingStatus !=
                              1,
                          labelText: 'Contact Person Name',
                          prefixIcon: CommonSvg(
                            path: "assets/contactPerson.svg",
                            width: 30,
                            height: 30,
                            parentWidth: 30,
                            parentHeight: 30,
                            color: AppColor.secondaryColor,
                          ),
                          items: controller.contactPersonNameModel?.output
                                  ?.map((e) => e.cPName)
                                  .toList() ??
                              [],
                          hint: '',
                          isRequired: true,
                          senValue: (value) {
                            controller.selectedContactPersonName = value;
                            controller.selectedContName = controller
                                .contactPersonNameModel?.output
                                ?.firstWhere((e) => e.cPName == value);
                            controller.update();
                          },
                          filledColor: AppColor.white,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (!controller.hasInternet) {
                            _showOfflineMessage();
                            return;
                          }

                          if (controller.punchInDetailsModel?.output?.first
                                  .punchingStatus ==
                              1) {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return addContactPerson();
                              },
                            );
                          }
                        },
                        child: Icon(
                          Icons.add_circle_outline_sharp,
                          color: AppColor.secondaryColor,
                        ),
                      ).paddingOnly(top: 32, bottom: 10, right: 10, left: 4),
                    ],
                  ),
                  MyCustomDropdown(
                    selectedItem: controller.selectedContPersonStat,
                    isViewProfile: controller.punchInDetailsModel?.output?.first
                            .punchingStatus !=
                        1,
                    labelText: 'Contact Person Status',
                    prefixIcon: CommonSvg(
                      path: "assets/user-circle.svg",
                      width: 30,
                      height: 30,
                      parentWidth: 30,
                      parentHeight: 30,
                      color: AppColor.secondaryColor,
                    ),
                    items: controller.contactPersonStatusModel?.output
                            ?.map((e) => e.statusName)
                            .toList() ??
                        [],
                    hint: '',
                    isRequired: true,
                    senValue: (value) {
                      controller.selectedContPersonStat = value;
                      controller.selectedContPersonStatObj = controller
                          .contactPersonStatusModel?.output
                          ?.firstWhere((e) => e.statusName == value);
                      controller.update();
                    },
                    filledColor: AppColor.white,
                  ),
                  MyCustomDropdownObject(
                    shouldValidate: controller.shouldValidateFields,
                    selectedItem: controller.selectedPurposeVisit,
                    isViewProfile: controller.punchInDetailsModel?.output?.first
                            .punchingStatus !=
                        1,
                    labelText: 'Purpose of Visit',
                    prefixIcon: CommonSvg(
                      path: "assets/clipboard.svg",
                      width: 30,
                      height: 30,
                      parentWidth: 30,
                      parentHeight: 30,
                      color: AppColor.secondaryColor,
                    ),
                    items: controller.purposeOfVisitModel?.output
                            ?.map((e) => e)
                            .toList() ??
                        [],
                    hint: '',
                    isRequired: true,
                    senValue: (value) {
                      controller.selectedPurposeVisit = value;
                      controller.update();
                    },
                    filledColor: AppColor.white,
                  ),
                  InkWell(
                      onTap: controller.punchInDetailsModel?.output?.first
                                  .punchingStatus !=
                              1
                          ? null
                          : () {
                              if (!controller.hasInternet) {
                                _showOfflineMessage();
                                return;
                              }

                              showModalBottomSheet(
                                enableDrag: false,
                                isScrollControlled: true,
                                context: context,
                                isDismissible: false,
                                builder: (BuildContext context) {
                                  return PopScope(
                                    canPop: false,
                                    child: AddServices(
                                      list: controller.servicesModel?.output ??
                                          [],
                                      callB: (List<SelectedServiceModel>
                                              selectedService,
                                          String selectedMarketingPerson) {
                                        selectedServices = selectedService;
                                        selectedServicesVal =
                                            selectedMarketingPerson;

                                        List<Map<String, dynamic>> dicSetList =
                                            [];

                                        for (var selectService
                                            in selectedService) {
                                          if (selectService
                                                  .CustVisitServiceID ==
                                              5) {
                                            var dict = {
                                              "CustVisitServiceID":
                                                  selectService
                                                      .CustVisitServiceID,
                                              "OtherDesc":
                                                  controller.other.text.trim()
                                            };
                                            dicSetList.add(dict);
                                          } else {
                                            var dict = {
                                              "CustVisitServiceID":
                                                  selectService
                                                      .CustVisitServiceID,
                                              "OtherDesc": ""
                                            };
                                            dicSetList.add(dict);
                                          }
                                        }

                                        controller.serviceJsonData = {
                                          "input": dicSetList
                                        };

                                        addVisitController.update();
                                        Get.back();
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                CustomText(
                                  text: "Services",
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  textColor: AppColor.black,
                                  textAlign: TextAlign.start,
                                  fontFam: 'Nunito Sans',
                                ),
                                CustomText(
                                  text: "*",
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  textColor: AppColor.red,
                                  textAlign: TextAlign.start,
                                  fontFam: 'Nunito Sans',
                                ),
                              ],
                            ),
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
                                selectedServicesVal ?? "",
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              )),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColor.secondaryColor,
                              )
                            ]),
                          ),
                        ],
                      ).paddingOnly(left: 4, top: 4, bottom: 4)),
                  InkWell(
                      onTap: controller.punchInDetailsModel?.output?.first
                                  .punchingStatus !=
                              1
                          ? null
                          : () {
                              if (!controller.hasInternet) {
                                _showOfflineMessage();
                                return;
                              }

                              showModalBottomSheet(
                                isScrollControlled: true,
                                isDismissible: false,
                                enableDrag: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return PopScope(
                                    canPop: false,
                                    child: SizedBox(
                                      height:
                                          MediaQuery.sizeOf(context).height /
                                              2.5,
                                      child: addConsultantMarketingPerson(
                                          addVisitController
                                                  .marketingPersonModel
                                                  ?.output ??
                                              []),
                                    ),
                                  );
                                },
                              );
                            },
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: CustomText(
                              text: "Consultant Marketing Person",
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              textColor: AppColor.black,
                              textAlign: TextAlign.start,
                              fontFam: 'Nunito Sans',
                            ),
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
                                selectedMarketingPerson ?? "",
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              )),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColor.secondaryColor,
                              )
                            ]),
                          ),
                        ],
                      ).paddingOnly(left: 4, top: 4)),
                  CustomTextField(
                    autofocus: false,
                    txtController: controller.discussionPoints,
                    labelText: 'Discussion Points',
                    hintText: 'Discussion Points',
                    isRequired: true,
                    keyBoardType: TextInputType.multiline,
                    fillColor: AppColor.white,
                    isReadOnly: controller.punchInDetailsModel?.output?.first
                            .punchingStatus !=
                        1,
                    maxLines: null,
                    fontSize: 13,
                    prefixIcon: CommonSvg(
                      path: "assets/list-check.svg",
                      width: 30,
                      height: 30,
                      parentWidth: 30,
                      parentHeight: 30,
                      color: AppColor.secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SafeArea(
                    bottom: true,
                    top: false,
                    child: CustomButton(
                      buttonFontSize: 16,
                      buttonText: 'Save & Punch Out',
                      path: 'assets/arrow_nav.svg',
                      callB: controller.punchInDetailsModel?.output?.first
                                  .punchingStatus ==
                              1
                          ? () async {
                              final List<ConnectivityResult>
                                  connectivityResult =
                                  await Connectivity().checkConnectivity();

                              if (connectivityResult
                                      .contains(ConnectivityResult.mobile) ||
                                  connectivityResult
                                      .contains(ConnectivityResult.wifi)) {
                                controller.shouldValidateFields = true;
                                controller.update();

                                if (controller.discussionPoints.text.isEmpty) {
                                  formKey.currentState?.validate() ?? false;
                                  return;
                                }

                                if (selectedServicesVal == null ||
                                    selectedServicesVal!.isEmpty) {
                                  CustomMessage.toast(
                                      "Please Select Services. It is Mandatory.");
                                  return;
                                }

                                if (formKey.currentState?.validate() ?? false) {
                                  if (myVisitControllerController.latitude !=
                                          null &&
                                      myVisitControllerController.longitude !=
                                          null) {
                                    await controller.savePunchIn(
                                      hospitalDetails!.userid!.toString(),
                                      "0",
                                      userData!['output'][0]['EmpCode']
                                          .toString(),
                                      myVisitControllerController.latitude
                                          .toString(),
                                      myVisitControllerController.longitude
                                          .toString(),
                                      controller.selectedContName?.cPName ?? "",
                                      controller.marketingJsonData,
                                      controller.serviceJsonData,
                                      controller.clientStatus!.clientStatusId!
                                          .toString(),
                                      controller.selectedDesig!.desgID!
                                          .toString(),
                                      controller
                                          .selectedPurposeVisit!.mVisitActionID!
                                          .toString(),
                                      myVisitControllerController.latitude
                                          .toString(),
                                      myVisitControllerController.longitude
                                          .toString(),
                                      controller.selectedVisit!.visitTypeID!
                                          .toString(),
                                      controller.discussionPoints.text,
                                      controller.selectedContName!.cPId!
                                          .toString(),
                                      controller.selectedContPersonStatObj!
                                          .cPStatusId!
                                          .toString(),
                                      myVisitControllerController,
                                      userData!['output'][0]['DISTLGDCODE']
                                          .toString(),
                                      userData?['output']?[0]?['Designation'],
                                    );
                                  } else {
                                    await fetchLocation();
                                  }
                                }
                              } else {
                                controller.hasInternet = false;
                                controller.update();
                                _showOfflineMessage();
                                return;
                              }
                            }
                          : null,
                      primColor: controller.punchInDetailsModel?.output?.first
                                  .punchingStatus ==
                              1
                          ? AppColor.primaryBackgroundColor
                          : AppColor.borderGrey,
                      secColor: controller.punchInDetailsModel?.output?.first
                                  .punchingStatus ==
                              1
                          ? AppColor.secondaryColor
                          : AppColor.borderGrey,
                      textColor: AppColor.white,
                      iconColor: AppColor.white,
                      buttonWidth: 200,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ).paddingSymmetric(vertical: 4, horizontal: 15),
            ),
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
                text: "No internet. Some features unavailable.",
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

  void _clearControllerData() {
    addVisitController.punchInDetailsModel = null;
    addVisitController.selectedVisitType = null;
    addVisitController.selectedVisit = null;
    addVisitController.selectedClientStat = null;
    addVisitController.clientStatus = null;
    addVisitController.selectedContPersonDesig = null;
    addVisitController.selectedDesig = null;
    addVisitController.selectedContName = null;
    addVisitController.selectedContactPersonName = null;
    addVisitController.selectedContPersonStat = null;
    addVisitController.selectedContPersonStatObj = null;
    addVisitController.selectedPurposeVisit = null;
    addVisitController.serviceJsonData = null;
    addVisitController.marketingJsonData = null;
    addVisitController.discussionPoints.text = '';
    addVisitController.searchController.clear();
    addVisitController.punchInDetailsModel = null;
    addVisitController.update();
  }

  Widget addContactPerson() {
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xffF8F8F8),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 0.5),
          ),
        ],
      ),
      child: Form(
        key: formKey1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                    text: "Add Contact Person",
                    fontSize: 18,
                    fontFam: "Nunito Sans",
                    fontWeight: FontWeight.bold,
                    textColor: Colors.black,
                    textAlign: TextAlign.start),
              ],
            ).paddingOnly(bottom: 8),
            NormalCustomTextField(
              txtController: addVisitController.contactPersonNameField,
              autofocus: false,
              labelText: 'Contact Person Name',
              hintText: 'Contact Person Name',
              isRequired: true,
              keyBoardType: TextInputType.text,
              fillColor: AppColor.white,
              isReadOnly: false,
              maxLines: 1,
              fontSize: 16,
              prefixIcon: CommonSvg(
                path: "assets/contactPerson.svg",
                width: 26,
                height: 26,
                parentWidth: 30,
                parentHeight: 30,
                color: AppColor.secondaryColor,
              ),
            ),
            NormalCustomDropdown(
              selectedItem: addVisitController.addSelectedContactPersonDesig,
              labelText: 'Designation',
              prefixIcon: CommonSvg(
                path: "assets/briefcase.svg",
                width: 26,
                height: 26,
                parentWidth: 30,
                parentHeight: 30,
                color: AppColor.secondaryColor,
              ),
              items: addVisitController.contactPersonDesignationModel?.output
                      ?.map((e) => e.designation)
                      .toList() ??
                  [],
              hint: 'Designation',
              isRequired: true,
              senValue: (value) {
                addVisitController.addSelectedContactPersonDesig = value;
                addVisitController.selectedAddContPersonObj = addVisitController
                    .contactPersonDesignationModel?.output
                    ?.firstWhere((e) => e.designation == value);
                addVisitController.update();
              },
              filledColor: AppColor.white,
            ),
            NormalCustomTextField(
              mazLenght: (FlavorConfig.instance.name == "HindLab Operational" ||
                      FlavorConfig.instance.name == "PlusCare Operational" ||
                      FlavorConfig.instance.name == "Lifenity Operational" ||
                      FlavorConfig.instance.name == "CSC HealthCare")
                  ? 10
                  : null,
              txtController: addVisitController.contactNumberField,
              autofocus: false,
              labelText: 'Contact Number',
              hintText: 'Contact Number',
              isRequired: FlavorConfig.instance.name == "Lifenity Operational"
                  ? true
                  : false,
              keyBoardType: TextInputType.phone,
              fillColor: AppColor.white,
              isReadOnly: false,
              maxLines: 1,
              fontSize: 16,
              prefixIcon: CommonSvg(
                path: "assets/device.svg",
                width: 26,
                height: 26,
                parentWidth: 30,
                parentHeight: 30,
                color: AppColor.secondaryColor,
              ),
            ),
            const SizedBox(height: 20),
            SafeArea(
              bottom: true,
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    buttonFontSize: 16,
                    buttonText: 'Save',
                    path: 'assets/arrow_nav.svg',
                    callB: () async {
                      if (!addVisitController.hasInternet) {
                        _showOfflineMessage();
                        return;
                      }

                      if (formKey1.currentState?.validate() ?? false) {
                        if (addVisitController.addSelectedContactPersonDesig !=
                                null &&
                            addVisitController
                                .contactPersonNameField.text.isNotEmpty) {
                          await addVisitController.saveAddContactPerson(
                              addVisitController
                                  .selectedAddContPersonObj!.desgID
                                  .toString(),
                              addVisitController.contactPersonNameField.text,
                              addVisitController.contactNumberField.text,
                              userData!['output'][0]['EmpCode'].toString(),
                              hospitalDetails!.userid.toString());
                        } else {
                          CustomMessage.toast('Please fill mandatory fields');
                        }
                      }
                    },
                    primColor: AppColor.primaryBackgroundColor,
                    secColor: AppColor.secondaryColor,
                    textColor: AppColor.white,
                    iconColor: AppColor.white,
                    buttonWidth: 120,
                  ),
                  const SizedBox(width: 20),
                  CustomButton(
                    buttonFontSize: 16,
                    buttonText: 'Cancel',
                    path: 'assets/arrow_nav.svg',
                    callB: () {
                      addVisitController.contactPersonNameField.clear();
                      addVisitController.addSelectedContactPersonDesig = null;
                      addVisitController.selectedAddContPersonObj = null;
                      addVisitController.contactNumberField.clear();
                      Get.back();
                    },
                    primColor: AppColor.borderGrey,
                    secColor: AppColor.borderGrey,
                    textColor: AppColor.black,
                    iconColor: AppColor.black,
                    buttonWidth: 120,
                  ),
                ],
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 10, vertical: 6),
      ),
    );
  }

  Widget addConsultantMarketingPerson(List<MarketingOutput> list) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                  text: "Consultant Marketing Person",
                  fontSize: 18,
                  fontFam: "Nunito Sans",
                  fontWeight: FontWeight.bold,
                  textColor: AppColor.black,
                  textAlign: TextAlign.start),
              InkWell(
                  onTap: () {
                    // setState(() {});
                    // this.setState(() {
                    //   selectedMarketingVal = list
                    //       .where((person) => person.isChecked == true)
                    //       .map((person) {
                    //     return MarketingOutput(
                    //         userid: person.userid!,
                    //         userName: person.userName,
                    //         desgid: person.desgid!,
                    //         desgName: person.desgName!);
                    //   }).toList();
                    //
                    //   if (selectedMarketingVal == null ||
                    //       selectedMarketingVal!.isEmpty) {
                    //     addVisitController.marketingJsonData = null;
                    //     selectedMarketingPerson = "";
                    //     addVisitController.update();
                    //   } else {
                    //     List<Map<String, dynamic>> dicSetList = [];
                    //
                    //     for (var selectService in selectedMarketingVal!) {
                    //       var dict = {"VisitUserID": selectService.userid ?? 0};
                    //       dicSetList.add(dict);
                    //     }
                    //
                    //     addVisitController.marketingJsonData = {
                    //       "input": dicSetList
                    //     };
                    //
                    //     selectedMarketingPerson = list
                    //         .where((person) => person.isChecked == true)
                    //         .map((person) => person.userName)
                    //         .join(', ');
                    //   }
                    // });

                    Get.back();
                  },
                  child: const Icon(Icons.cancel_outlined))
            ],
          ).paddingOnly(left: 14, right: 30, bottom: 10, top: 10),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(list[index].userName ?? ""),
                  value: list[index].isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      list[index].isChecked = value ?? false;
                    });
                    addVisitController.update();
                  },
                );
              },
            ),
          ),
          SafeArea(
            bottom: true,
            top: false,
            child: CustomButton(
              buttonFontSize: 16,
              buttonText: 'Save',
              path: 'assets/arrow_nav.svg',
              callB: () async {
                setState(() {});
                this.setState(() {
                  selectedMarketingVal = list
                      .where((person) => person.isChecked == true)
                      .map((person) {
                    return MarketingOutput(
                        userid: person.userid!,
                        userName: person.userName,
                        desgid: person.desgid!,
                        desgName: person.desgName!);
                  }).toList();

                  if (selectedMarketingVal == null ||
                      selectedMarketingVal!.isEmpty) {
                    addVisitController.marketingJsonData = null;
                    selectedMarketingPerson = "";
                    addVisitController.update();
                  } else {
                    List<Map<String, dynamic>> dicSetList = [];

                    for (var selectService in selectedMarketingVal!) {
                      var dict = {"VisitUserID": selectService.userid ?? 0};
                      dicSetList.add(dict);
                    }

                    addVisitController.marketingJsonData = {
                      "input": dicSetList
                    };

                    selectedMarketingPerson = list
                        .where((person) => person.isChecked == true)
                        .map((person) => person.userName)
                        .join(', ');
                  }
                });

                Get.back();
              },
              primColor: AppColor.primaryBackgroundColor,
              secColor: AppColor.secondaryColor,
              textColor: AppColor.white,
              iconColor: AppColor.white,
              buttonWidth: 200,
            ).paddingOnly(top: 4, bottom: 4),
          )
        ],
      ).paddingOnly(top: 6, bottom: 6);
    });
  }
}

class AddServices extends StatefulWidget {
  final List<ServicesOutput> list;
  final Function callB;

  const AddServices({
    super.key,
    required this.list,
    required this.callB,
  });

  @override
  State<AddServices> createState() => _AddServicesState();
}

class _AddServicesState extends State<AddServices> {
  final AddVisitController addVisitController = Get.find<AddVisitController>();
  String? selectedValue;
  String? selectedMarketingPerson;
  List<SelectedServiceModel> selectedValue1 = [];
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final otherItem = widget.list.firstWhere(
      (item) => item.custVisitService == "Other",
      orElse: () => ServicesOutput(),
    );
    if (otherItem.isChecked) {
      selectedValue = "Other";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xffF8F8F8),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 0.5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Form(
          key: formKey1,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Services",
                    fontSize: 18,
                    fontFam: 'Nunito Sans',
                    fontWeight: FontWeight.bold,
                    textColor: AppColor.black,
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                      onTap: () {
                        Get.back();
                        // final isOtherSelected = widget.list.any((item) =>
                        //     item.isChecked && item.custVisitService == "Other");
                        //
                        // if (isOtherSelected &&
                        //     addVisitController.other.text.trim().isEmpty) {
                        //   formKey1.currentState?.validate();
                        //   return;
                        // }
                        //
                        // if (formKey1.currentState?.validate() ?? false) {
                        //   selectedValue1 = widget.list
                        //       .where((person) => person.isChecked == true)
                        //       .map((person) {
                        //     if (person.custVisitService == "Other") {
                        //       return SelectedServiceModel(
                        //         person.custVisitServiceID!,
                        //         addVisitController.other.text.trim(),
                        //       );
                        //     } else {
                        //       return SelectedServiceModel(
                        //           person.custVisitServiceID!, "");
                        //     }
                        //   }).toList();
                        //
                        //   selectedMarketingPerson = widget.list
                        //       .where((person) => person.isChecked == true)
                        //       .map((person) {
                        //         if (person.custVisitService == "Other") {
                        //           return addVisitController.other.text.trim();
                        //         }
                        //         return person.custVisitService;
                        //       })
                        //       .where((service) =>
                        //           service != null && service.isNotEmpty)
                        //       .join(', ');
                        //
                        //   widget.callB(selectedValue1, selectedMarketingPerson);
                        // }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(Icons.cancel),
                      )).paddingOnly(right: 10)
                ],
              ).paddingOnly(left: 16, right: 16, bottom: 10),
              ListView.builder(
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.list.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(widget.list[index].custVisitService ?? ""),
                    value: widget.list[index].isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        widget.list[index].isChecked = value ?? false;
                        if (widget.list[index].custVisitService == "Other") {
                          selectedValue = value == true ? "Other" : null;
                          if (value == false) {
                            addVisitController.other.clear();
                          }
                        }
                      });
                    },
                  );
                },
              ),
              Visibility(
                visible: selectedValue == "Other",
                child: CustomTextField(
                  autofocus: false,
                  txtController: addVisitController.other,
                  labelText: 'Other',
                  hintText: '',
                  isRequired: true,
                  keyBoardType: TextInputType.text,
                  fillColor: AppColor.white,
                  isReadOnly: addVisitController
                          .punchInDetailsModel?.output?.first.punchingStatus !=
                      1,
                  maxLines: 1,
                  prefixIcon: const Icon(Icons.text_fields),
                  fontSize: 16,
                ),
              ).paddingOnly(left: 4, bottom: 6),
              SafeArea(
                bottom: true,
                top: false,
                child: CustomButton(
                  buttonFontSize: 16,
                  buttonText: 'Save',
                  path: 'assets/arrow_nav.svg',
                  callB: () async {
                    final isOtherSelected = widget.list.any((item) =>
                        item.isChecked && item.custVisitService == "Other");

                    if (isOtherSelected &&
                        addVisitController.other.text.trim().isEmpty) {
                      formKey1.currentState?.validate();
                      return;
                    }

                    if (formKey1.currentState?.validate() ?? false) {
                      selectedValue1 = widget.list
                          .where((person) => person.isChecked == true)
                          .map((person) {
                        if (person.custVisitService == "Other") {
                          return SelectedServiceModel(
                            person.custVisitServiceID!,
                            addVisitController.other.text.trim(),
                          );
                        } else {
                          return SelectedServiceModel(
                              person.custVisitServiceID!, "");
                        }
                      }).toList();

                      selectedMarketingPerson = widget.list
                          .where((person) => person.isChecked == true)
                          .map((person) {
                            if (person.custVisitService == "Other") {
                              return addVisitController.other.text.trim();
                            }
                            return person.custVisitService;
                          })
                          .where((service) =>
                              service != null && service.isNotEmpty)
                          .join(', ');

                      widget.callB(selectedValue1, selectedMarketingPerson);
                    }
                  },
                  primColor: AppColor.primaryBackgroundColor,
                  secColor: AppColor.secondaryColor,
                  textColor: AppColor.white,
                  iconColor: AppColor.white,
                  buttonWidth: 200,
                ),
              )
            ],
          ).paddingOnly(top: 6, bottom: 10),
        ),
      ),
    );
  }
}

class SelectedServiceModel {
  int CustVisitServiceID;
  String OtherDesc;

  SelectedServiceModel(this.CustVisitServiceID, this.OtherDesc);
}

class SelectedMarketingModel {
  int? VisitUserID;

  SelectedMarketingModel({this.VisitUserID});
}


