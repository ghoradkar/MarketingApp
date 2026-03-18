import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'package:marketingapp/dashboard/model/dash_count_model.dart';
import 'package:marketingapp/dashboard/model/district_list_model.dart';
import 'package:marketingapp/utils/api_urls.dart';
import 'package:marketingapp/utils/network_call.dart';
import 'package:marketingapp/widgets/cust_toast.dart';

class MyVisitControllerController extends GetxController {
  // bool isLoading = false;
  String? status;
  IOClient ioClient = IOClient(ByPassCert().httpClient);
  DistrictListModel? districtRespModel;
  DashCountModel? dashCountModel;
  DashCountModel? monthlyBTarget;
  bool hasInternet = true;

  String? locationMessage;

  double? latitude;

  double? longitude;

  String? fullAddress;

  // getDistrictList(String? stateCode) async {
  //   // isLoading = true;
  //   // update();
  //   CustomMessage.showLoader();
  //
  //   final uri = Uri.parse(
  //       "${ApiConstants.baseUrl}${ApiConstants.districtList}?STATELGDCODE=$stateCode");
  //
  //   debugPrint(uri.path);
  //
  //   final response = await ioClient.get(uri);
  //   debugPrint(response.statusCode.toString());
  //   debugPrint("response.body : ${response.body}");
  //
  //   if (response.statusCode == 200) {
  //     CustomMessage.hideLoader();
  //
  //     //getDeviceDetails
  //     final data = json.decode(response.body);
  //     if (data['status'] == 'Success') {
  //       districtRespModel = DistrictListModel.fromJson(data);
  //
  //       status = data['message'];
  //     } else {
  //       status = data['message'];
  //       CustomMessage.hideLoader();
  //     }
  //   }
  //   update();
  // }

