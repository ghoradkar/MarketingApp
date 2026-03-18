class ServicesModel {
  ServicesModel({
      this.status, 
      this.message, 
      this.output,});

  ServicesModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['output'] != null) {
      output = [];
      json['output'].forEach((v) {
        output?.add(ServicesOutput.fromJson(v));
      });
    }
  }
  String? status;
  String? message;
  List<ServicesOutput>? output;

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

class ServicesOutput {
  ServicesOutput({
      this.custVisitServiceID, 
      this.custVisitService, 
      this.custVisitServiceType,});

  ServicesOutput.fromJson(dynamic json) {
    custVisitServiceID = json['CustVisitServiceID'];
    custVisitService = json['CustVisitService'];
    custVisitServiceType = json['CustVisitServiceType'];
  }
  int? custVisitServiceID;
  String? custVisitService;
  String? custVisitServiceType;
  bool isChecked = false;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CustVisitServiceID'] = custVisitServiceID;
    map['CustVisitService'] = custVisitService;
    map['CustVisitServiceType'] = custVisitServiceType;
    return map;
  }

}