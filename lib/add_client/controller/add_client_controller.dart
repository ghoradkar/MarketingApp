import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:marketingapp/add_client/model/area_model.dart';
import 'package:marketingapp/add_client/model/city_list_model.dart';
import 'package:marketingapp/add_client/model/client_type_model.dart';
import 'package:marketingapp/dashboard/model/district_list_model.dart';
import 'package:marketingapp/utils/api_urls.dart';
import 'package:marketingapp/utils/network_call.dart';
import 'package:marketingapp/widgets/cust_toast.dart';

class AddClientController extends GetxController {
  // bool isLoading = false;
  // bool shouldValidateFields = false;
  bool shouldValidateArea = false;

  String? status;
  IOClient ioClient = IOClient(ByPassCert().httpClient);

  String? locationMessage;

  DistrictListModel? districtRespModel;
  DistrictOutput? selectedDistrictObj;
  DistrictOutput? selectedAddDistrictObj;
  String? selectedDistrictVal;
  bool hasInternet = true;
  List<CityOutput>? cityList;
  List<AreaOutput>? areaList;
  List<AreaOutput>? addAreaList;
  List<CustomerTypeOutput>? clientTypeList;

  String? selectedCityVal;
  CityOutput? selectedCityObj;

  String? selectedAreaVal;
  String? selectedAddAreaVal;
  AreaOutput? selectedAreaObj;
  AreaOutput? selectedAddAreaObj;

  TextEditingController businessPotential = TextEditingController();
  TextEditingController addAreaTxtField = TextEditingController();

  TextEditingController addressField = TextEditingController();

  TextEditingController specialty = TextEditingController();

  TextEditingController customerNameField = TextEditingController();
  TextEditingController contactPersonNameField = TextEditingController();

  TextEditingController mobNoField = TextEditingController();
  TextEditingController emailIdField = TextEditingController();

  String? selectedAddDistrictVal;

  String? selectedCustomerT;
  CustomerTypeOutput? selectedCustomerTypeObj;
  TextEditingController newCustomerype = TextEditingController();

