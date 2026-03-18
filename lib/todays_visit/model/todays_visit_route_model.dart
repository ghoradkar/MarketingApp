class TodaysVisitRouteTime {
  TodaysVisitRouteTime({
      this.status, 
      this.message, 
      this.output,});

  TodaysVisitRouteTime.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['output'] != null) {
      output = [];
      json['output'].forEach((v) {
        output?.add(TodaysVisitRouteOutput.fromJson(v));
      });
    }
  }
  String? status;
  String? message;
  List<TodaysVisitRouteOutput>? output;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (output != null) {
      map['output'] = output?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class TodaysVisitRouteOutput {
  TodaysVisitRouteOutput({
      this.startRouteTime, 
      this.eNDRouteTime, 
      this.startLatitude, 
      this.startLongitude, 
      this.endLatitude, 
      this.endLongitude,});

  TodaysVisitRouteOutput.fromJson(dynamic json) {
    startRouteTime = json['StartRouteTime'];
    eNDRouteTime = json['ENDRouteTime'];
    startLatitude = json['StartLatitude'];
    startLongitude = json['StartLongitude'];
    endLatitude = json['EndLatitude'];
    endLongitude = json['EndLongitude'];
  }
  String? startRouteTime;
  dynamic eNDRouteTime;
  String? startLatitude;
  String? startLongitude;
  dynamic endLatitude;
  dynamic endLongitude;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['StartRouteTime'] = startRouteTime;
    map['ENDRouteTime'] = eNDRouteTime;
    map['StartLatitude'] = startLatitude;
    map['StartLongitude'] = startLongitude;
    map['EndLatitude'] = endLatitude;
    map['EndLongitude'] = endLongitude;
    return map;
  }

}