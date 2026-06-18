import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketingapp/login/login_controller.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/widgets/dash_card.dart';
import 'package:marquee/marquee.dart';
// import 'package:shimmer_animation/shimmer_animation.dart';

class HindLabDash extends StatelessWidget {
  final String designation;
  final Function? myVisitsCallB;

  const HindLabDash({super.key, required this.designation, this.myVisitsCallB});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find<LoginController>();
    final isLoading = loginController.mainDashBoardCount == null;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DashCardCounts(
                secondCountFontSize: 18,
                secondCountTextFontSize: 14,
                secondCount: isLoading
                    ? "0"
                    : formatNumber(
                        loginController.mainDashBoardCount?.patientCount),
                secondCountText: "Patients",
                iconPath: 'assets/patients.svg',
                cardHeight: 100,
              ).paddingSymmetric(vertical: 8, horizontal: 10),
            ),
            Expanded(
              child: DashCardCounts(
                secondCountFontSize: 18,
                secondCountTextFontSize: 14,
                secondCount: isLoading
                    ? "0"
                    : formatNumber(
                        loginController.mainDashBoardCount?.testReportedCount),
                secondCountText: "No. of Tests",
                iconPath: 'assets/testtube.svg',
                cardHeight: 100,
              ).paddingSymmetric(vertical: 8, horizontal: 10),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: DashCardCounts(
                secondCountFontSize: 18,
                secondCountTextFontSize: 14,
                secondCount: isLoading
                    ? "0"
                    : formatNumber(
                        loginController.mainDashBoardCount?.facilityCount),
                secondCountText: "Customers",
                iconPath: 'assets/customer.svg',
                cardHeight: 100,
              ).paddingSymmetric(vertical: 8, horizontal: 10),
            ),
            Expanded(
              child: DashCardCounts(
                secondCountFontSize: 18,
                secondCountTextFontSize: 14,
                secondCount: isLoading
                    ? "0"
                    : formatNumber(
                        loginController.mainDashBoardCount?.totalLab),
                secondCountText: "No. of Labs",
                iconPath: 'assets/labs.svg',
                cardHeight: 100,
              ).paddingSymmetric(vertical: 8, horizontal: 10),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: DashCard(
                backGroundColorIcon: AppColor.primaryBackgroundColor,
                secondCountFontSize: 18,
                secondCountTextFontSize: 14,
                secondCount: '0',
                secondCountText: (designation == "Manager" ||
                        designation == "Lab Sales Manager")
                    ? "Visit Dashboard"
                    : 'My Visits',
                iconPath: (designation == "Manager" ||
                        designation == "Lab Sales Manager")
                    ? 'assets/addvisit.svg'
                    : 'assets/addvisit.svg',
                cardHeight: 75,
                onTap: () {
                  if (myVisitsCallB != null) {
                    myVisitsCallB!();
                  }
                },
              ).paddingSymmetric(vertical: 8, horizontal: 10),
            ),

            // const Expanded(child: SizedBox()),
            ///commented for now
            Expanded(
              child: SizedBox.shrink(),
              // child: DashCard(
              //   onTap: () {
              //     Get.to(const AvailabilityScreen());
              //   },
              //   secondCountFontSize: 18,
              //   secondCountTextFontSize: 14,
              //   secondCount: '0',
              //   secondCountText: "Availability",
              //   iconPath: 'assets/activeclient.svg',
              //   cardHeight: 75,
              //   backGroundColorIcon: AppColor.primaryBackgroundColor,
              // ).paddingSymmetric(vertical: 8, horizontal: 10),
            ),
          ],
        ),

        ///commented for now
        // Visibility(
        //   visible: designation == "Manager",
        //   child: Row(
        //     children: [
        //       Expanded(
        //         child: DashCard(
        //           onTap: () {
        //             Get.to(const BusinessScreen());
        //           },
        //           backGroundColorIcon: AppColor.primaryBackgroundColor,
        //           secondCountFontSize: 22,
        //           secondCountTextFontSize: 16,
        //           secondCount: '0',
        //           secondCountText: "Business",
        //           iconPath: 'assets/briefcase.png',
        //           cardHeight: 75,
        //         ).paddingSymmetric(vertical: 8, horizontal: 10),
        //       ),
        //       Expanded(
        //         child: DashCard(
        //           onTap: () {
        //             Get.to(const AvailabilityScreen());
        //           },
        //           secondCountFontSize: 22,
        //           secondCountTextFontSize: 16,
        //           secondCount: '0',
        //           secondCountText: "Availability",
        //           iconPath: 'assets/user-check.png',
        //           cardHeight: 75,
        //           backGroundColorIcon: AppColor.primaryBackgroundColor,
        //         ).paddingSymmetric(vertical: 8, horizontal: 10),
        //       ),
        //     ],
        //   ),
        // ),
        // Visibility(
        //   visible: designation == "Manager",
        //   child: Row(
        //     children: [
        //       Expanded(
        //         child: DashCard(
        //           onTap: () {},
        //           backGroundColorIcon: AppColor.primaryBackgroundColor,
        //           secondCountFontSize: 22,
        //           secondCountTextFontSize: 16,
        //           secondCount: '0',
        //           secondCountText: "Availability\nDashboard",
        //           iconPath: 'assets/gallery.png',
        //           cardHeight: 75,
        //         ).paddingSymmetric(vertical: 8, horizontal: 10),
        //       ),
        //       Expanded(
        //           child: const SizedBox()
        //               .paddingSymmetric(vertical: 8, horizontal: 10)),
        //     ],
        //   ),
        // ),
        const Spacer(),
        SafeArea(
          bottom: true,
          top: false,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
              padding: const EdgeInsets.symmetric(vertical: 2),
              height: 24,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [
                      AppColor.primaryBackgroundColor,
                      AppColor.secondaryColor
                    ],
                    // Change colors as needed
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )),
              child: Marquee(
                text:
                    "Covering 3500 Hospitals, reaching over 30000 medical professionals. Providing service to 25000+ patient per day",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: AppColor.white),
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

  // Widget _buildShimmerCard() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
  //     child: Shimmer(
  //       color: Colors.grey.shade300,
  //       // highlightColor: Colors.grey.shade100,
  //       child: Container(
  //         height: 100,
  //         decoration: BoxDecoration(
  //             color: Colors.grey.shade300,
  //             borderRadius: BorderRadius.circular(12),
  //             border: Border.all(
  //                 color: AppColor.borderGrey.withValues(alpha: 0.2))),
  //       ),
  //     ),
  //   );
  // }

  String formatNumber(String? value) {
    if (value != null) {
      // Try to parse the input string to a number
      num? number = num.tryParse(value);

      // If parsing fails, return the original string
      if (number == null) return value;

      if (number >= 10000000) {
        // 1 Crore = 10,000,000
        return "${(number / 10000000).toStringAsFixed(1)} Cr +";
      } else if (number >= 100000) {
        // 1 Lakh = 100,000
        return "${(number / 100000).toStringAsFixed(1)} L +";
      } else if (number >= 1000) {
        // 1 Thousand = 1,000
        return "${(number / 1000).toStringAsFixed(1)} K +";
      } else {
        return number.toString(); // Return as it is
      }
    } else {
      return "";
    }
  }
}

