import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketingapp/dashboard/screen/my_visits_screen.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/widgets/custom_text.dart';
import 'package:marquee/marquee.dart';

class UAEDash extends StatelessWidget {
  final String designation;

  const UAEDash({super.key, required this.designation});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          child: InkWell(
            onTap: () {
              Get.toNamed(
                MyVisitsScreen.routeName,
                arguments: {
                  'appBarTitle': (designation == "Manager" || designation == "Lab Sales Manager")
                      ? "Visit Dashboard"
                      : 'My Visits',
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [
                    AppColor.primaryBackgroundColor.withValues(alpha: 0.7),
                    AppColor.secondaryColor.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Image.asset(
                    (designation == "Manager" || designation == "Lab Sales Manager")
                        ? 'assets/visit_dash.png'
                        : 'assets/my_visits.png',
                  ),
                  // CommonSvg(
                  //   path: designation == "Manager"
                  //       ? 'assets/visit_dash.svg'
                  //       : 'assets/my_visits.svg',
                  //   width: 50,
                  //   height: 50,
                  //   parentWidth: 50,
                  //   parentHeight: 50,
                  //   color: AppColor.white,
                  // ),
                  const SizedBox(height: 10),
                  CustomText(
                    text: (designation == "Manager" ||  designation == "Lab Sales Manager")
                        ? "Visit Dashboard"
                        : 'My Visits',
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    textColor: AppColor.white,
                    textAlign: TextAlign.start,
                    fontFam: 'Nunito Sans',
                  ),
                ],
              ),
            ),
          ),
        ),
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
                    AppColor.secondaryColor,
                  ],
                  // Change colors as needed
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Marquee(
                text:
                    "Establishing U.A.E as the most Innovative Healthcare System on the Global Map Healthcare",
                style: TextStyle(
                  fontSize: 16,
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

  // Widget _buildShimmerCard() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
  //     child: Shimmer(
  //       color: Colors.grey.shade300,
  //       // highlightColor: Colors.grey.shade100,
  //       child: Container(
  //         height: 100,
  //         decoration: BoxDecoration(
  //           color: Colors.grey.shade300,
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
