class ClientTypeModel {
  ClientTypeModel({
      this.status, 
      this.message, 
      this.output,});

  ClientTypeModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['output'] != null) {
      output = [];
      json['output'].forEach((v) {
        output?.add(CustomerTypeOutput.fromJson(v));
      });
    }
  }
  String? status;
  String? message;
  List<CustomerTypeOutput>? output;

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

class CustomerTypeOutput {
  CustomerTypeOutput({
      this.typeid, 
      this.type,});

  CustomerTypeOutput.fromJson(dynamic json) {
    typeid = json['TYPEID'];
    type = json['TYPE'];
  }
  int? typeid;
  String? type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['TYPEID'] = typeid;
    map['TYPE'] = type;
    return map;
  }

}