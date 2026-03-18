

import 'dart:convert';

StateModelList stateModelListFromJson(String str) => StateModelList.fromJson(json.decode(str));

String stateModelListToJson(StateModelList data) => json.encode(data.toJson());

class StateModelList {
    StateModelList({
        required this.output,
        required this.message,
        required this.status,
    });

    List<Output> output;
    String message;
    String status;

    factory StateModelList.fromJson(Map<dynamic, dynamic> json) => StateModelList(
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
        required this.statename,
        required this.statelgdcode,
    });

    String statename;
    int statelgdcode;

    factory Output.fromJson(Map<dynamic, dynamic> json) => Output(
        statename: json["STATENAME"],
        statelgdcode: json["STATELGDCODE"],
    );

    Map<dynamic, dynamic> toJson() => {
        "STATENAME": statename,
        "STATELGDCODE": statelgdcode,
    };
}
