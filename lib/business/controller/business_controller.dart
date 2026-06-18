import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'package:marketingapp/add_visit/model/customer_list_model.dart';
import 'package:marketingapp/business/model/business_list_model.dart';
import 'package:marketingapp/business/model/district_list_model.dart';
import 'package:marketingapp/business/model/lab_list_model.dart';
import 'package:marketingapp/business/model/patch_model_list.dart';
import 'package:marketingapp/business/model/state_model_list.dart';
import 'package:marketingapp/utils/api_urls.dart';
import 'package:marketingapp/utils/network_call.dart';
import 'package:marketingapp/widgets/cust_toast.dart';
import 'package:http/http.dart' as http;

class BusinessController extends GetxController {
  bool hasInternet = false;
  LabOutput? lab;
  DateTime? selectedFromDate;
  var userData;
  OutputCustomer? customer;
  String? formattedFromDate;
  int totalPaidInvoice = 0;
  int totalUnPaidInvoice = 0;
  num totalInvoiceAmount = 0;
  DateTime? selectedToDate;

  String? formattedToDate;
  DistrictOutput? districtCode;
  TextEditingController fDateController = TextEditingController();
  TextEditingController tDateController = TextEditingController();

  String? selectedLab;

  String? selectedState;
  IOClient ioClient = IOClient(ByPassCert().httpClient);

  String? status;

  StateModelList? stateList;
  DistrictListModel? districtListModel;

  // PatchModelList? patchModelList;
  RxList<PatchOutput> patchList = <PatchOutput>[].obs;

  LabListModel? labListModel;
  CustomerListModel? customerListModel;

  BusinessListModel? businessListModel;

  String? selectedDistrict;

  String? selectedPatch;

  String? selectedCustomer;

  getStateList() async {
    CustomMessage.showLoader();

    final uri =
        Uri.parse("${ApiConstants.baseUrl}${ApiConstants.getStateList}");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      CustomMessage.hideLoader();

      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        stateList = StateModelList.fromJson(data);

        status = data['message'];
      } else {
        status = data['message'];
        stateList = null;
        CustomMessage.hideLoader();
      }
    }
    update();
  }

  getDistrictList(userId) async {
    CustomMessage.showLoader();

    final uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.getDisrtictList}?USERID=$userId");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      CustomMessage.hideLoader();

      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        districtListModel = DistrictListModel.fromJson(data);

        status = data['message'];
      } else {
        status = data['message'];
        stateList = null;
        CustomMessage.hideLoader();
      }
    }
    update();
  }

  getPatchList(distCode) async {
    CustomMessage.showLoader();

    final uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.patchList}?DistrictLGDCode=$distCode");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      CustomMessage.hideLoader();

      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        var patchModelList = PatchModelList.fromJson(data);
        patchList.value = patchModelList.output;
        status = data['message'];
      } else {
        status = data['message'];
        stateList = null;
        CustomMessage.hideLoader();
      }
    }
    update();
  }

  getLabList(userId, distCode) async {
    CustomMessage.showLoader();

    final uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.labListBusiness}?USERID=$userId&DISTLGDCODE=$distCode");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      CustomMessage.hideLoader();

      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        labListModel = LabListModel.fromJson(data);

        status = data['message'];
      } else {
        status = data['message'];
        stateList = null;
        CustomMessage.hideLoader();
      }
    }
    update();
  }

  searchBusiness(
      String userId,
      String dISTLGDCODE,
      String labCode,
      String customerUserId,
      String fromD,
      String toD,
      bool isFromFilter) async {
    // isLoading = true;
    // update();
    CustomMessage.showLoader();

    final uri =
        Uri.parse("${ApiConstants.baseUrl}${ApiConstants.searchBusiness}");

    debugPrint(uri.path);

    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request('POST', uri);
    request.bodyFields = {
      'USERID': userId,
      'DISTLGDCODE': dISTLGDCODE,
      'LabCode': labCode,
      'CustomerUSERID': customerUserId,
      'FromDate': fromD,
      'ToDate': toD,
    };

    request.headers.addAll(headers);
    var response = await ioClient.send(request);

    // final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    // debugPrint("response.body : ${await response.stream.bytesToString()}");

    if (response.statusCode == 200) {
      // isLoading = false;
      CustomMessage.hideLoader();

      //getDeviceDetails
      final data = json.decode(await response.stream.bytesToString());
      if (data['status'] == 'Success') {
        businessListModel = BusinessListModel.fromJson(data);
        status = data['message'];
        CustomMessage.toast(data['message']);
        for (var item in businessListModel!.output) {
          totalPaidInvoice += item.paidInvoice;
          totalUnPaidInvoice += item.unPaidInvoice;
          totalInvoiceAmount += item.invoiceAmount;
        }
        if (isFromFilter) {
          Get.back();
        }
      } else {
        status = data['message'];
        // isLoading = false;
        CustomMessage.hideLoader();

        CustomMessage.toast(data['message']);
      }
    }
    update();
  }

  getCustomerList(userId, distCode, labCode) async {
    CustomMessage.showLoader();

    final uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.getCustomerList}?USERID=$userId&DISTLGDCODE=$distCode&LabCode=$labCode");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      CustomMessage.hideLoader();

      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        customerListModel = CustomerListModel.fromJson(data);

        status = data['message'];
      } else {
        status = data['message'];
        stateList = null;
        CustomMessage.hideLoader();
      }
    }
    update();
  }
}