// class HindLabDash extends StatelessWidget {
//   final String designation;
//   final Function? myVisitsCallB;
//
//   const HindLabDash({super.key, required this.designation, this.myVisitsCallB});
//
//   @override
//   Widget build(BuildContext context) {
//     final LoginController loginController = Get.find<LoginController>();
//     final isLoading = loginController.mainDashBoardCount == null;
//
//     return Column(
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: isLoading
//                   ? _buildShimmerCard()
//                   : DashCardCounts(
//                       secondCountFontSize: 18,
//                       secondCountTextFontSize: 14,
//                       secondCount: formatNumber(
//                           loginController.mainDashBoardCount?.patientCount),
//                       secondCountText: "Patients",
//                       iconPath: 'assets/patients.svg',
//                       cardHeight: 100,
//                     ).paddingSymmetric(vertical: 8, horizontal: 10),
//             ),
//             Expanded(
//               child: isLoading
//                   ? _buildShimmerCard()
//                   : DashCardCounts(
//                       secondCountFontSize: 18,
//                       secondCountTextFontSize: 14,
//                       secondCount: formatNumber(loginController
//                           .mainDashBoardCount?.testReportedCount),
//                       secondCountText: "No. of Tests",
//                       iconPath: 'assets/testtube.svg',
//                       cardHeight: 100,
//                     ).paddingSymmetric(vertical: 8, horizontal: 10),
//             ),
//           ],
//         ),
//         Row(
//           children: [
//             Expanded(
//               child: isLoading
//                   ? _buildShimmerCard()
//                   : DashCardCounts(
//                       secondCountFontSize: 18,
//                       secondCountTextFontSize: 14,
//                       secondCount: formatNumber(
//                           loginController.mainDashBoardCount?.facilityCount),
//                       secondCountText: "Customers",
//                       iconPath: 'assets/customer.svg',
//                       cardHeight: 100,
//                     ).paddingSymmetric(vertical: 8, horizontal: 10),
//             ),
//             Expanded(
//               child: isLoading
//                   ? _buildShimmerCard()
//                   : DashCardCounts(
//                       secondCountFontSize: 18,
//                       secondCountTextFontSize: 14,
//                       secondCount: formatNumber(
//                           loginController.mainDashBoardCount?.totalLab),
//                       secondCountText: "No. of Labs",
//                       iconPath: 'assets/labs.svg',
//                       cardHeight: 100,
//                     ).paddingSymmetric(vertical: 8, horizontal: 10),
//             ),
//           ],
//         ),
//         Row(
//           children: [
//             Expanded(
//               child: DashCard(
//                 backGroundColorIcon: AppColor.primaryBackgroundColor,
//                 secondCountFontSize: 18,
//                 secondCountTextFontSize: 14,
//                 secondCount: '0',
//                 secondCountText:
//                 (designation == "Manager" || designation == "Lab Sales Manager") ? "Visit Dashboard" : 'My Visits',
//                 iconPath: (designation == "Manager" || designation == "Lab Sales Manager")
//                     ? 'assets/addvisit.svg'
//                     : 'assets/addvisit.svg',
//                 cardHeight: 75,
//                 onTap: () {
//                   if (myVisitsCallB != null) {
//                     myVisitsCallB!();
//                   }
//                 },
//               ).paddingSymmetric(vertical: 8, horizontal: 10),
//             ),
//
//             // const Expanded(child: SizedBox()),
//             ///commented for now
//             Expanded(
//               child: SizedBox.shrink(),
//               // child: DashCard(
//               //   onTap: () {
//               //     Get.to(const AvailabilityScreen());
//               //   },
//               //   secondCountFontSize: 18,
//               //   secondCountTextFontSize: 14,
//               //   secondCount: '0',
//               //   secondCountText: "Availability",
//               //   iconPath: 'assets/activeclient.svg',
//               //   cardHeight: 75,
//               //   backGroundColorIcon: AppColor.primaryBackgroundColor,
//               // ).paddingSymmetric(vertical: 8, horizontal: 10),
//             ),
//           ],
//         ),
//
//         ///commented for now
//         // Visibility(
//         //   visible: designation == "Manager",
//         //   child: Row(
//         //     children: [
//         //       Expanded(
//         //         child: DashCard(
//         //           onTap: () {
//         //             Get.to(const BusinessScreen());
//         //           },
//         //           backGroundColorIcon: AppColor.primaryBackgroundColor,
//         //           secondCountFontSize: 22,
//         //           secondCountTextFontSize: 16,
//         //           secondCount: '0',
//         //           secondCountText: "Business",
//         //           iconPath: 'assets/briefcase.png',
//         //           cardHeight: 75,
//         //         ).paddingSymmetric(vertical: 8, horizontal: 10),
//         //       ),
//         //       Expanded(
//         //         child: DashCard(
//         //           onTap: () {
//         //             Get.to(const AvailabilityScreen());
//         //           },
//         //           secondCountFontSize: 22,
//         //           secondCountTextFontSize: 16,
//         //           secondCount: '0',
//         //           secondCountText: "Availability",
//         //           iconPath: 'assets/user-check.png',
//         //           cardHeight: 75,
//         //           backGroundColorIcon: AppColor.primaryBackgroundColor,
//         //         ).paddingSymmetric(vertical: 8, horizontal: 10),
//         //       ),
//         //     ],
//         //   ),
//         // ),
//         // Visibility(
//         //   visible: designation == "Manager",
//         //   child: Row(
//         //     children: [
//         //       Expanded(
//         //         child: DashCard(
//         //           onTap: () {},
//         //           backGroundColorIcon: AppColor.primaryBackgroundColor,
//         //           secondCountFontSize: 22,
//         //           secondCountTextFontSize: 16,
//         //           secondCount: '0',
//         //           secondCountText: "Availability\nDashboard",
//         //           iconPath: 'assets/gallery.png',
//         //           cardHeight: 75,
//         //         ).paddingSymmetric(vertical: 8, horizontal: 10),
//         //       ),
//         //       Expanded(
//         //           child: const SizedBox()
//         //               .paddingSymmetric(vertical: 8, horizontal: 10)),
//         //     ],
//         //   ),
//         // ),
//         const Spacer(),
//         SafeArea(
//           bottom: true,
//           top: false,
//           child: Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
//               padding: const EdgeInsets.symmetric(vertical: 2),
//               height: 24,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30),
//                   gradient: LinearGradient(
//                     colors: [
//                       AppColor.primaryBackgroundColor,
//                       AppColor.secondaryColor
//                     ],
//                     // Change colors as needed
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                   )),
//               child: Marquee(
//                 text:
//                     "Covering 3500 Hospitals, reaching over 30000 medical professionals. Providing service to 25000+ patient per day",
//                 style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.normal,
//                     color: AppColor.white),
//                 scrollAxis: Axis.horizontal,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 blankSpace: 50.0,
//                 velocity: 50.0,
//                 pauseAfterRound: const Duration(seconds: 1),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildShimmerCard() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//       child: Shimmer(
//         color: Colors.grey.shade300,
//         // highlightColor: Colors.grey.shade100,
//         child: Container(
//           height: 100,
//           decoration: BoxDecoration(
//               color: Colors.grey.shade300,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                   color: AppColor.borderGrey.withValues(alpha: 0.2))),
//         ),
//       ),
//     );
//   }
//
//   String formatNumber(String? value) {
//     if (value != null) {
//       // Try to parse the input string to a number
//       num? number = num.tryParse(value);
//
//       // If parsing fails, return the original string
//       if (number == null) return value;
//
//       if (number >= 10000000) {
//         // 1 Crore = 10,000,000
//         return "${(number / 10000000).toStringAsFixed(1)} Cr +";
//       } else if (number >= 100000) {
//         // 1 Lakh = 100,000
//         return "${(number / 100000).toStringAsFixed(1)} L +";
//       } else if (number >= 1000) {
//         // 1 Thousand = 1,000
//         return "${(number / 1000).toStringAsFixed(1)} K +";
//       } else {
//         return number.toString(); // Return as it is
//       }
//     } else {
//       return "";
//     }
//   }
// }
