import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marketingapp/add_visit/model/purpose_of_visit_model.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/widgets/custom_text.dart';

class MyCustomDropdown extends StatefulWidget {
  final String labelText;
  final bool isRequired;
  final bool? isViewProfile;
  final String hint;
  final List<dynamic> items;
  final Function senValue;
  final Color filledColor;
  final Color? dropdownColor;
  final Widget? prefixIcon;

  final String? selectedItem;

  const MyCustomDropdown({
    super.key,
    required this.labelText,
    required this.items,
    required this.hint,
    required this.isRequired,
    required this.senValue,
    required this.filledColor,
    this.selectedItem,
    this.isViewProfile,
    this.prefixIcon,
    this.dropdownColor,
  });

  @override
  State<MyCustomDropdown> createState() => _MyCustomDropdownState();
}

class _MyCustomDropdownState extends State<MyCustomDropdown> {
  @override
  Widget build(BuildContext context) {
    bool allNotNull = widget.items.every((element) => element != null);
    // List<String> dummy = ['select'];
    bool hasItems = widget.items.isNotEmpty && allNotNull;
    List<dynamic> filteredItems = widget.items
        .where((item) => item != null && item.toString().trim().isNotEmpty)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:  EdgeInsets.fromLTRB(0, 4.h, 8.w, 4.h),
          child: Row(
            children: [
              CustomText(
                text: widget.labelText,
                fontSize: 16.sp,
                fontWeight: FontWeight.normal,
                textColor: AppColor.black,
                textAlign: TextAlign.right,
                fontFam: 'Nunito Sans',

              ),
              if (widget.isRequired)
                 Text(
                  ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12.sp,
                  ),
                ),
            ],
          ),
        ),
        DropdownButtonFormField<String>(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          // key: widget.key,
          dropdownColor: AppColor.white,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_outlined,
            color: widget.dropdownColor ?? AppColor.secondaryColor,
          ),
          decoration: InputDecoration(
            contentPadding:  EdgeInsets.symmetric(vertical: 10.h),
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon,
            filled: true,
            fillColor: widget.filledColor,
            hintStyle: TextStyle(
                fontSize: 14.sp,
                color: AppColor.textGrey,
                fontFamily: "Nunito Sans",
                fontWeight: FontWeight.normal),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: AppColor.borderGrey,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: AppColor.borderGrey,
              ),
            ),
          ),
          value: widget.selectedItem,
          items: allNotNull && hasItems
              ? [
                  DropdownMenuItem(
                    enabled: false, // makes it non-selectable
                    child: Padding(
                      padding:  EdgeInsets.symmetric(vertical: 8.h),
                      child: CustomText(
                        text: 'Select ${widget.labelText}',
                        fontSize: 14.sp,
                        fontFam: 'Nunito Sans',
                        fontWeight: FontWeight.bold,
                        textColor: AppColor.black,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  ...filteredItems.map((item) => DropdownMenuItem(
                      value: item,
                      child: CustomText(
                        text: item,
                        fontSize: 14.sp,
                        fontFam: 'Nunito Sans',
                        fontWeight: FontWeight.bold,
                        textColor: AppColor.black,
                        textAlign: TextAlign.start,
                      )))
                ]
              : [],
          onChanged: widget.isViewProfile == true
              ? null
              : (value) {
                  widget.senValue(value);
                },
          validator: (value) {
            if ((widget.isRequired)) {
              if (value == null) {
                return "${widget.labelText} is required";
              }
            }
            return null;
          },
        )
      ],
    );
  }
}

class NormalCustomDropdown extends StatefulWidget {
  final String labelText;
  final bool isRequired;
  final bool? isViewProfile;
  final String hint;
  final List<dynamic> items;
  final Function senValue;
  final Color filledColor;
  final Color? dropdownColor;
  final Widget? prefixIcon;
  final String? selectedItem;

  const NormalCustomDropdown(
      {super.key,
      required this.labelText,
      required this.items,
      required this.hint,
      required this.isRequired,
      required this.senValue,
      required this.filledColor,
      this.selectedItem,
      this.isViewProfile,
      this.prefixIcon,
      this.dropdownColor});

  @override
  State<NormalCustomDropdown> createState() => _NormalCustomDropdownState();
}

