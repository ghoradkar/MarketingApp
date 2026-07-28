import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/widgets/custom_text.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final String? identification;
  final String? errorM;
  final String hintText;
  final String? initialValue;
  final bool isRequired;
  final bool isReadOnly;
  final TextInputType keyBoardType;
  final TextEditingController? txtController;
  final Color fillColor;
  final int? maxLines;
  final int? minLines;
  final int? mazLenght;
  final Function? onChanged;
  final Function? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? obscureText;
  final double fontSize;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;
  // final bool shouldValidate;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.isRequired,
    required this.keyBoardType,
    required this.fillColor,
    required this.isReadOnly,
    this.maxLines,
    this.minLines,
    this.onChanged,
    this.identification,
    this.mazLenght,
    this.onTap,
    this.suffixIcon,
    this.initialValue,
    this.txtController,
    this.errorM,
    required this.fontSize,
    this.prefixIcon,
    this.obscureText,
    required this.autofocus,
    this.inputFormatters,
    // this.shouldValidate = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:  EdgeInsets.fromLTRB(0, 4.h, 8.w, 8.h),
          child: Row(
            children: [
              CustomText(
                text: widget.labelText,
                fontSize: widget.fontSize,
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
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }

          },
          obscureText: widget.obscureText ?? false,
          style: TextStyle(fontSize: widget.fontSize),
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          initialValue: widget.initialValue,
          maxLength: widget.mazLenght,
          readOnly: widget.isReadOnly,
          controller: widget.txtController,
          keyboardType: widget.keyBoardType,
          inputFormatters: widget.inputFormatters,
          autofocus: widget.autofocus,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
            fillColor: widget.fillColor,
            filled: true,
            hintText: widget.hintText,
            suffixIcon: widget.suffixIcon,
            prefixIcon: widget.prefixIcon,
            hintStyle: TextStyle(
              fontSize: 14.sp,
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
          validator: (value) {
            // Only validate if shouldValidate is true
            // if (!widget.shouldValidate) return null;

            if (widget.isRequired && (value == null || value.trim().isEmpty)) {
              return "${widget.labelText} is required";
            }

            // Mobile number validation
            // if (FlavorConfig.instance.name != "Lifenity International") {
            if ((widget.labelText == 'Mobile No') && value != null) {
              final mobileRegex = RegExp(r'^\d{10}$');
              if (!mobileRegex.hasMatch(value.trim())) {
                return "Please enter a valid 10-digit mobile number";
              }
            }
            // }

            // Email ID validation
            if (widget.labelText == 'Email ID' && value != null) {
              final emailRegex =
                  RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
              if (!emailRegex.hasMatch(value.trim())) {
                return "Please enter a valid email address";
              }
            }

            return null;
          },
        ),
      ],
    );
  }
}

class NormalCustomTextField extends StatefulWidget {
  final String labelText;
  final String? identification;
  final String? errorM;
  final String hintText;
  final String? initialValue;
  final bool isRequired;
  final bool isReadOnly;
  final TextInputType keyBoardType;
  final TextEditingController? txtController;
  final Color fillColor;
  final int maxLines;
  final int? mazLenght;
  final Function? onChanged;
  final Function? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? obscureText;
  final double fontSize;
  final bool autofocus;

  const NormalCustomTextField(
      {super.key,
      required this.labelText,
      required this.hintText,
      required this.isRequired,
      required this.keyBoardType,
      required this.fillColor,
      required this.isReadOnly,
      required this.maxLines,
      this.onChanged,
      this.identification,
      this.mazLenght,
      this.onTap,
      this.suffixIcon,
      this.initialValue,
      this.txtController,
      this.errorM,
      required this.fontSize,
      this.prefixIcon,
      this.obscureText,
      required this.autofocus});

  @override
  State<NormalCustomTextField> createState() => _NormalCustomTextFieldState();
}

class _NormalCustomTextFieldState extends State<NormalCustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.fromLTRB(8.w, 0, 8.w, 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:  EdgeInsets.fromLTRB(0, 8.h, 8.w, 8.h),
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
          TextFormField(
            onChanged: (value) {
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
            obscureText: widget.obscureText ?? false,
            style: TextStyle(fontSize: widget.fontSize),
            maxLines: widget.maxLines,
            initialValue: widget.initialValue,
            maxLength: widget.mazLenght,
            readOnly: widget.isReadOnly,
            controller: widget.txtController,
            keyboardType: widget.keyBoardType,
            autofocus: widget.autofocus,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
              fillColor: widget.fillColor,
              filled: true,
              hintText: widget.hintText,
              suffixIcon: widget.suffixIcon,
              prefixIcon: widget.prefixIcon,
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
            validator: (value) {
              if (widget.isRequired &&
                  (value == null || value.trim().isEmpty)) {
                return "${widget.labelText} is required";
              }

              // Mobile number validation
              if (FlavorConfig.instance.name != "Lifenity International") {
                if ((widget.labelText == 'Contact Number') &&
                    (value != null && value.isNotEmpty)) {
                  final mobileRegex = RegExp(r'^\d{10}$');
                  if (!mobileRegex.hasMatch(value.trim())) {
                    return "Please enter a valid mobile number";
                  }
                }
              }

              return null;
            },
          ),
        ],
      ),
    );
  }
}

class TubeCountCustomTextField extends StatefulWidget {
  final String labelText;
  final String? identification;
  final String? errorM;
  final String hintText;
  final String? initialValue;
  final bool isRequired;
  final bool isReadOnly;
  final TextInputType keyBoardType;
  final TextEditingController? txtController;
  final Color fillColor;
  final int? maxLines;
  final int? mazLenght;
  final Function? onChanged;
  final Function? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? obscureText;
  final double fontSize;
  final bool autofocus;
  final Function? validator;
  final List<TextInputFormatter>? inputFormatters;

  const TubeCountCustomTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.isRequired,
    required this.keyBoardType,
    required this.fillColor,
    required this.isReadOnly,
    this.maxLines,
    this.onChanged,
    this.identification,
    this.mazLenght,
    this.onTap,
    this.suffixIcon,
    this.initialValue,
    this.txtController,
    this.errorM,
    required this.fontSize,
    this.prefixIcon,
    this.obscureText,
    required this.autofocus,
    this.validator,
    this.inputFormatters,
  });

  @override
  State<TubeCountCustomTextField> createState() =>
      _TubeCountCustomTextFieldState();
}

class _TubeCountCustomTextFieldState extends State<TubeCountCustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:  EdgeInsets.fromLTRB(0, 4.h, 8.w, 8.h),
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
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          // key: widget.key,
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          },
          obscureText: widget.obscureText ?? false,
          style: TextStyle(fontSize: widget.fontSize),
          maxLines: widget.maxLines,
          initialValue: widget.initialValue,
          maxLength: widget.mazLenght,
          readOnly: widget.isReadOnly,
          controller: widget.txtController,
          keyboardType: widget.keyBoardType,
          inputFormatters: widget.inputFormatters,
          autofocus: widget.autofocus,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.only(top: 8.h, bottom: 8.h, left: 8.w),
            fillColor: widget.fillColor,
            filled: true,
            hintText: widget.hintText,
            suffixIcon: widget.suffixIcon,
            prefixIcon: widget.prefixIcon,
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
          validator: (value) {
            return widget.validator!(value);
          },
        ),
      ],
    );
  }
}