  getDistrictList(String? stateCode) async {
    final uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.districtList}?STATELGDCODE=$stateCode");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        districtRespModel = DistrictListModel.fromJson(data);
        status = data['message'];
      } else {
        status = data['message'];
      }
    }
    update();
  }

  getCityList(String distLGDCODE) async {
    // isLoading = true;
    // update();
    CustomMessage.showLoader();

    final uri = Uri.parse(
        "${ApiConstants.baseUrl}${(FlavorConfig.instance.name == "HindLab Operational" || FlavorConfig.instance.name == "PlusCare Operational" || FlavorConfig.instance.name == "Lifenity Operational" || FlavorConfig.instance.name == "CSC HealthCare") ? ApiConstants.getCityListHindLab : ApiConstants.getCityList}?DISTLGDCODE=$distLGDCODE");

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
        CityListModel cityListModel = CityListModel.fromJson(data);
        cityList = cityListModel.output;
        status = data['message'];
      } else {
        // status = data['message'];
        debugPrint(data['message']);
        // isLoading = false;
        CustomMessage.hideLoader();
      }
    }
    update();
  }

  getAreaList(String distLGDCODE) async {
    // isLoading = true;
    // update();
    CustomMessage.showLoader();

    final uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.getAreaList}?DISTLGDCODE=$distLGDCODE");

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
        AreaModel areaListModel = AreaModel.fromJson(data);
        areaList = areaListModel.output;
        status = data['message'];
      } else {
        status = data['message'];
        CustomMessage.toast(status);
        // isLoading = false;
        CustomMessage.hideLoader();
      }
    }
    update();
  }

  getAddAreaList(String distLGDCODE) async {
    // isLoading = true;
    // update();
    CustomMessage.showLoader();

    final uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.getAreaList}?DISTLGDCODE=$distLGDCODE");

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
        AreaModel areaListModel = AreaModel.fromJson(data);
        addAreaList = areaListModel.output;
        status = data['message'];
      } else {
        status = data['message'];
        CustomMessage.toast(status);
        // isLoading = false;
        CustomMessage.hideLoader();
      }
    }
    update();
  }

  getClientTypeList() async {
    final uri =
        Uri.parse("${ApiConstants.baseUrl}${ApiConstants.getCustomerTypeList}");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        ClientTypeModel clientTypeModel = ClientTypeModel.fromJson(data);
        clientTypeList = clientTypeModel.output;
        status = data['message'];
      } else {
        status = data['message'];
      }
    }
    update();
  }

  addClient(
      String custID,
      String customerName,
      String dISTLGDCODE,
      String mobNo,
      String emailId,
      String? createdBy,
      String address,
      String cityCode,
      String patchCode,
      String latitude,
      String longitude,
      String clientPotential) async {
    CustomMessage.showLoader();

    final uri = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.addClient}");

    debugPrint(uri.path);

    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request('POST', uri);
    request.bodyFields = {
      'CustID': custID,
      'CustomerName': customerName,
      'DISTLGDCODE': dISTLGDCODE,
      'MOBNO': mobNo,
      'EMAILID': emailId,
      'CREATEDBY': createdBy!,
      'Address': address,
      'CityCode': cityCode,
      'PatchCode': patchCode,
      'Latitude': latitude,
      'Longitude': longitude,
      'ClientPotential': clientPotential
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
        status = data['message'];
        CustomMessage.toast(data['message']);

        selectedCustomerT = null;
        selectedCustomerTypeObj = null;
        customerNameField.text = '';
        mobNoField.text = '';
        emailIdField.text = '';
        specialty.text = '';
        addressField.text = '';
        businessPotential.text = '';
        selectedDistrictVal = null;
        selectedDistrictObj = null;
        selectedCityVal = null;
        selectedCityObj = null;
        selectedAreaVal = null;
        selectedAreaObj = null;
        Get.back();
        // Get.to(const DashboardScreen());
      } else {
        status = data['message'];
        // isLoading = false;
        CustomMessage.hideLoader();

        CustomMessage.toast(data['message']);
      }
    }
    update();
  }

  addArea(
    String tallGdcode,
    String patchName,
    String distlgDcode,
    String patchId,
  ) async {
    // isLoading = true;
    // update();
    CustomMessage.showLoader();

    final uri = Uri.parse("${ApiConstants.baseUrl1}${ApiConstants.addArea}");

    debugPrint(uri.path);

    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request('POST', uri);
    request.bodyFields = {
      'TALLGDCODE': tallGdcode,
      'PATCHNAME': patchName,
      'DISTLGDCODE': distlgDcode,
      'PATCHID': patchId
    };

    request.headers.addAll(headers);
    var response = await ioClient.send(request);

    debugPrint(response.statusCode.toString());

    if (response.statusCode == 200) {
      // isLoading = false;
      CustomMessage.hideLoader();

      //getDeviceDetails
      final data = json.decode(await response.stream.bytesToString());
      if (data['status'] == 'Success') {
        status = data['message'];
        CustomMessage.toast(data['message']);
        await getAreaList(distlgDcode);
        selectedAddDistrictVal = null;
        selectedAddDistrictObj = null;
        selectedAddAreaVal = null;
        selectedAddAreaObj = null;
        addAreaTxtField.text = "";
        Get.back();
      } else {
        status = data['message'];
        // isLoading = false;
        CustomMessage.hideLoader();

        CustomMessage.toast(data['message']);
      }
    }
    update();
  }

  addCustomerType(String customerType, String? createdBy) async {
    // isLoading = true;
    // update();
    CustomMessage.showLoader();

    final uri =
        Uri.parse("${ApiConstants.baseUrl}${ApiConstants.addCustomerType}");

    debugPrint(uri.path);

    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request('POST', uri);
    request.bodyFields = {
      'CustomerType': customerType,
      'CreatedBy': createdBy!
    };

    request.headers.addAll(headers);
    var response = await ioClient.send(request);

    debugPrint(response.statusCode.toString());

    if (response.statusCode == 200) {
      // isLoading = false;
      CustomMessage.hideLoader();

      //getDeviceDetails
      final data = json.decode(await response.stream.bytesToString());
      if (data['status'] == 'Success') {
        await getClientTypeList();

        status = data['message'];
        CustomMessage.toast(data['message']);
        newCustomerype.text = '';

        Get.back();
      } else {
        status = data['message'];
        // isLoading = false;
        CustomMessage.hideLoader();

        CustomMessage.toast(data['message']);
      }
    }
    update();
  }
}
