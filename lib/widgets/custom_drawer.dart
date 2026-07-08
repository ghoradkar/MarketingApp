import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get/get.dart';
import 'package:marketingapp/change_password/screen/change_password.dart';
import 'package:marketingapp/login/screen/logout_screen.dart';
import 'package:marketingapp/profile/screen/profile_screen.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/widgets/common_svg.dart';
import 'package:marketingapp/widgets/custom_text.dart';

class CustomDrawer extends StatefulWidget {
  final dynamic userData;
  final String? version;
  final String? buildNumber;

  const CustomDrawer({
    super.key,
    this.userData,
    this.version,
    this.buildNumber,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    // ✅ Safe access to name and designation
    final outputList = widget.userData?['output'];
    final name = (outputList is List && outputList.isNotEmpty)
        ? outputList[0]['name'] ?? "User Name"
        : "User Name";
    final designation = (outputList is List && outputList.isNotEmpty)
        ? outputList[0]['Designation'] ?? "Designation"
        : "Designation";

    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        AppColor.primaryBackgroundColor,
                        AppColor.secondaryColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      Icon(Icons.account_circle,
                          size: 80, color: AppColor.white),
                      const SizedBox(height: 10),
                      CustomText(
                        text: name,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        textColor: AppColor.white,
                        textAlign: TextAlign.center,
                        fontFam: 'Nunito Sans',
                      ),
                      const SizedBox(height: 5),
                      CustomText(
                        text: '($designation)',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        textColor: AppColor.white,
                        textAlign: TextAlign.center,
                        fontFam: 'Nunito Sans',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                /// Profile
                _drawerItem(
                  iconPath: 'assets/username.svg',
                  title: 'Profile',
                  onTap: () {
                    Get.back();
                    if (FlavorConfig.instance.name == 'PlusCare Operational') {
                      Get.to(ProfileScreen(userData: widget.userData));
                    } else {
                      Get.to(ProfileScreen(userData: widget.userData));
                    }
                  },
                ),
                /// Change Password
                _drawerItem(
                  iconPath: 'assets/change_pass.svg',
                  title: 'Change Password',
                  onTap: () {
                    Get.back();
                    Get.to(ChangePassword(userData: widget.userData));
                  },
                ),

                /// Logout
                _drawerItem(
                  iconPath: 'assets/logout.svg',
                  title: 'Logout',
                  onTap: () {
                    Get.back();
                    Get.to(const LogoutScreen());
                  },
                ),
              ],
            ),
          ),

          /// Footer: App Version
          SafeArea(
            bottom: true,
            top: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: CustomText(
                text: widget.version != null ? "Version : ${widget.version}" : '',
                fontSize: 16,
                fontFam: 'Nunito Sans',
                fontWeight: FontWeight.normal,
                textColor: AppColor.black,
                textAlign: TextAlign.center,
              ),
            ).paddingOnly(bottom: 8),
          ),
        ],
      ),
    );
  }

  /// 🔹 Drawer item builder
  Widget _drawerItem({
    required String iconPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          CommonSvg(
            path: iconPath,
            width: 26,
            height: 26,
            parentWidth: 30,
            parentHeight: 30,
            color: AppColor.primaryBackgroundColor,
          ),
          CustomText(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.normal,
            textColor: AppColor.black,
            textAlign: TextAlign.start,
            fontFam: 'Nunito Sans',
          ).paddingOnly(left: 10),
        ],
      ).paddingSymmetric(vertical: 12, horizontal: 10),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_flavor/flutter_flavor.dart';
