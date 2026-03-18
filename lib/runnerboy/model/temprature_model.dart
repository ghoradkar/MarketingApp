
import 'dart:convert';

TempratureModel tempratureModelFromJson(String str) => TempratureModel.fromJson(json.decode(str));

String tempratureModelToJson(TempratureModel data) => json.encode(data.toJson());

class TempratureModel {
    TempratureModel({
        required this.output,
        required this.message,
        required this.status,
    });

    List<TempratureOutput> output;
    String message;
    String status;

    factory TempratureModel.fromJson(Map<dynamic, dynamic> json) => TempratureModel(
        output: List<TempratureOutput>.from(json["output"].map((x) => TempratureOutput.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<dynamic, dynamic> toJson() => {
        "output": List<dynamic>.from(output.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class TempratureOutput {
    TempratureOutput({
        required this.sampleTempId,
        required this.sampleTempName,
    });

    int sampleTempId;
    String sampleTempName;

    factory TempratureOutput.fromJson(Map<dynamic, dynamic> json) => TempratureOutput(
        sampleTempId: json["SampleTempID"],
        sampleTempName: json["SampleTempName"],
    );

    Map<dynamic, dynamic> toJson() => {
        "SampleTempID": sampleTempId,
        "SampleTempName": sampleTempName,
    };
}
