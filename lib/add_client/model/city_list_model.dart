class CityListModel {
  CityListModel({
      this.status, 
      this.message, 
      this.output,});

  CityListModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['output'] != null) {
      output = [];
      json['output'].forEach((v) {
        output?.add(CityOutput.fromJson(v));
      });
    }
  }
  String? status;
  String? message;
  List<CityOutput>? output;

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

class CityOutput {
  CityOutput({
      this.cityCode, 
      this.cityName,});

  CityOutput.fromJson(dynamic json) {
    cityCode = json['CityCode'];
    cityName = json['CityName'];
  }
  int? cityCode;
  String? cityName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CityCode'] = cityCode;
    map['CityName'] = cityName;
    return map;
  }

}