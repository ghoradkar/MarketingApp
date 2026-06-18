import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketingapp/forgot_pasword/controller/forgot_password_controller.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/widgets/custom_button.dart';
import 'package:marketingapp/widgets/custom_text.dart';
import 'package:marketingapp/widgets/custom_text_field.dart';
import 'package:marketingapp/widgets/no_internet_connectivity.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final ForgotPasswordController forgetController =
      Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: forgetController.hasInternet
          ? GetBuilder<ForgotPasswordController>(
              init: forgetController,
              builder: (controller) {
                return SafeArea(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          AppColor.primaryBackgroundColor.withValues(alpha: 0.3),
                          AppColor.white,
                          AppColor.white,
                          AppColor.secondaryColor.withValues(alpha: 0.1),
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
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                   Align(
                                      alignment: Alignment.centerLeft,
                                      child: IconButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        icon: const Icon(Icons.arrow_back),
                                      )).paddingOnly(top: 16, left: 16),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 20),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withValues(alpha: 0.5),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(3, 3),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                "assets/forgot_password.png",
                                                height: 160,
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              CustomText(
                                                text: 'Forgot Password',
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold,
                                                textColor: AppColor.black,
                                                textAlign: TextAlign.center,
                                                fontFam: 'Nunito Sans',
                                              ),
                                              CustomText(
                                                text:
                                                    'Enter Mobile Number for OTP\nVerification Processes',
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                                textColor: AppColor.textGrey,
                                                textAlign: TextAlign.center,
                                                fontFam: 'Nunito Sans',
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              CustomTextField(
                                                autofocus: false,
                                                txtController:
                                                    controller.userName.value,
                                                labelText: 'Mobile Number',
                                                hintText: 'Mobile Number',
                                                isRequired: false,
                                                keyBoardType:
                                                    TextInputType.text,
                                                fillColor: AppColor.white,
                                                isReadOnly: false,
                                                maxLines: 1,
                                                fontSize: 16,
                                                prefixIcon: Image.asset(
                                                    'assets/device.png'),
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8, 12, 8, 20),
                                                child: CustomButton(
                                                  buttonFontSize: 16,
                                                  buttonText: 'Send Otp',
                                                  path: 'assets/arrow_nav.svg',
                                                  callB: () async {
                                                    await controller.sendOtp(
                                                        controller.userName
                                                            .value.text);
                                                  },
                                                  // buttonWidth: double.infinity,
                                                  primColor: AppColor
                                                      .primaryBackgroundColor,
                                                  secColor:
                                                      AppColor.secondaryColor,
                                                  textColor: AppColor.white,
                                                  iconColor: AppColor.white,
                                                  buttonWidth: double.infinity,
                                                ),
                                              ),
                                            ],
                                          ),
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
                );
              })
          : InternetIssue(
              onRetryPressed: () {
                checkInternetAndLoadData();
              },
            ),
    );
  }

  void checkInternetAndLoadData() {}
}
