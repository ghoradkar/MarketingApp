class SampleCollectionOverviewModel {
  String? status;
  String? message;
  List<SampleCollectionOverviewMember>? members;

  SampleCollectionOverviewModel({this.status, this.message, this.members});

  SampleCollectionOverviewModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['output'] != null) {
      members = [];
      json['output'].forEach((v) {
        members?.add(SampleCollectionOverviewMember.fromJson(v));
      });
    }
  }
}

class SampleCollectionOverviewMember {
  String? name;
  String? zone;
  String? empCode;
  int? collectedCount;
  int? submittedCount;
  int? acceptedCount;

  SampleCollectionOverviewMember({
    this.name,
    this.zone,
    this.empCode,
    this.collectedCount,
    this.submittedCount,
    this.acceptedCount,
  });

  SampleCollectionOverviewMember.fromJson(dynamic json) {
    name = json['Name'];
    zone = json['Zone'];
    empCode = json['EmpCode']?.toString();
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
