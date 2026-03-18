class VisitTypeModel {
  VisitTypeModel({
      this.status, 
      this.message, 
      this.output,});

  VisitTypeModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['output'] != null) {
      output = [];
      json['output'].forEach((v) {
        output?.add(VisitTypeOutput.fromJson(v));
      });
    }
  }
  String? status;
  String? message;
  List<VisitTypeOutput>? output;

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

class VisitTypeOutput {
  VisitTypeOutput({
      this.visitTypeID, 
      this.visitType,});

  VisitTypeOutput.fromJson(dynamic json) {
    visitTypeID = json['VisitTypeID'];
    visitType = json['VisitType'];
  }
  int? visitTypeID;
  String? visitType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['VisitTypeID'] = visitTypeID;
    map['VisitType'] = visitType;
    return map;
  }

}