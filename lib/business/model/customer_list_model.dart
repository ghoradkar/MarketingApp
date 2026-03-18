
import 'dart:convert';

CustomerListModel customerListModelFromJson(String str) => CustomerListModel.fromJson(json.decode(str));

String customerListModelToJson(CustomerListModel data) => json.encode(data.toJson());

class CustomerListModel {
  CustomerListModel({
    required this.output,
    required this.message,
    required this.status,
  });

  List<CustomerOutput> output;
  String message;
  String status;

  factory CustomerListModel.fromJson(Map<dynamic, dynamic> json) => CustomerListModel(
    output: List<CustomerOutput>.from(json["output"].map((x) => CustomerOutput.fromJson(x))),
    message: json["message"],
    status: json["status"],
  );

  Map<dynamic, dynamic> toJson() => {
    "output": List<dynamic>.from(output.map((x) => x.toJson())),
    "message": message,
    "status": status,
  };
}

class CustomerOutput {
  CustomerOutput({
    required this.labName,
    required this.lEvel,
    required this.labCode,
  });

  String labName;
  int lEvel;
  int labCode;

  factory CustomerOutput.fromJson(Map<dynamic, dynamic> json) => CustomerOutput(
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
