import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'package:marketingapp/dashboard/dashboard_screen.dart';
import 'package:marketingapp/dashboard/model/main_dashboard_count.dart';
import 'package:marketingapp/login/model/login_resp_model.dart';
import 'package:marketingapp/utils/api_urls.dart';
import 'package:marketingapp/utils/network_call.dart';
import 'package:marketingapp/utils/session_manager.dart';
import 'package:marketingapp/utils/shared_pref_constants.dart';
import 'package:marketingapp/utils/shared_preference.dart';
import 'package:marketingapp/widgets/cust_toast.dart';

class LoginController extends GetxController {
  bool keepMeSignedIn = false;
  bool hasInternet = true;
  final userName = TextEditingController().obs;
  final password = TextEditingController().obs;
  final isPasswordVisible = true.obs;

  // final isLoading = false;
  bool obscurePassword = true;
  String? status;
  IOClient ioClient = IOClient(ByPassCert().httpClient);

  LoginRespModel? loginRespModel;

  MainDashBoardCount? mainDashBoardCount;

  login(String username, String password) async {
    CustomMessage.showLoader();
    final uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.login}?UserEmail=$username&Password=$password");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      CustomMessage.hideLoader();

      //getDeviceDetails
      final data = json.decode(response.body);
      loginRespModel = LoginRespModel.fromJson(data);

      if (data['status'] == 'Success') {
        SessionManager().setLoggedIn(true);
        if (loginRespModel?.output?.first.designation == 'Runner Boy') {
          int? kEmpId =
              await SharedPref().read(const SharedPrefConstant().kEmpId);
          if (kEmpId != null &&
              kEmpId != loginRespModel?.output?.first.empCode) {
            await SharedPref().removeData(SessionManager.routeDateKey);
            await SharedPref().removeData(SessionManager.routeResetKey);
          }
        }
        await SharedPref()
            .save(const SharedPrefConstant().kUserData, loginRespModel);
        await SharedPref().save(const SharedPrefConstant().kUserName, username);
        await SharedPref().save(const SharedPrefConstant().kPassword, password);
        await SharedPref().save(const SharedPrefConstant().kEmpId,
            loginRespModel?.output?.first.empCode);

        status = data['status'];

        Get.offNamed(DashboardScreen.routeName);
        CustomMessage.toast(loginRespModel?.message ?? "Login Successfully");
      } else {
        CustomMessage.hideLoader();

        SessionManager().setLoggedIn(false);
        status = data['status'];
        CustomMessage.toast(loginRespModel?.message);
      }
    } else {
      CustomMessage.hideLoader();

      CustomMessage.toast(loginRespModel?.message);
      SessionManager().setLoggedIn(false);
      throw Exception('Failed to sign in');
    }
    update();
  }

  Future<void> getMainDashCount() async {
    CustomMessage.showLoader();
    try {
      CustomMessage.showLoader();

      final uri = Uri.parse(ApiConstants.baseUrl3);
      debugPrint("Calling: $uri");

      final response = await ioClient.get(uri).timeout(
        const Duration(seconds: 8),
        onTimeout: () {
          throw Exception("Request timed out");
        },
      );

      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        CustomMessage.hideLoader();

        try {
          final data = json.decode(response.body);

          // Check if it's valid JSON and contains the expected keys
          // if (data is Map && data.containsKey('output')) {
          mainDashBoardCount = MainDashBoardCount.fromJson(data);
          status = data['message'];
          // }
          // else {
          //   debugPrint("⚠ Unexpected API response structure");
          //   status = "Unexpected response format";
          // }
        } catch (e) {
          CustomMessage.hideLoader();

          debugPrint("❌ JSON Decode Error: $e");
          status = "Invalid response from server";
        }
      } else {
        CustomMessage.hideLoader();

        debugPrint("❌ API Error: ${response.statusCode}");
        status = "Server error (${response.statusCode})";
      }
    } catch (e) {
      CustomMessage.hideLoader();

      debugPrint("❌ Exception: $e");
      status = "Something went wrong: $e";
    } finally {
      CustomMessage.hideLoader();

      CustomMessage.hideLoader();
      update(); // Notifies UI (if using GetX)
    }
  }
}
