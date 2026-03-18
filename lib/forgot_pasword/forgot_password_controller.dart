import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'package:marketingapp/utils/api_urls.dart';
import 'package:marketingapp/utils/network_call.dart';
import 'package:marketingapp/utils/session_manager.dart';
import 'package:marketingapp/widgets/cust_toast.dart';

class ForgotPasswordController extends GetxController {
  bool keepMeSignedIn = false;
  bool hasInternet = true;
  final userName = TextEditingController().obs;
  final password = TextEditingController().obs;
  final isPasswordVisible = true.obs;
  // final isLoading = false;
  bool obscurePassword = true;
  String? status;
  IOClient ioClient = IOClient(ByPassCert().httpClient);

  sendOtp(String mobileNo) async {
    CustomMessage.showLoader();
    final uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.sendOpt}?MobileNo=$mobileNo");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      CustomMessage.hideLoader();

      //getDeviceDetails
      final data = json.decode(response.body);
      // loginRespModel = LoginRespModel.fromJson(data);

      if (data['status'] == 'Success') {
        // status = data['status'];
        // Get.off(const DashboardScreen());
        // CustomMessage.toast(loginRespModel?.message ?? "Login Successfully");
      } else {
        CustomMessage.hideLoader();

        SessionManager().setLoggedIn(false);
        status = data['status'];
        // CustomMessage.toast(loginRespModel?.message);
      }
    } else {
      CustomMessage.hideLoader();

      // CustomMessage.toast(loginRespModel?.message);
      SessionManager().setLoggedIn(false);
      throw Exception('Failed to sign in');
    }
    update();
  }

}