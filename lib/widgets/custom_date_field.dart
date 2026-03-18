import 'package:flutter/material.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/widgets/common_svg.dart';

class CustomDateField extends StatelessWidget {
  final String labelText;
  final String hint;
  final bool isRequired;
  final Function callB;
  final TextEditingController? selectedDate;
  final String? initialValue;
  final Color filledColor;
  final Color? prefixIconColor;
  final bool dontDhowPrefix;
  final bool? isViewProfile;

  const CustomDateField(
      {super.key,
      required this.labelText,
      required this.hint,
      required this.isRequired,
      required this.callB,
      this.selectedDate,
      required this.filledColor,
      required this.dontDhowPrefix,
      this.isViewProfile,
      this.initialValue,
      this.prefixIconColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
            child: Row(
              children: [
                Text(
                  labelText,
                  style: const TextStyle(fontSize: 16),
                ),
                if (isRequired)
                  const Text(
                    ' *',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
              ],
            ),
          ),
          TextFormField(
            initialValue: initialValue,
            readOnly: true,
            style: const TextStyle(fontSize: 14, fontFamily: "Nunito Sans"),
            controller: selectedDate,
            decoration: InputDecoration(
              fillColor: filledColor,
              filled: true,
              hintText: hint,
              hintStyle: TextStyle(
                  fontSize: 16.0,
                  color: AppColor.textGrey,
                  fontFamily: "Nunito Sans",
                  fontWeight: FontWeight.normal),
              prefixIcon: dontDhowPrefix
                  ? const SizedBox.shrink()
                  : CommonSvg(
                      path: "assets/calendar.svg",
                      width: 26,
                      height: 26,
                      parentWidth: 30,
                      parentHeight: 30,
                      color: AppColor.primaryBackgroundColor,
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
            onTap: isViewProfile == true
                ? null
                : () {
                    callB();
                  },
            validator: isRequired
                ? (value) {
                    if (value == null || value.isEmpty) {
                      return "$labelText is required";
                    }
                    return null;
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
