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
    name = json['RunnerBoyName'];
    zone = json['Zone'];
    empCode = json['RunnerBoyuserID']?.toString();
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
