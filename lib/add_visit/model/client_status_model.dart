class ClientStatusModel {
  ClientStatusModel({
      this.status, 
      this.message, 
      this.output,});

  ClientStatusModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['output'] != null) {
      output = [];
      json['output'].forEach((v) {
        output?.add(ClientStatusOutput.fromJson(v));
      });
    }
  }
  String? status;
  String? message;
  List<ClientStatusOutput>? output;

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

class ClientStatusOutput {
  ClientStatusOutput({
      this.clientStatusId, 
      this.clientStatus,});

  ClientStatusOutput.fromJson(dynamic json) {
    clientStatusId = json['ClientStatusId'];
    clientStatus = json['ClientStatus'];
  }
  int? clientStatusId;
  String? clientStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ClientStatusId'] = clientStatusId;
    map['ClientStatus'] = clientStatus;
    return map;
  }

}