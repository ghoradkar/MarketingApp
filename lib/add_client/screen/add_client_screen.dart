import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:marketingapp/add_client/controller/add_client_controller.dart';
import 'package:marketingapp/add_client/model/area_model.dart';
import 'package:marketingapp/dashboard/controller/my_visit_controller.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/utils/shared_pref_constants.dart';
import 'package:marketingapp/utils/shared_preference.dart';
import 'package:marketingapp/widgets/common_svg.dart';
import 'package:marketingapp/widgets/cust_toast.dart';
import 'package:marketingapp/widgets/custom_button.dart';
import 'package:marketingapp/widgets/custom_text.dart';
import 'package:marketingapp/widgets/custom_text_field.dart';
import 'package:marketingapp/widgets/dropdown_search.dart';
import 'package:marketingapp/widgets/my_custom_dropdown.dart';

class AddClientScreen extends StatefulWidget {
  const AddClientScreen({super.key});

  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen>
    with WidgetsBindingObserver {
  final AddClientController addClientController =
      Get.put(AddClientController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();

  final MyVisitControllerController myVisitControllerController =
      Get.find<MyVisitControllerController>();

  Map<String, dynamic>? userData;
  Timer? _debounceTimer;

  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    formKey.currentState?.reset();
    WidgetsBinding.instance.addObserver(this);
    _initializeScreen();
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
        addClientController.hasInternet = true;

        // Try to fetch fresh data from API
        if (addClientController.hasInternet && userData != null) {
          await fetchLocation();

          await fetchInitialData();
        }
      } else {
        addClientController.hasInternet = false;
        debugPrint("No internet connection");
      }
    } catch (e) {
      debugPrint("Connectivity check error: $e");
      addClientController.hasInternet = false;
    }

