import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:marketingapp/login/login_screen.dart';
import 'package:marketingapp/utils/api_urls.dart';
import 'package:marketingapp/utils/network_call.dart';
import 'package:marketingapp/widgets/cust_toast.dart';

class ChangePassController extends GetxController {
  bool hasInternet = true;
  // bool isLoading = false;
  bool obscurePasswordOld = true;
  final isOldPasswordVisible = true.obs;
  final passwordOld = TextEditingController().obs;
  bool obscurePasswordNew = true;
  final isNewPasswordVisible = true.obs;
  final passwordNew = TextEditingController().obs;
  bool obscurePasswordConf = true;
  final isConfPasswordVisible = true.obs;
  final passwordConf = TextEditingController().obs;

  String? status;
  IOClient ioClient = IOClient(ByPassCert().httpClient);

  changePassword(
    String oldPsw,
    String newPsw,
    String empcode,
  ) async {
    // isLoading = true;
    // update();
CustomMessage.showLoader();
    final uri =
        Uri.parse("${ApiConstants.baseUrl}${ApiConstants.changePassword}");

    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request('POST', uri);
    request.bodyFields = {
      'OldPassword': oldPsw,
      'NewPassword': newPsw,
      'EmpCode': empcode,
    };
    request.headers.addAll(headers);

    // debugPrint(response.statusCode.toString());
    // debugPrint("response.body : ${response.body}");

    var ioStreamedResponse = await ioClient.send(request);

    if (ioStreamedResponse.statusCode == 200) {
      // isLoading = false;
      CustomMessage.hideLoader();

      final data = json.decode(await ioStreamedResponse.stream.bytesToString());
      if (data['status'] == 'Success') {
        status = data['message'];
        CustomMessage.toast(status);

        Get.off(const LoginScreen());
        // await Get.off(const MyVisitsScreen());
      } else {
        status = data['message'];
        CustomMessage.toast(status);
        // isLoading = false;
        CustomMessage.hideLoader();

      }
    }
    update();
  }
}
