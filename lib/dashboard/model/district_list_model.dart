class DistrictListModel {
  DistrictListModel({
      this.status, 
      this.message, 
      this.output,});

  DistrictListModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['output'] != null) {
      output = [];
      json['output'].forEach((v) {
        output?.add(DistrictOutput.fromJson(v));
      });
    }
  }
  String? status;
  String? message;
  List<DistrictOutput>? output;

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

class DistrictOutput {
  DistrictOutput({
      this.statelgdcode, 
      this.statename, 
      this.distlgdcode, 
      this.distname, 
      this.localdistname,});

  DistrictOutput.fromJson(dynamic json) {
    statelgdcode = json['STATELGDCODE'];
    statename = json['STATENAME'];
    distlgdcode = json['DISTLGDCODE'];
    distname = json['DISTNAME'];
    localdistname = json['LOCALDISTNAME'];
  }
  int? statelgdcode;
  String? statename;
  int? distlgdcode;
  String? distname;
  String? localdistname;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['STATELGDCODE'] = statelgdcode;
    map['STATENAME'] = statename;
    map['DISTLGDCODE'] = distlgdcode;
    map['DISTNAME'] = distname;
    map['LOCALDISTNAME'] = localdistname;
    return map;
  }

}