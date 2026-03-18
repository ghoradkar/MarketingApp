class PunchInDetailsModel {
  PunchInDetailsModel({
      this.status, 
      this.message, 
      this.output,});

  PunchInDetailsModel.fromJson(dynamic json) {
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
      this.userID, 
      this.punchInDateTime, 
      this.punchInLatitude, 
      this.punchInLogitude, 
      this.punchingStatus,});

  Output.fromJson(dynamic json) {
    userID = json['UserID'];
    punchInDateTime = json['PunchInDateTime'];
    punchInLatitude = json['PunchInLatitude'];
    punchInLogitude = json['PunchInLogitude'];
    punchingStatus = json['PunchingStatus'];
  }
  int? userID;
  String? punchInDateTime;
  String? punchInLatitude;
  String? punchInLogitude;
  int? punchingStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['UserID'] = userID;
    map['PunchInDateTime'] = punchInDateTime;
    map['PunchInLatitude'] = punchInLatitude;
    map['PunchInLogitude'] = punchInLogitude;
    map['PunchingStatus'] = punchingStatus;
    return map;
  }

}