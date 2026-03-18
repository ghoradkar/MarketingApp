import 'dart:convert';

import 'package:flutter/foundation.dart';

SamplePendingFromAccession samplePendingFromAccessionFromJson(String str) =>
    SamplePendingFromAccession.fromJson(json.decode(str));

String samplePendingFromAccessionToJson(SamplePendingFromAccession data) =>
    json.encode(data.toJson());

class SamplePendingFromAccession {
  SamplePendingFromAccession({
    required this.output,
    required this.message,
    required this.status,
  });

  List<AcceptedPendingOutput> output;
  String message;
  String status;

  factory SamplePendingFromAccession.fromJson(Map<String, dynamic> json) {
    try {
      debugPrint("Full JSON response: $json");

      // Verify output exists and is a list
      if (json['output'] == null) {
        debugPrint("Output is null, returning empty list");
        return SamplePendingFromAccession(
          output: [],
          message: json["message"] ?? "",
          status: json["status"] ?? "",
        );
      }

      if (json['output'] is! List) {
        debugPrint("Output is not a list, it's: ${json['output'].runtimeType}");
        throw Exception("Output is not a list");
      }

      // Process each item with error handling
      final outputList = <AcceptedPendingOutput>[];
      for (var item in json['output']) {
        try {
          debugPrint("Processing item: $item");
          outputList.add(AcceptedPendingOutput.fromJson(item));
        } catch (e, stack) {
          debugPrint("Failed to process item $item: $e");
          debugPrint("Stack trace: $stack");
          // Optionally continue with next item or rethrow
        }
      }

      return SamplePendingFromAccession(
        output: outputList,
        message: json["message"] ?? "",
        status: json["status"] ?? "",
      );
    } catch (e, stack) {
      debugPrint("Error in fromJson: $e");
      debugPrint("Stack trace: $stack");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        "output": List<dynamic>.from(output.map((x) => x.toJson())),
        "message": message,
        "status": status,
      };
}

class AcceptedPendingOutput {
  AcceptedPendingOutput(
      {required this.temprature,
      required this.detailsontrfId,
      required this.sufficeientTuberemark,
      required this.longitude,
      required this.paymentModeId,
      required this.uploadedFilePath,
      required this.recieptNo,
      required this.contactPerson,
      required this.sampleRemark,
      required this.detailsontrfremark,
      required this.customerTypeName,
      required this.sufficeientTubeId,
      required this.mapFlag,
      required this.paymentType,
      required this.sampleCount,
      required this.customerName,
      required this.centerId,
      required this.otherdocumentcollectedid,
      required this.viewUploadFilePath,
      required this.trfCount,
      required this.sampleCollTime,
      required this.isSampleAccepted,
      required this.allsamplebarcodeId,
      required this.amount,
      required this.ptypeid,
      required this.locid,
      required this.sampleTubeId,
      required this.sampleTempName,
      required this.customerType,
      required this.tansactionNo,
      required this.availableFund,
      required this.allsamplebarcoderemark,
      required this.otherdocumentRemark,
      required this.latitude,
      this.isSelected = false});

  int temprature;
  int detailsontrfId;
  String sufficeientTuberemark;
  String longitude;
  String paymentModeId;
  String uploadedFilePath;
  String recieptNo;
  String contactPerson;
  String sampleRemark;
  String detailsontrfremark;
  String customerTypeName;
  int sufficeientTubeId;
  int mapFlag;
  String paymentType;
  int sampleCount;
  String customerName;
  int centerId;
  int otherdocumentcollectedid;
  String viewUploadFilePath;
  String trfCount;
  String sampleCollTime;
  String isSampleAccepted;
  int allsamplebarcodeId;
  double amount;
  int ptypeid;
  int locid;
  int sampleTubeId;
  String sampleTempName;
  int customerType;
  String tansactionNo;
  double availableFund;
  String allsamplebarcoderemark;
  String otherdocumentRemark;
  String latitude;
  bool isSelected;

