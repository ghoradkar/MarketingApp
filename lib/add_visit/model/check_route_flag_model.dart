class CheckRouteFlagModel {
  CheckRouteFlagModel({
      this.status, 
      this.message, 
      this.output,});

  CheckRouteFlagModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['output'] != null) {
      output = [];
      json['output'].forEach((v) {
        output?.add(Output.fromJson(v));
      });
    }
  }
  String? status;
  String? message;
  List<Output>? output;

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

class Output {
  Output({
      this.routeID, 
      this.startRoute, 
      this.endRoute, 
      this.createdDate,});

  Output.fromJson(dynamic json) {
    routeID = json['RouteID'];
    startRoute = json['StartRoute'];
    endRoute = json['EndRoute'];
    createdDate = json['CreatedDate'];
  }
  int? routeID;
  int? startRoute;
  int? endRoute;
  String? createdDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['RouteID'] = routeID;
    map['StartRoute'] = startRoute;
    map['EndRoute'] = endRoute;
    map['CreatedDate'] = createdDate;
    return map;
  }

}