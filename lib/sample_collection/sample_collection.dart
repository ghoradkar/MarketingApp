import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marketingapp/dashboard/my_visit_controller.dart';
import 'package:marketingapp/sample_collection_tracking/sample_collection_tracking_controller.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/utils/shared_pref_constants.dart';
import 'package:marketingapp/utils/shared_preference.dart';
import 'package:marketingapp/widgets/custom_text.dart';
import 'package:marketingapp/widgets/no_internet_connectivity.dart';

class SampleCollection extends StatefulWidget {
  final String userId;
  final String uDate;
  final String labCode;
  final String routeId;

  const SampleCollection(
      {super.key,
      required this.userId,
      required this.uDate,
      required this.labCode,
      required this.routeId});

  @override
  State<SampleCollection> createState() => SampleCollectionState();
}

class SampleCollectionState extends State<SampleCollection>
    with WidgetsBindingObserver {
  final SampleCollectionTrackingController sampleCollectionTrackingController =
      Get.find();

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Timer? _debounceTimer;

  Set<Marker> markers = {};

  var userData;

  final MyVisitControllerController myVisitControllerController =
      Get.put(MyVisitControllerController());

  void addMarkers() async {

    markers.clear();

    final points = sampleCollectionTrackingController
        .googleMapPointSampleCollected?.output;

    if (points == null || points.isEmpty) return;

    bool cameraMoved = false;

    for (int i = 0; i < points.length; i++) {
      final point = points[i];

      double? lat = double.tryParse(point.latitude);
      double? long = double.tryParse(point.longitude);

      if (lat == null || long == null) continue;

      double pointColor = BitmapDescriptor.hueRed;
      String markerTitle = 'Location';

      switch (point.mapFlag) {
        case 0:
          pointColor = BitmapDescriptor.hueBlue;
          markerTitle = 'Start Route';
          break;
        case 1:
          pointColor = BitmapDescriptor.hueGreen;
          markerTitle = 'Sample Collected';
          break;
        case 2:
          pointColor = BitmapDescriptor.hueYellow;
          markerTitle = 'End Point';
          break;
        default:
          markerTitle = 'Other';
      }

      final marker = Marker(
        markerId: MarkerId('marker_$i'),
        position: LatLng(lat, long),
        infoWindow: InfoWindow(title: markerTitle),
        icon: BitmapDescriptor.defaultMarkerWithHue(pointColor),
      );

      markers.add(marker);

      // Move camera to the first marker
      if (!cameraMoved) {
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(lat, long), zoom: 15),
          ),
        );
        cameraMoved = true;
      }
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

  @override
  void initState() {
    checkInternetAndLoadData();
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  Future<void> getUserData() async {
    userData = await SharedPref().read(const SharedPrefConstant().kUserData);
    await sampleCollectionTrackingController.getLatLongSampleCollection(
        widget.userId, widget.uDate, widget.labCode, widget.routeId);
    if (myVisitControllerController.latitude != null &&
        myVisitControllerController.longitude != null) {
      addMarkers();
    } else {
      fetchLocation();
    }

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
  void dispose() {
    _debounceTimer?.cancel();

    super.dispose();
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
          checkInternetAndLoadData();
          setState(() {}); // If using StatefulWidget
        } else {
          debugPrint("Failed to get location after resume");
        }
      });
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          sampleIndicator(Colors.green, "Start Route")
                              .paddingSymmetric(vertical: 4, horizontal: 4),
                          sampleIndicator(Colors.blue, "Sample Collected")
                              .paddingSymmetric(vertical: 4, horizontal: 4),
                          sampleIndicator(Colors.yellow, "End Point")
                              .paddingSymmetric(vertical: 4, horizontal: 4),
                        ],
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: GoogleMap(
                            myLocationEnabled: true,
                            // mapType: MapType.hybrid,
                            initialCameraPosition: const CameraPosition(
                              target: LatLng(18.5204, 73.8567),
                              zoom: 12,
                            ),
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                            markers: markers,
                          ).paddingOnly(left: 12, right: 12, top: 4, bottom: 8),
                        ),
                      ),
                    ],
                  )
                : InternetIssue(
                    onRetryPressed: () {
                      checkInternetAndLoadData();
                    },
                  ),
          );
        });
  }

  Widget sampleIndicator(Color indicatorColor, String name) {
    return Row(
      children: [
        Container(
          height: 15,
          width: 15,
          decoration: BoxDecoration(
              color: indicatorColor, borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(
          width: 4,
        ),
        CustomText(
            text: name,
            fontSize: 16,
            fontWeight: FontWeight.normal,
            textColor: AppColor.black,
            textAlign: TextAlign.start,
            fontFam: "Nunito Sans")
      ],
    );
  }
}