  factory AcceptedPendingOutput.fromJson(Map<String, dynamic> json) =>
      AcceptedPendingOutput(
        temprature: json["temprature"] is String
            ? int.parse(json["temprature"])
            : json["temprature"] ?? 0,
        // added null check
        detailsontrfId: json["DetailsontrfId"] ?? 0,
        sufficeientTuberemark: json["SufficeientTuberemark"] ?? "",
        longitude: json["LONGITUDE"] ?? "",
        paymentModeId: json["PaymentModeId"] is int
            ? json["PaymentModeId"].toString()
            : json["PaymentModeId"] ?? "",
        uploadedFilePath: json["UploadedFilePath"] ?? "",
        recieptNo: json["RecieptNo"] ?? "",
        contactPerson: json["ContactPerson"] ?? "",
        sampleRemark: json["SampleRemark"] ?? "",
        detailsontrfremark: json["Detailsontrfremark"] ?? "",
        customerTypeName: json["CustomerTypeName"] ?? "",
        sufficeientTubeId: json["SufficeientTubeId"] ?? 0,
        mapFlag: json["MapFlag"] ?? 0,
        paymentType: json["PaymentType"] ?? "",
        sampleCount: json["SampleCount"] ?? 0,
        customerName: json["CustomerName"] ?? "",
        centerId: json["CenterID"] ?? 0,
        otherdocumentcollectedid: json["otherdocumentcollectedid"] ?? 0,
        viewUploadFilePath: json["ViewUploadFilePath"] ?? "",
        trfCount: json["TRFCount"] ?? "",
        sampleCollTime: json["SampleCollTime"] ?? "",
        isSampleAccepted: json["ISSampleAccepted"] ?? "",
        allsamplebarcodeId: json["AllsamplebarcodeId"] ?? 0,
        amount: json["Amount"] ?? 0,
        ptypeid: json["Ptypeid"] ?? 0,
        locid: json["LOCID"] ?? 0,
        sampleTubeId: json["SampleTubeId"] ?? 0,
        sampleTempName: json["SampleTempName"] ?? "",
        customerType: json["CustomerType"] ?? 0,
        tansactionNo: json["tansactionNo"] ?? "",
        availableFund: json["AvailableFund"] ?? 0,
        allsamplebarcoderemark: json["Allsamplebarcoderemark"] ?? "",
        otherdocumentRemark: json["otherdocumentRemark"] ?? "",
        latitude: json["LATITUDE"] ?? "",
        isSelected: false,
      );

  Map<String, dynamic> toJson() => {
        "temprature": temprature,
        "DetailsontrfId": detailsontrfId,
        "SufficeientTuberemark": sufficeientTuberemark,
        "LONGITUDE": longitude,
        "PaymentModeId": paymentModeId,
        "UploadedFilePath": uploadedFilePath,
        "RecieptNo": recieptNo,
        "ContactPerson": contactPerson,
        "SampleRemark": sampleRemark,
        "Detailsontrfremark": detailsontrfremark,
        "CustomerTypeName": customerTypeName,
        "SufficeientTubeId": sufficeientTubeId,
        "MapFlag": mapFlag,
        "PaymentType": paymentType,
        "SampleCount": sampleCount,
        "CustomerName": customerName,
        "CenterID": centerId,
        "otherdocumentcollectedid": otherdocumentcollectedid,
        "ViewUploadFilePath": viewUploadFilePath,
        "TRFCount": trfCount,
        "SampleCollTime": sampleCollTime,
        "ISSampleAccepted": isSampleAccepted,
        "AllsamplebarcodeId": allsamplebarcodeId,
        "Amount": amount,
        "Ptypeid": ptypeid,
        "LOCID": locid,
        "SampleTubeId": sampleTubeId,
        "SampleTempName": sampleTempName,
        "CustomerType": customerType,
        "tansactionNo": tansactionNo,
        "AvailableFund": availableFund,
        "Allsamplebarcoderemark": allsamplebarcoderemark,
        "otherdocumentRemark": otherdocumentRemark,
        "LATITUDE": latitude,
      };
}
