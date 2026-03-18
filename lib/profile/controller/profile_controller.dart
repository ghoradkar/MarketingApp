import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'package:marketingapp/profile/model/bank_details_list.dart';
import 'package:marketingapp/profile/model/blood_group_list.dart';
import 'package:marketingapp/profile/model/edit_profile_model.dart';
import 'package:marketingapp/profile/model/profile_bank_details_model.dart';
import 'package:marketingapp/utils/api_urls.dart';
import 'package:marketingapp/utils/network_call.dart';
import 'package:marketingapp/widgets/cust_toast.dart';

class ProfileController extends GetxController {
  TextEditingController currentAddress = TextEditingController();

  TextEditingController contactNumber = TextEditingController();

  TextEditingController motherName = TextEditingController();

  TextEditingController age = TextEditingController();

  TextEditingController dob = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController lastName = TextEditingController();

  TextEditingController middleName = TextEditingController();

  TextEditingController firstName = TextEditingController();
  TextEditingController permanetAddress = TextEditingController();
  TextEditingController pin = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController baranchName = TextEditingController();
  TextEditingController ifscNo = TextEditingController();
  TextEditingController accNo = TextEditingController();
  TextEditingController bankAddress = TextEditingController();

  IOClient ioClient = IOClient(ByPassCert().httpClient);
  List<GenderList> genderList = [
    GenderList("Male", 1),
    GenderList("Other", 2),
    GenderList("Female", 3),
  ];
  bool shouldValidateFields = false;

  String? selectedBank;
  String? selectedGender;

  String? selectedBloodG;

  EditProfileModel? editProfileModel;
  ProfileBankDetailsModel? profileBankDetailsModel;
  BloodGroupList? bloodGroupList;
  BankDetailsList? bankDetailsList;

  String? status;

  bool hasInternet = true;

  editProfile(
    String userId,
    String mobNo,
    String createdBy,
    String firstName,
    String lastName,
    String motherName,
    String middleName,
    String dateofbirth,
    String genderId,
    String noOfChildren,
    String spouseName,
    String uidNo,
    String panNo,
    String bloodId,
    String age,
    String addressCurrent,
    String addressPer,
    String pinCode,
    String cityCode,
  ) async {
    CustomMessage.showLoader();

    final uri = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.editProfile}");

    debugPrint(uri.path);

    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request('POST', uri);
    request.bodyFields = {
      'USERID': userId,
      'MOBNO': mobNo,
      'CREATEDBY': createdBy,
      'FIRSTNAME': mobNo,
      'LASTNAME': lastName,
      'MOTHERNAME': motherName,
      'MIDDLENAME': middleName,
      'dateofbirth': dateofbirth,
      'GENDERID': genderId,
      'NOOFCHILDREN': noOfChildren,
      'SPOUSENAME': spouseName,
      'UIDNO': uidNo,
      'PANNO': panNo,
      'BLOODID': bloodId,
      'AGE': age,
      'ADDRESSCURRENT': addressCurrent,
      'ADDRESSPER': addressPer,
      'PINCODE': pinCode,
      'CityCode': cityCode,
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
        editProfileModel = EditProfileModel.fromJson(data);
      } else {
        status = data['message'];
        // isLoading = false;
        CustomMessage.hideLoader();

        CustomMessage.toast(data['message']);
      }
    }
    update();
  }

  editProfileBankDet(
      String userId,
      String? bankId,
      String accountNo,
      String ifscode,
      String branch,
      String bankAddress,
      String createdBy,
      String isConfirm,
      String upDocPath,
      String isAmntDepoConfirm) async {
    CustomMessage.showLoader();

    final uri =
        Uri.parse("${ApiConstants.baseUrl}${ApiConstants.editProfileBankDet}");

    debugPrint(uri.path);

    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request('POST', uri);
    request.bodyFields = {
      'USERID': userId,
      'BANKID': bankId ?? '0',
      'ACCOUNTNO': accountNo.isEmpty ? '0' : accountNo,
      'IFSCCODE': ifscode.isEmpty ? '0' : ifscode,
      'BRANCH': branch,
      'BANKADDRESS': bankAddress,
      'CREATEDBY': createdBy,
      'Isconfirm': isConfirm,
      'UPDOCPATH': upDocPath,
      'IsAmntDepoConfirm': isAmntDepoConfirm,
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
        profileBankDetailsModel = ProfileBankDetailsModel.fromJson(data);
      } else {
        status = data['message'];
        // isLoading = false;
        CustomMessage.hideLoader();

        CustomMessage.toast(data['message']);
      }
    }
    update();
  }

  getBloodGroupList() async {
    // isLoading = true;
    // update();
    CustomMessage.showLoader();

    final uri =
        Uri.parse("${ApiConstants.baseUrl}${ApiConstants.bloodGroupList}");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      CustomMessage.hideLoader();

      //getDeviceDetails
      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        bloodGroupList = BloodGroupList.fromJson(data);

        status = data['message'];
      } else {
        status = data['message'];
        CustomMessage.hideLoader();
      }
    }
    update();
  }

  getBankDetailsList() async {
    // isLoading = true;
    // update();
    CustomMessage.showLoader();

    final uri =
        Uri.parse("${ApiConstants.baseUrl}${ApiConstants.getBankDetailsList}");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      CustomMessage.hideLoader();

      //getDeviceDetails
      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        bankDetailsList = BankDetailsList.fromJson(data);

        status = data['message'];
      } else {
        status = data['message'];
        CustomMessage.hideLoader();
      }
    }
    update();
  }
}

class GenderList {
  String gender;
  int genderId;

  GenderList(this.gender, this.genderId);
}
