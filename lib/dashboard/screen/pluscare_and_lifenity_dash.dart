import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:marketingapp/availability/screen/availability_screen.dart';
import 'package:marketingapp/lab_accession/screen/receive_sample.dart';
import 'package:marketingapp/login/login_controller.dart';
import 'package:marketingapp/runnerboy/screen/sample_collection_start_route.dart';
import 'package:marketingapp/sample_collection_tracking/screen/sample_collection_tracking.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/widgets/dash_card.dart';
import 'package:marquee/marquee.dart';

class PlusCareAndLifenityDash extends StatelessWidget {
  final String designation;
  final Function? myVisitsCallB;

  const PlusCareAndLifenityDash({
    super.key,
    required this.designation,
    this.myVisitsCallB,
  });

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find<LoginController>();
    final isLoading = loginController.isDashLoading;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DashCardCounts(
                secondCountFontSize: 14.sp,
                secondCountTextFontSize: 12.sp,
                isLoading: isLoading,
                secondCount: formatLargeNumber(
                    loginController.mainDashBoardCount?.patientCount),
                secondCountText: "Patients",
                iconPath: 'assets/patients.svg',
                cardHeight: 100.h,
              ).paddingSymmetric(vertical: 8.h, horizontal: 8.w),
            ),
            Expanded(
              child: DashCardCounts(
                secondCountFontSize: 14.sp,
                secondCountTextFontSize: 12.sp,
                isLoading: isLoading,
                secondCount: formatLargeNumber(
                    loginController.mainDashBoardCount?.testReportedCount),
                secondCountText: "No. of Tests",
                iconPath: 'assets/testtube.svg',
                cardHeight: 100.h,
              ).paddingSymmetric(vertical: 8.h, horizontal: 10.w),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: DashCardCounts(
                secondCountFontSize: 14.sp,
                secondCountTextFontSize: 12.sp,
                isLoading: isLoading,
                secondCount: formatLargeNumber(
                    loginController.mainDashBoardCount?.facilityCount),
                secondCountText: "Customers",
                iconPath: 'assets/customer.svg',
                cardHeight: 100.h,
              ).paddingSymmetric(vertical: 8.h, horizontal: 10.w),
            ),
            Expanded(
              child: DashCardCounts(
                secondCountFontSize: 14.sp,
                secondCountTextFontSize: 12.sp,
                isLoading: isLoading,
                secondCount: formatLargeNumber(
                    loginController.mainDashBoardCount?.totalLab),
                secondCountText: "No. of Labs",
                iconPath: 'assets/labs.svg',
                cardHeight: 100.h,
              ).paddingSymmetric(vertical: 8.h, horizontal: 10.w),
            ),
          ],
        ),
        getCardsAccordingToUser(designation, isLoading),
        if (FlavorConfig.instance.name == "Lifenity Operational")
          const Spacer(),
        if (FlavorConfig.instance.name == "Lifenity Operational")
          SafeArea(
            bottom: true,
            top: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 6.w),
                padding: EdgeInsets.symmetric(vertical: 2.h),
                height: 24.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [
                      AppColor.primaryBackgroundColor,
                      AppColor.secondaryColor,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Marquee(
                  text:
                      "Covering 3500 Hospitals, reaching over 30000 medical professionals. Providing service to 25000+ patient per day",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.normal,
                    color: AppColor.white,
                  ),
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  blankSpace: 50.0,
                  velocity: 50.0,
                  pauseAfterRound: const Duration(seconds: 1),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget getCardsAccordingToUser(String type, bool isLoading) {
    switch (type) {
      case 'Manager':
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DashCard(
                    backGroundColorIcon: AppColor.secondaryColor,
                    secondCountFontSize: 18.sp,
                    secondCountTextFontSize: 14.sp,
                    secondCount: '0',
                    secondCountText: "Visit Dashboard",
                    iconPath: 'assets/addvisit.svg',
                    cardHeight: 75.h,
                    isLoading: isLoading,
                    onTap: () => myVisitsCallB?.call(),
                  ).paddingSymmetric(vertical: 8.h, horizontal: 10.w),
                ),
                Expanded(
                  child: SizedBox.shrink(),
                ),
                // Expanded(
                //   child: DashCard(
                //     onTap: () => Get.to(const SampleCollectionTracking()),
                //     secondCountFontSize: 18.sp,
                //     secondCountTextFontSize: 14.sp,
                //     secondCount: '0',
                //     secondCountText: "Sample\nCollection\nTracking",
                //     iconPath: 'assets/location-pin.svg',
                //     cardHeight: 75.h,
                //     backGroundColorIcon: AppColor.secondaryColor,
                //   ).paddingSymmetric(vertical: 8.h, horizontal: 10.w),
                // ),
              ],
            ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: DashCard(
            //         onTap: () => Get.to(const BusinessScreen()),
            //         backGroundColorIcon: AppColor.secondaryColor,
            //         secondCountFontSize: 18.sp,
            //         secondCountTextFontSize: 14.sp,
            //         secondCount: '0',
            //         secondCountText: "Business",
            //         iconPath: 'assets/briefcase.svg',
            //         cardHeight: 75.h,
            //       ).paddingSymmetric(vertical: 8.h, horizontal: 10.w),
            //     ),
            //     Expanded(
            //       child: SizedBox.shrink(),
            //     ),
            //   ],
            // ),
          ],
        );

      case 'Lab Sales Manager':
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DashCard(
                    backGroundColorIcon: AppColor.secondaryColor,
                    secondCountFontSize: 18.sp,
                    secondCountTextFontSize: 14.sp,
                    secondCount: '0',
                    secondCountText: "Visit Dashboard",
                    iconPath: 'assets/addvisit.svg',
                    cardHeight: 75.h,
                    isLoading: isLoading,
                    onTap: () => myVisitsCallB?.call(),
                  ).paddingSymmetric(vertical: 8.h, horizontal: 10.w),
                ),
                Expanded(child: SizedBox()

                    // DashCard(
                    //   onTap: () => Get.to(const SampleCollectionTracking()),
                    //   secondCountFontSize: 18.sp,
                    //   secondCountTextFontSize: 14.sp,
                    //   secondCount: '0',
                    //   secondCountText: "Sample\nCollection\nTracking",
                    //   iconPath: 'assets/location-pin.svg',
                    //   cardHeight: 75.h,
                    //   backGroundColorIcon: AppColor.secondaryColor,
                    // ).paddingSymmetric(vertical: 8.h, horizontal: 10.w),
                    ),
              ],
            ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: DashCard(
            //         onTap: () => Get.to(const BusinessScreen()),
            //         backGroundColorIcon: AppColor.secondaryColor,
            //         secondCountFontSize: 18.sp,
            //         secondCountTextFontSize: 14.sp,
            //         secondCount: '0',
            //         secondCountText: "Business",
            //         iconPath: 'assets/briefcase.svg',
            //         cardHeight: 75.h,
            //       ).paddingSymmetric(vertical: 8.h, horizontal: 10.w),
            //     ),
            //     Expanded(
            //       child: SizedBox.shrink(),
            //     ),
            //   ],
            // ),
          ],
        );

      case 'Marketing Executive':
        return Row(
          children: [
            Expanded(
              child: DashCard(
                backGroundColorIcon: AppColor.secondaryColor,
                secondCountFontSize: 18.sp,
                secondCountTextFontSize: 14.sp,
                secondCount: '0',
                secondCountText: (designation == "Manager" ||
                        designation == "Lab Sales Manager")
                    ? "Visit Dashboard"
                    : 'My Visits',
                iconPath: 'assets/addvisit.svg',
                cardHeight: 75.h,
                isLoading: isLoading,
                onTap: () => myVisitsCallB?.call(),
              ).paddingSymmetric(vertical: 8.h, horizontal: 10.w),
            ),
            Expanded(
              child: DashCard(
                onTap: () => Get.to(const AvailabilityScreen()),
                secondCountFontSize: 22,
                secondCountTextFontSize: 16,
                secondCount: '0',
                secondCountText: "Availability",
                iconPath: 'assets/activeclient.svg',
                cardHeight: 75,
                isLoading: isLoading,
                backGroundColorIcon: AppColor.secondaryColor,
              ).paddingSymmetric(vertical: 8, horizontal: 10),
            ),
          ],
        );

      case 'Runner Boy' || "runner boy":
        return Row(
          children: [
            Expanded(
              child: DashCard(
                onTap: () => Get.to(const SampleCollectionStartRoute()),
                backGroundColorIcon: AppColor.secondaryColor,
                secondCountFontSize: 18.sp,
                secondCountTextFontSize: 14.sp,
                secondCount: '0',
                secondCountText: "Sample\nCollection",
                iconPath: 'assets/location-pin.svg',
                cardHeight: 75.h,
                isLoading: isLoading,
              ).paddingSymmetric(vertical: 8.h, horizontal: 10.w),
            ),
            Expanded(
              child: DashCard(
                onTap: () => Get.to(const AvailabilityScreen()),
                secondCountFontSize: 22,
                secondCountTextFontSize: 16,
                secondCount: '0',
                secondCountText: "Availability",
                iconPath: 'assets/activeclient.svg',
                cardHeight: 75,
                isLoading: isLoading,
                backGroundColorIcon: AppColor.secondaryColor,
              ).paddingSymmetric(vertical: 8, horizontal: 10),
            ),
          ],
        );

      case 'Lab Accession Team':
        return Row(
          children: [
            Expanded(
              child: DashCard(
                onTap: () => Get.to(const ReceiveSampleScreen()),
                backGroundColorIcon: AppColor.secondaryColor,
                secondCountFontSize: 18.sp,
                secondCountTextFontSize: 14.sp,
                secondCount: '0',
                secondCountText: "Receive\nSample",
                iconPath: 'assets/location-pin.svg',
                cardHeight: 75.h,
                isLoading: isLoading,
              ).paddingSymmetric(vertical: 8.h, horizontal: 10.w),
            ),
            Expanded(
              child: DashCard(
                onTap: () => Get.to(const AvailabilityScreen()),
                secondCountFontSize: 22,
                secondCountTextFontSize: 16,
                secondCount: '0',
                secondCountText: "Availability",
                iconPath: 'assets/activeclient.svg',
                cardHeight: 75,
                isLoading: isLoading,
                backGroundColorIcon: AppColor.secondaryColor,
              ).paddingSymmetric(vertical: 8, horizontal: 10),
            ),
          ],
        );

      case 'Logistic Manager' || "Logistics Manager":
        return Row(
          children: [
            Expanded(
              child: DashCard(
                onTap: () => Get.to(const SampleCollectionStartRoute()),
                backGroundColorIcon: AppColor.secondaryColor,
                secondCountFontSize: 18.sp,
                secondCountTextFontSize: 14.sp,
                secondCount: '0',
                secondCountText: "Sample\nCollection",
                iconPath: 'assets/location-pin.svg',
                cardHeight: 75.h,
                isLoading: isLoading,
              ).paddingSymmetric(vertical: 8.h, horizontal: 10.w),
            ),
            Expanded(
              child: DashCard(
                onTap: () => Get.to(const SampleCollectionTracking()),
                secondCountFontSize: 18.sp,
                secondCountTextFontSize: 14.sp,
                secondCount: '0',
                secondCountText: "Sample\nCollection\nTracking",
                iconPath: 'assets/location-pin.svg',
                cardHeight: 75.h,
                isLoading: isLoading,
                backGroundColorIcon: AppColor.secondaryColor,
              ).paddingSymmetric(vertical: 8.h, horizontal: 10.w),
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  String formatLargeNumber(String? value) {
    if (value == null) return '-';
    final number = int.tryParse(value);
    if (number == null) return '-';

    if (number >= 10000000) {
      return "${(number / 10000000).toStringAsFixed(2)} Cr+";
    } else if (number >= 1000) {
      return "${(number / 1000).toStringAsFixed(1)} K+";
    } else {
      return number.toString();
    }
  }
}
