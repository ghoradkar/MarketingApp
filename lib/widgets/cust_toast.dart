import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
class CustomMessage {
  // Private constructor
  CustomMessage._();

  // Singleton instance
  static final CustomMessage instance = CustomMessage._();

  // Toast message function
  static void toast(String? msg) {
    if (msg != null) {
      Fluttertoast.showToast(msg: msg);
    }
  }

  // Show loading indicator
  static void showLoader() {
    EasyLoading.show(status: "Please wait...");
  }

  // Hide loading indicator
  static void hideLoader() {
    EasyLoading.dismiss();
  }



}