class _NormalCustomDropdownState extends State<NormalCustomDropdown> {
  @override
  Widget build(BuildContext context) {
    bool allNotNull = widget.items.every((element) => element != null);
    // List<String> dummy = ['select'];
    bool hasItems = widget.items.isNotEmpty && allNotNull;

    return Padding(
      padding:  EdgeInsets.fromLTRB(8.w, 0, 8.w, 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:  EdgeInsets.fromLTRB(0, 4.h, 8.w, 4.h),
            child: Row(
              children: [
                CustomText(
                  text: widget.labelText,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.normal,
                  textColor: AppColor.black,
                  textAlign: TextAlign.right,
                  fontFam: 'Nunito Sans',
                ),
                if (widget.isRequired)
                   Text(
                    ' *',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12.sp,
                    ),
                  ),
              ],
            ),
          ),
          DropdownButtonFormField<String>(
            dropdownColor: AppColor.white,
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down_outlined,
              color: widget.dropdownColor ?? AppColor.secondaryColor,
            ),
            decoration: InputDecoration(
              contentPadding:  EdgeInsets.symmetric(vertical: 14.h),
              hintText: widget.hint,
              prefixIcon: widget.prefixIcon,
              filled: true,
              fillColor: widget.filledColor,
              hintStyle: TextStyle(
                  fontSize: 12.sp,
                  color: AppColor.textGrey,
                  fontFamily: "Nunito Sans",
                  fontWeight: FontWeight.normal),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: AppColor.borderGrey,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: AppColor.borderGrey,
                ),
              ),
            ),
            value: widget.selectedItem,
            items: allNotNull && hasItems
                ? [
                    DropdownMenuItem(
                      enabled: false, // makes it non-selectable
                      child: Padding(
                        padding:  EdgeInsets.symmetric(vertical: 8.h),
                        child: CustomText(
                          text: 'Select ${widget.labelText}',
                          fontSize: 12.sp,
                          fontFam: 'Nunito Sans',
                          fontWeight: FontWeight.bold,
                          textColor: AppColor.black,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    ...widget.items.map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        ))
                  ]
                : [],
            onChanged: widget.isViewProfile == true
                ? null
                : (value) {
                    widget.senValue(value);
                  },
            validator: (widget.isRequired)
                ? (value) {
                    if (value == null) {
                      return "${widget.labelText} is required";
                    }
                    return null;
                  }
                : null,
          )
        ],
      ),
    );
  }
}

class MyCustomDropdownObject extends StatefulWidget {
  final String labelText;
  final bool isRequired;
  final bool? isViewProfile;
  final String hint;
  final List<PurposeOutput>
      items; // Ensure the list contains objects of type PurposeOutput
  final Function(PurposeOutput?)
      senValue; // Callback now accepts PurposeOutput?
  final Color filledColor;
  final Color? dropdownColor;
  final Widget? prefixIcon;
  final PurposeOutput? selectedItem;
  final bool shouldValidate;

  const MyCustomDropdownObject({
    super.key,
    required this.labelText,
    required this.items,
    required this.hint,
    required this.isRequired,
    required this.senValue,
    required this.filledColor,
    this.selectedItem,
    this.isViewProfile,
    this.prefixIcon,
    this.dropdownColor,
    this.shouldValidate = false,
  });

  @override
  State<MyCustomDropdownObject> createState() => _MyCustomDropdownObjectState();
}

class _MyCustomDropdownObjectState extends State<MyCustomDropdownObject> {
  @override
  Widget build(BuildContext context) {
    bool allNotNull = widget.items.every((element) => element != null);
    // List<String> dummy = ['select'];
    bool hasItems = widget.items.isNotEmpty && allNotNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:  EdgeInsets.fromLTRB(0, 4.w, 8.w, 4.h),
          child: Row(
            children: [
              CustomText(
                text: widget.labelText,
                fontSize: 12.sp,
                fontWeight: FontWeight.normal,
                textColor: AppColor.black,
                textAlign: TextAlign.right,
                fontFam: 'Nunito Sans',
              ),
              if (widget.isRequired)
                 Text(
                  ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12.sp,
                  ),
                ),
            ],
          ),
        ),
        DropdownButtonFormField<PurposeOutput>(
          dropdownColor: AppColor.white,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_outlined,
            color: widget.dropdownColor ?? AppColor.secondaryColor,
          ),
          decoration: InputDecoration(
            contentPadding:  EdgeInsets.symmetric(vertical: 14.h),
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon,
            filled: true,
            fillColor: widget.filledColor,
            hintStyle: TextStyle(
              fontSize: 12.sp,
              color: AppColor.textGrey,
              fontFamily: "Nunito Sans",
              fontWeight: FontWeight.normal,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: AppColor.borderGrey,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: AppColor.borderGrey,
              ),
            ),
          ),
          value: widget.selectedItem,
          // Ensure the value is of type PurposeOutput
          items: allNotNull && hasItems
              ? [
                  DropdownMenuItem(
                    enabled: false, // makes it non-selectable
                    child: Padding(
                      padding:  EdgeInsets.symmetric(vertical: 8.h),
                      child: CustomText(
                        text: 'Select ${widget.labelText}',
                        fontSize: 12.sp,
                        fontFam: 'Nunito Sans',
                        fontWeight: FontWeight.bold,
                        textColor: AppColor.black,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  ...widget.items.map((PurposeOutput item) {
                    return DropdownMenuItem<PurposeOutput>(
                      value: item,
                      // child: Text(item.mVisitAction
                      //     .toString()),
                      child: CustomText(
                        text: item.mVisitAction.toString(),
                        fontSize: 12.sp,
                        fontFam: 'Nunito Sans',
                        fontWeight: FontWeight.normal,
                        textColor: AppColor.black,
                        textAlign: TextAlign.start,
                      ),
                    );
                  })
                ]
              : [],
          onChanged: widget.isViewProfile == true
              ? null
              : (PurposeOutput? value) {
                  widget.senValue(value);
                  if (widget.shouldValidate) {
                    Form.of(context).validate();
                  }
                },
          validator: (widget.isRequired && widget.shouldValidate)
              ? (PurposeOutput? value) {
                  if (value == null) {
                    return "${widget.labelText} is required";
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }
}
