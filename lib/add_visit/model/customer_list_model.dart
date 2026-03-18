class CustomerListModel {
  CustomerListModel({
      this.status, 
      this.message, 
      this.output,});

  CustomerListModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['output'] != null) {
      output = [];
      json['output'].forEach((v) {
        output?.add(OutputCustomer.fromJson(v));
      });
    }
  }
  String? status;
  String? message;
  List<OutputCustomer>? output;

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

class OutputCustomer {
  OutputCustomer({
      this.userid, 
      this.firstname, 
      this.distlgdcode,});

  OutputCustomer.fromJson(dynamic json) {
    userid = json['USERID'];
    firstname = json['FIRSTNAME'];
    distlgdcode = json['DISTLGDCODE'];
  }
  int? userid;
  String? firstname;
  int? distlgdcode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['USERID'] = userid;
    map['FIRSTNAME'] = firstname;
    map['DISTLGDCODE'] = distlgdcode;
    return map;
  }

}