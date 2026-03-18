class TodaysVisitDetailModel {
  TodaysVisitDetailModel({
      this.status, 
      this.message, 
      this.output,});

  TodaysVisitDetailModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['output'] != null) {
      output = [];
      json['output'].forEach((v) {
        output?.add(TodaysVisitDetOutput.fromJson(v));
      });
    }
  }
  String? status;
  String? message;
  List<TodaysVisitDetOutput>? output;

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

class TodaysVisitDetOutput {
  TodaysVisitDetOutput({
      this.userid, 
      this.visitID, 
      this.firstname, 
      this.visitTime, 
      this.latitude, 
      this.logitude, 
      this.custLat, 
      this.custLongi, 
      this.visitTypeID, 
      this.punchInLatitude, 
      this.punchInLogitude, 
      this.punchOutLatitude, 
      this.punchOutLogitude, 
      this.punchInTime, 
      this.punchOutTime,});

  TodaysVisitDetOutput.fromJson(dynamic json) {
    userid = json['USERID'];
    visitID = json['VisitID'];
    firstname = json['FIRSTNAME'];
    visitTime = json['VisitTime'];
    latitude = json['latitude'];
    logitude = json['logitude'];
    custLat = json['CustLat'];
    custLongi = json['CustLongi'];
    visitTypeID = json['VisitTypeID'];
    punchInLatitude = json['PunchInLatitude'];
    punchInLogitude = json['PunchInLogitude'];
    punchOutLatitude = json['PunchOutLatitude'];
    punchOutLogitude = json['PunchOutLogitude'];
    punchInTime = json['PunchInTime'];
    punchOutTime = json['PunchOutTime'];
  }
  int? userid;
  int? visitID;
  String? firstname;
  String? visitTime;
  String? latitude;
  String? logitude;
  String? custLat;
  String? custLongi;
  int? visitTypeID;
  String? punchInLatitude;
  String? punchInLogitude;
  String? punchOutLatitude;
  String? punchOutLogitude;
  String? punchInTime;
  String? punchOutTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['USERID'] = userid;
    map['VisitID'] = visitID;
    map['FIRSTNAME'] = firstname;
    map['VisitTime'] = visitTime;
    map['latitude'] = latitude;
    map['logitude'] = logitude;
    map['CustLat'] = custLat;
    map['CustLongi'] = custLongi;
    map['VisitTypeID'] = visitTypeID;
    map['PunchInLatitude'] = punchInLatitude;
    map['PunchInLogitude'] = punchInLogitude;
    map['PunchOutLatitude'] = punchOutLatitude;
    map['PunchOutLogitude'] = punchOutLogitude;
    map['PunchInTime'] = punchInTime;
    map['PunchOutTime'] = punchOutTime;
    return map;
  }

}