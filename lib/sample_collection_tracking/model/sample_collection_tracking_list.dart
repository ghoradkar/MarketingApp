

import 'dart:convert';

SampleCollectionTrackingList sampleCollectionTrackingListFromJson(String str) => SampleCollectionTrackingList.fromJson(json.decode(str));

String sampleCollectionTrackingListToJson(SampleCollectionTrackingList data) => json.encode(data.toJson());

class SampleCollectionTrackingList {
    SampleCollectionTrackingList({
        required this.output,
        required this.message,
        required this.status,
    });

    List<Output> output;
    String message;
    String status;

    factory SampleCollectionTrackingList.fromJson(Map<dynamic, dynamic> json) => SampleCollectionTrackingList(
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
        required this.temprature,
        required this.isSampleAccepted,
        required this.userid,
        required this.collectedAmount,
        required this.sampleCount,
        required this.resourcesName,
        required this.routeId,
        required this.sampleTempName,
        required this.trfCount,
        required this.isSampleSubmitted,
    });

    int temprature;
    String isSampleAccepted;
    int userid;
    double collectedAmount;
    int sampleCount;
    String resourcesName;
    int routeId;
    String? sampleTempName;
    int trfCount;
    String isSampleSubmitted;

    factory Output.fromJson(Map<dynamic, dynamic> json) => Output(
        temprature: json["temprature"],
        isSampleAccepted: json["ISSampleAccepted"],
        userid: json["Userid"],
        collectedAmount: json["CollectedAmount"],
        sampleCount: json["SampleCount"],
        resourcesName: json["ResourcesName"],
        routeId: json["RouteID"],
        sampleTempName: json["SampleTempName"],
        trfCount: json["TRFCount"],
        isSampleSubmitted: json["ISSampleSubmitted"],
    );

    Map<dynamic, dynamic> toJson() => {
        "temprature": temprature,
        "ISSampleAccepted": isSampleAccepted,
        "Userid": userid,
        "CollectedAmount": collectedAmount,
        "SampleCount": sampleCount,
        "ResourcesName": resourcesName,
        "RouteID": routeId,
        "SampleTempName": sampleTempName,
        "TRFCount": trfCount,
        "ISSampleSubmitted": isSampleSubmitted,
    };
}
