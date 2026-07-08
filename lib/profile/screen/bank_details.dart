// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:marketingapp/profile/controller/profile_controller.dart';
// import 'package:marketingapp/utils/color_constants.dart';
// import 'package:marketingapp/widgets/common_svg.dart';
// import 'package:marketingapp/widgets/custom_text_field.dart';
// import 'package:marketingapp/widgets/no_internet_connectivity.dart';
//
// class BankDetailsProfileScreen extends StatefulWidget {
//   final dynamic userData;
//
//   const BankDetailsProfileScreen({super.key, this.userData});
//
//   @override
//   State<BankDetailsProfileScreen> createState() =>
//       _BankDetailsProfileScreenState();
// }
//
// class _BankDetailsProfileScreenState extends State<BankDetailsProfileScreen> {
//   final ProfileController profileController = Get.find();
//
//   @override
//   void initState() {
//     setDetails();
//     checkInternetAndLoadData();
//     super.initState();
//   }
//
//   checkInternetAndLoadData() async {
//     final List<ConnectivityResult> connectivityResult =
//         await (Connectivity().checkConnectivity());
//     if (connectivityResult.contains(ConnectivityResult.mobile) ||
//         connectivityResult.contains(ConnectivityResult.wifi)) {
//       profileController.hasInternet = true;
//     } else {
//       profileController.hasInternet = false;
//     }
//     profileController.update();
//     if (profileController.hasInternet) {
//       await profileController.getBankDetailsList();
//     }
//   }
//
//   setDetails() {
//     profileController.selectedBank =
//         widget.userData['output'][0]['bankname'] == "NA"
//             ? null
//             : widget.userData['output'][0]['bankname'];
//
//     profileController.accNo.text =
//         widget.userData['output'][0]['accountno'] == "NA"
//             ? ""
//             : widget.userData['output'][0]['accountno'];
//
//     profileController.ifscNo.text =
//         widget.userData['output'][0]['ifsccode'] == "NA"
//             ? ""
//             : widget.userData['output'][0]['ifsccode'];
//     profileController.baranchName.text =
//         widget.userData['output'][0]['branchname'] == "NA"
//             ? ""
//             : widget.userData['output'][0]['branchname'];
//
//     profileController.bankAddress.text =
//         widget.userData['output'][0]['bankaddress'] == "NA"
//             ? ""
//             : widget.userData['output'][0]['bankaddress'];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return profileController.hasInternet
//         ? SingleChildScrollView(
//             child: Column(
//               children: [
//                 CustomTextField(
//                   // txtController: profileController.accNo,
//                   initialValue: profileController.selectedBank,
//                   autofocus: false,
//                   labelText: 'Bank name',
//                   hintText: 'Bank name',
//                   isRequired: false,
//                   keyBoardType: TextInputType.streetAddress,
//                   fillColor: AppColor.white,
//                   isReadOnly: true,
//                   maxLines: 1,
//                   fontSize: 16,
//                   prefixIcon: Icon(
//                     Icons.account_balance,
//                     color: AppColor.primaryBackgroundColor,
//                   ),
//                 ),
//
//                 CustomTextField(
//                   txtController: profileController.accNo,
//                   // initialValue: widget.userData['output'][0]['FirstName'],
//                   autofocus: false,
//                   labelText: 'Account Number',
//                   hintText: 'Account Number',
//                   isRequired: false,
//                   keyBoardType: TextInputType.streetAddress,
//                   fillColor: AppColor.white,
//                   isReadOnly: true,
//                   maxLines: 1,
//                   fontSize: 16,
//                   prefixIcon: CommonSvg(
//                     path: "assets/username.svg",
//                     width: 30,
//                     height: 30,
//                     parentWidth: 30,
//                     parentHeight: 30,
//                     color: AppColor.primaryBackgroundColor,
//                   ),
//                 ),
//                 CustomTextField(
//                   // initialValue: widget.userData['output'][0]['MiddleName'],
//                   txtController: profileController.ifscNo,
//                   autofocus: false,
//                   labelText: 'IFSC Code',
//                   hintText: 'IFSC Code',
//                   isRequired: false,
//                   keyBoardType: TextInputType.streetAddress,
//                   fillColor: AppColor.white,
//                   isReadOnly: true,
//                   maxLines: 1,
//                   fontSize: 16,
//                   prefixIcon: CommonSvg(
//                     path: "assets/username.svg",
//                     width: 30,
//                     height: 30,
//                     parentWidth: 30,
//                     parentHeight: 30,
//                     color: AppColor.primaryBackgroundColor,
//                   ),
//                 ),
//                 CustomTextField(
//                   txtController: profileController.baranchName,
//                   // initialValue: widget.userData['output'][0]['LastName'],
//                   autofocus: false,
//                   labelText: 'Branch Name',
//                   hintText: 'Branch Name',
//                   isRequired: false,
//                   keyBoardType: TextInputType.streetAddress,
//                   fillColor: AppColor.white,
//                   isReadOnly: true,
//                   maxLines: 1,
//                   fontSize: 16,
//                   prefixIcon: Icon(
//                     Icons.account_balance,
//                     color: AppColor.primaryBackgroundColor,
//                   ),
//                 ),
//                 CustomTextField(
//                   // initialValue: widget.userData['output'][0]['per_email'],
//                   txtController: profileController.bankAddress,
//                   autofocus: false,
//                   labelText: 'Bank Address',
//                   hintText: 'Bank Address',
//                   isRequired: false,
//                   keyBoardType: TextInputType.streetAddress,
//                   fillColor: AppColor.white,
//                   isReadOnly: true,
//                   maxLines: 1,
//                   fontSize: 16,
//                   prefixIcon: CommonSvg(
//                     path: "assets/location.svg",
//                     width: 30,
//                     height: 30,
//                     parentWidth: 30,
//                     parentHeight: 30,
//                     color: AppColor.primaryBackgroundColor,
//                   ),
//                 ).paddingOnly(bottom: 20),
//                 // CustomButton(
//                 //   buttonFontSize: 16,
//                 //   buttonText: 'Edit',
//                 //   path: 'assets/arrow_nav.png',
//                 //   callB: () async {
//                 //     await profileController.editProfileBankDet(
//                 //         widget.userData['output'][0]['EmpCode'].toString(),
//                 //         profileController.bankDetailsList?.output
//                 //             .firstWhere((e) =>
//                 //                 e.bankname == profileController.selectedBank)
//                 //             .bankid
//                 //             .toString(),
//                 //         profileController.accNo.text,
//                 //         profileController.ifscNo.text,
//                 //         profileController.baranchName.text,
//                 //         profileController.bankAddress.text,
//                 //         widget.userData['output'][0]['EmpCode'].toString(),
//                 //         '1',
//                 //         '1',
//                 //         '1');
//                 //   },
//                 //   // buttonWidth: double.infinity,
//                 //   primColor: AppColor.primaryBackgroundColor,
//                 //   secColor: AppColor.secondaryColor,
//                 //   textColor: AppColor.white,
//                 //   iconColor: AppColor.white,
//                 //   buttonWidth: 170,
//                 // ).paddingOnly(top: 20, bottom: 20)
//               ],
//             ).paddingSymmetric(horizontal: 8),
//           )
//         : InternetIssue(
//             onRetryPressed: () {
//               checkInternetAndLoadData();
//             },
//           );
//   }
// }
