class DashCountModel {
  DashCountModel({
      this.status,
      this.message,
      this.output,});

  DashCountModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['output'] != null) {
      output = [];
      json['output'].forEach((v) {
        output?.add(Output.fromJson(v));
      });
    }
  }
  String? status;
  String? message;
  List<Output>? output;

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

class Output {
  Output({
      this.distlgdcode,
      this.totalCustomer,
      this.totalVisit,
      this.todaysVisit,
      this.customerVisitedToday,
      this.prospectiveClient,
      this.activeClient,
      this.inActiveClient,
      this.closedClient,});

  Output.fromJson(dynamic json) {
    distlgdcode = json['DISTLGDCODE'];
    totalCustomer = json['TotalCustomer'];
    totalVisit = json['TotalVisit'];
    todaysVisit = json['TodaysVisit'];
    customerVisitedToday = json['CustomerVisitedToday'];
    prospectiveClient = json['ProspectiveClient'];
    activeClient = json['ActiveClient'];
    inActiveClient = json['InActiveClient'];
    closedClient = json['ClosedClient'];
    convertedYesCount = json['ConvertedYesCount'];
    convertedNOCount = json['ConvertedNOCount'];
    salesTarget = json['SalesTarget'];
    clientPotential = json['ClientPotential'];
    invoiceAmount = json['InvoiceAmount'];
  }
  int? distlgdcode;
  int? totalCustomer;
  int? totalVisit;
  int? todaysVisit;
  int? customerVisitedToday;
  int? prospectiveClient;
  int? activeClient;
  int? inActiveClient;
  int? closedClient;
  int? convertedYesCount;
  int? convertedNOCount;
  double? salesTarget;
  int? clientPotential;
  double? invoiceAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DISTLGDCODE'] = distlgdcode;
    map['TotalCustomer'] = totalCustomer;
    map['TotalVisit'] = totalVisit;
    map['TodaysVisit'] = todaysVisit;
    map['CustomerVisitedToday'] = customerVisitedToday;
    map['ProspectiveClient'] = prospectiveClient;
    map['ActiveClient'] = activeClient;
    map['InActiveClient'] = inActiveClient;
    map['ClosedClient'] = closedClient;
    map['ConvertedYesCount'] = convertedYesCount;
    map['ConvertedNOCount'] = convertedNOCount;
    map['SalesTarget'] = salesTarget;
    map['ClientPotential'] = clientPotential;
    map['InvoiceAmount'] = invoiceAmount;
    return map;
  }

}