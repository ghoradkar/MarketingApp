import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marketingapp/add_visit/controller/add_visit_controller.dart';
import 'package:marketingapp/add_visit/model/customer_list_model.dart';
import 'package:marketingapp/add_visit/screen/add_visit_punch_out_screen.dart';
import 'package:marketingapp/dashboard/controller/my_visit_controller.dart';
import 'package:marketingapp/dashboard/model/district_list_model.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/utils/shared_pref_constants.dart';
import 'package:marketingapp/utils/shared_preference.dart';
import 'package:marketingapp/widgets/custom_button.dart';
import 'package:marketingapp/widgets/custom_popup.dart';
import 'package:marketingapp/widgets/custom_text.dart';
import 'package:marketingapp/widgets/custom_text_field.dart';
import 'package:marketingapp/widgets/dropdown_search.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class AddVisitStartRouteScreen extends StatefulWidget {
  static const routeName = '/add-visit-start';

  const AddVisitStartRouteScreen({super.key});

  @override
  State<AddVisitStartRouteScreen> createState() =>
      _AddVisitStartRouteScreenState();
}

class _AddVisitStartRouteScreenState extends State<AddVisitStartRouteScreen> {
  final AddVisitController addVisitController = Get.put(AddVisitController());
  final MyVisitControllerController myVisitControllerController =
      Get.find<MyVisitControllerController>();
  Map<String, dynamic>? userData;

  bool isResultFound = false;

  bool isLoading = true;
  bool isActionLoading = false;
  bool hasError = false;

  String? todayStr;
  late VoidCallback _customerListListener;

  @override
  void initState() {
    super.initState();

    addVisitController.selectedDist = null;
    addVisitController.filteredCustomerList.clear();
    addVisitController.customerListModel?.output?.clear();
    addVisitController.searchController.clear();

    _initializeScreen();

    _customerListListener = () {
      if (!mounted) return;
      if (addVisitController.customerListModel?.output != null) {
        setState(() {
          addVisitController.filteredCustomerList =
              List.from(addVisitController.customerListModel!.output!);
        });
      }
    };

    addVisitController.addListener(_customerListListener);
  }

  @override
  void dispose() {
    addVisitController.removeListener(_customerListListener);
    super.dispose();
  }

  Future<void> _initializeScreen() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      // Always load user data from SharedPreferences first (works offline)
      await getUserData();

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

  Future<void> getUserData() async {
    try {
      userData = await SharedPref().read(const SharedPrefConstant().kUserData);
      DateTime today = DateTime.now();
      todayStr = "${today.year.toString().padLeft(4, '0')}"
          "-${today.month.toString().padLeft(2, '0')}"
          "-${today.day.toString().padLeft(2, '0')}";

      setState(() {});
    } catch (e) {
      debugPrint("Error loading user data: $e");
    }
  }

  Future<void> checkInternetAndLoadData() async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await Connectivity().checkConnectivity();

