import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SampleCollectionController extends GetxController {
  bool hasInternet = false;

  DateTime? selectedFromDate;

  String? formattedFromDate;

  TextEditingController fDateController = TextEditingController();

  String? selectedLab;

  String? selectedRunnerBoy;
}