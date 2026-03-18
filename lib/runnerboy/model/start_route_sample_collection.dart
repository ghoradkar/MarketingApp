

import 'dart:convert';

StartRouteSampleCollection startRouteSampleCollectionFromJson(String str) => StartRouteSampleCollection.fromJson(json.decode(str));

String startRouteSampleCollectionToJson(StartRouteSampleCollection data) => json.encode(data.toJson());

class StartRouteSampleCollection {
    StartRouteSampleCollection({
        required this.message,
        required this.status,
    });

    int message;
    String status;

    factory StartRouteSampleCollection.fromJson(Map<dynamic, dynamic> json) => StartRouteSampleCollection(
        message: json["message"],
        status: json["status"],
    );

    Map<dynamic, dynamic> toJson() => {
        "message": message,
        "status": status,
    };
}
