class ContactPersonNameModel {
  ContactPersonNameModel({
      this.status, 
      this.message, 
      this.output,});

  ContactPersonNameModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['output'] != null) {
      output = [];
      json['output'].forEach((v) {
        output?.add(ContactPersonNameOutput.fromJson(v));
      });
    }
  }
  String? status;
  String? message;
  List<ContactPersonNameOutput>? output;

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

class ContactPersonNameOutput {
  ContactPersonNameOutput({
      this.cPId, 
      this.cPName, 
      this.desgId, 
      this.cPContactNo, 
      this.isActive, 
      this.userId,});

  ContactPersonNameOutput.fromJson(dynamic json) {
    cPId = json['CPId'];
    cPName = json['CPName'];
    desgId = json['DesgId'];
    cPContactNo = json['CPContactNo'];
    isActive = json['IsActive'];
    userId = json['UserId'];
  }
  int? cPId;
  String? cPName;
  int? desgId;
  String? cPContactNo;
  bool? isActive;
  int? userId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CPId'] = cPId;
    map['CPName'] = cPName;
    map['DesgId'] = desgId;
    map['CPContactNo'] = cPContactNo;
    map['IsActive'] = isActive;
    map['UserId'] = userId;
    return map;
  }

}