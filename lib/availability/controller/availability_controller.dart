import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:marketingapp/availability/model/saved_availabilty.dart';
import 'package:marketingapp/utils/api_urls.dart';
import 'package:marketingapp/utils/network_call.dart';
import 'package:marketingapp/widgets/cust_toast.dart';

class AvailabilityController extends GetxController {
  bool hasInternet = true;
  IOClient ioClient = IOClient(ByPassCert().httpClient);
  String? status;

  List<DateTime> savedDates = [];

  SavedAvailabilty? getAvailabilityData;

  SavedAvailabilty? savedAvailabilty;

  getAvailability(String USERID, String Year, String Month) async {
    CustomMessage.showLoader();
    final uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.availability}?USERID=$USERID&Year=$Year&Month=$Month");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      savedDates.clear();

      CustomMessage.hideLoader();

      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        getAvailabilityData = SavedAvailabilty.fromJson(data);
        for (AvailabilityOutput item in getAvailabilityData?.output ?? []) {
          savedDates.add(DateTime(item.year!, item.month!, item.day!));
        }
        status = getAvailabilityData?.message ?? "";
        CustomMessage.toast(status);
        return true;
      } else {
        status = data['message'];
        CustomMessage.toast(status);

        CustomMessage.hideLoader();
      }
    }
    update();
  }

  saveAvailability(String EmpCode, String LATITUDE, String LONGITUDE,
      String ATTENDANCEMARKBY, year, month) async {
    CustomMessage.showLoader();

    final uri =
        Uri.parse("${ApiConstants.baseUrl}${ApiConstants.saveAvailability}");

    debugPrint(uri.path);

    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request('POST', uri);
    request.bodyFields = {
      'EmpCode': EmpCode,
      'LATITUDE': LATITUDE,
      'LONGITUDE': LONGITUDE,
      'ATTENDANCEMARKBY': ATTENDANCEMARKBY
    };

    request.headers.addAll(headers);
    var response = await ioClient.send(request);

    debugPrint(response.statusCode.toString());

    if (response.statusCode == 200) {
      CustomMessage.hideLoader();

      final data = json.decode(await response.stream.bytesToString());
      if (data['status'] == 'Success') {
        savedAvailabilty = SavedAvailabilty.fromJson(data);

        CustomMessage.toast(savedAvailabilty?.message ?? "");
        bool isTrue = await getAvailability(
          EmpCode,
          year,
          month,
        );
        if (isTrue) {
          Get.back();
        }
        update();
      } else {
        status = data['message'];
        // isLoading = false;
        CustomMessage.hideLoader();

        CustomMessage.toast("You Have already marked your availability");
      }
    }
    update();
  }
}
