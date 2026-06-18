import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:marketingapp/login/login_controller.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/utils/session_manager.dart';
import 'package:marketingapp/utils/shared_pref_constants.dart';
import 'package:marketingapp/utils/shared_preference.dart';
import 'package:marketingapp/widgets/common_svg.dart';
import 'package:marketingapp/widgets/custom_button.dart';
import 'package:marketingapp/widgets/custom_text.dart';
import 'package:marketingapp/widgets/custom_text_field.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:upgrader/upgrader.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final upgrader = Get.find<Upgrader>();
  final LoginController loginController = Get.find<LoginController>();

  String? version;

  @override
  void initState() {
    super.initState();
    checkInternetAndLoadData();
    _loadVersion();
  }

  _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() => version = info.version);
  }

  checkInternetAndLoadData() async {
    await Future.delayed(const Duration(seconds: 2));

    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      loginController.hasInternet = true;

      String? userN =
          await SharedPref().read(const SharedPrefConstant().kUserName);
      String? userPsw =
          await SharedPref().read(const SharedPrefConstant().kPassword);
      bool keepFlag = await SessionManager().getKeepSignedIn();
      if (keepFlag) {
        loginController.userName.value.text = userN!;
        loginController.password.value.text = userPsw!;
      } else {
        loginController.userName.value.text = "";
        loginController.password.value.text = "";
      }
    } else {
      loginController.hasInternet = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            // loginController.hasInternet ?
            GetBuilder<LoginController>(
                init: loginController,
                builder: (controller) {
                  return UpgradeAlert(
                    upgrader: upgrader,
                    showIgnore: false,
                    showLater: false,
                    showReleaseNotes: false,
                    barrierDismissible: false,
                    shouldPopScope: () => false,
                    child: Stack(
                      children: [
                      Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            AppColor.primaryBackgroundColor
                                .withValues(alpha: 0.3),
                            AppColor.white,
                            AppColor.white,
                            FlavorConfig.instance.name == 'Lifenity Operational'
                                ? AppColor.primaryBackgroundColor
                                    .withValues(alpha: 0.1)
                                : AppColor.secondaryColor
                                    .withValues(alpha: 0.1),
                          ],
                          stops: const [0.0, 0.4, 0.6, 1.0],
                        ),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: IntrinsicHeight(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 20),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey
                                                  .withValues(alpha: 0.5),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(3, 3),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 10.h,
                                              bottom: 10.h,
                                              left: 10.w,
                                              right: 10.w),
                                          child: Column(
                                            children: [
                                              FlavorConfig.instance.name ==
                                                      "CSC HealthCare"
                                                  ? Image.asset(
                                                      "assets/csc_text_logo.png",
                                                      width: 300.w,
                                                    )
                                                  : Image.asset(
                                                      FlavorConfig.instance
                                                          .variables['aapLogo'],
                                                      height: 160.h,
                                                    ),
                                              // const SizedBox(
                                              //   height: 10,
                                              // ),
                                              CustomText(
                                                text: 'Sign In',
                                                fontSize: 26.sp,
                                                fontWeight: FontWeight.bold,
                                                textColor: AppColor.black,
                                                textAlign: TextAlign.center,
                                                fontFam: 'Nunito Sans',
                                              ).paddingOnly(
                                                  bottom: 4.h, top: 2.h),
                                              CustomText(
                                                text:
                                                    'Welcome! Enter Registered Mobile Number & Password To Continue.',
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.normal,
                                                textColor: AppColor.black,
                                                textAlign: TextAlign.center,
                                                fontFam: 'Nunito Sans',
                                              ),
                                              SizedBox(
                                                height: 16.h,
                                              ),
                                              CustomTextField(
                                                  autofocus: false,
                                                  txtController:
                                                      controller.userName.value,
                                                  labelText: 'Mobile Number',
                                                  hintText: 'Mobile Number',
                                                  isRequired: false,
                                                  keyBoardType:
                                                      TextInputType.number,
                                                  fillColor: AppColor.white,
                                                  isReadOnly: false,
                                                  maxLines: 1,
                                                  mazLenght: 10,
                                                  fontSize: 16.sp,
                                                  prefixIcon: CommonSvg(
                                                    path: 'assets/username.svg',
                                                    width: 26.w,
                                                    height: 26.h,
                                                    parentWidth: 30.w,
                                                    parentHeight: 30.h,
                                                    color: AppColor
                                                        .primaryBackgroundColor,
                                                  )),
                                              CustomTextField(
                                                autofocus: false,
                                                obscureText:
                                                    controller.obscurePassword,
                                                txtController:
                                                    controller.password.value,
                                                labelText: 'Password',
                                                hintText: 'Password',
                                                isRequired: false,
                                                keyBoardType:
                                                    TextInputType.text,
                                                fillColor: AppColor.white,
                                                isReadOnly: false,
                                                maxLines: 1,
                                                fontSize: 16.sp,
                                                prefixIcon: CommonSvg(
                                                  path: 'assets/password.svg',
                                                  width: 26.w,
                                                  height: 26.h,
                                                  parentWidth: 30.w,
                                                  parentHeight: 30.h,
                                                  color: AppColor
                                                      .primaryBackgroundColor,
                                                ),
                                                suffixIcon: IconButton(
                                                  color: AppColor
                                                      .primaryBackgroundColor,
                                                  onPressed: () {
                                                    controller.obscurePassword =
                                                        !controller
                                                            .obscurePassword;
                                                    controller.update();
                                                  },
                                                  icon: Icon(
                                                    controller.obscurePassword
                                                        ? Icons.key_off_rounded
                                                        : Icons.key_outlined,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Checkbox(
                                                    activeColor: AppColor
                                                        .primaryBackgroundColor,
                                                    value: controller
                                                        .keepMeSignedIn,
                                                    onChanged:
                                                        (bool? newValue) {
                                                      setState(() {
                                                        controller
                                                                .keepMeSignedIn =
                                                            newValue ?? false;
                                                      });
                                                      SessionManager()
                                                          .setKeepSignedIn(
                                                              controller
                                                                  .keepMeSignedIn);
                                                    },
                                                  ),
                                                  SizedBox(
                                                    height: 16.h,
                                                  ),
                                                  CustomText(
                                                    text: 'Keep me sign in',
                                                    fontSize: 16.sp,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    textColor: AppColor.black,
                                                    textAlign: TextAlign.right,
                                                    fontFam: 'Nunito Sans',
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 16.h,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    8.w, 12.h, 8.w, 20.h),
                                                child: CustomButton(
                                                  buttonFontSize: 16.sp,
                                                  buttonText: 'Sign In',
                                                  path: 'assets/arrow_nav.svg',
                                                  callB: () async {
                                                    // ✅ Check internet before attempting login
                                                    final connectivityResult =
                                                        await Connectivity()
                                                            .checkConnectivity();

                                                    if (connectivityResult
                                                        .contains(
                                                            ConnectivityResult
                                                                .none)) {
                                                      // Show toast/snackbar when no internet
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'No Internet Connection'),
                                                          backgroundColor:
                                                              Colors.redAccent,
                                                          duration: Duration(
                                                              seconds: 2),
                                                        ),
                                                      );
                                                      return; // stop execution
                                                    }

                                                    // ✅ Continue normal login if connected
                                                    await loginController.login(
                                                      loginController
                                                          .userName.value.text,
                                                      loginController
                                                          .password.value.text,
                                                    );
                                                  },
                                                  primColor: AppColor
                                                      .primaryBackgroundColor,
                                                  secColor:
                                                      AppColor.secondaryColor,
                                                  textColor: AppColor.white,
                                                  iconColor: AppColor.white,
                                                  buttonWidth: double.infinity,
                                                ),
                                              ),

                                              CustomText(
                                                text: version != null ? "Version : $version" : '',
                                                fontSize: 16,
                                                fontFam: 'Nunito Sans',
                                                fontWeight: FontWeight.normal,
                                                textColor: AppColor.black,
                                                textAlign: TextAlign.center,
                                              ).paddingOnly(top: 8)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    ],
                    ),
                  );
                })
        // : InternetIssue(
        //     onRetryPressed: () {
        //       checkInternetAndLoadData();
        //     },
        //   ),
        );
  }
}