      if (connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi)) {
        addVisitController.hasInternetVisit = true;
        addVisitController.update();

        // Reload data when internet is available
        if (userData != null && addVisitController.hasInternetVisit == true) {
          await addVisitController
              .getRouteFlag(userData?['output'][0]['EmpCode'].toString());

          await myVisitControllerController.getDistrictList(
              userData?['output'][0]['STATELGDCODE'].toString());

          await addVisitController
              .getRouteFlag(userData?['output'][0]['EmpCode'].toString());

          await myVisitControllerController.getDistrictList(
              userData?['output'][0]['STATELGDCODE'].toString());

          if (myVisitControllerController.latitude == null &&
              myVisitControllerController.longitude == null) {
            await fetchLocation();
          }
        }
      } else {
        addVisitController.hasInternetVisit = false;
        addVisitController.update();
        debugPrint("No internet connection");
      }
    } catch (e) {
      debugPrint("Connectivity check error: $e");
      addVisitController.hasInternetVisit = false;
      addVisitController.update();
    }

    setState(() {});
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

  filterSearchResults(String query) {
    if (query.isEmpty) {
      addVisitController.filteredCustomerList =
          List.from(addVisitController.customerListModel!.output!);
      setState(() {});
      return false;
    } else {
      addVisitController.filteredCustomerList = addVisitController
          .customerListModel!.output!
          .where((customer) =>
              customer.firstname!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      setState(() {});

      if (addVisitController.filteredCustomerList.isNotEmpty) {
        return false;
      } else {
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddVisitController>(
      init: addVisitController,
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    FlavorConfig.instance.name == "HindLab Operational"
                        ? AppColor.primaryBackgroundColor.withValues(alpha: 0.1)
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
              text: 'Add Visit',
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
              icon: const Icon(Icons.arrow_back),
            ),
            actions: [
              if (controller.checkRouteFlagModel?.message ==
                      "Start Route Flag Not Availaible" ||
                  (controller.todayStr != null &&
                      controller
                              .checkRouteFlagModel!.output?.first.createdDate !=
                          controller.todayStr))
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomButton(
                    buttonText: 'Start Route',
                    path: 'assets/arrow_nav.svg',
                    callB: () async {
                      if (!controller.hasInternetVisit) {
                        _showOfflineAlert();
                        return;
                      }

                      if (myVisitControllerController.longitude != null &&
                          myVisitControllerController.latitude != null) {
                        CustomPopup.takeConfirmationDialog(() {
                          Get.back();
                        }, () async {
                          Get.back();

                          setState(() => isActionLoading = true);
                          try {
                            await addVisitController.startRoute(
                                userData?['output'][0]['EmpCode'].toString(),
                                "1",
                                myVisitControllerController.latitude
                                    .toString(),
                                myVisitControllerController.longitude
                                    .toString(),
                                DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now()),
                                userData!['output'][0]['EmpCode'].toString());
                          } finally {
                            if (mounted) {
                              setState(() => isActionLoading = false);
                            }
                          }

                          if (addVisitController.startRouteModel!.message ==
                              'Start Route Details Save  Successfully') {
                            CustomPopup.takeConfirmationDialog(() async {
                              Get.back();
                              setState(() => isActionLoading = true);
                              try {
                                await addVisitController.getRouteFlag(
                                    userData?['output'][0]['EmpCode']
                                        .toString());
                              } finally {
                                if (mounted) {
                                  setState(() => isActionLoading = false);
                                }
                              }
                            }, () async {
                              Get.back();
                              setState(() => isActionLoading = true);
                              try {
                                await addVisitController.getRouteFlag(
                                    userData?['output'][0]['EmpCode']
                                        .toString());
                              } finally {
                                if (mounted) {
                                  setState(() => isActionLoading = false);
                                }
                              }
                            },
                                addVisitController.startRouteModel!.message ??
                                    "You can now start your journey\nfor add visit.",
                                'assets/destination.png',
                                "Ok",
                                130);
                          }
                        }, "Are you sure you want to Start Route ?",
                            'assets/destination.png', "Yes, Start Route", 190);
                      } else {
                        await fetchLocation();
                      }
                    },
                    primColor: AppColor.primaryBackgroundColor,
                    secColor: AppColor.secondaryColor,
                    textColor: AppColor.white,
                    iconColor: AppColor.white,
                    buttonFontSize: 14,
                    buttonWidth: 140,
                  ),
                )
            ],
          ),
          body: _buildBody(controller),
        );
      },
    );
  }

  Widget _buildBody(AddVisitController controller) {
    if (isLoading) {
      return _buildSkeletonContent();
    }

    if (hasError) {
      return _buildErrorWidget();
    }

    return Column(
      children: [
        // Show offline banner if no internet (non-blocking)
        if (!controller.hasInternetVisit) _buildOfflineBanner(),

        // Main content
        Expanded(
          child: Column(
            children: [
              DropDownSearch(
                selectedItem: controller.selectedDist,
                labelText:
                    FlavorConfig.instance.name == 'Lifenity International'
                        ? 'Emirates'
                        : "City",
                items: myVisitControllerController.districtRespModel?.output
                        ?.map((e) => e.distname ?? '')
                        .toList() ??
                    [],
                hint: '',
                isRequired: true,
                senValue: (value) async {
                  if (!controller.hasInternetVisit) {
                    _showOfflineAlert();
                    return;
                  }

                  controller.selectedDist = value;

                  DistrictOutput? selectedDistObj = myVisitControllerController
                      .districtRespModel?.output
                      ?.firstWhere((e) => e.distname == value);

                  setState(() => isActionLoading = true);
                  try {
                    await controller.getCustomerList(
                        selectedDistObj!.distlgdcode.toString());
                  } finally {
                    if (mounted) setState(() => isActionLoading = false);
                  }

                  controller.update();
                },
                filledColor: AppColor.white,
                prefixIcon: Icon(
                  Icons.location_on_outlined,
                  color: AppColor.secondaryColor,
                ),
              ),
              Visibility(
                visible: controller.selectedDist != null,
                child: CustomTextField(
                  autofocus: false,
                  txtController: controller.searchController,
                  onChanged: (value) {
                    isResultFound = filterSearchResults(value);
                  },
                  labelText: 'Search Customer Name',
                  hintText: 'Search',
                  isRequired: false,
                  keyBoardType: TextInputType.text,
                  fillColor: AppColor.white,
                  isReadOnly: false,
                  maxLines: 1,
                  fontSize: 16,
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColor.secondaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (isActionLoading)
                Expanded(child: _buildListSkeleton())
              else if (controller.filteredCustomerList.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.filteredCustomerList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (!controller.hasInternetVisit) {
                            _showOfflineAlert();
                            return;
                          }

                          if (controller.checkRouteFlagModel?.message ==
                                  "Start Route Flag Not Availaible" ||
                              (controller.todayStr != null &&
                                  controller.checkRouteFlagModel!.output!.first
                                          .createdDate !=
                                      controller.todayStr)) {
                            CustomPopup.takeConfirmationDialog(() {
                              Get.back();
                            }, () async {
                              Get.back();
                            }, "It is mandatory to 'Start Route'from starting point before add visit",
                                'assets/destination.png', "Ok", 160);
                          } else {
                            Get.toNamed(AddVisitPunchOutScreen.routeName,
                                arguments:
                                    controller.filteredCustomerList[index]);
                          }
                        },
                        child: LocationCard(
                          locationDate: controller.filteredCustomerList[index],
                        ).paddingSymmetric(vertical: 6, horizontal: 6),
                      );
                    },
                  ),
                )
              else if (controller.selectedDist == null)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/district.png'),
                      const SizedBox(height: 20),
                      FlavorConfig.instance.name == 'Lifenity International'
                          ? CustomText(
                              text:
                                  "Select emirates to view\nthe customers lists.",
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              textColor: AppColor.black,
                              textAlign: TextAlign.center,
                              fontFam: "Nunito Sans")
                          : CustomText(
                              text: "Select City to view\nthe customers lists.",
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              textColor: AppColor.black,
                              textAlign: TextAlign.center,
                              fontFam: "Nunito Sans"),
                    ],
                  ),
                )
              else
                Expanded(
                  child: Center(
                    child: CustomText(
                        text: "No customers found",
                        fontSize: 16,
                        fontFam: "Nunito Sans",
                        fontWeight: FontWeight.normal,
                        textColor: AppColor.black.withValues(alpha: 0.5),
                        textAlign: TextAlign.center),
                  ),
                ),
            ],
          ).paddingSymmetric(vertical: 4, horizontal: 10),
        ),
      ],
    );
  }

  Widget _buildSkeletonContent() {
    return Shimmer(
      colorOpacity: 0.6,
      duration: const Duration(seconds: 2),
      direction: const ShimmerDirection.fromLeftToRight(),
      child: Column(
        children: [
          _skeletonField(),
          for (int i = 0; i < 6; i++)
            _skeletonBox(
              height: 56,
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              radius: 12,
            ),
        ],
      ).paddingSymmetric(vertical: 4, horizontal: 10),
    );
  }

  Widget _buildListSkeleton() {
    return Shimmer(
      colorOpacity: 0.6,
      duration: const Duration(seconds: 2),
      direction: const ShimmerDirection.fromLeftToRight(),
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) => _skeletonBox(
          height: 56,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
          radius: 12,
        ),
      ),
    );
  }

  Widget _skeletonField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _skeletonBox(
              height: 14, width: 100, margin: const EdgeInsets.only(bottom: 8)),
          _skeletonBox(height: 48),
        ],
      ),
    );
  }

  Widget _skeletonBox({
    required double height,
    double? width,
    EdgeInsets margin = EdgeInsets.zero,
    double radius = 8,
  }) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  Widget _buildOfflineBanner() {
    return Container(
      width: double.infinity,
      color: Colors.orange.shade100,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.wifi_off, color: Colors.orange, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: CustomText(
                text: "No internet connection",
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
                  fontWeight: FontWeight.bold,
                  textColor: AppColor.black,
                  textAlign: TextAlign.start),
            ),
          ],
        ),
      ),
    );
  }

  void _showOfflineAlert() {
    Get.snackbar(
      'No Internet Connection',
      'This action requires an internet connection',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange.shade100,
      colorText: Colors.black87,
      icon: const Icon(Icons.wifi_off, color: Colors.orange),
      duration: const Duration(seconds: 3),
    );
  }
}

