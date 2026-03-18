class ContactPersonStatusModel {
  ContactPersonStatusModel({
      this.status, 
      this.message, 
      this.output,});

  ContactPersonStatusModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['output'] != null) {
      output = [];
      json['output'].forEach((v) {
        output?.add(ContPersonStatOutput.fromJson(v));
      });
    }
  }
  String? status;
  String? message;
  List<ContPersonStatOutput>? output;

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

class ContPersonStatOutput {
  ContPersonStatOutput({
      this.cPStatusId, 
      this.statusName, 
      this.isActive, 
      this.createdBy, 
      this.createdon,});

  ContPersonStatOutput.fromJson(dynamic json) {
    cPStatusId = json['CPStatusId'];
    statusName = json['StatusName'];
    isActive = json['IsActive'];
    createdBy = json['CreatedBy'];
    createdon = json['Createdon'];
  }
  int? cPStatusId;
  String? statusName;
  bool? isActive;
  int? createdBy;
  String? createdon;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CPStatusId'] = cPStatusId;
    map['StatusName'] = statusName;
    map['IsActive'] = isActive;
    map['CreatedBy'] = createdBy;
    map['Createdon'] = createdon;
    return map;
  }

}