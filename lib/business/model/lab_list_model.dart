
import 'dart:convert';

LabListModel labListModelFromJson(String str) => LabListModel.fromJson(json.decode(str));

String labListModelToJson(LabListModel data) => json.encode(data.toJson());

class LabListModel {
    LabListModel({
        required this.output,
        required this.message,
        required this.status,
    });

    List<LabOutput> output;
    String message;
    String status;

    factory LabListModel.fromJson(Map<dynamic, dynamic> json) => LabListModel(
        output: List<LabOutput>.from(json["output"].map((x) => LabOutput.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<dynamic, dynamic> toJson() => {
        "output": List<dynamic>.from(output.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class LabOutput {
    LabOutput({
        required this.labName,
        required this.lEvel,
        required this.labCode,
    });

    String labName;
    int lEvel;
    int labCode;

    factory LabOutput.fromJson(Map<dynamic, dynamic> json) => LabOutput(
        labName: json["LabName"],
        lEvel: json["lEVEL"],
        labCode: json["LabCode"],
    );

    Map<dynamic, dynamic> toJson() => {
        "LabName": labName,
        "lEVEL": lEvel,
        "LabCode": labCode,
    };
}
