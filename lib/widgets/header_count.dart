import 'package:flutter/material.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/widgets/custom_text.dart';

class HeaderCount extends StatelessWidget {
  final String countHeading;
  final String count;
  final bool showSeperator;

  const HeaderCount(this.countHeading, this.count, this.showSeperator,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                text: countHeading,
                fontSize: 14,
                fontWeight: FontWeight.normal,
                textColor: AppColor.black,
                textAlign: TextAlign.center,
                fontFam: 'Nunito Sans',
              ),
              const SizedBox(height: 4),
              CustomText(
                text: count,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                textColor: AppColor.black,
                textAlign: TextAlign.center,
                fontFam: 'Nunito Sans',
              ),
            ],
          ),
        ),
        Visibility(
          visible: showSeperator,
          child: Container(
            height: 68,
            width: 1,
            color: AppColor.secondaryColor,
          ),
        ),
      ],
    );
  }
}

// class HeaderCount extends StatelessWidget {
//   final String countHeading;
//   final String count;
//   final bool showSeperator;
//
//   const HeaderCount(this.countHeading, this.count, this.showSeperator,
//       {super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Column(
//           children: [
//             CustomText(
//               text: countHeading,
//               fontSize: 14,
//               fontWeight: FontWeight.normal,
//               textColor: AppColor.black,
//               textAlign: TextAlign.right,
//               fontFam: 'Nunito Sans',
//             ),
//             CustomText(
//               text: count,
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//               textColor: AppColor.black,
//               textAlign: TextAlign.right,
//               fontFam: 'Nunito Sans',
//             ),
//           ],
//         ),
//         Visibility(
//           visible: showSeperator,
//           child: Container(
//             height: 68,
//             width: 1,
//             color: AppColor.secondaryColor,
//           ),
//         )
//       ],
//     );
//   }
// }
