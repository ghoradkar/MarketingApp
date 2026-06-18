import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marketingapp/availability/availability_controller.dart';
import 'package:marketingapp/dashboard/my_visit_controller.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/utils/shared_pref_constants.dart';
import 'package:marketingapp/utils/shared_preference.dart';
import 'package:marketingapp/widgets/custom_text.dart';
import 'package:marketingapp/widgets/no_internet_connectivity.dart';
import 'package:table_calendar/table_calendar.dart';

class AvailabilityScreen extends StatefulWidget {
  const AvailabilityScreen({super.key});

  @override
  AvailabilityScreenState createState() => AvailabilityScreenState();
}

class AvailabilityScreenState extends State<AvailabilityScreen>
    with WidgetsBindingObserver {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;

  // Dynamically calculate first and last dates
  DateTime get firstDay =>
      DateTime.now().subtract(const Duration(days: 365 * 10)); // 10 years ago
  DateTime get lastDay => DateTime.now()
      .add(const Duration(days: 365 * 10)); // 10 years in the future

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition? _kGooglePlex;

  final MyVisitControllerController myVisitControllerController =
      Get.find<MyVisitControllerController>();

  final AvailabilityController availabilityController =
      Get.put(AvailabilityController());
  Timer? _debounceTimer;

  var userData;

  @override
  void initState() {
    // TODO: implement initState
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
          myVisitControllerController.update(); // Force UI refresh
          _kGooglePlex = CameraPosition(
            target: LatLng(myVisitControllerController.latitude!,
                myVisitControllerController.longitude!),
            zoom: 14.4746,
          );
          setState(() {}); // If using StatefulWidget
        } else {
          debugPrint("Failed to get location after resume");
        }
      });
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel(); // Always dispose timers
    super.dispose();
  }

  Future<void> getUserData() async {
    userData = await SharedPref().read(const SharedPrefConstant().kUserData);
    await fetchLocation();

    DateTime now = DateTime.now();
    int currentYear = now.year;
    int currentMonth = now.month;
    await availabilityController.getAvailability(
        userData['output'][0]['EmpCode'].toString(),
        currentYear.toString(),
        currentMonth.toString());

    if (myVisitControllerController.latitude != null) {
      _kGooglePlex = CameraPosition(
        target: LatLng(myVisitControllerController.latitude!,
            myVisitControllerController.longitude!),
        zoom: 14.4746,
      );
    }

    setState(() {});
  }

  checkInternetAndLoadData() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      myVisitControllerController.hasInternet = true;
    } else {
      myVisitControllerController.hasInternet = false;
    }
    myVisitControllerController.update();
    if (myVisitControllerController.hasInternet) {
      await getUserData();
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
                  AppColor.secondaryColor.withValues(alpha: 0.3)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          title: CustomText(
            text: "Availability",
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
      body: GetBuilder<AvailabilityController>(
          init: availabilityController,
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
                        child: TableCalendar(
                          firstDay: firstDay,
                          lastDay: lastDay,
                          focusedDay: _focusedDay,
                          calendarFormat: _calendarFormat,
                          enabledDayPredicate: (date) {
                            return isSameDay(date, DateTime.now());
                          },
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDate, day);
                          },
                          onDaySelected: (selectedDay, focusedDay) async {
                            setState(() {
                              _selectedDate = selectedDay;
                              _focusedDay = focusedDay;
                            });

                            DateTime now = DateTime.now();
                            int currentYear = now.year;
                            int currentMonth = now.month;

                            if (myVisitControllerController.longitude != null &&
                                myVisitControllerController.latitude != null) {
                              await availabilityController.saveAvailability(
                                  userData['output'][0]['EmpCode'].toString(),
                                  myVisitControllerController.latitude
                                      .toString(),
                                  myVisitControllerController.longitude
                                      .toString(),
                                  userData['output'][0]['EmpCode'].toString(),
                                  currentYear.toString(),
                                  currentMonth.toString());
                            } else {
                              await fetchLocation();
                            }
                          },
                          onFormatChanged: (format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          },
                          onPageChanged: (focusedDay) {
                            setState(() {
                              _focusedDay = focusedDay;
                            });
                          },
                          calendarStyle: CalendarStyle(
                            selectedDecoration: BoxDecoration(
                              color: AppColor.secondaryColor,
                              shape: BoxShape.circle,
                            ),
                            defaultTextStyle:
                                const TextStyle(color: Colors.black),
                            outsideTextStyle:
                                const TextStyle(color: Colors.grey),
                          ),
                          calendarBuilders: CalendarBuilders(
                            todayBuilder: (context, date, _) {
                              bool isSaved = availabilityController.savedDates
                                  .any((savedDate) =>
                                      isSameDay(savedDate, date));

                              if (isSaved) {
                                return Container(
                                  margin: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${date.day}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Display Selected Date
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: locationLatLong(
                                true,
                                myVisitControllerController.latitude != null
                                    ? myVisitControllerController.latitude
                                        .toString()
                                    : "-",
                                "Latitude",
                              ),
                            ),
                            Container(
                              height: 68,
                              width: 1,
                              color: AppColor.secondaryColor,
                            ).paddingSymmetric(horizontal: 6),
                            Flexible(
                              child: locationLatLong(
                                false,
                                myVisitControllerController.longitude != null
                                    ? myVisitControllerController.longitude
                                        .toString()
                                    : "-",
                                "Longitude",
                              ),
                            ),
                          ],
                        ),
                      ),

                      _kGooglePlex == null
                          ? const SizedBox.shrink()
                          : Expanded(
                              child: Container(
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
                                child: GoogleMap(
                                    myLocationEnabled: true,
                                    initialCameraPosition: _kGooglePlex!,
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                      _controller.complete(controller);
                                    },
                                    markers: <Marker>{
                                      const Marker(
                                        markerId: MarkerId('current_location'),
                                        position: LatLng(37.43296265331129,
                                            -122.08832357078792),
                                        infoWindow:
                                            InfoWindow(title: 'Your Location'),
                                      ),
                                    }),
                              ).paddingSymmetric(vertical: 10, horizontal: 6),
                            )
                    ],
                  ).paddingSymmetric(horizontal: 8)
                : InternetIssue(
                    onRetryPressed: () {
                      checkInternetAndLoadData();
                    },
                  );
          }),
    );
  }

  DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Widget locationLatLong(bool isVisible, String latLong, String isLatOrLong) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.location_on_outlined,
            color: AppColor.primaryBackgroundColor),
        const SizedBox(width: 8), // Adds spacing between icon and text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Prevents unnecessary space
            children: [
              CustomText(
                text: "Current $isLatOrLong",
                fontSize: 14,
                // Reduced slightly for better adaptability
                fontWeight: FontWeight.normal,
                textColor: AppColor.black,
                textAlign: TextAlign.left,
                fontFam: 'Nunito Sans',
              ),
              CustomText(
                text: latLong,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                textColor: AppColor.black,
                textAlign: TextAlign.left,
                fontFam: 'Nunito Sans',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