    addClientController.update();
    setState(() {});
  }

  Future<void> fetchInitialData() async {
    try {
      await addClientController
          .getDistrictList(userData?['output'][0]['STATELGDCODE'].toString());
      await addClientController.getClientTypeList();
    } catch (e) {
      debugPrint("Error fetching initial data: $e");
      // Don't block UI if this fails
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
          text: 'Add Customer',
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

    if (userData == null) {
      return _buildNoDataWidget();
    }

    return GetBuilder<AddClientController>(
        init: addClientController,
        builder: (controller) {
          return Column(
            children: [
              // Show offline banner if no internet (non-blocking)
              if (!controller.hasInternet) _buildOfflineBanner(),

              // Main content
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Card(
                          color: Colors.white,
                          child: const CustomTextRichText(
                            textHeading: 'Note',
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            textColor: Colors.black,
                            textAlign: TextAlign.start,
                            text:
                                'Customer registration must happen at customer location.',
                            fontWeightHeading: FontWeight.bold,
                            textColorHeading: Colors.green,
                          ).paddingOnly(left: 16, right: 16, bottom: 8, top: 8),
                        ),
                        Card(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 50,
                                    child: CommonSvg(
                                      path: "assets/location.svg",
                                      width: 26,
                                      height: 26,
                                      parentWidth: 30,
                                      parentHeight: 30,
                                      color: AppColor.secondaryColor,
                                    ),
                                  ),
                                  Expanded(
                                    child: CustomTextRichText(
                                      textHeading: 'Your Google Location ',
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
                              ).paddingOnly(bottom: 8, top: 8, right: 8),
                            ],
                          ),
                        ).paddingSymmetric(vertical: 2, horizontal: 0),
                        DropDownSearch(
                          selectedItem: controller.selectedCustomerT,
                          labelText: "Customer Type",
                          items: controller.clientTypeList
                                  ?.map((e) => e.type ?? '')
                                  .toList() ??
                              [],
                          hint: '',
                          isRequired: true,
                          senValue: (value) async {
                            controller.selectedCustomerT = value;
                            controller.selectedCustomerTypeObj = controller
                                .clientTypeList
                                ?.firstWhere((e) => e.type == value);
                            controller.update();
                          },
                          filledColor: AppColor.white,
                          prefixIcon: Icon(
                            Icons.account_circle_outlined,
                            color: AppColor.secondaryColor,
                          ),
                        ),
                        CustomTextField(
                          txtController: controller.customerNameField,
                          labelText: 'Customer Name',
                          hintText: 'Customer Name',
                          isRequired: true,
                          keyBoardType: TextInputType.text,
                          fillColor: AppColor.white,
                          isReadOnly: false,
                          maxLines: 1,
                          fontSize: 16,
                          prefixIcon: Icon(
                            Icons.supervisor_account_outlined,
                            color: AppColor.secondaryColor,
                          ),
                          autofocus: false,
                        ),
                        CustomTextField(
                          txtController: controller.contactPersonNameField,
                          labelText: 'Contact Person Name',
                          hintText: 'Contact Person Name',
                          isRequired: true,
                          keyBoardType: TextInputType.text,
                          fillColor: AppColor.white,
                          isReadOnly: false,
                          maxLines: 1,
                          fontSize: 16,
                          prefixIcon: Icon(
                            Icons.contact_page_outlined,
                            color: AppColor.secondaryColor,
                          ),
                          autofocus: false,
                        ),
                        CustomTextField(
                          txtController: controller.mobNoField,
                          mazLenght: 10,
                          autofocus: false,
                          labelText: 'Mobile No',
                          hintText: 'Mobile No',
                          isRequired: true,
                          keyBoardType: TextInputType.phone,
                          fillColor: AppColor.white,
                          isReadOnly: false,
                          maxLines: 1,
                          fontSize: 16,
                          prefixIcon: Icon(
                            Icons.phone_android,
                            color: AppColor.secondaryColor,
                          ),
                        ),
                        CustomTextField(
                          txtController: controller.emailIdField,
                          autofocus: false,
                          labelText: 'Email ID',
                          hintText: 'Email ID',
                          isRequired: true,
                          keyBoardType: TextInputType.emailAddress,
                          fillColor: AppColor.white,
                          isReadOnly: false,
                          maxLines: 1,
                          fontSize: 16,
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: AppColor.secondaryColor,
                          ),
                        ),
                        CustomTextField(
                          txtController: controller.specialty,
                          autofocus: false,
                          labelText: 'Speciality',
                          hintText: 'Speciality',
                          isRequired: true,
                          keyBoardType: TextInputType.text,
                          fillColor: AppColor.white,
                          isReadOnly: false,
                          maxLines: 1,
                          fontSize: 16,
                          prefixIcon: Icon(
                            Icons.manage_accounts_outlined,
                            color: AppColor.secondaryColor,
                          ),
                        ),
                        CustomTextField(
                          txtController: controller.addressField,
                          autofocus: false,
                          labelText: 'Address',
                          hintText: 'Address',
                          isRequired: true,
                          keyBoardType: TextInputType.streetAddress,
                          fillColor: AppColor.white,
                          isReadOnly: false,
                          maxLines: 1,
                          fontSize: 16,
                          prefixIcon: Icon(
                            Icons.location_on_outlined,
                            color: AppColor.secondaryColor,
                          ),
                        ),
                        CustomTextField(
                          txtController: controller.businessPotential,
                          autofocus: false,
                          labelText:
                              FlavorConfig.instance.name == "CSC HealthCare"
                                  ? 'Monthly Business Potential(Rs)'
                                  : 'Monthly Business Potential',
                          hintText:
                              FlavorConfig.instance.name == "CSC HealthCare"
                                  ? 'Monthly Business Potential(Rs)'
                                  : 'Monthly Business Potential',
                          isRequired: true,
                          keyBoardType: TextInputType.number,
                          fillColor: AppColor.white,
                          isReadOnly: false,
                          maxLines: 1,
                          fontSize: 16,
                          prefixIcon: Icon(
                            Icons.shopping_bag_outlined,
                            color: AppColor.secondaryColor,
                          ),
                        ),
                        DropDownSearch(
                          selectedItem: controller.selectedDistrictVal,
                          labelText: FlavorConfig.instance.name ==
                                      "HindLab Operational" ||
                                  FlavorConfig.instance.name ==
                                      "PlusCare Operational" ||
                                  FlavorConfig.instance.name ==
                                      "Lifenity Operational" ||
                                  FlavorConfig.instance.name == "CSC HealthCare"
                              ? "District"
                              : 'Emirates',
                          items: controller.districtRespModel?.output
                                  ?.map((e) => e.distname ?? '')
                                  .toList() ??
                              [],
                          hint: '',
                          isRequired: true,
                          senValue: (value) async {
                            if (!controller.hasInternet) {
                              _showOfflineMessage();
                              return;
                            }

                            controller.selectedCityVal = null;
                            controller.selectedCityObj = null;
                            controller.selectedAreaVal = null;
                            controller.selectedAreaObj = null;
                            controller.update();
                            controller.selectedDistrictVal = value;
                            controller.selectedDistrictObj = controller
                                .districtRespModel?.output
                                ?.firstWhere((e) => e.distname == value);
                            await controller.getCityList(addClientController
                                .selectedDistrictObj!.distlgdcode
                                .toString());
                            await controller.getAreaList(addClientController
                                .selectedDistrictObj!.distlgdcode
                                .toString());
                            controller.update();
                          },
                          filledColor: AppColor.white,
                          prefixIcon: Icon(
                            Icons.location_on_outlined,
                            color: AppColor.secondaryColor,
                          ),
                        ),
                        MyCustomDropdown(
                          selectedItem: controller.selectedCityVal,
                          labelText: "City",
                          prefixIcon: Icon(
                            Icons.location_on_outlined,
                            color: AppColor.secondaryColor,
                          ),
                          items: controller.cityList
                                  ?.map((e) => e.cityName)
                                  .toList() ??
                              [],
                          hint: '',
                          isRequired: true,
                          senValue: (value) {
                            controller.selectedCityVal = value;
                            controller.selectedCityObj = controller.cityList
                                ?.firstWhere((e) => e.cityName == value);
                            controller.update();
                          },
                          filledColor: AppColor.white,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: MyCustomDropdown(
                                selectedItem: controller.selectedAreaVal,
                                labelText: 'Area',
                                prefixIcon: Icon(
                                  Icons.location_on_outlined,
                                  color: AppColor.secondaryColor,
                                ),
                                items: controller.areaList
                                        ?.map((e) => e.patchName)
                                        .toList() ??
                                    [],
                                hint: '',
                                isRequired: true,
                                senValue: (value) {
                                  controller.selectedAreaVal = value;
                                  controller.selectedAreaObj =
                                      controller.areaList?.firstWhereOrNull(
                                          (e) => e.patchName == value);
                                  controller.update();
                                },
                                filledColor: AppColor.white,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                onPressed: () {
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
                                      addClientController.shouldValidateArea =
                                          false;
                                      return PopScope(
                                          canPop: false, child: addArea());
                                    },
                                  );
                                },
                                icon: Icon(
                                  Icons.add_circle_outline_sharp,
                                  color: controller.hasInternet
                                      ? AppColor.secondaryColor
                                      : AppColor.borderGrey,
                                ),
                              ).paddingOnly(top: 32, bottom: 10, right: 0),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SafeArea(
                          bottom: true,
                          top: false,
                          child: CustomButton(
                            buttonFontSize: 16,
                            buttonText: 'Register',
                            path: 'assets/arrow_nav.svg',
                            callB: () async {
                              final List<ConnectivityResult>
                                  connectivityResult =
                                  await Connectivity().checkConnectivity();

                              if (connectivityResult
                                      .contains(ConnectivityResult.mobile) ||
                                  connectivityResult
                                      .contains(ConnectivityResult.wifi)) {
                                if (myVisitControllerController.longitude !=
                                        null &&
                                    myVisitControllerController.latitude !=
                                        null) {
                                  if (formKey.currentState?.validate() ??
                                      false) {
                                    await controller.addClient(
                                        controller
                                            .selectedCustomerTypeObj!.typeid
                                            .toString(),
                                        controller.customerNameField.text
                                            .trim(),
                                        addClientController
                                            .selectedDistrictObj!.distlgdcode
                                            .toString(),
                                        controller.mobNoField.text.trim(),
                                        controller.emailIdField.text.trim(),
                                        userData?['output'][0]['EmpCode']
                                            .toString(),
                                        controller.addressField.text.trim(),
                                        controller.selectedCityObj!.cityCode
                                            .toString(),
                                        controller.selectedAreaObj!.patchId
                                            .toString(),
                                        myVisitControllerController.latitude
                                            .toString(),
                                        myVisitControllerController.longitude
                                            .toString(),
                                        controller.businessPotential.text
                                            .trim());
                                  }
                                } else {
                                  await fetchLocation();
                                }
                              } else {
                                controller.hasInternet = false;
                                controller.update();
                                _showOfflineMessage();
                                return;
                              }
                            },
                            primColor: AppColor.primaryBackgroundColor,
                            secColor: AppColor.secondaryColor,
                            textColor: AppColor.white,
                            iconColor: AppColor.white,
                            buttonWidth: 126,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ).paddingSymmetric(vertical: 4, horizontal: 10),
                  ),
                ),
              ),
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
                text: "No internet available.",
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
                text: "Unable to load form data",
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

  Widget addArea() {
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
                    text: "Add Area",
                    fontSize: 18,
                    fontFam: "Nunito Sans",
                    fontWeight: FontWeight.bold,
                    textColor: Colors.black,
                    textAlign: TextAlign.start),
              ],
            ).paddingOnly(bottom: 8),
            MyCustomDropdown(
              selectedItem: addClientController.selectedAddDistrictVal,
              labelText: FlavorConfig.instance.name == "HindLab Operational" ||
                      FlavorConfig.instance.name == "PlusCare Operational" ||
                      FlavorConfig.instance.name == "Lifenity Operational" ||
                      FlavorConfig.instance.name == "CSC HealthCare"
                  ? "District"
                  : 'Emirates',
              prefixIcon: Icon(
                Icons.location_on_outlined,
                color: AppColor.secondaryColor,
              ),
              items: addClientController.districtRespModel?.output
                      ?.map((e) => e.distname)
                      .toList() ??
                  [],
              hint: '',
              isRequired: true,
              senValue: (value) async {
                if (!addClientController.hasInternet) {
                  _showOfflineMessage();
                  return;
                }

                addClientController.addAreaTxtField.clear();
                addClientController.selectedAddDistrictVal = value;
                addClientController.selectedAddDistrictObj = addClientController
                    .districtRespModel?.output
                    ?.firstWhere((e) => e.distname == value);

                await addClientController.getAddAreaList(addClientController
                    .selectedAddDistrictObj!.distlgdcode
                    .toString());
              },
              filledColor: AppColor.white,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  CustomText(
                      text: "Area",
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      textColor: AppColor.black,
                      textAlign: TextAlign.start,
                      fontFam: "Nunito Sans"),
                  const CustomText(
                      text: " *",
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      textColor: Colors.red,
                      textAlign: TextAlign.start,
                      fontFam: "Nunito Sans"),
                ],
              ),
            ).paddingOnly(left: 8, top: 4),
            TypeAheadField<AreaOutput>(
              controller: addClientController.addAreaTxtField,
              suggestionsCallback: (search) {
                if (search.isEmpty) {
                  return [];
                }
                return addClientController.addAreaList
                        ?.where((area) =>
                            area.patchName
                                ?.toLowerCase()
                                .contains(search.toLowerCase()) ??
                            false)
                        .toList() ??
                    [];
              },
              builder: (context, controller, focusNode) {
                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  autofocus: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    fillColor: AppColor.white,
                    filled: true,
                    hintText: "Area",
                    prefixIcon: Icon(
                      Icons.location_on_outlined,
                      color: AppColor.secondaryColor,
                    ),
                    hintStyle: TextStyle(
                        fontSize: 16.0,
                        color: AppColor.textGrey,
                        fontFamily: "Nunito Sans",
                        fontWeight: FontWeight.normal),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: AppColor.borderGrey,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: AppColor.borderGrey,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Area field is required';
                    }
                    return null;
                  },
                );
              },
              itemBuilder: (context, city) {
                return ListTile(
                  title: Text(city.patchName ?? ""),
                );
              },
              onSelected: (city) {},
              emptyBuilder: (context) => const SizedBox.shrink(),
            ).paddingSymmetric(vertical: 4, horizontal: 8),
            const SizedBox(height: 84),
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
                      if (!addClientController.hasInternet) {
                        _showOfflineMessage();
                        return;
                      }

                      if (formKey1.currentState?.validate() ?? false) {
                        if (addClientController.selectedAddDistrictVal !=
                                null &&
                            addClientController
                                .addAreaTxtField.text.isNotEmpty) {
                          await addClientController.addArea(
                              '0',
                              addClientController.addAreaTxtField.text,
                              addClientController
                                  .selectedAddDistrictObj!.distlgdcode
                                  .toString(),
                              '0');
                        } else {
                          CustomMessage.toast("Please fill mandatory fields");
                        }
                      }
                    },
                    primColor: addClientController.hasInternet
                        ? AppColor.primaryBackgroundColor
                        : AppColor.borderGrey,
                    secColor: addClientController.hasInternet
                        ? AppColor.secondaryColor
                        : AppColor.borderGrey,
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
                      addClientController.selectedAddDistrictVal = null;
                      addClientController.selectedAddDistrictObj = null;
                      addClientController.selectedAddAreaVal = null;
                      addClientController.selectedAddAreaObj = null;
                      addClientController.addAreaTxtField.clear();
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
}

// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_flavor/flutter_flavor.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:get/get.dart';
// import 'package:marketingapp/add_client/add_client_controller.dart';
// import 'package:marketingapp/add_client/model/area_model.dart';
// import 'package:marketingapp/dashboard/my_visit_controller.dart';
// import 'package:marketingapp/utils/color_constants.dart';
// import 'package:marketingapp/utils/shared_pref_constants.dart';
// import 'package:marketingapp/utils/shared_preference.dart';
// import 'package:marketingapp/widgets/common_svg.dart';
// import 'package:marketingapp/widgets/cust_toast.dart';
// import 'package:marketingapp/widgets/custom_button.dart';
// import 'package:marketingapp/widgets/custom_text.dart';
// import 'package:marketingapp/widgets/custom_text_field.dart';
// import 'package:marketingapp/widgets/dropdown_search.dart';
// import 'package:marketingapp/widgets/my_custom_dropdown.dart';
// import 'package:marketingapp/widgets/no_internet_connectivity.dart';
//
// class AddClientScreen extends StatefulWidget {
//   const AddClientScreen({super.key});
//
//   @override
//   State<AddClientScreen> createState() => _AddClientScreenState();
// }
//
// class _AddClientScreenState extends State<AddClientScreen>
//     with WidgetsBindingObserver {
//   final AddClientController addClientController =
//   Get.put(AddClientController());
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
//
//   // final GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
//   final MyVisitControllerController myVisitControllerController =
//   Get.find<MyVisitControllerController>();
//   Map<String, dynamic>? userData;
//   Timer? _debounceTimer;
//
//   @override
//   void initState() {
//     formKey.currentState?.reset();
//     getUserData();
//     WidgetsBinding.instance.addObserver(this);
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _debounceTimer?.cancel(); // Always dispose timers
//     super.dispose();
//   }
//
//   Future<void> getUserData() async {
//     userData = await SharedPref().read(const SharedPrefConstant().kUserData);
//     await addClientController
//         .getDistrictList(userData?['output'][0]['STATELGDCODE'].toString());
//     await addClientController.getClientTypeList();
//     if (myVisitControllerController.latitude == null &&
//         myVisitControllerController.longitude == null) {
//       await fetchLocation();
//     }
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     debugPrint("App state changed to: $state");
//     if (state == AppLifecycleState.resumed) {
//       // Cancel any existing timer
//       _debounceTimer?.cancel();
//
//       // Start a new debounce timer
//       _debounceTimer = Timer(Duration(seconds: 1), () async {
//         bool success = await fetchLocation();
//         if (success) {
//           myVisitControllerController.update(); // Force UI refresh
//           setState(() {}); // If using StatefulWidget
//         } else {
//           debugPrint("Failed to get location after resume");
//         }
//       });
//     }
//   }
//
//   Future<bool> fetchLocation() async {
//     try {
//       await myVisitControllerController.getLocation();
//       return myVisitControllerController.latitude != null &&
//           myVisitControllerController.longitude != null;
//     } catch (e) {
//       debugPrint("Location fetch error: $e");
//       return false;
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
//           text: 'Add Customer',
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
//         actions: const [],
//       ),
//       body: GetBuilder<AddClientController>(
//           init: addClientController,
//           builder: (controller) {
//             return controller.hasInternet
//                 ? SingleChildScrollView(
//               child: Form(
//                 key: formKey,
//                 child: Column(
//                   children: [
//                     Card(
//                       color: Colors.white,
//                       child: const CustomTextRichText(
//                         textHeading: 'Note',
//                         fontSize: 16,
//                         fontWeight: FontWeight.normal,
//                         textColor: Colors.black,
//                         textAlign: TextAlign.start,
//                         text:
//                         'Customer registration must happen at customer location.',
//                         fontWeightHeading: FontWeight.bold,
//                         textColorHeading: Colors.green,
//
//                       ).paddingOnly(
//                           left: 16, right: 16, bottom: 8, top: 8),
//                     ),
//                     Card(
//                       color: Colors.white,
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               SizedBox(
//                                 width: 50,
//                                 child: CommonSvg(
//                                   path: "assets/location.svg",
//                                   width: 26,
//                                   height: 26,
//                                   parentWidth: 30,
//                                   parentHeight: 30,
//                                   color: AppColor.secondaryColor,
//                                 ),
//                               ),
//                               Expanded(
//                                 child: CustomTextRichText(
//                                   textHeading: 'Your Google Location ',
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.normal,
//                                   textColor: Colors.black,
//                                   textAlign: TextAlign.start,
//                                   text: myVisitControllerController
//                                       .locationMessage ??
//                                       "location not found",
//                                   fontWeightHeading: FontWeight.bold,
//                                   textColorHeading: AppColor.black,
//                                 ),
//                               )
//                             ],
//                           ).paddingOnly(bottom: 8, top: 8, right: 8),
//                         ],
//                       ),
//                     ).paddingSymmetric(vertical: 2, horizontal: 0),
//                     // MyCustomDropdown(
//                     //   // key: UniqueKey(),
//                     //   // shouldValidate: true,
//                     //   selectedItem: controller.selectedCustomerT,
//                     //   labelText: 'Customer Type',
//                     //   prefixIcon: Icon(
//                     //     Icons.account_circle_outlined,
//                     //     color: AppColor.secondaryColor,
//                     //   ),
//                     //   items: controller.clientTypeList
//                     //       ?.map((e) => e.type)
//                     //       .toList() ??
//                     //       [],
//                     //   hint: '',
//                     //   isRequired: true,
//                     //   senValue: (value) {
//                     //     controller.selectedCustomerT = value;
//                     //     controller.selectedCustomerTypeObj = controller
//                     //         .clientTypeList
//                     //         ?.firstWhere((e) => e.type == value);
//                     //   },
//                     //   filledColor: AppColor.white,
//                     // ),
//                     DropDownSearch(
//                       selectedItem: controller.selectedCustomerT,
//                       labelText: "Customer Type",
//                       items: controller.clientTypeList
//                           ?.map((e) => e.type ?? '')
//                           .toList() ??
//                           [],
//                       hint: '',
//
//                       isRequired: true,
//                       senValue: (value) async {
//                         controller.selectedCustomerT = value;
//                         controller.selectedCustomerTypeObj = controller
//                             .clientTypeList
//                             ?.firstWhere((e) => e.type == value);
//                         controller.update();
//                       },
//                       filledColor: AppColor.white,
//                       prefixIcon: Icon(
//                         Icons.account_circle_outlined,
//                         color: AppColor.secondaryColor,
//                       ),
//                     ),
//                     CustomTextField(
//                       // key: UniqueKey(),
//                       // shouldValidate: true,
//                       txtController: controller.customerNameField,
//                       labelText: 'Customer Name',
//                       hintText: 'Customer Name',
//                       isRequired: true,
//                       keyBoardType: TextInputType.text,
//                       fillColor: AppColor.white,
//                       isReadOnly: false,
//                       maxLines: 1,
//                       fontSize: 16,
//                       prefixIcon: Icon(
//                         Icons.supervisor_account_outlined,
//                         color: AppColor.secondaryColor,
//                       ),
//                       autofocus: false,
//                     ),
//                     CustomTextField(
//                       // key: UniqueKey(),
//                       // shouldValidate: true,
//                       txtController: controller.contactPersonNameField,
//                       labelText: 'Contact Person Name',
//                       hintText: 'Contact Person Name',
//                       isRequired: true,
//                       keyBoardType: TextInputType.text,
//                       fillColor: AppColor.white,
//                       isReadOnly: false,
//                       maxLines: 1,
//                       fontSize: 16,
//                       prefixIcon: Icon(
//                         Icons.contact_page_outlined,
//                         color: AppColor.secondaryColor,
//                       ),
//                       autofocus: false,
//                     ),
//                     CustomTextField(
//                       // key: UniqueKey(),
//                       // shouldValidate: true,
//                       txtController: controller.mobNoField,
//                       // mazLenght: FlavorConfig.instance.name != "Lifenity Operational" ??10,
//                       mazLenght: 10,
//                       autofocus: false,
//                       labelText: 'Mobile No',
//                       hintText: 'Mobile No',
//                       isRequired: true,
//                       keyBoardType: TextInputType.phone,
//                       fillColor: AppColor.white,
//                       isReadOnly: false,
//                       maxLines: 1,
//                       fontSize: 16,
//                       prefixIcon: Icon(
//                         Icons.phone_android,
//                         color: AppColor.secondaryColor,
//                       ),
//                     ),
//                     CustomTextField(
//                       // key: UniqueKey(),
//                       // shouldValidate: true,
//                       txtController: controller.emailIdField,
//                       autofocus: false,
//                       labelText: 'Email ID',
//                       hintText: 'Email ID',
//                       isRequired: true,
//                       keyBoardType: TextInputType.emailAddress,
//                       fillColor: AppColor.white,
//                       isReadOnly: false,
//                       maxLines: 1,
//                       fontSize: 16,
//                       prefixIcon: Icon(
//                         Icons.email_outlined,
//                         color: AppColor.secondaryColor,
//                       ),
//                     ),
//                     CustomTextField(
//                       // key: UniqueKey(),
//                       // shouldValidate: true,
//                       txtController: controller.specialty,
//                       autofocus: false,
//                       labelText: 'Speciality',
//                       hintText: 'Speciality',
//                       isRequired: true,
//                       keyBoardType: TextInputType.text,
//                       fillColor: AppColor.white,
//                       isReadOnly: false,
//                       maxLines: 1,
//                       fontSize: 16,
//                       prefixIcon: Icon(
//                         Icons.manage_accounts_outlined,
//                         color: AppColor.secondaryColor,
//                       ),
//                     ),
//                     CustomTextField(
//                       // key: UniqueKey(),
//                       // shouldValidate: true,
//                       txtController: controller.addressField,
//                       autofocus: false,
//                       labelText: 'Address',
//                       hintText: 'Address',
//                       isRequired: true,
//                       keyBoardType: TextInputType.streetAddress,
//                       fillColor: AppColor.white,
//                       isReadOnly: false,
//                       maxLines: 1,
//                       fontSize: 16,
//                       prefixIcon: Icon(
//                         Icons.location_on_outlined,
//                         color: AppColor.secondaryColor,
//                       ),
//                     ),
//                     CustomTextField(
//                       // key: UniqueKey(),
//                       // shouldValidate: true,
//                       txtController: controller.businessPotential,
//                       autofocus: false,
//                       labelText:
//                       FlavorConfig.instance.name == "CSC HealthCare"
//                           ? 'Monthly Business Potential(Rs)'
//                           : 'Monthly Business Potential',
//                       hintText:
//                       FlavorConfig.instance.name == "CSC HealthCare"
//                           ? 'Monthly Business Potential(Rs)'
//                           : 'Monthly Business Potential',
//                       isRequired: true,
//                       keyBoardType: TextInputType.number,
//                       fillColor: AppColor.white,
//                       isReadOnly: false,
//                       maxLines: 1,
//                       fontSize: 16,
//                       prefixIcon: Icon(
//                         Icons.shopping_bag_outlined,
//                         color: AppColor.secondaryColor,
//                       ),
//                     ),
//                     DropDownSearch(
//                       selectedItem: controller.selectedDistrictVal,
//                       labelText: FlavorConfig.instance.name ==
//                           "HindLab Operational" ||
//                           FlavorConfig.instance.name ==
//                               "PlusCare Operational" ||
//                           FlavorConfig.instance.name ==
//                               "Lifenity Operational" ||
//                           FlavorConfig.instance.name ==
//                               "CSC HealthCare"
//                           ? "District"
//                           : 'Emirates',
//                       items: controller.districtRespModel?.output
//                           ?.map((e) => e.distname ?? '')
//                           .toList() ??
//                           [],
//                       hint: '',
//
//                       isRequired: true,
//                       senValue: (value) async {
//                         controller.selectedCityVal = null;
//                         controller.selectedCityObj = null;
//                         controller.selectedAreaVal = null;
//                         controller.selectedAreaObj = null;
//                         controller.update();
//                         controller.selectedDistrictVal = value;
//                         controller.selectedDistrictObj = controller
//                             .districtRespModel?.output
//                             ?.firstWhere((e) => e.distname == value);
//                         await controller.getCityList(addClientController
//                             .selectedDistrictObj!.distlgdcode
//                             .toString());
//                         await controller.getAreaList(addClientController
//                             .selectedDistrictObj!.distlgdcode
//                             .toString());
//                         controller.update();
//                       },
//                       filledColor: AppColor.white,
//                       prefixIcon: Icon(
//                         Icons.location_on_outlined,
//                         color: AppColor.secondaryColor,
//                       ),
//                     )
//                     // MyCustomDropdown(
//                     //   // key: UniqueKey(),
//                     //   // shouldValidate: true,
//                     //   selectedItem: controller.selectedDistrictVal,
//                     //   labelText: FlavorConfig.instance.name ==
//                     //               "HindLab Operational" ||
//                     //           FlavorConfig.instance.name ==
//                     //               "PlusCare Operational" ||
//                     //           FlavorConfig.instance.name ==
//                     //               "Lifenity Operational" ||
//                     //           FlavorConfig.instance.name ==
//                     //               "CSC HealthCare"
//                     //       ? "District"
//                     //       : 'Emirates',
//                     //   prefixIcon: Icon(
//                     //     Icons.location_on_outlined,
//                     //     color: AppColor.secondaryColor,
//                     //   ),
//                     //   items: controller.districtRespModel?.output
//                     //           ?.map((e) => e.distname)
//                     //           .toList() ??
//                     //       [],
//                     //   hint: '',
//                     //   isRequired: true,
//                     //   senValue: (value) async {
//                     //     controller.selectedCityVal = null;
//                     //     controller.selectedCityObj = null;
//                     //     controller.selectedAreaVal = null;
//                     //     controller.selectedAreaObj = null;
//                     //     controller.update();
//                     //     controller.selectedDistrictVal = value;
//                     //     controller.selectedDistrictObj = controller
//                     //         .districtRespModel?.output
//                     //         ?.firstWhere((e) => e.distname == value);
//                     //     await controller.getCityList(addClientController
//                     //         .selectedDistrictObj!.distlgdcode
//                     //         .toString());
//                     //     await controller.getAreaList(addClientController
//                     //         .selectedDistrictObj!.distlgdcode
//                     //         .toString());
//                     //   },
//                     //   filledColor: AppColor.white,
//                     // ),
//                     ,MyCustomDropdown(
//                       // shouldValidate: true,
//                       selectedItem: controller.selectedCityVal,
//                       labelText: "City",
//                       prefixIcon: Icon(
//                         Icons.location_on_outlined,
//                         color: AppColor.secondaryColor,
//                       ),
//                       items: controller.cityList
//                           ?.map((e) => e.cityName)
//                           .toList() ??
//                           [],
//                       hint: '',
//                       isRequired: true,
//                       senValue: (value) {
//                         controller.selectedCityVal = value;
//                         controller.selectedCityObj = controller.cityList
//                             ?.firstWhere((e) => e.cityName == value);
//                         controller.update();
//                       },
//                       filledColor: AppColor.white,
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: MyCustomDropdown(
//                             // key: UniqueKey(),
//                             // shouldValidate: true,
//                             selectedItem: controller.selectedAreaVal,
//                             labelText: 'Area',
//                             prefixIcon: Icon(
//                               Icons.location_on_outlined,
//                               color: AppColor.secondaryColor,
//                             ),
//                             items: controller.areaList
//                                 ?.map((e) => e.patchName)
//                                 .toList() ??
//                                 [],
//                             hint: '',
//                             isRequired: true,
//                             senValue: (value) {
//                               controller.selectedAreaVal = value;
//                               controller.selectedAreaObj =
//                                   controller.areaList?.firstWhereOrNull(
//                                           (e) => e.patchName == value);
//                               controller.update();
//                             },
//                             filledColor: AppColor.white,
//                           ),
//                         ),
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: IconButton(
//                             onPressed: () {
//                               showModalBottomSheet(
//                                 isScrollControlled: true,
//                                 isDismissible: false,
//                                 enableDrag: false,
//                                 context: context,
//                                 builder: (BuildContext context) {
//                                   addClientController.shouldValidateArea =
//                                   false;
//                                   return PopScope(
//                                       canPop: false, child: addArea());
//                                 },
//                               );
//                             },
//                             icon: Icon(
//                               Icons.add_circle_outline_sharp,
//                               color: AppColor.secondaryColor,
//                             ),
//                           ).paddingOnly(top: 32, bottom: 10, right: 0),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     SafeArea(
//                       bottom: true,
//                       top: false,
//                       child: CustomButton(
//                         buttonFontSize: 16,
//                         buttonText: 'Register',
//                         path: 'assets/arrow_nav.svg',
//                         callB: () async {
//                           // controller.shouldValidateFields = true;
//                           // controller.update();
//
//                           // if (controller.customerNameField.text.isEmpty ||
//                           //     controller
//                           //         .contactPersonNameField.text.isEmpty ||
//                           //     controller.mobNoField.text.isEmpty ||
//                           //     controller.emailIdField.text.isEmpty ||
//                           //     controller.specialty.text.isEmpty ||
//                           //     controller.businessPotential.text.isEmpty ||
//                           //     controller.selectedCustomerT == null ||
//                           //     controller.selectedCityVal == null ||
//                           //     controller.selectedCityVal == null ||
//                           //     controller.selectedAreaVal == null) {
//                           //   formKey.currentState?.validate() ?? false;
//                           //   return;
//                           // }
//
//                           if (myVisitControllerController.longitude !=
//                               null &&
//                               myVisitControllerController.longitude !=
//                                   null) {
//                             if (formKey.currentState?.validate() ??
//                                 false) {
//                               await controller.addClient(
//                                   controller
//                                       .selectedCustomerTypeObj!.typeid
//                                       .toString(),
//                                   controller.customerNameField.text
//                                       .trim(),
//                                   addClientController
//                                       .selectedDistrictObj!.distlgdcode
//                                       .toString(),
//                                   controller.mobNoField.text.trim(),
//                                   controller.emailIdField.text.trim(),
//                                   userData?['output'][0]['EmpCode']
//                                       .toString(),
//                                   controller.addressField.text.trim(),
//                                   controller.selectedCityObj!.cityCode
//                                       .toString(),
//                                   controller.selectedAreaObj!.patchId
//                                       .toString(),
//                                   myVisitControllerController.latitude
//                                       .toString(),
//                                   myVisitControllerController.longitude
//                                       .toString(),
//                                   controller.businessPotential.text
//                                       .trim());
//                             }
//                           } else {
//                             await fetchLocation();
//                           }
//                         },
//                         // buttonWidth: double.infinity,
//                         primColor: AppColor.primaryBackgroundColor,
//                         secColor: AppColor.secondaryColor,
//                         textColor: AppColor.white,
//                         iconColor: AppColor.white,
//                         buttonWidth: 126,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                   ],
//                 ).paddingSymmetric(vertical: 4, horizontal: 10),
//               ),
//             )
//                 : InternetIssue(
//               onRetryPressed: () {
//                 getUserData();
//               },
//             );
//           }),
//     );
//   }
//
//   Widget addArea() {
//     // addClientController.shouldValidateArea = true;
//
//     return Container(
//       margin: EdgeInsets.only(bottom: MediaQuery
//           .of(context)
//           .viewInsets
//           .bottom),
//       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
//       decoration: BoxDecoration(
//         color: const Color(0xffF8F8F8),
//         borderRadius: BorderRadius.circular(6),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.1),
//             spreadRadius: 2,
//             blurRadius: 4,
//             offset: const Offset(0, 0.5), // changes position of shadow
//           ),
//         ],
//       ),
//       child: Form(
//         key: formKey1,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CustomText(
//                     text: "Add Area",
//                     fontSize: 18,
//                     fontFam: "Nunito Sans",
//                     fontWeight: FontWeight.bold,
//                     textColor: Colors.black,
//                     textAlign: TextAlign.start),
//               ],
//             ).paddingOnly(bottom: 8),
//             MyCustomDropdown(
//               // shouldValidate: true,
//               selectedItem: addClientController.selectedAddDistrictVal,
//               labelText: FlavorConfig.instance.name == "HindLab Operational" ||
//                   FlavorConfig.instance.name == "PlusCare Operational" ||
//                   FlavorConfig.instance.name == "Lifenity Operational" ||
//                   FlavorConfig.instance.name == "CSC HealthCare"
//                   ? "District"
//                   : 'Emirates',
//               prefixIcon: Icon(
//                 Icons.location_on_outlined,
//                 color: AppColor.secondaryColor,
//               ),
//               items: addClientController.districtRespModel?.output
//                   ?.map((e) => e.distname)
//                   .toList() ??
//                   [],
//               hint: '',
//               isRequired: true,
//               senValue: (value) async {
//                 addClientController.addAreaTxtField.clear();
//                 addClientController.selectedAddDistrictVal = value;
//                 addClientController.selectedAddDistrictObj = addClientController
//                     .districtRespModel?.output
//                     ?.firstWhere((e) => e.distname == value);
//
//                 await addClientController.getAddAreaList(addClientController
//                     .selectedAddDistrictObj!.distlgdcode
//                     .toString());
//                 // addClientController.update();
//               },
//               filledColor: AppColor.white,
//             ),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Row(
//                 children: [
//                   CustomText(
//                       text: "Area",
//                       fontSize: 16,
//                       fontWeight: FontWeight.normal,
//                       textColor: AppColor.black,
//                       textAlign: TextAlign.start,
//                       fontFam: "Nunito Sans"),
//                   const CustomText(
//                       text: " *",
//                       fontSize: 16,
//                       fontWeight: FontWeight.normal,
//                       textColor: Colors.red,
//                       textAlign: TextAlign.start,
//                       fontFam: "Nunito Sans"),
//                 ],
//               ),
//             ).paddingOnly(left: 8, top: 4),
//             TypeAheadField<AreaOutput>(
//               controller: addClientController.addAreaTxtField,
//               suggestionsCallback: (search) {
//                 if (search.isEmpty) {
//                   return []; // Return an empty list if no input
//                 }
//                 return addClientController.addAreaList
//                     ?.where((area) =>
//                 area.patchName
//                     ?.toLowerCase()
//                     .contains(search.toLowerCase()) ??
//                     false)
//                     .toList() ??
//                     [];
//               },
//               builder: (context, controller, focusNode) {
//                 return TextFormField(
//                   controller: controller,
//                   focusNode: focusNode,
//                   autofocus: false,
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   decoration: InputDecoration(
//                     contentPadding: const EdgeInsets.symmetric(vertical: 14),
//                     fillColor: AppColor.white,
//                     filled: true,
//                     hintText: "Area",
//                     prefixIcon: Icon(
//                       Icons.location_on_outlined,
//                       color: AppColor.secondaryColor,
//                     ),
//                     hintStyle: TextStyle(
//                         fontSize: 16.0,
//                         color: AppColor.textGrey,
//                         fontFamily: "Nunito Sans",
//                         fontWeight: FontWeight.normal),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                       borderSide: BorderSide(
//                         color: AppColor.borderGrey,
//                       ),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                       borderSide: BorderSide(
//                         color: AppColor.borderGrey,
//                       ),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Area field is required';
//                     }
//                     return null;
//                   },
//                 );
//               },
//               itemBuilder: (context, city) {
//                 return ListTile(
//                   title: Text(city.patchName ?? ""),
//                 );
//               },
//               onSelected: (city) {},
//
//               emptyBuilder: (context) =>
//               const SizedBox.shrink(), // Hide "No items found!"
//             ).paddingSymmetric(vertical: 4, horizontal: 8),
//             const SizedBox(
//               height: 84,
//             ),
//             SafeArea(
//               bottom: true,
//               top: false,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CustomButton(
//                     buttonFontSize: 16,
//                     buttonText: 'Save',
//                     path: 'assets/arrow_nav.svg',
//                     callB: () async {
//                       if (formKey1.currentState?.validate() ?? false) {
//                         if (addClientController.selectedAddDistrictVal !=
//                             null &&
//                             addClientController
//                                 .addAreaTxtField.text.isNotEmpty) {
//                           await addClientController.addArea(
//                               '0',
//                               addClientController.addAreaTxtField.text,
//                               addClientController
//                                   .selectedAddDistrictObj!.distlgdcode
//                                   .toString(),
//                               '0');
//                         } else {
//                           CustomMessage.toast("Please fill mandatory fields");
//                         }
//                       }
//                     },
//                     // buttonWidth: double.infinity,
//                     primColor: AppColor.primaryBackgroundColor,
//                     secColor: AppColor.secondaryColor,
//                     textColor: AppColor.white,
//                     iconColor: AppColor.white,
//                     buttonWidth: 120,
//                   ),
//                   const SizedBox(
//                     width: 20,
//                   ),
//                   CustomButton(
//                     buttonFontSize: 16,
//                     buttonText: 'Cancel',
//                     path: 'assets/arrow_nav.svg',
//                     callB: () {
//                       addClientController.selectedAddDistrictVal = null;
//                       addClientController.selectedAddDistrictObj = null;
//                       addClientController.selectedAddAreaVal = null;
//                       addClientController.selectedAddAreaObj = null;
//                       addClientController.addAreaTxtField.clear();
//                       Get.back();
//                     },
//                     // buttonWidth: double.infinity,
//                     primColor: AppColor.borderGrey,
//                     secColor: AppColor.borderGrey,
//                     textColor: AppColor.black,
//                     iconColor: AppColor.black,
//                     buttonWidth: 120,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ).paddingSymmetric(horizontal: 10, vertical: 6),
//       ),
//     );
//   }
// }
