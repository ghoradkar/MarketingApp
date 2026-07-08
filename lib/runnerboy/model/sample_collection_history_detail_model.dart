class SampleCollectionHistoryDetailModel {
  String? status;
  String? message;
  List<SampleCollectionHistoryDetailOutput>? output;

  SampleCollectionHistoryDetailModel({this.status, this.message, this.output});

  SampleCollectionHistoryDetailModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['output'] != null) {
      output = [];
      json['output'].forEach((v) {
        output?.add(SampleCollectionHistoryDetailOutput.fromJson(v));
      });
    }
  }
}

class SampleCollectionHistoryDetailOutput {
  String? entryDate;
  String? dayName;
  String? client;
  String? tube;
  String? trf;
  String? temperature;
  String? time;
  num? amount;

  SampleCollectionHistoryDetailOutput({
    this.entryDate,
    this.dayName,
    this.client,
    this.tube,
    this.trf,
    this.temperature,
    this.time,
    this.amount,
  });

  SampleCollectionHistoryDetailOutput.fromJson(dynamic json) {
    entryDate = json['EntryDate'];
    dayName = json['DayName'];
    client = json['Client'];
    tube = json['Tube'];
    trf = json['TRF'];
    temperature = json['temprature'];
    time = json['Time'];
    amount =
        json['Amount'] is String ? num.tryParse(json['Amount']) : json['Amount'];
  }
}
