import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final String fontFam;
  final Color textColor;
  final int? maxLine;

  const CustomText(
      {super.key,
      required this.text,
      required this.fontSize,
      required this.fontFam,
      required this.fontWeight,
      required this.textColor,
      required this.textAlign,
      this.maxLine});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLine,
      style: TextStyle(
          fontSize: fontSize,
          fontFamily: fontFam,
          fontWeight: fontWeight,
          color: textColor),
      textAlign: textAlign,
    );
  }
}

class CustomTextRichText extends StatelessWidget {
  final String textHeading;
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final TextAlign textAlign;
  final FontWeight fontWeightHeading;
  final Color textColorHeading;
  final int? maxLines;

  const CustomTextRichText({
    super.key,
    required this.textHeading,
    required this.text,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.textColor = Colors.black,
    this.textAlign = TextAlign.start,
    this.fontWeightHeading = FontWeight.w600,
    this.textColorHeading = Colors.black,
    this.maxLines = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: textHeading,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeightHeading,
              color: textColorHeading,
              fontFamily: "Nunito Sans",
            ),
          ),
          const TextSpan(text: ' '),
          TextSpan(
            text: text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: textColor,
              fontFamily: "Nunito Sans",
            ),
          ),
        ],
      ),
      maxLines: maxLines,
      overflow: maxLines == null ? TextOverflow.visible : TextOverflow.ellipsis,
      softWrap: true,
      textAlign: textAlign,
    );
  }
}


// class CustomTextRichText extends StatelessWidget {
//   final String textHeading;
//   final String text;
//   final double fontSize;
//   final FontWeight fontWeight;
//   final FontWeight fontWeightHeading;
//   final TextAlign textAlign;
//   final String fontFam;
//   final Color textColor;
//   final Color textColorHeading;
//
//   const CustomTextRichText(
//       {super.key,
//       required this.textHeading,
//       required this.fontSize,
//       required this.fontFam,
//       required this.fontWeight,
//       required this.textColor,
//       required this.textAlign,
//       required this.text,
//       required this.fontWeightHeading,
//       required this.textColorHeading});
//
//   @override
//   Widget build(BuildContext context) {
//     return RichText(
//       text: TextSpan(
//         children: [
//           TextSpan(
//             text: "$textHeading :",
//             style: TextStyle(
//               fontWeight: fontWeightHeading, // Makes text bold
//               color: textColorHeading, // Default text color
//               fontSize: 16,
//             ),
//           ),
//           TextSpan(
//             text: text,
//             style: TextStyle(
//               fontWeight: fontWeight, // Makes text bold
//               color: textColor, // Default text color
//
//               fontSize: 16,
//             ),
//           ),
//         ],
//       ),
//     ).paddingSymmetric(vertical: 10, horizontal: 6);
//   }
// }
