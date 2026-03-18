import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'package:marketingapp/lab_accession/model/lab_name_list.dart';
import 'package:marketingapp/lab_accession/model/resource_name_list_model.dart';
import 'package:marketingapp/lab_accession/model/sample_pending_from_accession.dart';
import 'package:marketingapp/sample_collection_tracking/model/google_map_point_sample_collected.dart';
import 'package:marketingapp/sample_collection_tracking/model/sample_collection_tracking_list.dart';
import 'package:marketingapp/utils/api_urls.dart';
import 'package:marketingapp/utils/network_call.dart';
import 'package:marketingapp/widgets/cust_toast.dart';
import 'package:http/http.dart' as http;

class SampleCollectionTrackingController extends GetxController {
  bool hasInternet = false;

  DateTime? selectedFromDate;

  String? formattedFromDate;
  String? dateSendToApi;

  TextEditingController fDateController = TextEditingController();
  TextEditingController remark = TextEditingController();

  String? selectedLab;
  String? selectedRunnerBoy;
  IOClient ioClient = IOClient(ByPassCert().httpClient);

  String? status;

  LabNameList? labNameList;
  ResourceNameListModel? resourceNameListModel;

  SamplePendingFromAccession? collectSampleListAccssionTeam;

  List<AcceptedPendingOutput>? pendingList;

  List<AcceptedPendingOutput>? acceptedList;

  SampleCollectionTrackingList? sampleCollectionTrackingList;

  GoogleMapPointSampleCollected? googleMapPointSampleCollected;

  getLabNameList(String distlgCode) async {
    CustomMessage.showLoader();
    final uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.labNameListSampleTracking}?DISTLGDCODE=$distlgCode");

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

  getSampleCollectionTrackingList(String labCode, String date) async {
    CustomMessage.showLoader();

    final uri = Uri.parse(
        "${ApiConstants.baseUrl1}${ApiConstants.sampleCollectionTrackingList}");

    debugPrint(uri.path);

    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request('POST', uri);
    request.bodyFields = {'LabCode': labCode, 'Date': date};

    request.headers.addAll(headers);
    var response = await ioClient.send(request);

    debugPrint(response.statusCode.toString());

    if (response.statusCode == 200) {
      CustomMessage.hideLoader();

      final data = json.decode(await response.stream.bytesToString());
      if (data['status'] == 'Success') {
        sampleCollectionTrackingList =
            SampleCollectionTrackingList.fromJson(data);

        status = data['message'];
      } else {
        sampleCollectionTrackingList = null;

        status = data['message'];

        CustomMessage.hideLoader();
      }
    } else {
      sampleCollectionTrackingList = null;
      CustomMessage.toast("Fail getting sample Collection Tracking List");

      CustomMessage.hideLoader();
    }
    update();
  }

  getLatLongSampleCollection(
      String userId, String uDate, String labCode, String routeId) async {
    CustomMessage.showLoader();
    final uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.getLatLonSampleCollectedList}?userid=$userId&UDate=$uDate&LabCode=$labCode&RouteID=$routeId");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      CustomMessage.hideLoader();

      //getDeviceDetails
      final data = json.decode(response.body);

      if (data['status'] == 'Success') {
         googleMapPointSampleCollected = GoogleMapPointSampleCollected.fromJson(data);
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
}
