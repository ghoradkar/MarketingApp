

import 'dart:convert';

ResourceNameListModel resourceNameListModelFromJson(String str) => ResourceNameListModel.fromJson(json.decode(str));

String resourceNameListModelToJson(ResourceNameListModel data) => json.encode(data.toJson());

class ResourceNameListModel {
    ResourceNameListModel({
        required this.output,
        required this.message,
        required this.status,
    });

    List<Output> output;
    String message;
    String status;

    factory ResourceNameListModel.fromJson(Map<dynamic, dynamic> json) => ResourceNameListModel(
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
        required this.isactivedesg,
        required this.userid,
        required this.desgid,
        required this.name,
    });

    bool isactivedesg;
    int userid;
    int desgid;
    String name;

    factory Output.fromJson(Map<dynamic, dynamic> json) => Output(
        isactivedesg: json["ISACTIVEDESG"],
        userid: json["USERID"],
        desgid: json["DESGID"],
        name: json["Name"],
    );

    Map<dynamic, dynamic> toJson() => {
        "ISACTIVEDESG": isactivedesg,
        "USERID": userid,
        "DESGID": desgid,
        "Name": name,
    };
}
