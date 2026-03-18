class MarketingPersonModel {
  MarketingPersonModel({
      this.status, 
      this.message, 
      this.output,});

  MarketingPersonModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['output'] != null) {
      output = [];
      json['output'].forEach((v) {
        output?.add(MarketingOutput.fromJson(v));
      });
    }
  }
  String? status;
  String? message;
  List<MarketingOutput>? output;

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

class MarketingOutput {
  MarketingOutput({
      this.userid, 
      this.userName, 
      this.desgid, 
      this.desgName,});

  MarketingOutput.fromJson(dynamic json) {
    userid = json['USERID'];
    userName = json['UserName'];
    desgid = json['DESGID'];
    desgName = json['DesgName'];
  }
  int? userid;
  String? userName;
  int? desgid;
  String? desgName;
  bool isChecked = false;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['USERID'] = userid;
    map['UserName'] = userName;
    map['DESGID'] = desgid;
    map['DesgName'] = desgName;
    return map;
  }

}