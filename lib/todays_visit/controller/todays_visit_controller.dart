import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'package:marketingapp/todays_visit/model/customer_visit_details.dart';
import 'package:marketingapp/todays_visit/model/todays_visit_detail_model.dart';
import 'package:marketingapp/todays_visit/model/todays_visit_model.dart';
import 'package:marketingapp/todays_visit/model/todays_visit_route_model.dart';
import 'package:marketingapp/utils/api_urls.dart';
import 'package:marketingapp/utils/network_call.dart';
import 'package:marketingapp/widgets/cust_toast.dart';

class TodaysVisitController extends GetxController {
  DateTime? selectedFromDate;
  String? formattedFromDate;
  TextEditingController dateController = TextEditingController();
  bool isCustomCalender = false;

  DateTime? selectedFromDate1;
  String? formattedFromDate1;
  TextEditingController dateController1 = TextEditingController();
  bool isCustomCalender1 = false;

  // bool isLoading = false;
  IOClient ioClient = IOClient(ByPassCert().httpClient);

  List<TodaysVisitOutput>? todaysVisitList;
  List<TodaysVisitRouteOutput>? todaysVisitRoute;
  List<OutputCustDet>? todaysVisitCustDet;
  List<TodaysVisitDetOutput>? todaysVisitDetList;

  String? status;

  bool hasInternet = true;

  getTodaysVisitList(
      String distlgdCode, String visitDate, String userID) async {
    CustomMessage.showLoader();

    final uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.todaysVisitListManager}?DISTLGDCODE=$distlgdCode&VisitDate=$visitDate&UserID=$userID");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      // isLoading = false;
      CustomMessage.hideLoader();

      //getDeviceDetails
      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        TodaysVisitModel todaysVisitModel = TodaysVisitModel.fromJson(data);
        todaysVisitList = todaysVisitModel.output;
        status = data['message'];
        CustomMessage.toast(status);
      } else {
        todaysVisitList = null;
        status = data['message'];
        // isLoading = false;
        CustomMessage.toast(status);

        CustomMessage.hideLoader();
      }
    }
    update();
  }

  getTodaysVisitRouteTime(String visitDate, String userID) async {
    CustomMessage.showLoader();

    final uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.todaysVisitRouteTime}?VisitDate=$visitDate&UserID=$userID");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      CustomMessage.hideLoader();

      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        TodaysVisitRouteTime todaysVisitModel =
            TodaysVisitRouteTime.fromJson(data);
        todaysVisitRoute = todaysVisitModel.output;
        status = data['message'];
        update();
      } else {
        todaysVisitRoute = null;
        status = data['message'];
        CustomMessage.hideLoader();
      }
    }
    update();
  }

  getTodaysVisitDetList(String visitDate, String userID) async {
    CustomMessage.showLoader();

    final uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.todaysVisitDetailsList}?VisitDate=$visitDate&UserID=$userID");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      CustomMessage.hideLoader();

      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        TodaysVisitDetailModel todaysVisitModel =
            TodaysVisitDetailModel.fromJson(data);
        todaysVisitDetList = todaysVisitModel.output;
        status = data['message'];
      } else {
        todaysVisitDetList = null;
        status = data['message'];
        // isLoading = false;
        CustomMessage.hideLoader();
      }
    }
    update();
  }

  getCustomerVisitDet(String visitID, String cusVisitDate) async {
    CustomMessage.showLoader();

    final uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.todaysVisitCustomerDet}?VisitID=$visitID&CusVisitDate=$cusVisitDate");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      CustomMessage.hideLoader();

      //getDeviceDetails
      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        CustomerVisitDetails todaysVisitModel =
            CustomerVisitDetails.fromJson(data);
        todaysVisitCustDet = todaysVisitModel.output;
        status = data['message'];
        CustomMessage.hideLoader();

        return true;
      } else {
        status = data['message'];
        CustomMessage.hideLoader();

        return false;
      }
    }
    update();
  }
}
