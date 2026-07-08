class SampleCollectionHistoryModel {
  String? status;
  String? message;
  List<SampleCollectionHistoryOutput>? output;

  SampleCollectionHistoryModel({this.status, this.message, this.output});

  SampleCollectionHistoryModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['output'] != null) {
      output = [];
      json['output'].forEach((v) {
        output?.add(SampleCollectionHistoryOutput.fromJson(v));
      });
    }
  }
}

class SampleCollectionHistoryOutput {
  String? collectionDate;
  String? dayName;
  int? collectedCount;
  int? submittedCount;
  int? acceptedCount;

  SampleCollectionHistoryOutput({
    this.collectionDate,
    this.dayName,
    this.collectedCount,
    this.submittedCount,
    this.acceptedCount,
  });

  SampleCollectionHistoryOutput.fromJson(dynamic json) {
    collectionDate = json['EntryDate'];
    dayName = json['DayName'];
    collectedCount = json['SampleCollected'] is String
        ? int.tryParse(json['SampleCollected'])
        : json['SampleCollected'];
    submittedCount = json['SampleSubmitted'] is String
        ? int.tryParse(json['SampleSubmitted'])
        : json['SampleSubmitted'];
    acceptedCount = json['SampleAccepted'] is String
        ? int.tryParse(json['SampleAccepted'])
        : json['SampleAccepted'];
  }
}
