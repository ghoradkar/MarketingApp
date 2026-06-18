import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get/get.dart';
import 'package:marketingapp/change_password/controller/change_pass_controller.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/widgets/common_svg.dart';
import 'package:marketingapp/widgets/custom_button.dart';
import 'package:marketingapp/widgets/custom_text.dart';
import 'package:marketingapp/widgets/custom_text_field.dart';
import 'package:marketingapp/widgets/no_internet_connectivity.dart';

class ChangePassword extends StatefulWidget {
  final dynamic userData;
  const ChangePassword({super.key, this.userData});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final ChangePassController changePassController =
      Get.put(ChangePassController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChangePassController>(
        init: changePassController,
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      FlavorConfig.instance.name == "HindLab Operational"
                          ?AppColor.primaryBackgroundColor
                          .withValues(alpha: 0.1)
                          : AppColor.primaryBackgroundColor
                          .withValues(alpha: 0.3),
                      FlavorConfig.instance.name == 'Lifenity Operational'
                          ? AppColor.white
                          :  AppColor.secondaryColor.withValues(alpha: 0.3)

                    ],
                    // Change colors as needed
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              title: CustomText(
                text: 'Change Password',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                textColor: AppColor.black,
                textAlign: TextAlign.start,
                fontFam: 'Nunito Sans',
              ),
              leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back)),
            ),
            body: controller.hasInternet
                ?Column(
              children: [
                CustomTextField(
                  autofocus: false,
                  obscureText: controller.obscurePasswordOld,
                  txtController: controller.passwordOld.value,
                  labelText: 'Old Password',
                  hintText: 'Old Password',
                  isRequired: false,
                  keyBoardType: TextInputType.text,
                  fillColor: AppColor.white,
                  isReadOnly: false,
                  maxLines: 1,
                  fontSize: 16,
                  prefixIcon: CommonSvg(
                    path: 'assets/password.svg',
                    width: 26,
                    height: 26,
                    parentWidth: 30,
                    parentHeight: 30,
                    color: AppColor
                        .primaryBackgroundColor,
                  ),
                  suffixIcon: IconButton(
                    color: AppColor.primaryBackgroundColor,
                    onPressed: () {
                      controller.obscurePasswordOld =
                          !controller.obscurePasswordOld;
                      controller.update();
                    },
                    icon: Icon(
                      controller.obscurePasswordOld
                          ? Icons.key_off_rounded
                          : Icons.key_outlined,
                    ),
                  ),
                ),
                CustomTextField(
                  autofocus: false,
                  obscureText: controller.obscurePasswordNew,
                  txtController: controller.passwordNew.value,
                  labelText: 'New Password',
                  hintText: 'New Password',
                  isRequired: false,
                  keyBoardType: TextInputType.text,
                  fillColor: AppColor.white,
                  isReadOnly: false,
                  maxLines: 1,
                  fontSize: 16,
                  prefixIcon: CommonSvg(
                    path: 'assets/password.svg',
                    width: 26,
                    height: 26,
                    parentWidth: 30,
                    parentHeight: 30,
                    color: AppColor
                        .primaryBackgroundColor,
                  ),
                  suffixIcon: IconButton(
                    color: AppColor.primaryBackgroundColor,
                    onPressed: () {
                      controller.obscurePasswordNew =
                          !controller.obscurePasswordNew;
                      controller.update();
                    },
                    icon: Icon(
                      controller.obscurePasswordNew
                          ? Icons.key_off_rounded
                          : Icons.key_outlined,
                    ),
                  ),
                ),
                CustomTextField(
                  autofocus: false,
                  obscureText: controller.obscurePasswordConf,
                  txtController: controller.passwordConf.value,
                  labelText: 'Confirm Password',
                  hintText: 'Confirm Password',
                  isRequired: false,
                  keyBoardType: TextInputType.text,
                  fillColor: AppColor.white,
                  isReadOnly: false,
                  maxLines: 1,
                  fontSize: 16,
                  prefixIcon: CommonSvg(
                    path: 'assets/password.svg',
                    width: 26,
                    height: 26,
                    parentWidth: 30,
                    parentHeight: 30,
                    color: AppColor
                        .primaryBackgroundColor,
                  ),
                  suffixIcon: IconButton(
                    color: AppColor.primaryBackgroundColor,
                    onPressed: () {
                      controller.obscurePasswordConf =
                          !controller.obscurePasswordConf;
                      controller.update();
                    },
                    icon: Icon(
                      controller.obscurePasswordConf
                          ? Icons.key_off_rounded
                          : Icons.key_outlined,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      buttonFontSize: 16,
                      buttonText: 'Save',
                      path: 'assets/arrow_nav.svg',
                      callB: () async {
                        await controller.changePassword(
                            controller.passwordOld.value.text,
                            controller.passwordNew.value.text,
                            widget.userData['output'][0]['EmpCode'].toString());
                      },
                      // buttonWidth: double.infinity,
                      primColor: AppColor.primaryBackgroundColor,
                      secColor: AppColor.secondaryColor,
                      textColor: AppColor.white,
                      iconColor: AppColor.white,
                      buttonWidth: 120,
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
            ).paddingSymmetric(horizontal: 12):InternetIssue(
              onRetryPressed: () {
                // checkInternetAndLoadData();
              },
            ),
          );
        });
  }
}
