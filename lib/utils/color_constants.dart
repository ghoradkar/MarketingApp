import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

class AppColor {
  // static Color primaryBackgroundColor = const Color(0xFF24ABE3);
  // static Color secondaryColor = const Color(0xFF04B35A);
  // static Color textGrey = const Color(0xff666666);
  // static Color borderGrey = const Color(0xffD1D1D1);
  // static Color white = const Color(0xFFFFFFFF);
  // static Color black = const Color(0xFF000000);
  // static Color red = const Color(0xFFC62828);



  static Color primaryBackgroundColor = FlavorConfig.instance.color;
  static Color secondaryColor =
      Color(int.parse(FlavorConfig.instance.variables['secondaryColor']));
  static Color textGrey = const Color(0xFFBDBDBD);
  static Color borderGrey = const Color(0xffD1D1D1);
  static Color white = const Color(0xFFFFFFFF);
  static Color black = const Color(0xFF000000);
  static Color red = const Color(0xFFC62828);
  static Color green = const Color(0xFF43A047);
  static Color orange = const Color(0xFFEF953B);
  static Color transparent = const Color(0x00000000);
}
