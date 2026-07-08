// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:marketingapp/profile/controller/profile_controller.dart';
// import 'package:marketingapp/profile/profile_tab.dart';
// import 'package:marketingapp/utils/color_constants.dart';
// import 'package:marketingapp/widgets/custom_text.dart';
//
// class ProfileBankDetails extends StatefulWidget {
//   final dynamic userData;
//
//   const ProfileBankDetails({super.key, this.userData});
//
//   @override
//   State<ProfileBankDetails> createState() => _ProfileBankDetailsState();
// }
//
// class _ProfileBankDetailsState extends State<ProfileBankDetails>
//     with TickerProviderStateMixin {
//   late final TabController tabController;
//   final ProfileController profileController = Get.put(ProfileController());
//
//   @override
//   void initState() {
//     tabController = TabController(length: 1, vsync: this);
//     tabController.addListener(() {
//       // collectSampleController.update();
//     });
//
//     // checkInternetAndLoadData();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 AppColor.primaryBackgroundColor.withValues(alpha: 0.3),
//                 AppColor.secondaryColor.withValues(alpha: 0.3)
//                 // AppColor.primaryBackgroundColor.withValues(alpha: 0.3),
//                 // AppColor.secondaryColor.withValues(alpha: 0.3)
//               ],
//               // Change colors as needed
//               begin: Alignment.centerLeft,
//               end: Alignment.centerRight,
//             ),
//           ),
//         ),
//         title: CustomText(
//           text: 'My Profile',
//           fontSize: 18,
//           fontWeight: FontWeight.w500,
//           textColor: AppColor.black,
//           textAlign: TextAlign.start,
//           fontFam: 'Nunito Sans',
//         ),
//         leading: IconButton(
//             onPressed: () {
//               Get.back();
//             },
//             icon: const Icon(Icons.arrow_back)),
//       ),
//       body: GetBuilder(
//           init: profileController,
//           builder: (controller) {
//             return Column(
//               children: [
//                 TabBar(
//                   controller: tabController,
//                   isScrollable: false,
//                   // Ensures no extra space
//                   dividerColor: Colors.transparent,
//                   indicatorColor: Colors.transparent,
//                   padding: EdgeInsets.zero,
//                   indicatorPadding: EdgeInsets.zero,
//                   labelPadding: EdgeInsets.zero,
//                   tabs: [
//                     buildTab(0, "Personal Details"),
//                     // buildTab(1, "Bank Details"),
//                   ],
//                 ).paddingSymmetric(vertical: 10, horizontal: 10),
//                 Expanded(
//                   child: TabBarView(
//                     controller: tabController,
//                     children: [
//                       ProfileScreenTab(
//                         userData: widget.userData,
//                       ),
//                       // BankDetailsProfileScreen(
//                       //   userData: widget.userData,
//                       // )
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           }),
//     );
//   }
//
//   Widget buildTab(int index, String text) {
//     bool isSelected = tabController.index == index;
//     return Container(
//       // width: MediaQuery.of(context).size.width * 0.45,
//       padding: const EdgeInsets.symmetric(vertical: 14),
//       decoration: BoxDecoration(
//         gradient: isSelected
//             ? LinearGradient(
//                 colors: [
//                   AppColor.primaryBackgroundColor,
//                   AppColor.secondaryColor
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomCenter,
//               )
//             : const LinearGradient(
//                 colors: [
//                   Colors.transparent,
//                   Colors.transparent,
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomCenter,
//               ),
//         borderRadius: setBorderRadiusIndexWise(index),
//         border: Border.all(color: const Color(0xffE1E1E1)),
//       ),
//       child: Center(
//         child: CustomText(
//           text: text,
//           fontSize: 12.0,
//           fontFam: 'Lato',
//           fontWeight: FontWeight.normal,
//           textColor: isSelected ? Colors.white : const Color(0xff777777),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     );
//   }
//
//   setBorderRadiusIndexWise(index) {
//     if (index == 0) {
//       return const BorderRadius.only(
//           topLeft: Radius.circular(10), bottomLeft: Radius.circular(10));
//     } else if (index == 1) {
//       // return BorderRadius.zero;
//       return const BorderRadius.only(
//           topRight: Radius.circular(10), bottomRight: Radius.circular(10));
//     }
//   }
// }
