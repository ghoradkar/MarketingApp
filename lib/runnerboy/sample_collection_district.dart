import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:marketingapp/dashboard/model/district_list_model.dart';
import 'package:marketingapp/runnerboy/collect_sample.dart';
import 'package:marketingapp/runnerboy/controller/sample_collection_controller.dart';
import 'package:marketingapp/runnerboy/model/get_center_id_and_available_fund.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/utils/shared_pref_constants.dart';
import 'package:marketingapp/utils/shared_preference.dart';
import 'package:marketingapp/widgets/custom_text.dart';
import 'package:marketingapp/widgets/custom_text_field.dart';
import 'package:marketingapp/widgets/dropdown_search.dart';
import 'package:marketingapp/widgets/no_internet_connectivity.dart';

class SampleCollectionDistrict extends StatefulWidget {
  const SampleCollectionDistrict({super.key});

  @override
  State<SampleCollectionDistrict> createState() =>
      _SampleCollectionDistrictState();
}

class _SampleCollectionDistrictState extends State<SampleCollectionDistrict> {
  final SampleCollectionController sampleCollectionController =
  Get.find<SampleCollectionController>();
  var userData;
  String? selectedDist;
  bool isResultFound = false;
  late final VoidCallback controllerListener;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    selectedDist = sampleCollectionController.cityController.text.isNotEmpty
        ? sampleCollectionController.cityController.text
        : null;

    checkInternetAndLoadData();

    controllerListener = () {
      if (!mounted) return;
      if (sampleCollectionController.getCenterIdAndAvailableFund?.output !=
          null) {
        setState(() {
          sampleCollectionController.filteredCustomerList = List.from(
              sampleCollectionController.getCenterIdAndAvailableFund!.output);
        });
      }
    };

