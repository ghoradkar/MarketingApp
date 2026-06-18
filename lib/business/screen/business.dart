import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marketingapp/business/business_controller.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/utils/shared_pref_constants.dart';
import 'package:marketingapp/utils/shared_preference.dart';
import 'package:marketingapp/widgets/cust_table.dart';
import 'package:marketingapp/widgets/custom_button.dart';
import 'package:marketingapp/widgets/custom_date_field.dart';
import 'package:marketingapp/widgets/custom_searchable_dropdown.dart';
import 'package:marketingapp/widgets/custom_text.dart';
import 'package:marketingapp/widgets/date_picker.dart';
import 'package:marketingapp/widgets/header_count.dart';
import 'package:marketingapp/widgets/no_internet_connectivity.dart';

class BusinessScreen extends StatefulWidget {
  const BusinessScreen({super.key});

  @override
  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {
  final BusinessController businessController = Get.put(BusinessController());

  @override
  void initState() {
    checkInternetAndLoadData();
    super.initState();
  }

  Future<void> getUserData() async {
    businessController.userData =
        await SharedPref().read(const SharedPrefConstant().kUserData);
    await businessController.getStateList();
    await businessController.getDistrictList(
        businessController.userData?['output'][0]['EmpCode'].toString());
    await businessController.getLabList(
        businessController.userData?['output'][0]['EmpCode'].toString(), '0');

    final now = DateTime.now();
    final toDate = DateFormat('dd-MM-yyyy').format(now);
    final fromDate = DateFormat('dd-MM-yyyy').format(
      DateTime(now.year, now.month - 1, 1),
    );
    businessController.selectedState = businessController.stateList?.output
        .firstWhere((e) => e.statename == "Maharashtra")
        .statename;
    businessController.selectedDistrict = businessController
        .districtListModel?.output
        .firstWhere((e) => e.distname == "ALL")
        .distname;
    businessController.districtCode = businessController
        .districtListModel?.output
        .firstWhere((e) => e.distname == "ALL");

    businessController.selectedPatch = "ALL";
    businessController.selectedLab = businessController.labListModel?.output
        .firstWhere((e) => e.labName == "ALL")
        .labName;
    businessController.lab = businessController.labListModel?.output
        .firstWhere((e) => e.labName == "ALL");
    businessController.selectedCustomer = "ALL";
    businessController.fDateController.text = toDate;
    businessController.tDateController.text = toDate;
    await businessController.searchBusiness(
        businessController.userData!['output'][0]['EmpCode'].toString(),
        '0',
        '0',
        '',
        fromDate,
        toDate,
        false);

    // setState(() {});
  }

  checkInternetAndLoadData() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      businessController.hasInternet = true;
    } else {
      businessController.hasInternet = false;
    }
    businessController.update();
    if (businessController.hasInternet) {
      getUserData();
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
                  // AppColor.primaryBackgroundColor.withValues(alpha: 0.3),
                  // AppColor.secondaryColor.withValues(alpha: 0.3)
                ],
                // Change colors as needed
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          actions: [
            InkWell(
                    onTap: () {
                      Get.to(FilterBusiness());
                      // showModalBottomSheet(
                      //   isScrollControlled: true,
                      //   context: context,
                      //   builder: (BuildContext context) {
                      //     return businessFilter();
                      //   },
                      // );
                    },
                    child: Image.asset("assets/filter.png"))
                .paddingOnly(right: 8)
          ],
          title: CustomText(
            text: "Business",
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
      body: GetBuilder<BusinessController>(
          init: null,
          builder: (controller) {
            return controller.hasInternet
                ? Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.4),
                              // Shadow color
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(1, 1),
                            ),
                          ],
                          color: AppColor.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: HeaderCount(
                                  'Business Target',
                                  businessController.totalInvoiceAmount
                                      .toString(),
                                  true),
                            ),
                            Expanded(
                              child: HeaderCount(
                                  'Client Potential',
                                  businessController.totalPaidInvoice
                                      .toString(),
                                  true),
                            ),
                            Expanded(
                              child: HeaderCount(
                                  'Actual Business',
                                  businessController.totalUnPaidInvoice
                                      .toString(),
                                  false),
                            ),
                          ],
                        ),
                      ).paddingOnly(top: 10, left: 8, right: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.4),
                              // Shadow color
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(1, 1),
                            ),
                          ],
                          color: AppColor.white,
                        ),
                        child: CustomText(
                            text:
                                "*Click on Unpaid Invoice Count from Table to see the Total Pending Amount",
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            textColor: AppColor.red,
                            textAlign: TextAlign.start,
                            fontFam: "Nunito Sans"),
                      ).paddingOnly(top: 10, left: 8, right: 8, bottom: 10),
                      Expanded(
                        child: BusinessTable(
                          l1: List.generate(
                              businessController
                                      .businessListModel?.output.length ??
                                  0,
                              (index) => (index + 1).toString()),
                          l2: businessController.businessListModel?.output
                                  .map((e) => e.date)
                                  .toList() ??
                              [],
                          l3: businessController.businessListModel?.output
                                  .map((e) => e.noOfCustomer)
                                  .toList() ??
                              [],
                          l4: businessController.businessListModel?.output
                                  .map((e) => e.paidInvoice)
                                  .toList() ??
                              [],
                          l5: businessController.businessListModel?.output
                                  .map((e) => e.unPaidInvoice)
                                  .toList() ??
                              [],
                          l6: businessController.businessListModel?.output
                                  .map((e) => e.invoiceAmount)
                                  .toList() ??
                              [],
                          tableHeader: const [
                            "Sr.\nNo",
                            "Date\n",
                            "No of Customer",
                            "Paid Invoice",
                            "Unpaid Invoice",
                            "Total Business"
                          ],
                        ).paddingOnly(left: 8, right: 8),
                      )
                    ],
                  )
                : InternetIssue(
                    onRetryPressed: () {
                      getUserData();
                    },
                  );
          }),
    );
  }
}

