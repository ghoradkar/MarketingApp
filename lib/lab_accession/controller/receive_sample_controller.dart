import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'package:marketingapp/lab_accession/model/lab_name_list.dart';
import 'package:marketingapp/lab_accession/model/resource_name_list_model.dart';
import 'package:marketingapp/lab_accession/model/sample_pending_from_accession.dart';
import 'package:marketingapp/utils/api_urls.dart';
import 'package:marketingapp/utils/network_call.dart';
import 'package:marketingapp/widgets/cust_toast.dart';
import 'package:http/http.dart' as http;

class ReceiveSampleController extends GetxController {
  bool hasInternet = false;

  DateTime? selectedFromDate;

  String? formattedFromDate;
  String? dateSendToApi;

  TextEditingController fDateController = TextEditingController();
  TextEditingController remark = TextEditingController();
  bool selectAll = false;
  String? selectedLab;
  String? selectedRunnerBoy;
  IOClient ioClient = IOClient(ByPassCert().httpClient);

  String? status;

  LabNameList? labNameList;
  ResourceNameListModel? resourceNameListModel;

  SamplePendingFromAccession? collectSampleListAccssionTeam;

  List<AcceptedPendingOutput>? pendingList;

  List<AcceptedPendingOutput>? acceptedList;

  // bool shouldValidate = false;

  getLabNameList(String userId) async {
    CustomMessage.showLoader();
    final uri = Uri.parse(
        "${ApiConstants.baseUrl1}${ApiConstants.labNameList}?USERID=$userId");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      CustomMessage.hideLoader();

      //getDeviceDetails
      final data = json.decode(response.body);

      if (data['status'] == 'Success') {
        labNameList = LabNameList.fromJson(data);
        status = data['status'];
      } else {
        CustomMessage.hideLoader();
        status = data['status'];
        debugPrint(status);
      }
    } else {
      CustomMessage.hideLoader();
      debugPrint(status);
    }
    update();
  }

  void toggleSelectAll() {
    selectAll = !selectAll;
    final list = pendingList ?? const <AcceptedPendingOutput>[];
    for (final it in list) {
      if (it.isSampleAccepted == "0") it.isSelected = selectAll;
    }
    update();
  }

  void toggleItem(AcceptedPendingOutput? item, bool? v) {
    item?.isSelected = v ?? false;

    final list = pendingList ?? const <AcceptedPendingOutput>[];
    final selectable = list.where((e) => e.isSampleAccepted == "0");
    selectAll = selectable.isNotEmpty && selectable.every((e) => e.isSelected);

    update();
  }

  List<AcceptedPendingOutput> get selectedPending =>
      (pendingList ?? const <AcceptedPendingOutput>[])
          .where((e) => e.isSampleAccepted == "0" && e.isSelected)
          .toList();

  getResourceList(String labCode) async {
    CustomMessage.showLoader();
    final uri = Uri.parse(
        "${ApiConstants.baseUrl1}${ApiConstants.resourceNameList}?LabCode=$labCode");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      CustomMessage.hideLoader();

      //getDeviceDetails
      final data = json.decode(response.body);

      if (data['status'] == 'Success') {
        resourceNameListModel = ResourceNameListModel.fromJson(data);
        status = data['status'];
      } else {
        CustomMessage.hideLoader();
        status = data['status'];
        debugPrint(status);
      }
    } else {
      CustomMessage.hideLoader();
      debugPrint(status);
    }
    update();
  }

  getCollectedSampleList(String date, String userId, String labCode) async {
    CustomMessage.showLoader();

    final uri = Uri.parse(
        "${ApiConstants.baseUrl1}${ApiConstants.collectedSampleList}");

    debugPrint(uri.path);

    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request('POST', uri);
    request.bodyFields = {'date': date, 'userid': userId, 'LabCode': labCode};

    request.headers.addAll(headers);
    var response = await ioClient.send(request);

    debugPrint(response.statusCode.toString());

    if (response.statusCode == 200) {
      CustomMessage.hideLoader();

      final data = json.decode(await response.stream.bytesToString());
      if (data['status'] == 'Success') {
        collectSampleListAccssionTeam =
            SamplePendingFromAccession.fromJson(data);
        pendingList = collectSampleListAccssionTeam!.output
            .where((sample) => sample.isSampleAccepted == "0")
            .toList();
        acceptedList = collectSampleListAccssionTeam!.output
            .where((sample) => sample.isSampleAccepted == "1")
            .toList();

        status = data['message'];
        CustomMessage.toast(status);
      } else {
        status = data['message'];

        CustomMessage.hideLoader();
      }
    } else {
      CustomMessage.toast("Fail adding contact person");

      CustomMessage.hideLoader();
    }
    update();
  }

  acceptCollectedSampleFromRunnerBoy(String locId, String userId,
      String acceptedBy, String accepteRemark, String updatedBy) async {
    CustomMessage.showLoader();

    final uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.acceptCollectedSampleList}");

    debugPrint(uri.path);

    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request('POST', uri);
    request.bodyFields = {
      'LOCID': locId,
      'UserID': userId,
      'AcceptedBy': acceptedBy,
      'AcceptRemark': accepteRemark,
      'UpdatedBy': updatedBy
    };

    request.headers.addAll(headers);
    var response = await ioClient.send(request);

    debugPrint(response.statusCode.toString());

    if (response.statusCode == 200) {
      CustomMessage.hideLoader();

      final data = json.decode(await response.stream.bytesToString());
      if (data['status'] == 'Success') {
        status = data['message'];

        remark.clear();
      } else {
        status = data['message'];

        CustomMessage.hideLoader();
      }
    } else {
      CustomMessage.toast("Fail adding contact person");

      CustomMessage.hideLoader();
    }
    update();
  }
}
