
import 'dart:convert';

BloodGroupList bloodGroupListFromJson(String str) => BloodGroupList.fromJson(json.decode(str));

String bloodGroupListToJson(BloodGroupList data) => json.encode(data.toJson());

class BloodGroupList {
    BloodGroupList({
        required this.output,
        required this.message,
        required this.status,
    });

    List<Output> output;
    String message;
    String status;

    factory BloodGroupList.fromJson(Map<dynamic, dynamic> json) => BloodGroupList(
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
        required this.bloodid,
        required this.bloodname,
    });

    int bloodid;
    String bloodname;

    factory Output.fromJson(Map<dynamic, dynamic> json) => Output(
        bloodid: json["BLOODID"],
        bloodname: json["BLOODNAME"],
    );

    Map<dynamic, dynamic> toJson() => {
        "BLOODID": bloodid,
        "BLOODNAME": bloodname,
    };
}
