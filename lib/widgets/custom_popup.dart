import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/widgets/custom_button.dart';
import 'package:marketingapp/widgets/custom_text.dart';

class CustomPopup {
  static void takeConfirmationDialog(Function cancelCallB, Function yesCallB,
      String dialogContent, String path, String buttonTxt, double buttonWidth) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                    onTap: () {
                      cancelCallB();
                      // Get.off(const DashScreen());
                    },
                    child: Icon(
                      Icons.cancel_outlined,
                      color: AppColor.secondaryColor,
                    )),
              ).paddingOnly(top: 4, right: 6),
              Image.asset(
                path,
                width: 70,
                height: 70,
              ),
              Column(
                children: [
                  CustomText(
                      text: dialogContent,
                      fontSize: 16,
                      fontFam: "Nunito Sans",
                      fontWeight: FontWeight.w400,
                      textColor: Colors.black,
                      textAlign: TextAlign.center),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        primColor: AppColor.primaryBackgroundColor,
                        secColor: AppColor.secondaryColor,
                        buttonText: buttonTxt,
                        path: 'assets/arrow_nav.svg',
                        callB: () {
                          yesCallB();
                        },
                        textColor: Colors.white,
                        iconColor: Colors.white,
                        buttonFontSize: 16,
                        buttonWidth: buttonWidth,
                      ),
                    ],
                  ).paddingOnly(top: 10)
                ],
              ).paddingOnly(top: 8, bottom: 14, left: 14, right: 14)
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void yesNoConfirmationDialog(
      Function cancelCallB,
      Function yesCallB,
      String dialogContent,
      String path,
      String buttonTxt,
      double buttonWidth,
      Function noCallBack,
      String noTxtButton) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                    onTap: () {
                      cancelCallB();
                      // Get.off(const DashScreen());
                    },
                    child: Icon(
                      Icons.cancel_outlined,
                      color: AppColor.secondaryColor,
                    )),
              ).paddingOnly(top: 4, right: 6),
              Image.asset(
                path,
                width: 70,
                height: 70,
              ),
              Column(
                children: [
                  CustomText(
                      text: dialogContent,
                      fontSize: 16,
                      fontFam: "Nunito Sans",
                      fontWeight: FontWeight.w400,
                      textColor: Colors.black,
                      textAlign: TextAlign.center),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        primColor: Colors.red,
                        secColor: AppColor.red,
                        buttonText: noTxtButton,
                        path: 'assets/cross.svg',
                        callB: () {
                          noCallBack();
                        },
                        textColor: Colors.white,
                        iconColor: Colors.white,
                        buttonFontSize: 16,
                        buttonWidth: buttonWidth,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      CustomButton(
                        primColor: AppColor.primaryBackgroundColor,
                        secColor: AppColor.secondaryColor,
                        buttonText: buttonTxt,
                        path: 'assets/check.svg',
                        callB: () {
                          yesCallB();
                        },
                        textColor: Colors.white,
                        iconColor: Colors.white,
                        buttonFontSize: 16,
                        buttonWidth: buttonWidth,
                      ),
                    ],
                  ).paddingOnly(top: 10)
                ],
              ).paddingOnly(top: 8, bottom: 14, left: 14, right: 14)
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void showSuccessSiteSelectedDialog({
    required String message,
    required VoidCallback onOkPressed,
    required String imgPath,
  }) {
    Get.dialog(
      Dialog(
        backgroundColor: AppColor.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(imgPath, width: 80, height: 80),
              const SizedBox(height: 16),
              CustomText(
                text: message,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                textColor: AppColor.black,
                textAlign: TextAlign.center,
                fontFam: 'Nunito Sans',
              ),
              const SizedBox(height: 16),
              CustomButton(
                textColor: AppColor.white,
                iconColor: AppColor.white,
                buttonText: 'OK',
                path: 'assets/success-check.png',
                callB: () {
                  onOkPressed();
                },
                buttonWidth: 120,
                primColor: AppColor.primaryBackgroundColor,
                secColor: AppColor.secondaryColor,
                buttonFontSize: 18,
              ).paddingSymmetric(horizontal: 70),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
