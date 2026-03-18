import 'package:flutter/material.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/widgets/custom_text.dart';

class DataNotFound extends StatelessWidget {
  const DataNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/nodata.png'),
          const SizedBox(
            height: 20,
          ),
          CustomText(
              text: "Data Not Found",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              textColor: AppColor.black,
              textAlign: TextAlign.center, fontFam: "Nunito Sans"),
          const SizedBox(
            height: 20,
          ),
          CustomText(
              text:
              "Maybe go back and try\ndifferent keyword?",
              fontSize: 18,
              fontWeight: FontWeight.normal,
              textColor: AppColor.borderGrey,
              textAlign: TextAlign.center, fontFam: "Nunito Sans"),

        ],
      ),
    );
  }
}
