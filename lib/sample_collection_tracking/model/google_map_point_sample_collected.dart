

import 'dart:convert';

GoogleMapPointSampleCollected googleMapPointSampleCollectedFromJson(String str) => GoogleMapPointSampleCollected.fromJson(json.decode(str));

String googleMapPointSampleCollectedToJson(GoogleMapPointSampleCollected data) => json.encode(data.toJson());

class GoogleMapPointSampleCollected {
    GoogleMapPointSampleCollected({
        required this.output,
        required this.message,
        required this.status,
    });

    List<Output> output;
    String message;
    String status;

    factory GoogleMapPointSampleCollected.fromJson(Map<dynamic, dynamic> json) => GoogleMapPointSampleCollected(
        output: List<Output>.from(json["output"].map((x) => Output.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<dynamic, dynamic> toJson() => {
        "output": List<dynamic>.from(output.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class Output {
    Output({
        required this.isSampleAccepted,
        required this.isLabSubmit,
        required this.longitude,
        required this.createdDate,
        required this.mapFlag,
        required this.customerName,
        required this.latitude,
    });

    String isSampleAccepted;
    String isLabSubmit;
    String longitude;
    String createdDate;
    int mapFlag;
    String customerName;
    String latitude;

    factory Output.fromJson(Map<dynamic, dynamic> json) => Output(
        isSampleAccepted: json["ISSampleAccepted"],
        isLabSubmit: json["ISLabSubmit"],
        longitude: json["LONGITUDE"],
        createdDate: json["CreatedDate"],
        mapFlag: json["MapFlag"],
        customerName: json["CustomerName"],
        latitude: json["LATITUDE"],
    );

    Map<dynamic, dynamic> toJson() => {
        "ISSampleAccepted": isSampleAccepted,
        "ISLabSubmit": isLabSubmit,
        "LONGITUDE": longitude,
        "CreatedDate": createdDate,
        "MapFlag": mapFlag,
        "CustomerName": customerName,
        "LATITUDE": latitude,
    };
}
