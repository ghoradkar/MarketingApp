import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get/get.dart';
import 'package:marketingapp/login/login_screen.dart';
import 'package:marketingapp/utils/session_manager.dart';
import 'package:marketingapp/utils/shared_pref_constants.dart';
import 'package:marketingapp/utils/shared_preference.dart';
import 'package:marketingapp/widgets/cust_toast.dart';
import 'package:marketingapp/widgets/custom_button.dart';
import 'package:marketingapp/widgets/custom_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/color_constants.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  var userData;

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                FlavorConfig.instance.name == "HindLab Operational"
                    ? AppColor.primaryBackgroundColor.withValues(alpha: 0.1)
                    : AppColor.primaryBackgroundColor.withValues(alpha: 0.3),
                FlavorConfig.instance.name == 'Lifenity Operational'
                    ? AppColor.white
                    : AppColor.secondaryColor.withValues(alpha: 0.3)
              ],
              // Change colors as needed
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: CustomText(
          text: 'LogOut',
          fontSize: 18,
          fontWeight: FontWeight.w500,
          textColor: AppColor.black,
          textAlign: TextAlign.right,
          fontFam: 'Nunito Sans',
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/checkout.png"),
          CustomText(
            text: 'Are you sure, you\nwant to logout ?',
            fontSize: 20,
            fontWeight: FontWeight.w500,
            textColor: AppColor.black,
            textAlign: TextAlign.right,
            fontFam: 'Nunito Sans',
          ).paddingOnly(top: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                buttonFontSize: 16,
                buttonText: 'Yes',
                path: 'assets/arrow_nav.svg',
                callB: () async {
                  CustomMessage.showLoader();

                  // Backup route info from SharedPreferences
                  final prefs = await SharedPreferences.getInstance();
                  String? routeDate =
                      prefs.getString(SessionManager.routeDateKey);
                  bool? isRouteTapped =
                      prefs.getBool(SessionManager.routeResetKey);

                  // Backup login info
                  String? userN = await SharedPref()
                      .read(const SharedPrefConstant().kUserName);


                  String? userPsw = await SharedPref()
                      .read(const SharedPrefConstant().kPassword);

                  int? empId = await SharedPref()
                      .read(const SharedPrefConstant().kEmpId);
                  bool keepFlag = await SessionManager().getKeepSignedIn();

                  await SharedPref().clearSaveData();

                  // Restore login info
                  if (userN != null) {
                    await SharedPref()
                        .save(const SharedPrefConstant().kUserName, userN);
                  }
                  if (userPsw != null) {
                    await SharedPref()
                        .save(const SharedPrefConstant().kPassword, userPsw);
                  }

                  if (empId != null) {
                    await SharedPref()
                        .save(const SharedPrefConstant().kEmpId, empId);
                  }
                  await SessionManager().setKeepSignedIn(keepFlag);

                  // ✅ Restore route info directly to SharedPreferences
                  if (routeDate != null) {
                    await prefs.setString(
                        SessionManager.routeDateKey, routeDate);
                  }
                  if (isRouteTapped != null) {
                    await prefs.setBool(
                        SessionManager.routeResetKey, isRouteTapped);
                  }

                  CustomMessage.hideLoader();
                  Get.offAll(const LoginScreen());
                },
                // buttonWidth: double.infinity,
                primColor: AppColor.primaryBackgroundColor,
                secColor: AppColor.secondaryColor,
                textColor: AppColor.white,
                iconColor: AppColor.white,
                buttonWidth: 100,
              ),
              const SizedBox(
                width: 20,
              ),
              CustomButton(
                buttonFontSize: 16,
                buttonText: 'Cancel',
                path: 'assets/arrow_nav.svg',
                callB: () {
                  Get.back();
                },
                // buttonWidth: double.infinity,
                primColor: AppColor.borderGrey,
                secColor: AppColor.borderGrey,
                textColor: AppColor.black,
                iconColor: AppColor.black,
                buttonWidth: 120,
              ),
            ],
          ).paddingOnly(top: 50),
        ],
      ),
    );
  }

  void getUserData() async {
    userData = await SharedPref().read(const SharedPrefConstant().kUserData);
  }
}
