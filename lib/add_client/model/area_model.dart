class AreaModel {
  AreaModel({
      this.status, 
      this.message, 
      this.output,});

  AreaModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['output'] != null) {
      output = [];
      json['output'].forEach((v) {
        output?.add(AreaOutput.fromJson(v));
      });
    }
  }
  String? status;
  String? message;
  List<AreaOutput>? output;

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

class AreaOutput {
  AreaOutput({
      this.patchName, 
      this.patchId,});

  AreaOutput.fromJson(dynamic json) {
    patchName = json['PatchName'];
    patchId = json['PatchId'];
  }
  String? patchName;
  String? patchId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['PatchName'] = patchName;
    map['PatchId'] = patchId;
    return map;
  }

}