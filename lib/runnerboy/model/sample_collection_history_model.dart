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
    collectionDate = json['CollectionDate'];
    dayName = json['DayName'];
    collectedCount = json['CollectedCount'] is String
        ? int.tryParse(json['CollectedCount'])
        : json['CollectedCount'];
    submittedCount = json['SubmittedCount'] is String
        ? int.tryParse(json['SubmittedCount'])
        : json['SubmittedCount'];
    acceptedCount = json['AcceptedCount'] is String
        ? int.tryParse(json['AcceptedCount'])
        : json['AcceptedCount'];
  }
}