    sampleCollectionController.addListener(controllerListener);
  }

  @override
  void dispose() {
    sampleCollectionController.removeListener(controllerListener);
    super.dispose();
  }

  Future<void> getUserData() async {
    userData = await SharedPref().read(const SharedPrefConstant().kUserData);

    // if (FlavorConfig.instance.name == "CSC HealthCare") {
    //   await sampleCollectionController.getDistrictList("36");
    // } else {
    await sampleCollectionController
        .getDistrictList(userData['output'][0]['STATELGDCODE'].toString());
    // }

    final list = sampleCollectionController.districtRespModel?.output ?? [];
    final match = list.firstWhereOrNull(
            (e) => e.distlgdcode == userData['output'][0]['DISTLGDCODE']);

    if (match != null) {
      selectedDist = match.distname;

      await sampleCollectionController.getCenterId(
          '0', match.distlgdcode.toString());
    }
    setState(() {});
  }

  checkInternetAndLoadData() async {
    final List<ConnectivityResult> connectivityResult =
    await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      sampleCollectionController.hasInternet = true;
    } else {
      sampleCollectionController.hasInternet = false;
    }
    sampleCollectionController.update();
    if (sampleCollectionController.hasInternet) {
      getUserData();
    }
  }

  filterSearchResults(String query) {
    if (query.isEmpty) {
      sampleCollectionController.filteredCustomerList = List.from(
          sampleCollectionController.getCenterIdAndAvailableFund!.output);
    } else {
      sampleCollectionController.filteredCustomerList =
          sampleCollectionController.getCenterIdAndAvailableFund!.output
              .where((customer) =>
              (customer.facilityName)
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .toList();
    }

    setState(() {});
  }

  // filterSearchResults(String query) {
  //   if (query.isEmpty) {
  //     sampleCollectionController.filteredCustomerList = List.from(
  //         sampleCollectionController.getCenterIdAndAvailableFund!.output);
  //     setState(() {});
  //     return false;
  //   } else {
  //     sampleCollectionController.filteredCustomerList =
  //         sampleCollectionController.getCenterIdAndAvailableFund!.output
  //             .where((customer) => customer.customerTypeName
  //                 .toLowerCase()
  //                 .contains(query.toLowerCase()))
  //             .toList();
  //     setState(() {});
  //
  //     if (sampleCollectionController.filteredCustomerList.isNotEmpty) {
  //       return false;
  //     } else {
  //       return false;
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SampleCollectionController>(
        init: sampleCollectionController,
        builder: (controller) {
          return Scaffold(
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
              leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back)),
            ),
            body: controller.hasInternet
                ? Column(
              children: [
                DropDownSearch(
                  isViewProfile: true,
                  selectedItem: selectedDist,
                  labelText: 'City',
                  items: controller.districtRespModel?.output
                      ?.map((e) => e.distname ?? '')
                      .toList() ??
                      [],
                  hint: '',
                  isRequired: true,
                  senValue: (value) async {
                    selectedDist = value;
                    sampleCollectionController.cityController.text =
                        value ?? '';

                    DistrictOutput? selectedDistObj = controller
                        .districtRespModel?.output
                        ?.firstWhere((e) => e.distname == value);

                    await sampleCollectionController.getCenterId(
                        '0', selectedDistObj!.distlgdcode.toString());

                    controller.update();
                  },
                  filledColor: AppColor.white,
                  prefixIcon: Icon(
                    Icons.location_on_outlined,
                    color: AppColor.secondaryColor,
                  ),
                ),
                Visibility(
                  visible: selectedDist != null,
                  child: CustomTextField(
                    autofocus: false,
                    txtController: controller.searchController,
                    onChanged: (value) {
                      filterSearchResults(value);
                    },
                    labelText: 'Search Customer Name',
                    hintText: 'Search',
                    isRequired: false,
                    keyBoardType: TextInputType.text,
                    fillColor: AppColor.white,
                    isReadOnly: false,
                    maxLines: 1,
                    fontSize: 14.sp,
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColor.secondaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                if (controller.filteredCustomerList.isNotEmpty)
                  Expanded(
                    child: Builder(
                      builder: (_) {
                        final visibleCustomers = controller
                            .filteredCustomerList
                            .where(
                                (e) =>
                            (e.facilityName
                                .trim()
                                .isNotEmpty))
                            .toList();

                        if (visibleCustomers.isEmpty) {
                          return const Center(
                              child: Text("No customers found"));
                        }

                        return ListView.builder(
                          itemCount: visibleCustomers.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Get.to(
                                  CollectSample(
                                    hospitalDetails:
                                    visibleCustomers[index],
                                    isEdit: false,
                                  ),
                                );
                              },
                              child: LocationCard(
                                  locationDate:
                                  visibleCustomers[index])
                                  .paddingSymmetric(vertical: 6.h),
                            );
                          },
                        );
                      },
                    ),
                    // child: ListView.builder(
                    //     shrinkWrap: true,
                    //     itemCount: controller.filteredCustomerList.length,
                    //     itemBuilder: (context, index) {
                    //       //this is for if facilityName is empty then show customer in list
                    //       final List<CenterIdAndAvailableFundOutput>
                    //           visibleCustomers = controller
                    //               .filteredCustomerList
                    //               .where((e) =>
                    //                   (e.facilityName.trim().isNotEmpty ??
                    //                       false))
                    //               .toList();
                    //
                    //       return InkWell(
                    //         onTap: () {
                    //           Get.to(CollectSample(
                    //             hospitalDetails: visibleCustomers[index],
                    //             isEdit: false,
                    //           ));
                    //         },
                    //         child: LocationCard(
                    //           locationDate: visibleCustomers[index],
                    //         ).paddingSymmetric(
                    //             vertical: 6, horizontal: 6),
                    //       );
                    //
                    //
                    //     }),
                  )
                else
                  if (selectedDist == null)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/district.png'),
                        SizedBox(
                          height: 20.h,
                        ),
                        CustomText(
                            text:
                            "Select city to view\nthe customers lists.",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            textColor: AppColor.black,
                            textAlign: TextAlign.center,
                            fontFam: "Nunito Sans"),
                      ],
                    ).paddingOnly(top: 60.h)
              ],
            ).paddingSymmetric(vertical: 4.h, horizontal: 20.w)
                : InternetIssue(
              onRetryPressed: () {
                checkInternetAndLoadData();
              },
            ),
          );
        });
  }
}

class LocationCard extends StatelessWidget {
  final CenterIdAndAvailableFundOutput? locationDate;

  const LocationCard({super.key, this.locationDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.borderGrey),
        color: AppColor.primaryBackgroundColor.withValues(alpha: 0.1),
      ),
      child: CustomText(
        text: locationDate?.facilityName ?? "",
        fontSize: 16,
        fontWeight: FontWeight.w500,
        textColor: AppColor.black,
        textAlign: TextAlign.start,
        fontFam: 'Nunito Sans',
      ),
    );
  }
}
