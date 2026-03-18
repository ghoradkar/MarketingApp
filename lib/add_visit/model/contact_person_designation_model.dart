class ContactPersonDesignationModel {
  ContactPersonDesignationModel({
      this.status, 
      this.message, 
      this.output,});

  ContactPersonDesignationModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['output'] != null) {
      output = [];
      json['output'].forEach((v) {
        output?.add(DesignationOutput.fromJson(v));
      });
    }
  }
  String? status;
  String? message;
  List<DesignationOutput>? output;

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

class DesignationOutput {
  DesignationOutput({
      this.desgID, 
      this.designation,});

  DesignationOutput.fromJson(dynamic json) {
    desgID = json['DesgID'];
    designation = json['Designation'];
  }
  int? desgID;
  String? designation;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DesgID'] = desgID;
    map['Designation'] = designation;
    return map;
  }

}