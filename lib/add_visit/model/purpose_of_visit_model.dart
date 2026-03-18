class PurposeOfVisitModel {
  PurposeOfVisitModel({
      this.status, 
      this.message, 
      this.output,});

  PurposeOfVisitModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['output'] != null) {
      output = [];
      json['output'].forEach((v) {
        output?.add(PurposeOutput.fromJson(v));
      });
    }
  }
  String? status;
  String? message;
  List<PurposeOutput>? output;

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

class PurposeOutput {
  PurposeOutput({
      this.mVisitActionID, 
      this.mVisitAction, 
      this.mVisitActionType,});

  PurposeOutput.fromJson(dynamic json) {
    mVisitActionID = json['MVisitActionID'];
    mVisitAction = json['MVisitAction'];
    mVisitActionType = json['MVisitActionType'];
  }
  int? mVisitActionID;
  String? mVisitAction;
  String? mVisitActionType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['MVisitActionID'] = mVisitActionID;
    map['MVisitAction'] = mVisitAction;
    map['MVisitActionType'] = mVisitActionType;
    return map;
  }

}