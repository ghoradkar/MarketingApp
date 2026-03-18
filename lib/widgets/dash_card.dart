import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/widgets/common_svg.dart';
import 'package:marketingapp/widgets/custom_text.dart';

class VisitDashCardCounts extends StatelessWidget {
  final String? secondCount;
  final String? pendingCount;
  final String? complateCount;
  final String? firstCountText;
  final String? secondCountText;
  final String iconPath;
  final bool? isVisiableRow;
  final bool? isTodaysVisit;
  final bool? isVisiableCol;
  final double cardHeight;
  final double secondCountFontSize;
  final double secondCountTextFontSize;
  final Function? onClicked;
  final Color? cardColor;

  const VisitDashCardCounts({
    super.key,
    this.secondCount,
    this.firstCountText,
    this.secondCountText,
    required this.iconPath,
    this.isVisiableRow,
    this.pendingCount,
    this.complateCount,
    this.isVisiableCol,
    required this.cardHeight,
    required this.secondCountFontSize,
    required this.secondCountTextFontSize,
    this.isTodaysVisit,
    this.onClicked,
    this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClicked!();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: cardColor ?? Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CommonSvg(
              path: iconPath,
              width: 34,
              height: 34,
              parentWidth: 34,
              parentHeight: 34,
              color: AppColor.black,
            ).paddingOnly(right: 20, left: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: secondCount ?? "",
                    fontSize: secondCountFontSize,
                    fontWeight: FontWeight.bold,
                    textColor: AppColor.black,
                    textAlign: TextAlign.start,
                    fontFam: 'Nunito Sans',
                  ).paddingOnly(bottom: 10, left: 4),
                  CustomText(
                    text: secondCountText ?? "",
                    fontSize: secondCountTextFontSize,
                    fontWeight: FontWeight.normal,
                    textColor: AppColor.black,
                    textAlign: TextAlign.start,
                    fontFam: 'Nunito Sans',
                  ).paddingOnly(left: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashCard extends StatelessWidget {
  final String? secondCount;
  final String? pendingCount;
  final String? complateCount;
  final String? firstCountText;
  final String? secondCountText;
  final String iconPath;
  final bool? isVisiableRow;
  final bool? isVisiableCol;
  final double cardHeight;
  final double secondCountFontSize;
  final double secondCountTextFontSize;
  final Function onTap;
  final Color backGroundColorIcon;

  const DashCard({
    super.key,
    this.secondCount,
    this.firstCountText,
    this.secondCountText,
    required this.iconPath,
    this.isVisiableRow,
    this.pendingCount,
    this.complateCount,
    this.isVisiableCol,
    required this.cardHeight,
    required this.secondCountFontSize,
    required this.secondCountTextFontSize,
    required this.backGroundColorIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.borderGrey.withValues(alpha: 0.5)),
          color: Colors.white24,
        ),
        child: Row(
          children: [
            Container(
              width: 60.w,
              alignment: Alignment.center,
              height: double.infinity,
              decoration: BoxDecoration(
                color: backGroundColorIcon,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CommonSvg(
                path: iconPath,
                width: 26.w,
                height: 26.h,
                parentWidth: 30.w,
                parentHeight: 30.h,
                color: AppColor.white,
              ),
            ),
            Expanded(
              child: CustomText(
                text: secondCountText ?? "",
                fontSize: secondCountTextFontSize,
                fontWeight: FontWeight.normal,
                textColor: AppColor.black,
                textAlign: TextAlign.start,
                fontFam: 'Nunito Sans',
              ).paddingOnly(left: 8.w, right: 8.w),
            ),
          ],
        ),
      ),
    );
  }
}

class DashCardCounts extends StatelessWidget {
  final String? secondCount;
  final String? pendingCount;
  final String? complateCount;
  final String? firstCountText;
  final String? secondCountText;
  final String iconPath;
  final bool? isVisiableRow;
  final bool? isTodaysVisit;
  final bool? isVisiableCol;
  final double cardHeight;
  final double secondCountFontSize;
  final double secondCountTextFontSize;
  final Function? onClicked;

  // final Color? cardColor;

  const DashCardCounts({
    super.key,
    this.secondCount,
    this.firstCountText,
    this.secondCountText,
    required this.iconPath,
    this.isVisiableRow,
    this.pendingCount,
    this.complateCount,
    this.isVisiableCol,
    required this.cardHeight,
    required this.secondCountFontSize,
    required this.secondCountTextFontSize,
    this.isTodaysVisit,
    this.onClicked,
    // this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClicked!();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        height: cardHeight,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Color(0xffF5F5F5),
            border:
                Border.all(color: AppColor.borderGrey.withValues(alpha: 0.2))),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // Space between each child
          children: [
            // Image.asset(
            //   iconPath,
            //   color: AppColor.primaryBackgroundColor,
            //   width: 36,
            // ),
            CommonSvg(
              path: iconPath,
              width: 30.w,
              height: 30.h,
              parentWidth: 30.w,
              parentHeight: 30.h,
              color: AppColor.primaryBackgroundColor,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              // Center contents vertically
              children: [
                CustomText(
                  text: secondCount ?? "",
                  fontSize: secondCountFontSize,
                  fontWeight: FontWeight.bold,
                  textColor: AppColor.black,
                  textAlign: TextAlign.start,
                  fontFam: 'Nunito Sans',
                ).paddingOnly(bottom: 10.h, left: 8.w),
                CustomText(
                  text: secondCountText ?? "",
                  fontSize: secondCountTextFontSize,
                  fontWeight: FontWeight.normal,
                  textColor: AppColor.black,
                  textAlign: TextAlign.start,
                  fontFam: 'Nunito Sans',
                ).paddingOnly(left: 8.w),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
