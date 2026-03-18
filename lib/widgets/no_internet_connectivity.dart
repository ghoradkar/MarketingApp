import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/widgets/custom_text.dart';

class InternetIssue extends StatelessWidget {
  // const InternetIssue({super.key});

  final Function onRetryPressed;

  const InternetIssue({super.key, required this.onRetryPressed});

  @override
  Widget build(BuildContext context) {
    final screenHeight = Get.height;
    final screenWidth = Get.width;
    return SizedBox(
      height: screenHeight / 1.19,
      width: screenWidth,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 30, bottom: 14, left: 14, right: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/internet.png",
              width: 350,
              height: 300,
            ),
            Center(
                child: CustomText(
              text: 'Oh No!',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              textColor: AppColor.black,
              textAlign: TextAlign.right,
              fontFam: 'Nunito Sans',
            )),
            Center(
                child: Column(
              children: [
                CustomText(
                  text: 'No Internet found.',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  textColor: AppColor.black,
                  textAlign: TextAlign.right,
                  fontFam: 'Nunito Sans',
                ),
                CustomText(
                  text: 'Check your connection or try again.',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  textColor: AppColor.black,
                  textAlign: TextAlign.right,
                  fontFam: 'Nunito Sans',
                ),
              ],
            )),
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: Get.width / 3.5,
                    height: Get.height / 20,
                    child: ElevatedButton(
                      onPressed: () async {
                        // onRetryPressed();

                        // Show loader for a few seconds
                        Get.defaultDialog(
                          title: "Loading",
                          content: const CircularProgressIndicator(),
                        );

                        // Wait for a few seconds
                        await Future.delayed(const Duration(seconds: 3));

                        // Close the loading dialog
                        Get.back();

                        // Call the retry function
                        onRetryPressed();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          backgroundColor: AppColor.secondaryColor,
                          foregroundColor: AppColor.secondaryColor),
                      child: CustomText(
                        text: 'Retry',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        textColor: AppColor.white,
                        textAlign: TextAlign.right,
                        fontFam: 'Nunito Sans',
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
