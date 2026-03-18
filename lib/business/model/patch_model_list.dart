
import 'dart:convert';

PatchModelList patchModelListFromJson(String str) => PatchModelList.fromJson(json.decode(str));

String patchModelListToJson(PatchModelList data) => json.encode(data.toJson());

class PatchModelList {
    PatchModelList({
        required this.output,
        required this.message,
        required this.status,
    });

    List<PatchOutput> output;
    String message;
    String status;

    factory PatchModelList.fromJson(Map<dynamic, dynamic> json) => PatchModelList(
        output: List<PatchOutput>.from(json["output"].map((x) => PatchOutput.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<dynamic, dynamic> toJson() => {
        "output": List<dynamic>.from(output.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class PatchOutput {
    PatchOutput({
        required this.patchName,
        required this.patchId,
    });

    String patchName;
    String patchId;

    factory PatchOutput.fromJson(Map<dynamic, dynamic> json) => PatchOutput(
        patchName: json["PatchName"],
        patchId: json["PatchId"],
    );

    Map<dynamic, dynamic> toJson() => {
        "PatchName": patchName,
        "PatchId": patchId,
    };
}
