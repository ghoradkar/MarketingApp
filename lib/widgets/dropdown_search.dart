import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marketingapp/utils/color_constants.dart';

class DropDownSearch extends StatelessWidget {
  final String labelText;
  final bool isRequired;
  final bool? isViewProfile;
  final String hint;
  final List<String> items;
  final Function(String?) senValue;
  final Color filledColor;
  final Color? dropdownColor;
  final Widget? prefixIcon;
  final String? selectedItem;

  const DropDownSearch({
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 4.h, 8.w, 4.h),
          child: Row(
            children: [
              Text(labelText,
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w400)),
              if (isRequired)
                Text(
                  ' *',
                  style: TextStyle(color: Colors.red, fontSize: 14.sp),
                ),
            ],
          ),
        ),
        DropdownSearch<String>(
          enabled: isViewProfile != true,
          selectedItem: selectedItem,
          items: (f, cs) => items,
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
              prefixIcon: prefixIcon,
              filled: true,
              fillColor: filledColor,
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColor.borderGrey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColor.borderGrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColor.borderGrey),
              ),
            ),
          ),
          popupProps: PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search...",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.borderGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.borderGrey),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColor.borderGrey),
                ),
              ),
            ),
          ),
          onChanged: senValue,
          validator: (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return "$labelText is required";
            }
            return null;
          },
        ),
      ],
    );
  }
}
