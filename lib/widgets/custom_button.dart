import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marketingapp/widgets/common_svg.dart';
import 'package:marketingapp/widgets/custom_text.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final String path;
  final Function? callB;
  final double buttonWidth;
  final double buttonFontSize;
  final Color primColor;
  final Color secColor;
  final Color textColor;
  final Color iconColor;
  final bool? isLoading;

  const CustomButton(
      {super.key,
      required this.buttonText,
      required this.path,
      required this.callB,
      required this.buttonWidth,
      required this.primColor,
      required this.secColor,
      required this.textColor,
      required this.iconColor,
      this.isLoading,
      required this.buttonFontSize});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (callB != null) {
          callB!();
        }
      },
      child: Container(
          padding:  EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
          alignment: Alignment.center,
          width: buttonWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [primColor, secColor],
              // begin: Alignment.topLeft,
              // end: Alignment.bottomCenter,
            ),
          ),
          child: isLoading == true
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomText(
                        text: buttonText,
                        fontSize: buttonFontSize,
                        fontFam: "Nunito Sans",
                        fontWeight: FontWeight.normal,
                        textColor: textColor,
                        textAlign: TextAlign.center),
                     SizedBox(
                      width: 2.w,
                    ),
                    CommonSvg(
                      path: path,
                      width: 20.w,
                      height: 20.h,
                      parentWidth: 24.w,
                      parentHeight: 24.h,
                      color: iconColor,
                    ),
                    // Image.asset(
                    //   path,
                    //   color: iconColor,
                    // ),
                  ],
                )),
    );
  }
}
