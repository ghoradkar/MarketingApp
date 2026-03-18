import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get/get.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/widgets/common_svg.dart';
import 'package:marketingapp/widgets/custom_text.dart';
import 'package:marketingapp/widgets/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  final dynamic userData;

  const ProfileScreen({super.key, this.userData});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                FlavorConfig.instance.name == "HindLab Operational"
                    ? AppColor.primaryBackgroundColor.withValues(alpha: 0.1)
                    : AppColor.primaryBackgroundColor.withValues(alpha: 0.3),
                FlavorConfig.instance.name == 'Lifenity Operational'
                    ? AppColor.white
                    : AppColor.secondaryColor.withValues(alpha: 0.3)
              ],
              // Change colors as needed
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: CustomText(
          text: 'My Profile',
          fontSize: 18,
          fontWeight: FontWeight.w500,
          textColor: AppColor.black,
          textAlign: TextAlign.start,
          fontFam: 'Nunito Sans',
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextField(
              // txtController: TextEditingController(),
              initialValue: widget.userData['output'][0]['FirstName'],
              autofocus: false,
              labelText: 'First Name',
              hintText: 'First Name',
              isRequired: false,
              keyBoardType: TextInputType.streetAddress,
              fillColor: AppColor.white,
              isReadOnly: true,
              maxLines: 1,
              fontSize: 16,
              prefixIcon: CommonSvg(
                path: "assets/username.svg",
                width: 30,
                height: 30,
                parentWidth: 30,
                parentHeight: 30,
                color: AppColor.primaryBackgroundColor,
              ),
            ),
            CustomTextField(
              initialValue: widget.userData['output'][0]['MiddleName'],
              // txtController: TextEditingController(),
              autofocus: false,
              labelText: 'Middle Name',
              hintText: 'Middle Name',
              isRequired: false,
              keyBoardType: TextInputType.streetAddress,
              fillColor: AppColor.white,
              isReadOnly: true,
              maxLines: 1,
              fontSize: 16,
              prefixIcon: CommonSvg(
                path: "assets/username.svg",
                width: 30,
                height: 30,
                parentWidth: 30,
                parentHeight: 30,
                color: AppColor.primaryBackgroundColor,
              ),
            ),
            CustomTextField(
              // txtController: TextEditingController(),
              initialValue: widget.userData['output'][0]['LastName'],
              autofocus: false,
              labelText: 'Last Name',
              hintText: 'Last Name',
              isRequired: false,
              keyBoardType: TextInputType.streetAddress,
              fillColor: AppColor.white,
              isReadOnly: true,
              maxLines: 1,
              fontSize: 16,
              prefixIcon: CommonSvg(
                path: "assets/username.svg",
                width: 30,
                height: 30,
                parentWidth: 30,
                parentHeight: 30,
                color: AppColor.primaryBackgroundColor,
              ),
            ),
            CustomTextField(
              initialValue: widget.userData['output'][0]['per_email'],
              // txtController: TextEditingController(),
              autofocus: false,
              labelText: 'Email',
              hintText: 'Email',
              isRequired: false,
              keyBoardType: TextInputType.streetAddress,
              fillColor: AppColor.white,
              isReadOnly: true,
              maxLines: 1,
              fontSize: 16,
              prefixIcon: CommonSvg(
                path: "assets/mail.svg",
                width: 30,
                height: 30,
                parentWidth: 30,
                parentHeight: 30,
                color: AppColor.primaryBackgroundColor,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    initialValue: widget.userData['output'][0]['dob'],
                    // txtController: TextEditingController(),
                    autofocus: false,
                    labelText: 'DOB',
                    hintText: 'DOB',
                    isRequired: false,
                    keyBoardType: TextInputType.streetAddress,
                    fillColor: AppColor.white,
                    isReadOnly: true,
                    maxLines: 1,
                    fontSize: 16,
                    prefixIcon: CommonSvg(
                      path: "assets/calendar.svg",
                      width: 30,
                      height: 30,
                      parentWidth: 30,
                      parentHeight: 30,
                      color: AppColor.primaryBackgroundColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: CustomTextField(
                    initialValue:
                        widget.userData['output'][0]['AGE'].toString(),
                    // txtController: TextEditingController(),
                    autofocus: false,
                    labelText: 'Age',
                    hintText: 'Age',
                    isRequired: false,
                    keyBoardType: TextInputType.streetAddress,
                    fillColor: AppColor.white,
                    isReadOnly: true,
                    maxLines: 1,
                    fontSize: 16,
                    prefixIcon: CommonSvg(
                      path: "assets/calendar.svg",
                      width: 30,
                      height: 30,
                      parentWidth: 30,
                      parentHeight: 30,
                      color: AppColor.primaryBackgroundColor,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    initialValue: widget.userData['output'][0]['MotherName'],
                    // txtController: TextEditingController(),
                    autofocus: false,
                    labelText: 'Mother Name',
                    hintText: 'Mother Name',
                    isRequired: false,
                    keyBoardType: TextInputType.streetAddress,
                    fillColor: AppColor.white,
                    isReadOnly: true,
                    maxLines: 1,
                    fontSize: 16,
                    prefixIcon: CommonSvg(
                      path: "assets/username.svg",
                      width: 30,
                      height: 30,
                      parentWidth: 30,
                      parentHeight: 30,
                      color: AppColor.primaryBackgroundColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: CustomTextField(
                    // txtController: TextEditingController(),
                    initialValue:
                        widget.userData['output'][0]['bloodgroup'] ?? "",
                    autofocus: false,
                    labelText: 'Blood Group',
                    hintText: 'Blood Group',
                    isRequired: false,
                    keyBoardType: TextInputType.streetAddress,
                    fillColor: AppColor.white,
                    isReadOnly: true,
                    maxLines: 1,
                    fontSize: 16,
                    prefixIcon: CommonSvg(
                      path: "assets/bloodgroup.svg",
                      width: 30,
                      height: 30,
                      parentWidth: 30,
                      parentHeight: 30,
                      color: AppColor.primaryBackgroundColor,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    // txtController: TextEditingController(),
                    initialValue: widget.userData['output'][0]['Gender'] == 1
                        ? "Male"
                        : "Female",
                    autofocus: false,
                    labelText: 'Gender',
                    hintText: 'Gender',
                    isRequired: false,
                    keyBoardType: TextInputType.streetAddress,
                    fillColor: AppColor.white,
                    isReadOnly: true,
                    maxLines: 1,
                    fontSize: 16,
                    prefixIcon: CommonSvg(
                      path: "assets/username.svg",
                      width: 30,
                      height: 30,
                      parentWidth: 30,
                      parentHeight: 30,
                      color: AppColor.primaryBackgroundColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: CustomTextField(
                    initialValue:
                        widget.userData['output'][0]['per_mobile'] ?? "",
                    // txtController: TextEditingController(),
                    autofocus: false,
                    labelText: 'Contact Number',
                    hintText: 'Contact Number',
                    isRequired: false,
                    keyBoardType: TextInputType.streetAddress,
                    fillColor: AppColor.white,
                    isReadOnly: true,
                    maxLines: 1,
                    fontSize: 16,
                    prefixIcon: CommonSvg(
                      path: "assets/device.svg",
                      width: 30,
                      height: 30,
                      parentWidth: 30,
                      parentHeight: 30,
                      color: AppColor.primaryBackgroundColor,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    initialValue: widget.userData['output'][0]['STATE'] ?? "",
                    // txtController: TextEditingController(),
                    autofocus: false,
                    labelText: 'State',
                    hintText: 'State',
                    isRequired: false,
                    keyBoardType: TextInputType.streetAddress,
                    fillColor: AppColor.white,
                    isReadOnly: true,
                    maxLines: 1,
                    fontSize: 16,
                    prefixIcon: CommonSvg(
                      path: "assets/location.svg",
                      width: 30,
                      height: 30,
                      parentWidth: 30,
                      parentHeight: 30,
                      color: AppColor.primaryBackgroundColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: CustomTextField(
                    initialValue:
                        widget.userData['output'][0]['district'] ?? "",
                    // txtController: TextEditingController(),
                    autofocus: false,
                    labelText: 'District',
                    hintText: 'District',
                    isRequired: false,
                    keyBoardType: TextInputType.streetAddress,
                    fillColor: AppColor.white,
                    isReadOnly: true,
                    maxLines: 1,
                    fontSize: 16,
                    prefixIcon: CommonSvg(
                      path: "assets/location.svg",
                      width: 30,
                      height: 30,
                      parentWidth: 30,
                      parentHeight: 30,
                      color: AppColor.primaryBackgroundColor,
                    ),
                  ),
                ),
              ],
            ),
            SafeArea(
              bottom: true,
              top: false,
              child: CustomTextField(
                // txtController: TextEditingController(),
                initialValue: widget.userData['output'][0]['Address'] ?? "",
                autofocus: false,
                labelText: 'Address',
                hintText: 'Address',
                isRequired: false,
                keyBoardType: TextInputType.streetAddress,
                fillColor: AppColor.white,
                isReadOnly: true,
                maxLines: 1,
                fontSize: 16,
                prefixIcon: CommonSvg(
                  path: "assets/location.svg",
                  width: 30,
                  height: 30,
                  parentWidth: 30,
                  parentHeight: 30,
                  color: AppColor.primaryBackgroundColor,
                ),
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 8),
      ),
    );
  }
}
