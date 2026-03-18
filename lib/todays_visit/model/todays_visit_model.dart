class TodaysVisitModel {
  TodaysVisitModel({
      this.status, 
      this.message, 
      this.output,});

  TodaysVisitModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['output'] != null) {
      output = [];
      json['output'].forEach((v) {
        output?.add(TodaysVisitOutput.fromJson(v));
      });
    }
  }
  String? status;
  String? message;
  List<TodaysVisitOutput>? output;

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

class TodaysVisitOutput {
  TodaysVisitOutput({
      this.resourceName, 
      this.noOfVisit, 
      this.resourceUserID, 
      this.newCustomer,});

  TodaysVisitOutput.fromJson(dynamic json) {
    resourceName = json['ResourceName'];
    noOfVisit = json['NoOfVisit'];
    resourceUserID = json['ResourceUserID'];
    newCustomer = json['NewCustomer'];
  }
  String? resourceName;
  int? noOfVisit;
  int? resourceUserID;
  int? newCustomer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ResourceName'] = resourceName;
    map['NoOfVisit'] = noOfVisit;
    map['ResourceUserID'] = resourceUserID;
    map['NewCustomer'] = newCustomer;
    return map;
  }

}