  Future<void> getDistrictList(String? stateCode) async {
    CustomMessage.showLoader();
    try {
      final uri = Uri.parse(
          "${ApiConstants.baseUrl}${ApiConstants.districtList}?STATELGDCODE=$stateCode");

      debugPrint(uri.path);

      final response = await ioClient
          .get(uri)
          .timeout(const Duration(seconds: 10)); // 10-second timeout

      debugPrint(response.statusCode.toString());
      debugPrint("response.body : ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'Success') {
          districtRespModel = DistrictListModel.fromJson(data);
          status = data['message'];
        } else {
          status = data['message'];
          CustomMessage.toast(status);
        }
      } else {
        CustomMessage.toast("Something went wrong. Please try again.");
      }
    } on TimeoutException {
      CustomMessage.toast(
          "Request timed out. Please check your internet connection.");
    } catch (e) {
      CustomMessage.toast(
          "Unable to fetch district list. Please try again later.");
      debugPrint("getDistrictList error: $e");
    } finally {
      CustomMessage.hideLoader();
      update();
    }
  }

  // getDashCount(String distCode, String userId, String flavour) async {
  //   CustomMessage.showLoader();
  //
  //   final uri = Uri.parse(
  //       "${ApiConstants.baseUrl1}${ApiConstants.dashCount}?DISTLGDCODE=$distCode&USERID=$userId");
  //
  //   debugPrint(uri.path);
  //
  //   final response = await ioClient.get(uri);
  //   debugPrint(response.statusCode.toString());
  //   debugPrint("response.body : ${response.body}");
  //
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     if (data['status'] == 'Success') {
  //       dashCountModel = DashCountModel.fromJson(data);
  //
  //       status = data['message'];
  //       CustomMessage.hideLoader();
  //     } else {
  //       dashCountModel = null;
  //       status = data['message'];
  //       CustomMessage.hideLoader();
  //       CustomMessage.toast(status);
  //     }
  //   }
  //   update();
  // }

  Future<void> getDashCount(
      String distCode, String userId, String flavour) async {
    CustomMessage.showLoader();
    try {
      final uri = Uri.parse(
          "${ApiConstants.baseUrl1}${ApiConstants.dashCount}?DISTLGDCODE=$distCode&USERID=$userId");

      debugPrint(uri.path);

      final response = await ioClient
          .get(uri)
          .timeout(const Duration(seconds: 10)); // 10-second timeout

      debugPrint(response.statusCode.toString());
      debugPrint("response.body : ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'Success') {
          dashCountModel = DashCountModel.fromJson(data);
          status = data['message'];
        } else {
          dashCountModel = null;
          status = data['message'];
          CustomMessage.toast(status);
        }
      } else {
        CustomMessage.toast("Something went wrong. Please try again.");
      }
    } on TimeoutException {
      CustomMessage.toast(
          "Request timed out. Please check your internet connection.");
    } catch (e) {
      CustomMessage.toast("Unable to fetch data. Please try again later.");
      debugPrint("getDashCount error: $e");
    } finally {
      CustomMessage.hideLoader();
      update();
    }
  }

  Future<void> getMonthlyTarget(String distCode, String userId) async {
    CustomMessage.showLoader();
    try {
      final uri = Uri.parse(
          "${ApiConstants.baseUrl1}${ApiConstants.monthlyBusinessTarget}?DISTLGDCODE=$distCode&USERID=$userId");

      debugPrint(uri.path);

      final response = await ioClient
          .get(uri)
          .timeout(const Duration(seconds: 10)); // 10-second timeout

      debugPrint(response.statusCode.toString());
      debugPrint("response.body : ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'Success') {
          monthlyBTarget = DashCountModel.fromJson(data);
          status = data['message'];
          CustomMessage.toast(status);
        } else {
          monthlyBTarget = null;
          status = data['message'];
          CustomMessage.toast(status);
        }
      } else {
        CustomMessage.toast("Something went wrong. Please try again.");
      }
    } on TimeoutException {
      CustomMessage.toast(
          "Request timed out. Please check your internet connection.");
    } catch (e) {
      CustomMessage.toast("Unable to fetch data. Please try again later.");
      debugPrint("getMonthlyTarget error: $e");
    } finally {
      CustomMessage.hideLoader();
      update();
    }
  }

  // getMonthlyTarget(String distCode, String userId) async {
  //   CustomMessage.showLoader();
  //
  //   final uri = Uri.parse(
  //       "${ApiConstants.baseUrl1}${ApiConstants.monthlyBusinessTarget}?DISTLGDCODE=$distCode&USERID=$userId");
  //
  //   debugPrint(uri.path);
  //
  //   final response = await ioClient.get(uri);
  //   debugPrint(response.statusCode.toString());
  //   debugPrint("response.body : ${response.body}");
  //
  //   if (response.statusCode == 200) {
  //     //getDeviceDetails
  //     final data = json.decode(response.body);
  //     if (data['status'] == 'Success') {
  //       monthlyBTarget = DashCountModel.fromJson(data);
  //
  //       status = data['message'];
  //       CustomMessage.toast(status);
  //       CustomMessage.hideLoader();
  //     } else {
  //       monthlyBTarget = null;
  //       status = data['message'];
  //       CustomMessage.toast(status);
  //       CustomMessage.hideLoader();
  //     }
  //   }
  //   update();
  // }

  Future<void> getLocation() async {
    try {
      // First check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (LocationEnableDialog.isDialogShowing) {
          Get.back();
        }
        // Show custom dialog explaining need to enable location first
        bool? wantsToEnable = await showEnableLocationDialog();
        if (wantsToEnable == true) {
          await Geolocator.openLocationSettings();
        }
        return;
      }

      //  Now check permissions (will show system dialog if needed)
      await _checkAndRequestLocationPermission();

      //  Get location if everything is enabled
      await _fetchCurrentLocation();
    } catch (e) {
      _handleLocationError(e);
    } finally {
      CustomMessage.hideLoader();
      update();
    }
  }

  Future<bool?> showEnableLocationDialog() {
    LocationEnableDialog.isDialogShowing = true;
    var result = showDialog<bool>(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => LocationEnableDialog(),
    );
    LocationEnableDialog.isDialogShowing = false;
    return result;
  }

  Future<bool?> _showPermanentDenialDialog() {
    return showDialog<bool>(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Location Denied"),
        content: const Text("Location permission permanently denied"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  Future<void> _checkAndRequestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await _showPermanentDenialDialog();
      throw Exception("Location permission permanently denied");
    }
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      CustomMessage.showLoader();

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude = position.latitude;
      longitude = position.longitude;

      // attempt reverse geocoding with timeout
      try {
        List<geo.Placemark> placemarks = await geo
            .placemarkFromCoordinates(
              latitude!,
              longitude!,
            )
            .timeout(const Duration(seconds: 5));

        if (placemarks.isNotEmpty) {
          final geo.Placemark place = placemarks.first;

          locationMessage = [
            place.name,
            place.subThoroughfare,
            place.thoroughfare,
            place.subLocality,
            place.locality,
            place.postalCode,
            place.administrativeArea,
            place.country
          ].where((e) => e != null && e.isNotEmpty).join(", ");
        } else {
          locationMessage =
              "Could not determine address. Please check your internet and try again.";
          Get.snackbar(
            "Address not found",
            "We couldn't get your address. Please check your connection.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
          );
        }
      } on TimeoutException {
        locationMessage = "Internet seems slow. Showing coordinates instead.";
        Get.snackbar(
          "Slow connection",
          "Could not fetch address in time. Please check your network speed.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      } catch (e) {
        locationMessage =
            "Could not get address details. Please verify internet connectivity.";
        Get.snackbar(
          "Location error",
          "There was a problem getting your address. Please check your internet and try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }

      // fallback to coordinates if address missing
      if (locationMessage == null || locationMessage!.isEmpty) {
        locationMessage = "Lat: $latitude, Lng: $longitude";
      }

      debugPrint('Latitude: $latitude, Longitude: $longitude');
      debugPrint('Address or fallback: $locationMessage');
    } catch (e) {
      locationMessage =
          "Unable to get location. Please enable location permissions and check your network.";
      Get.snackbar(
        "Location Error",
        locationMessage!,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      debugPrint('Location exception: $e');
    } finally {
      CustomMessage.hideLoader();
      update();
    }
  }

  void _handleLocationError(dynamic e) {
    locationMessage = "Location error: ${e.toString()}";
    Get.snackbar(
      "Error",
      locationMessage!,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  // Future<void> _fetchCurrentLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );
  //
  //   // Store coordinates
  //   latitude = position.latitude;
  //   longitude = position.longitude;
  //
  //   // Reverse geocoding to get address
  //   List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
  //     latitude!,
  //     longitude!,
  //   );
  //
  //   if (placemarks.isNotEmpty) {
  //     final geo.Placemark place = placemarks.first;
  //     List<String?> locationParts = [
  //       place.name,
  //       place.subThoroughfare,
  //       place.thoroughfare,
  //       place.subLocality,
  //       place.locality,
  //       place.postalCode,
  //       place.administrativeArea,
  //       place.country
  //     ];
  //
  //     locationMessage = locationParts
  //         .where((part) => part != null && part.isNotEmpty)
  //         .join(", ");
  //
  //     debugPrint('Latitude: $latitude, Longitude: $longitude');
  //     debugPrint('Full Address: $locationMessage');
  //   } else {
  //     locationMessage = "Could not fetch location name.";
  //     Get.snackbar(
  //       "Fail",
  //       locationMessage ?? "Could not fetch location name.",
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //       duration: const Duration(seconds: 3),
  //     );
  //   }
  // }
  int getSumCount(List<Output>? outputs, String fieldName) {
    if (outputs == null || outputs.isEmpty) return 0;
    int sum = 0;
    for (var output in outputs) {
      switch (fieldName) {
        case 'todaysVisit':
          sum += output.todaysVisit ?? 0;
          break;
        case 'totalVisit':
          sum += output.totalVisit ?? 0;
          break;
        case 'prospectiveClient':
          sum += output.prospectiveClient ?? 0;
          break;
        case 'activeClient':
          sum += output.activeClient ?? 0;
          break;
        case 'inActiveClient':
          sum += output.inActiveClient ?? 0;
          break;
        case 'closedClient':
          sum += output.closedClient ?? 0;
          break;
      }
    }
    return sum;
  }

  double getSumDouble(List<Output>? outputs, String fieldName) {
    if (outputs == null || outputs.isEmpty) return 0;
    double sum = 0;
    for (var output in outputs) {
      switch (fieldName) {
        case 'salesTarget':
          sum += output.salesTarget ?? 0;
          break;
        case 'invoiceAmount':
          sum += output.invoiceAmount ?? 0;
          break;
        default:
          sum += 0;
      }
    }
    return sum;
  }
}

class LocationEnableDialog extends StatelessWidget {
  static bool isDialogShowing = false;

  const LocationEnableDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Location Required"),
      content: const Text("Please enable your device's location services first."
          "It is mandatory for punch in and punch out"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text("Enable Location"),
        ),
      ],
    );
  }
}
