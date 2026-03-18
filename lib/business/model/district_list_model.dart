
import 'dart:convert';

DistrictListModel districtListModelFromJson(String str) => DistrictListModel.fromJson(json.decode(str));

String districtListModelToJson(DistrictListModel data) => json.encode(data.toJson());

class DistrictListModel {
    DistrictListModel({
        required this.output,
        required this.message,
        required this.status,
    });

    List<DistrictOutput> output;
    String message;
    String status;

    factory DistrictListModel.fromJson(Map<dynamic, dynamic> json) => DistrictListModel(
        output: List<DistrictOutput>.from(json["output"].map((x) => DistrictOutput.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<dynamic, dynamic> toJson() => {
        "output": List<dynamic>.from(output.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class DistrictOutput {
    DistrictOutput({
        required this.distlgdcode,
        required this.level,
        required this.distname,
    });

    int distlgdcode;
    int level;
    String distname;

    factory DistrictOutput.fromJson(Map<dynamic, dynamic> json) => DistrictOutput(
        distlgdcode: json["DISTLGDCODE"],
        level: json["Level"],
        distname: json["DISTNAME"],
    );

    Map<dynamic, dynamic> toJson() => {
        "DISTLGDCODE": distlgdcode,
        "Level": level,
        "DISTNAME": distname,
    };
}