class LocationCard extends StatelessWidget {
  final OutputCustomer? locationDate;

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
        text: locationDate?.firstname ?? "",
        fontSize: 16,
        fontWeight: FontWeight.w500,
        textColor: AppColor.black,
        textAlign: TextAlign.start,
        fontFam: 'Nunito Sans',
      ),
    );
  }
}

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_flavor/flutter_flavor.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:marketingapp/add_visit/add_visit_controller.dart';
// import 'package:marketingapp/add_visit/model/customer_list_model.dart';
// import 'package:marketingapp/add_visit/add_visit_punch_out_screen.dart';
// import 'package:marketingapp/dashboard/model/district_list_model.dart';
// import 'package:marketingapp/dashboard/my_visit_controller.dart';
// import 'package:marketingapp/utils/color_constants.dart';
// import 'package:marketingapp/utils/shared_pref_constants.dart';
// import 'package:marketingapp/utils/shared_preference.dart';
// import 'package:marketingapp/widgets/custom_button.dart';
// import 'package:marketingapp/widgets/custom_popup.dart';
// import 'package:marketingapp/widgets/custom_text.dart';
// import 'package:marketingapp/widgets/custom_text_field.dart';
// import 'package:marketingapp/widgets/dropdown_search.dart';
// import 'package:marketingapp/widgets/no_internet_connectivity.dart';
//
// class AddVisitStartRouteScreen extends StatefulWidget {
//   static const routeName = '/add-visit-start';
//   const AddVisitStartRouteScreen({super.key});
//
//   @override
//   State<AddVisitStartRouteScreen> createState() => _AddVisitStartRouteScreenState();
// }
//
// class _AddVisitStartRouteScreenState extends State<AddVisitStartRouteScreen> {
//   final AddVisitController addVisitController = Get.put(AddVisitController());
//   final MyVisitControllerController myVisitControllerController =
//       Get.find<MyVisitControllerController>();
//   Map<String, dynamic>? userData;
//
//   bool isResultFound = false;
//
//   String? todayStr;
//   late VoidCallback _customerListListener;
//
//
//
//   @override
//   void initState() {
//
//
//     super.initState();
//
//     addVisitController.selectedDist = null;
//     addVisitController.filteredCustomerList.clear();
//     addVisitController.customerListModel?.output?.clear();
//     addVisitController.searchController.clear();
//
//     checkInternetAndLoadData();
//
//     _customerListListener = () {
//       if (!mounted) return;
//       if (addVisitController.customerListModel?.output != null) {
//         setState(() {
//           addVisitController.filteredCustomerList =
//               List.from(addVisitController.customerListModel!.output!);
//         });
//       }
//     };
//
//     addVisitController.addListener(_customerListListener);
//   }
//
//   @override
//   void dispose() {
//     addVisitController.removeListener(_customerListListener);
//     super.dispose();
//   }
//
//   Future<void> getUserData() async {
//     // addVisitController.location = Location();
//
//     userData = await SharedPref().read(const SharedPrefConstant().kUserData);
//     DateTime today = DateTime.now();
//     todayStr = "${today.year.toString().padLeft(4, '0')}"
//         "-${today.month.toString().padLeft(2, '0')}"
//         "-${today.day.toString().padLeft(2, '0')}";
//     await addVisitController
//         .getRouteFlag(userData?['output'][0]['EmpCode'].toString());
//
//     await myVisitControllerController
//         .getDistrictList(userData?['output'][0]['STATELGDCODE'].toString());
//     if (myVisitControllerController.latitude == null &&
//         myVisitControllerController.longitude == null) {
//       await fetchLocation();
//
//     }
//     setState(() {});
//   }
//
//   checkInternetAndLoadData() async {
//     final List<ConnectivityResult> connectivityResult =
//         await (Connectivity().checkConnectivity());
//     if (connectivityResult.contains(ConnectivityResult.mobile) ||
//         connectivityResult.contains(ConnectivityResult.wifi)) {
//       addVisitController.hasInternetVisitVisit = true;
//       addVisitController.update();
//     } else {
//       addVisitController.hasInternetVisit = false;
//       addVisitController.update();
//     }
//     if (addVisitController.hasInternetVisit) {
//       getUserData();
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
//   filterSearchResults(String query) {
//     if (query.isEmpty) {
//       addVisitController.filteredCustomerList =
//           List.from(addVisitController.customerListModel!.output!);
//       setState(() {});
//       // addVisitController.update();
//       return false;
//     } else {
//       addVisitController.filteredCustomerList = addVisitController
//           .customerListModel!.output!
//           .where((customer) =>
//               customer.firstname!.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//       setState(() {});
//       // addVisitController.update();
//
//       if (addVisitController.filteredCustomerList.isNotEmpty) {
//         return false;
//       } else {
//         return false;
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<AddVisitController>(
//         init: addVisitController,
//         builder: (controller) {
//           return Scaffold(
//             appBar: AppBar(
//               flexibleSpace: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       FlavorConfig.instance.name == "HindLab Operational"
//                           ? AppColor.primaryBackgroundColor
//                               .withValues(alpha: 0.1)
//                           : AppColor.primaryBackgroundColor
//                               .withValues(alpha: 0.3),
//                       FlavorConfig.instance.name == 'Lifenity Operational'
//                           ? AppColor.white
//                           :   AppColor.secondaryColor.withValues(alpha: 0.3)
//                       // AppColor.primaryBackgroundColor.withValues(alpha: 0.3),
//                       // AppColor.secondaryColor.withValues(alpha: 0.3)
//                     ],
//                     // Change colors as needed
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                   ),
//                 ),
//               ),
//               title: CustomText(
//                 text: 'Add Visit',
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//                 textColor: AppColor.black,
//                 textAlign: TextAlign.start,
//                 fontFam: 'Nunito Sans',
//               ),
//               leading: IconButton(
//                   onPressed: () {
//                     Get.back();
//                   },
//                   icon: const Icon(Icons.arrow_back)),
//               actions: [
//                 if (controller.checkRouteFlagModel?.message ==
//                         "Start Route Flag Not Availaible" ||
//                     (controller.todayStr != null &&
//                         controller.checkRouteFlagModel!.output?.first
//                                 .createdDate !=
//                             controller.todayStr)
//                 )
//                   Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: CustomButton(
//                       buttonText: 'Start Route',
//                       path: 'assets/arrow_nav.svg',
//                       callB: () async {
//                         if (myVisitControllerController.longitude != null &&
//                             myVisitControllerController.latitude != null) {
//                           CustomPopup.takeConfirmationDialog(() {
//                             Get.back();
//                           }, () async {
//                             Get.back();
//
//                             await addVisitController.startRoute(
//                                 userData?['output'][0]['EmpCode'].toString(),
//                                 "1",
//                                 myVisitControllerController.latitude.toString(),
//                                 myVisitControllerController.longitude
//                                     .toString(),
//                                 DateFormat('yyyy-MM-dd').format(DateTime.now()),
//                                 userData!['output'][0]['EmpCode'].toString());
//                             if (addVisitController.startRouteModel!.message ==
//                                 'Start Route Details Save  Successfully') {
//                               CustomPopup.takeConfirmationDialog(() async {
//                                 Get.back();
//                                 await addVisitController.getRouteFlag(
//                                     userData?['output'][0]['EmpCode']
//                                         .toString());
//                               }, () async {
//                                 Get.back();
//                                 await addVisitController.getRouteFlag(
//                                     userData?['output'][0]['EmpCode']
//                                         .toString());
//                                 // Get.to(const VisitDetailsScreen());
//                               },
//                                   addVisitController.startRouteModel!.message ??
//                                       "You can now start your journey\nfor add visit.",
//                                   'assets/destination.png',
//                                   "Ok",
//                                   130);
//                             }
//                           },
//                               "Are you sure you want to Start Route ?",
//                               'assets/destination.png',
//                               "Yes, Start Route",
//                               190);
//                         } else {
//                           await fetchLocation();
//                         }
//                       },
//                       // buttonWidth: 130,
//                       primColor: AppColor.primaryBackgroundColor,
//                       secColor: AppColor.secondaryColor,
//                       textColor: AppColor.white,
//                       iconColor: AppColor.white,
//                       buttonFontSize: 14,
//                       buttonWidth: 140,
//                     ),
//                   )
//               ],
//             ),
//             body: controller.hasInternetVisit
//                 ? Column(
//                     children: [
//                       // MyCustomDropdown(
//                       //   labelText:
//                       //       FlavorConfig.instance.name == 'Lifenity International'
//                       //           ? 'Emirates'
//                       //           : "City",
//                       //   // labelText: "City",
//                       //   selectedItem: controller.selectedDist,
//                       //   prefixIcon: Icon(
//                       //     Icons.location_on_outlined,
//                       //     color: AppColor.secondaryColor,
//                       //   ),
//                       //   items: myVisitControllerController
//                       //           .districtRespModel?.output
//                       //           ?.map((e) => e.distname)
//                       //           .toList() ??
//                       //       [],
//                       //   hint: '',
//                       //   isRequired: true,
//                       //   senValue: (value) async {
//                       //     controller.selectedDist = value;
//                       //
//                       //     DistrictOutput? selectedDistObj =
//                       //         myVisitControllerController
//                       //             .districtRespModel?.output
//                       //             ?.firstWhere((e) => e.distname == value);
//                       //     await controller.getCustomerList(
//                       //         selectedDistObj!.distlgdcode.toString());
//                       //
//                       //     // }
//                       //     controller.update();
//                       //   },
//                       //   filledColor: AppColor.white,
//                       // ),
//                       DropDownSearch(
//                           selectedItem: controller.selectedDist,
//
//                         labelText:  FlavorConfig.instance.name == 'Lifenity International'
//                             ? 'Emirates'
//                             : "City",
//                         items:  myVisitControllerController
//                             .districtRespModel?.output
//                             ?.map((e) => e.distname ?? '')
//                             .toList() ??
//                             [],
//                         hint: '',
//                         isRequired: true,
//                         senValue: (value) async{
//                           controller.selectedDist = value;
//
//                           DistrictOutput? selectedDistObj =
//                           myVisitControllerController
//                               .districtRespModel?.output
//                               ?.firstWhere((e) => e.distname == value);
//                           await controller.getCustomerList(
//                               selectedDistObj!.distlgdcode.toString());
//
//                           // }
//                           controller.update();
//                         },
//                         filledColor: AppColor.white,
//                         prefixIcon: Icon(
//                           Icons.location_on_outlined,
//                           color: AppColor.secondaryColor,
//                         ),
//                       ),
//                       Visibility(
//                         visible: controller.selectedDist != null,
//                         child: CustomTextField(
//                           autofocus: false,
//                           txtController: controller.searchController,
//                           onChanged: (value) {
//                             isResultFound = filterSearchResults(value);
//                           },
//                           labelText: 'Search Customer Name',
//                           hintText: 'Search',
//                           isRequired: false,
//                           keyBoardType: TextInputType.text,
//                           fillColor: AppColor.white,
//                           isReadOnly: false,
//                           maxLines: 1,
//                           fontSize: 16,
//                           prefixIcon: Icon(
//                             Icons.search,
//                             color: AppColor.secondaryColor,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       if (controller.filteredCustomerList.isNotEmpty)
//                         Expanded(
//                           child: ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: controller.filteredCustomerList.length,
//                               itemBuilder: (context, index) {
//                                 return InkWell(
//                                   onTap: () {
//                                     if (controller
//                                                 .checkRouteFlagModel?.message ==
//                                             "Start Route Flag Not Availaible" ||
//                                         (controller.todayStr != null &&
//                                             controller
//                                                     .checkRouteFlagModel!
//                                                     .output!
//                                                     .first
//                                                     .createdDate !=
//                                                 controller.todayStr)) {
//                                       CustomPopup.takeConfirmationDialog(() {
//                                         Get.back();
//                                       }, () async {
//                                         Get.back();
//                                       }, "It is mandatory to 'Start Route'from starting point before add visit",
//                                           'assets/destination.png', "Ok", 160);
//                                     } else {
//                                       Get.toNamed(AddVisitPunchOutScreen.routeName, arguments: controller.filteredCustomerList[index]);
//                                       // Get.to(AddVisitPunchOutScreen(
//                                       //   hospitalDetails: controller
//                                       //       .filteredCustomerList[index],
//                                       // ));
//                                     }
//                                   },
//                                   child: LocationCard(
//                                     locationDate:
//                                         controller.filteredCustomerList[index],
//                                   ).paddingSymmetric(
//                                       vertical: 6, horizontal: 6),
//                                 );
//                               }),
//                         )
//                       else if (controller.selectedDist == null)
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Image.asset('assets/district.png'),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             FlavorConfig.instance.name == 'Lifenity International'
//                                 ? CustomText(
//                                     text:
//                                         "Select emirates to view\nthe customers lists.",
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     textColor: AppColor.black,
//                                     textAlign: TextAlign.center,
//                                     fontFam: "Nunito Sans")
//                                 : CustomText(
//                                     text:
//                                         "Select City to view\nthe customers lists.",
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     textColor: AppColor.black,
//                                     textAlign: TextAlign.center,
//                                     fontFam: "Nunito Sans"),
//                             // const SizedBox(
//                             //   height: 20,
//                             // ),
//                             // CustomButton(
//                             //   primColor: AppColor.primaryBackgroundColor,
//                             //   secColor: AppColor.secondaryColor,
//                             //   buttonText: "Ok",
//                             //   path: 'assets/arrow_nav.png',
//                             //   callB: () {
//                             //     // yesCallB();
//                             //   },
//                             //   textColor: Colors.white,
//                             //   iconColor: Colors.white,
//                             //   buttonFontSize: 16,
//                             //   buttonWidth: 70,
//                             // )
//                           ],
//                         ).paddingOnly(top: 60)
//                       // else if (isResultFound == false)
//                       //   const DataNotFound()
//                     ],
//                   ).paddingSymmetric(vertical: 4, horizontal: 10)
//                 : InternetIssue(
//                     onRetryPressed: () {
//                       checkInternetAndLoadData();
//                     },
//                   ),
//           );
//         });
//   }
// }
//
// class LocationCard extends StatelessWidget {
//   final OutputCustomer? locationDate;
//
//   const LocationCard({super.key, this.locationDate});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(10.0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: AppColor.borderGrey),
//         color: AppColor.primaryBackgroundColor.withValues(alpha: 0.1),
//       ),
//       child: CustomText(
//         text: locationDate?.firstname ?? "",
//         fontSize: 16,
//         fontWeight: FontWeight.w500,
//         textColor: AppColor.black,
//         textAlign: TextAlign.start,
//         fontFam: 'Nunito Sans',
//       ),
//     );
//   }
// }