// import 'package:get/get.dart';
// import 'package:marketingapp/change_password/change_password.dart';
// import 'package:marketingapp/dashboard/dashboard_screen.dart';
// import 'package:marketingapp/login/logout_screen.dart';
// import 'package:marketingapp/profile/profile_bank_details.dart';
// import 'package:marketingapp/profile/profile_screen.dart';
// import 'package:marketingapp/utils/color_constants.dart';
// import 'package:marketingapp/widgets/common_svg.dart';
// import 'package:marketingapp/widgets/custom_text.dart';
//
// class CustomDrawer extends StatefulWidget {
//   final dynamic userData;
//   final String? version;
//   final String? buildNumber;
//
//   const CustomDrawer(
//       {super.key, this.userData, this.version, this.buildNumber});
//
//   @override
//   State<CustomDrawer> createState() => _CustomDrawerState();
// }
//
// class _CustomDrawerState extends State<CustomDrawer> {
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                 // Custom Header with Gradient and Centered Content
//                 Container(
//                   padding: const EdgeInsets.symmetric(vertical: 20),
//                   decoration: BoxDecoration(
//                     borderRadius: const BorderRadius.only(
//                         bottomLeft: Radius.circular(24),
//                         bottomRight: Radius.circular(24)),
//                     gradient: LinearGradient(
//                       colors: [
//                         AppColor.primaryBackgroundColor,
//                         // Replace with your gradient start color
//                         AppColor.secondaryColor,
//                         // Replace with your gradient end color
//                       ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const SizedBox(
//                         height: 30,
//                       ),
//                       Icon(
//                         Icons.account_circle,
//                         size: 80,
//                         color: AppColor.white,
//                       ),
//                       const SizedBox(height: 10),
//                       CustomText(
//                         text:
//                             widget.userData['output'][0]['name'] ?? "User Name",
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         textColor: AppColor.white,
//                         textAlign: TextAlign.center,
//                         fontFam: 'Nunito Sans',
//                       ),
//                       const SizedBox(height: 5),
//                       CustomText(
//                         text:
//                             '(${widget.userData['output'][0]['Designation'] ?? "Designation"})',
//                         fontSize: 16,
//                         fontWeight: FontWeight.normal,
//                         textColor: AppColor.white,
//                         textAlign: TextAlign.center,
//                         fontFam: 'Nunito Sans',
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     Get.back();
//                     // Get.to(const DashboardScreen());
//                     Get.toNamed(DashboardScreen.routeName);
//                   },
//                   child: Row(
//                     children: [
//                       CommonSvg(
//                         path: 'assets/screen.svg',
//                         width: 26,
//                         height: 26,
//                         parentWidth: 30,
//                         parentHeight: 30,
//                         color: AppColor.primaryBackgroundColor,
//                       ),
//                       // Image.asset(
//                       //   'assets/screen.png',
//                       //   color: AppColor.primaryBackgroundColor,
//                       // ),
//                       CustomText(
//                         text: 'Dashboard',
//                         fontSize: 16,
//                         fontWeight: FontWeight.normal,
//                         textColor: AppColor.black,
//                         textAlign: TextAlign.start,
//                         fontFam: 'Nunito Sans',
//                       ).paddingOnly(left: 10),
//                     ],
//                   ).paddingSymmetric(vertical: 12, horizontal: 10),
//                 ),
//                 InkWell(
//                   onTap: () {
//                     Get.back();
//                     if (FlavorConfig.instance.name == 'PlusCare Operational') {
//                       Get.to(ProfileBankDetails(
//                         userData: widget.userData,
//                       ));
//                     } else {
//                       Get.to(ProfileScreen(
//                         userData: widget.userData,
//                       ));
//                     }
//                   },
//                   child: Row(
//                     children: [
//                       // Image.asset('assets/users-group.png',
//                       //     color: AppColor.primaryBackgroundColor),
//                       CommonSvg(
//                         path: 'assets/username.svg',
//                         width: 26,
//                         height: 26,
//                         parentWidth: 30,
//                         parentHeight: 30,
//                         color: AppColor.primaryBackgroundColor,
//                       ),
//                       CustomText(
//                         text: 'Profile',
//                         fontSize: 16,
//                         fontWeight: FontWeight.normal,
//                         textColor: AppColor.black,
//                         textAlign: TextAlign.start,
//                         fontFam: 'Nunito Sans',
//                       ).paddingOnly(left: 10),
//                     ],
//                   ).paddingSymmetric(vertical: 12, horizontal: 10),
//                 ),
//                 InkWell(
//                   onTap: () {
//                     Get.back();
//                     Get.to(ChangePassword(
//                       userData: widget.userData,
//                     ));
//                   },
//                   child: Row(
//                     children: [
//                       // Image.asset('assets/change_pass.svg',
//                       //     color: AppColor.primaryBackgroundColor),
//                       CommonSvg(
//                         path: 'assets/change_pass.svg',
//                         width: 26,
//                         height: 26,
//                         parentWidth: 30,
//                         parentHeight: 30,
//                         color: AppColor.primaryBackgroundColor,
//                       ),
//                       CustomText(
//                         text: 'Change Password',
//                         fontSize: 16,
//                         fontWeight: FontWeight.normal,
//                         textColor: AppColor.black,
//                         textAlign: TextAlign.start,
//                         fontFam: 'Nunito Sans',
//                       ).paddingOnly(left: 10),
//                     ],
//                   ).paddingSymmetric(vertical: 12, horizontal: 10),
//                 ),
//                 InkWell(
//                   onTap: () async {
//                     // final prefs = await SharedPreferences.getInstance();
//                     Get.back();
//                     Get.to(const LogoutScreen());
//                   },
//                   child: Row(
//                     children: [
//                       // Image.asset('assets/logout.png',
//                       //     color: AppColor.primaryBackgroundColor),
//                       CommonSvg(
//                         path: 'assets/logout.svg',
//                         width: 26,
//                         height: 26,
//                         parentWidth: 30,
//                         parentHeight: 30,
//                         color: AppColor.primaryBackgroundColor,
//                       ),
//                       CustomText(
//                         text: 'Logout',
//                         fontSize: 16,
//                         fontWeight: FontWeight.normal,
//                         textColor: AppColor.black,
//                         textAlign: TextAlign.start,
//                         fontFam: 'Nunito Sans',
//                       ).paddingOnly(left: 10),
//                     ],
//                   ).paddingSymmetric(vertical: 12, horizontal: 10),
//                 ),
//               ],
//             ),
//           ),
//           SafeArea(
//             bottom: true,
//             top: false,
//             child: Align(
//               alignment: Alignment.bottomCenter,
//               child: CustomText(
//                   text: (widget.version != null)
//                       ? "Version : ${widget.version}"
//                       : '',
//                   fontSize: 16,
//                   fontFam: 'Nunito Sans',
//                   fontWeight: FontWeight.normal,
//                   textColor: AppColor.black,
//                   textAlign: TextAlign.center),
//             ).paddingOnly(bottom: 8),
//           )
//         ],
//       ),
//     );
//   }
// }
