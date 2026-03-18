class SavedAvailabilty {
  SavedAvailabilty({
      this.status, 
      this.message, 
      this.output,});

  SavedAvailabilty.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['output'] != null) {
      output = [];
      json['output'].forEach((v) {
        output?.add(AvailabilityOutput.fromJson(v));
      });
    }
  }
  String? status;
  String? message;
  List<AvailabilityOutput>? output;

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

class AvailabilityOutput {
  AvailabilityOutput({
      this.year, 
      this.month, 
      this.day, 
      this.daytype,});

  AvailabilityOutput.fromJson(dynamic json) {
    year = json['Year'];
    month = json['Month'];
    day = json['Day'];
    daytype = json['DAYTYPE'];
  }
  int? year;
  int? month;
  int? day;
  int? daytype;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Year'] = year;
    map['Month'] = month;
    map['Day'] = day;
    map['DAYTYPE'] = daytype;
    return map;
  }

}