import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketingapp/profile/controller/profile_controller.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/widgets/common_svg.dart';
import 'package:marketingapp/widgets/custom_text_field.dart';
import 'package:marketingapp/widgets/my_custom_dropdown.dart';
import 'package:marketingapp/widgets/no_internet_connectivity.dart';

class ProfileScreenTab extends StatefulWidget {
  final dynamic userData;

  const ProfileScreenTab({super.key, this.userData});

  @override
  State<ProfileScreenTab> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreenTab> {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    setInitials();

    checkInternetAndLoadData();
    super.initState();
  }

  checkInternetAndLoadData() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      profileController.hasInternet = true;
    } else {
      profileController.hasInternet = false;
    }
    profileController.update();
    if (profileController.hasInternet) {
      await profileController.getBloodGroupList();
    }
  }

  void setInitials() {
    profileController.firstName.text =
        widget.userData['output'][0]['FirstName'];
    profileController.middleName.text =
        widget.userData['output'][0]['MiddleName'];
    profileController.lastName.text = widget.userData['output'][0]['LastName'];
    profileController.email.text = widget.userData['output'][0]['per_email'];
    profileController.dob.text = widget.userData['output'][0]['dob'];
    profileController.age.text = widget.userData['output'][0]['AGE'].toString();
    profileController.motherName.text =
        widget.userData['output'][0]['MotherName'];
    profileController.contactNumber.text =
        widget.userData['output'][0]['per_mobile'];
    profileController.currentAddress.text =
        widget.userData['output'][0]['CAddress'] ?? "";
    profileController.selectedBloodG =
        widget.userData['output'][0]['bloodgroup'];
    profileController.selectedGender = profileController.genderList
        .firstWhere(
          (e) => e.genderId == widget.userData['output'][0]['Gender'],
        )
        .gender;
    // widget.userData['output'][0]['Gender'] == "1" ? "Male" : "Female";
    profileController.permanetAddress.text =
        widget.userData['output'][0]['PAddress'] ?? "";
    profileController.pin.text =
        widget.userData['output'][0]['pincode'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return profileController.hasInternet
        ? SingleChildScrollView(
            child: Column(
              children: [
                CustomTextField(
                  txtController: profileController.firstName,
                  // initialValue: widget.userData['output'][0]['FirstName'],
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
                  // initialValue: widget.userData['output'][0]['MiddleName'],
                  txtController: profileController.middleName,
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
                  txtController: profileController.lastName,
                  // initialValue: widget.userData['output'][0]['LastName'],
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
                  // initialValue: widget.userData['output'][0]['per_email'],
                  txtController: profileController.email,
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
                        // initialValue: widget.userData['output'][0]['dob'],
                        txtController: profileController.dob,
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
                    SizedBox(width: 6,),
                    Expanded(
                      child: CustomTextField(
                        // initialValue:
                        //     widget.userData['output'][0]['AGE'].toString(),
                        txtController: profileController.age,
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
                        // initialValue: widget.userData['output'][0]
                        //     ['MotherName'],
                        txtController: profileController.motherName,
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
                    SizedBox(width: 6,),
                    Expanded(
                        child: MyCustomDropdown(
                      // shouldValidate: profileController.shouldValidateFields,
                      selectedItem: profileController.selectedBloodG,
                      labelText: 'Blood Group',
                      prefixIcon: CommonSvg(
                        path: "assets/bloodgroup.svg",
                        width: 30,
                        height: 30,
                        parentWidth: 30,
                        parentHeight: 30,
                        color: AppColor.primaryBackgroundColor,
                      ),
                      items: profileController.bloodGroupList?.output
                              .map((e) => e.bloodname)
                              .toList() ??
                          [],
                      hint: '',
                      isRequired: true,
                      senValue: (value) {
                        profileController.selectedBloodG = value;
                        profileController.update();
                      },
                      filledColor: AppColor.white,
                    )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyCustomDropdown(
                        // shouldValidate: profileController.shouldValidateFields,
                        selectedItem: profileController.selectedGender,
                        labelText: 'Gender',
                        prefixIcon: CommonSvg(
                          path: "assets/username.svg",
                          width: 30,
                          height: 30,
                          parentWidth: 30,
                          parentHeight: 30,
                          color: AppColor.primaryBackgroundColor,
                        ),
                        items: profileController.genderList
                            .map((e) => e.gender)
                            .toList(),
                        hint: '',
                        isRequired: true,
                        senValue: (value) {
                          profileController.selectedGender = value;
                          profileController.update();
                        },
                        filledColor: AppColor.white,
                      ),
                    ),
                    SizedBox(width: 6,),

                    Expanded(
                      child: CustomTextField(
                        // initialValue:
                        //     widget.userData['output'][0]['per_mobile'] ?? "",
                        txtController: profileController.contactNumber,
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
                CustomTextField(
                  txtController: profileController.currentAddress,
                  // initialValue: widget.userData['output'][0]['CAddress'] ?? "",
                  autofocus: false,
                  labelText: 'Current Address',
                  hintText: 'Current Address',
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
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        initialValue:
                            widget.userData['output'][0]['STATE'] ?? "",
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
                    SizedBox(width: 6,),

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
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        initialValue:
                            widget.userData['output'][0]['taluka'] ?? "",
                        // txtController: TextEditingController(),
                        autofocus: false,
                        labelText: 'Taluka',
                        hintText: 'Taluka',
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
                    SizedBox(width: 6,),

                    Expanded(
                      child: CustomTextField(
                        initialValue:
                            widget.userData['output'][0]['PatchName'] ?? "",
                        // txtController: TextEditingController(),
                        autofocus: false,
                        labelText: 'Patch',
                        hintText: 'Patch',
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
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        initialValue:
                            widget.userData['output'][0]['CityName'] ?? "",
                        // txtController: TextEditingController(),
                        autofocus: false,
                        labelText: 'City',
                        hintText: 'City',
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
                    SizedBox(width: 6,),

                    Expanded(
                      child: CustomTextField(
                        // initialValue: widget.userData['output'][0]['pincode']
                        //         .toString() ??
                        //     "",
                        txtController: profileController.pin,
                        autofocus: false,
                        labelText: 'Pin',
                        hintText: 'Pin',
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
                CustomTextField(
                  txtController: profileController.permanetAddress,
                  // initialValue: widget.userData['output'][0]['PAddress'] ?? "",
                  autofocus: false,
                  labelText: 'Permanent Address',
                  hintText: 'Permanent Address',
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
                ).paddingOnly(bottom: 20),
              ],
            ).paddingSymmetric(horizontal: 8),
          )
        : InternetIssue(
            onRetryPressed: () {
              checkInternetAndLoadData();
            },
          );
  }
}
