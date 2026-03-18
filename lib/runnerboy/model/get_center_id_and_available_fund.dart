

import 'dart:convert';

GetCenterIdAndAvailableFund getCenterIdAndAvailableFundFromJson(String str) => GetCenterIdAndAvailableFund.fromJson(json.decode(str));

String getCenterIdAndAvailableFundToJson(GetCenterIdAndAvailableFund data) => json.encode(data.toJson());

class GetCenterIdAndAvailableFund {
    GetCenterIdAndAvailableFund({
        required this.output,
        required this.message,
        required this.status,
    });

    List<CenterIdAndAvailableFundOutput> output;
    String message;
    String status;

    factory GetCenterIdAndAvailableFund.fromJson(Map<dynamic, dynamic> json) => GetCenterIdAndAvailableFund(
        output: List<CenterIdAndAvailableFundOutput>.from(json["output"].map((x) => CenterIdAndAvailableFundOutput.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<dynamic, dynamic> toJson() => {
        "output": List<dynamic>.from(output.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class CenterIdAndAvailableFundOutput {
    CenterIdAndAvailableFundOutput({
        required this.availableFund,
        required this.customerTypeName,
        required this.ptypeid,
        required this.paymentType,
        required this.facilityCode,
        required this.customerType,
        required this.facilityName,
    });

    double availableFund;
    String customerTypeName;
    int ptypeid;
    String paymentType;
    int facilityCode;
    int customerType;
    String facilityName;

    factory CenterIdAndAvailableFundOutput.fromJson(Map<dynamic, dynamic> json) => CenterIdAndAvailableFundOutput(
        availableFund: json["AvailableFund"],
        customerTypeName: json["CustomerTypeName"],
        ptypeid: json["Ptypeid"],
        paymentType: json["PaymentType"],
        facilityCode: json["FacilityCode"],
        customerType: json["CustomerType"],
        facilityName: json["FacilityName"],
    );

    Map<dynamic, dynamic> toJson() => {
        "AvailableFund": availableFund,
        "CustomerTypeName": customerTypeName,
        "Ptypeid": ptypeid,
        "PaymentType": paymentType,
        "FacilityCode": facilityCode,
        "CustomerType": customerType,
        "FacilityName": facilityName,
    };
}
