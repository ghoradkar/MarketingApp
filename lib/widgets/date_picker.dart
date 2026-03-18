import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marketingapp/utils/color_constants.dart';

class DatePickerHelper {
  static Future<DateTime?> selectDate(BuildContext context,
      {DateTime? initialDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1700),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.secondaryColor,
              onPrimary: Colors.black,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: AppColor.secondaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    return picked;
  }

  static Future<DateTime?> visiableCurrentAndYesturdaysDateOnly(
      BuildContext context,
      {DateTime? initialDate}) async {
    final DateTime today = DateTime.now();
    final DateTime yesterday = today.subtract(const Duration(days: 1));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? today,
      firstDate: yesterday,
      lastDate: today,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.secondaryColor,
              onPrimary: Colors.black,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: AppColor.secondaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    return picked;
  }

  static Future<DateTime?> futureDateWillBeDisable(BuildContext context,
      {DateTime? initialDate}) async {
    final DateTime today = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? today,
      firstDate: DateTime(1700),
      lastDate: today,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.secondaryColor,
              onPrimary: Colors.black,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: AppColor.secondaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    return picked;
  }


  String getCurrentTime24Hour() {
    final now = DateTime.now();
    final DateFormat formatter = DateFormat('HH:mm:ss'); // 24-hour format
    return formatter.format(now);
  }

  static Future<String?> selectTime(BuildContext context) async {
    TimeOfDay selectedTime = TimeOfDay.now();

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null) {
      selectedTime = picked;

      // Format the time as "HH:mm"
      final formattedTime =
          "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}";

      return formattedTime;
    }

    return null; // Return null if no time was picked
  }
}
