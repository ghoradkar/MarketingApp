class CustomerVisitDetails {
  CustomerVisitDetails({
      this.status, 
      this.message, 
      this.output,});

  CustomerVisitDetails.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['output'] != null) {
      output = [];
      json['output'].forEach((v) {
        output?.add(OutputCustDet.fromJson(v));
      });
    }
  }
  String? status;
  String? message;
  List<OutputCustDet>? output;

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

class OutputCustDet {
  OutputCustDet({
      this.visitID, 
      this.userid, 
      this.firstname, 
      this.custVisitDate, 
      this.custConverted, 
      this.productName, 
      this.disscussionPoint, 
      this.contactPerson, 
      this.cPId, 
      this.cPName, 
      this.cPStatusId, 
      this.statusName, 
      this.latitude, 
      this.logitude, 
      this.userAddress, 
      this.custVisitMeetingTypeID, 
      this.custVisitMeetingType, 
      this.custVisitTypeID, 
      this.custVisitType, 
      this.visitActionID, 
      this.visitAction, 
      this.marketingUsers, 
      this.visitService, 
      this.desgid, 
      this.clientStatusId, 
      this.desgID1, 
      this.mVisitActionID, 
      this.clientStatus, 
      this.designation, 
      this.mVisitAction, 
      this.resourceName, 
      this.visitTypeID, 
      this.punchInLatitude, 
      this.punchInLogitude, 
      this.punchOutLatitude, 
      this.punchOutLogitude, 
      this.punchInTime, 
      this.punchOutTime, 
      this.visitType, 
      this.lat, 
      this.long, 
      this.disscussionPoint1,});

  OutputCustDet.fromJson(dynamic json) {
    visitID = json['VisitID'];
    userid = json['USERID'];
    firstname = json['FIRSTNAME'];
    custVisitDate = json['CustVisitDate'];
    custConverted = json['CustConverted'];
    productName = json['ProductName'];
    disscussionPoint = json['DisscussionPoint'];
    contactPerson = json['ContactPerson'];
    cPId = json['CPId'];
    cPName = json['CPName'];
    cPStatusId = json['CPStatusId'];
    statusName = json['StatusName'];
    latitude = json['latitude'];
    logitude = json['logitude'];
    userAddress = json['UserAddress'];
    custVisitMeetingTypeID = json['CustVisitMeetingTypeID'];
    custVisitMeetingType = json['CustVisitMeetingType'];
    custVisitTypeID = json['CustVisitTypeID'];
    custVisitType = json['CustVisitType'];
    visitActionID = json['VisitActionID'];
    visitAction = json['VisitAction'];
    marketingUsers = json['MarketingUsers'];
    visitService = json['VisitService'];
    desgid = json['DESGID'];
    clientStatusId = json['ClientStatusId'];
    desgID1 = json['DesgID1'];
    mVisitActionID = json['MVisitActionID'];
    clientStatus = json['ClientStatus'];
    designation = json['Designation'];
    mVisitAction = json['MVisitAction'];
    resourceName = json['ResourceName'];
    visitTypeID = json['VisitTypeID'];
    punchInLatitude = json['PunchInLatitude'];
    punchInLogitude = json['PunchInLogitude'];
    punchOutLatitude = json['PunchOutLatitude'];
    punchOutLogitude = json['PunchOutLogitude'];
    punchInTime = json['PunchInTime'];
    punchOutTime = json['PunchOutTime'];
    visitType = json['VisitType'];
    lat = json['lat'];
    long = json['Long'];
    disscussionPoint1 = json['DisscussionPoint1'];
  }
  int? visitID;
  int? userid;
  String? firstname;
  String? custVisitDate;
  String? custConverted;
  dynamic productName;
  String? disscussionPoint;
  dynamic contactPerson;
  int? cPId;
  String? cPName;
  int? cPStatusId;
  String? statusName;
  String? latitude;
  String? logitude;
  String? userAddress;
  dynamic custVisitMeetingTypeID;
  dynamic custVisitMeetingType;
  dynamic custVisitTypeID;
  dynamic custVisitType;
  dynamic visitActionID;
  dynamic visitAction;
  String? marketingUsers;
  String? visitService;
  int? desgid;
  int? clientStatusId;
  int? desgID1;
  int? mVisitActionID;
  String? clientStatus;
  String? designation;
  String? mVisitAction;
  String? resourceName;
  int? visitTypeID;
  String? punchInLatitude;
  String? punchInLogitude;
  String? punchOutLatitude;
  String? punchOutLogitude;
  String? punchInTime;
  String? punchOutTime;
  String? visitType;
  String? lat;
  String? long;
  String? disscussionPoint1;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['VisitID'] = visitID;
    map['USERID'] = userid;
    map['FIRSTNAME'] = firstname;
    map['CustVisitDate'] = custVisitDate;
    map['CustConverted'] = custConverted;
    map['ProductName'] = productName;
    map['DisscussionPoint'] = disscussionPoint;
    map['ContactPerson'] = contactPerson;
    map['CPId'] = cPId;
    map['CPName'] = cPName;
    map['CPStatusId'] = cPStatusId;
    map['StatusName'] = statusName;
    map['latitude'] = latitude;
    map['logitude'] = logitude;
    map['UserAddress'] = userAddress;
    map['CustVisitMeetingTypeID'] = custVisitMeetingTypeID;
    map['CustVisitMeetingType'] = custVisitMeetingType;
    map['CustVisitTypeID'] = custVisitTypeID;
    map['CustVisitType'] = custVisitType;
    map['VisitActionID'] = visitActionID;
    map['VisitAction'] = visitAction;
    map['MarketingUsers'] = marketingUsers;
    map['VisitService'] = visitService;
    map['DESGID'] = desgid;
    map['ClientStatusId'] = clientStatusId;
    map['DesgID1'] = desgID1;
    map['MVisitActionID'] = mVisitActionID;
    map['ClientStatus'] = clientStatus;
    map['Designation'] = designation;
    map['MVisitAction'] = mVisitAction;
    map['ResourceName'] = resourceName;
    map['VisitTypeID'] = visitTypeID;
    map['PunchInLatitude'] = punchInLatitude;
    map['PunchInLogitude'] = punchInLogitude;
    map['PunchOutLatitude'] = punchOutLatitude;
    map['PunchOutLogitude'] = punchOutLogitude;
    map['PunchInTime'] = punchInTime;
    map['PunchOutTime'] = punchOutTime;
    map['VisitType'] = visitType;
    map['lat'] = lat;
    map['Long'] = long;
    map['DisscussionPoint1'] = disscussionPoint1;
    return map;
  }

}