class FilterBusiness extends StatefulWidget {
  const FilterBusiness({super.key});

  @override
  State<FilterBusiness> createState() => _FilterBusinessState();
}

class _FilterBusinessState extends State<FilterBusiness> {
  final BusinessController businessController = Get.find();

  @override
  Widget build(BuildContext context) {
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
            text: "Filter",
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
      body: GetBuilder<BusinessController>(
          init: businessController,
          builder: (controller) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SearchableDropDown(
                    isViewPatient: true,
                    list: businessController.stateList?.output
                            .map((e) => e.statename)
                            .toList() ??
                        [],
                    onChanged: (value) {
                      businessController.selectedState = value;
                    },
                    selectedItem: businessController.selectedState,
                    hintText: 'State',
                    iconPath: 'assets/location.png',
                  ),
                  SearchableDropDown(
                    isViewPatient: true,
                    list: businessController.districtListModel?.output
                            .map((e) => e.distname)
                            .toList() ??
                        [],
                    onChanged: (value) async {
                      debugPrint(value);
                      businessController.selectedDistrict = value;

                      businessController.districtCode = businessController
                          .districtListModel?.output
                          .firstWhere((e) => e.distname == value);
                      await businessController.getPatchList(
                          businessController.districtCode!.distlgdcode);
                    },
                    selectedItem: businessController.selectedDistrict,
                    hintText: 'District',
                    iconPath: 'assets/location.png',
                  ),
                  Obx(() => SearchableDropDown(
                        isViewPatient: true,
                        list: businessController.patchList
                            .map((e) => e.patchName)
                            .toList(),
                        onChanged: (value) async {
                          businessController.selectedPatch = value;

                          businessController.labListModel = null;
                          businessController.update();
                          await businessController.getLabList(
                              businessController.userData?['output'][0]
                                      ['EmpCode']
                                  .toString(),
                              businessController.districtCode!.distlgdcode
                                  .toString());
                        },
                        selectedItem: businessController.selectedPatch,
                        hintText: 'Patch',
                        iconPath: 'assets/location.png',
                      )),
                  SearchableDropDown(
                    isViewPatient: true,
                    list: businessController.labListModel?.output
                            .map((e) => e.labName)
                            .toList() ??
                        [],
                    onChanged: (value) async {
                      businessController.selectedLab = value;
                      businessController.lab = businessController
                          .labListModel?.output
                          .firstWhere((e) => e.labName == value);
                      await businessController.getCustomerList(
                        businessController.userData?['output'][0]['EmpCode']
                            .toString(),
                        businessController.districtCode!.distlgdcode.toString(),
                        businessController.lab!.labCode.toString(),
                      );
                    },
                    selectedItem: businessController.selectedLab,
                    hintText: 'Lab',
                    iconPath: 'assets/list-check.png',
                  ),
                  SearchableDropDown(
                    isViewPatient: true,
                    list: businessController.customerListModel?.output
                            ?.map((e) => e.firstname ?? '')
                            .toList() ??
                        [],
                    onChanged: (value) {
                      businessController.selectedCustomer = value;
                      businessController.customer = businessController
                          .customerListModel?.output
                          ?.firstWhere((e) => e.firstname == value);
                    },
                    selectedItem: businessController.selectedCustomer,
                    hintText: 'Customer',
                    iconPath: 'assets/users.png',
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomDateField(
                          labelText: 'From Date',
                          hint: 'Select Date',
                          isRequired: false,
                          callB: () {
                            selectFromDate(context);
                          },
                          selectedDate: businessController.fDateController,
                          filledColor: Colors.white,
                          prefixIconColor: AppColor.primaryBackgroundColor,
                          dontDhowPrefix: false,
                        ),
                      ),
                      Expanded(
                        child: CustomDateField(
                          labelText: 'To Date',
                          hint: 'Select Date',
                          isRequired: false,
                          callB: () {
                            selectToDate(context);
                          },
                          selectedDate: businessController.tDateController,
                          filledColor: Colors.white,
                          prefixIconColor: AppColor.primaryBackgroundColor,
                          dontDhowPrefix: false,
                        ),
                      ),
                    ],
                  ),
                  CustomButton(
                    buttonFontSize: 16,
                    buttonText: 'Search',
                    path: 'assets/arrow_nav.svg',
                    callB: () async {
                      await businessController.searchBusiness(
                          businessController.userData!['output'][0]['EmpCode']
                              .toString(),
                          businessController.districtCode!.distlgdcode
                              .toString(),
                          businessController.lab!.labCode.toString(),
                          '',
                          businessController.fDateController.text,
                          businessController.tDateController.text,
                          true);
                    },
                    // buttonWidth: double.infinity,
                    primColor: AppColor.primaryBackgroundColor,
                    secColor: AppColor.secondaryColor,
                    textColor: AppColor.white,
                    iconColor: AppColor.white,
                    buttonWidth: 120,
                  ).paddingOnly(top: 40),
                ],
              ).paddingSymmetric(horizontal: 10, vertical: 6),
            );
          }),
    );
  }

  selectFromDate(context) async {
    final DateTime? picked = await DatePickerHelper.selectDate(context);
    if (picked != null) {
      // Update the selected date
      businessController.selectedFromDate = picked;

      // Format the date as "01-OCT-2024"
      DateFormat formatter = DateFormat('dd-MM-yyy');

      businessController.formattedFromDate =
          formatter.format(businessController.selectedFromDate!);

      // Set the formatted date in the text field
      businessController.fDateController.text =
          businessController.formattedFromDate!;

      // Refresh the UI
      // setState(() {});
      businessController.update();
    }
  }

  selectToDate(context) async {
    final DateTime? picked = await DatePickerHelper.selectDate(context);
    if (picked != null) {
      // Update the selected date
      businessController.selectedToDate = picked;

      // Format the date as "01-OCT-2024"
      // DateFormat formatter = DateFormat('yyyy/MM/dd');
      DateFormat formatter = DateFormat('dd-MM-yyy');
      businessController.formattedToDate =
          formatter.format(businessController.selectedToDate!);

      // Set the formatted date in the text field
      businessController.tDateController.text =
          businessController.formattedToDate!;

      // Refresh the UI
      // setState(() {});
      businessController.update();
    }
  }
}
