

import 'dart:convert';

LabNameList labNameListFromJson(String str) => LabNameList.fromJson(json.decode(str));

String labNameListToJson(LabNameList data) => json.encode(data.toJson());

class LabNameList {
    LabNameList({
        required this.output,
        required this.message,
        required this.status,
    });

    List<Output> output;
    String message;
    String status;

    factory LabNameList.fromJson(Map<dynamic, dynamic> json) => LabNameList(
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
        required this.labName,
        required this.labCode,
    });

    String labName;
    int labCode;

    factory Output.fromJson(Map<dynamic, dynamic> json) => Output(
        labName: json["LabName"],
        labCode: json["LabCode"],
    );

    Map<dynamic, dynamic> toJson() => {
        "LabName": labName,
        "LabCode": labCode,
    };
}
