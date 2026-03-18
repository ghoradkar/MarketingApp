class MainDashBoardCount {
  MainDashBoardCount({
      this.districtCount, 
      this.facilityCount, 
      this.patientCount, 
      this.testCount, 
      this.patientCounttoday, 
      this.testCounttoday, 
      this.testReportedCount, 
      this.testPendingCount, 
      this.syncDate, 
      this.emergencyPatientCount, 
      this.totalLab, 
      this.tATMETPercentage, 
      this.todaysEmergencyPatientCount, 
      this.todaysPhleboPresentPer,});

  MainDashBoardCount.fromJson(dynamic json) {
    districtCount = json['DistrictCount'];
    facilityCount = json['FacilityCount'];
    patientCount = json['PatientCount'];
    testCount = json['TestCount'];
    patientCounttoday = json['PatientCounttoday'];
    testCounttoday = json['TestCounttoday'];
    testReportedCount = json['TestReportedCount'];
    testPendingCount = json['TestPendingCount'];
    syncDate = json['SyncDate'];
    emergencyPatientCount = json['EmergencyPatientCount'];
    totalLab = json['TotalLab'];
    tATMETPercentage = json['TATMETPercentage'];
    todaysEmergencyPatientCount = json['TodaysEmergencyPatientCount'];
    todaysPhleboPresentPer = json['TodaysPhleboPresentPer'];
  }
  String? districtCount;
  String? facilityCount;
  String? patientCount;
  String? testCount;
  String? patientCounttoday;
  String? testCounttoday;
  String? testReportedCount;
  String? testPendingCount;
  String? syncDate;
  String? emergencyPatientCount;
  String? totalLab;
  String? tATMETPercentage;
  String? todaysEmergencyPatientCount;
  String? todaysPhleboPresentPer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistrictCount'] = districtCount;
    map['FacilityCount'] = facilityCount;
    map['PatientCount'] = patientCount;
    map['TestCount'] = testCount;
    map['PatientCounttoday'] = patientCounttoday;
    map['TestCounttoday'] = testCounttoday;
    map['TestReportedCount'] = testReportedCount;
    map['TestPendingCount'] = testPendingCount;
    map['SyncDate'] = syncDate;
    map['EmergencyPatientCount'] = emergencyPatientCount;
    map['TotalLab'] = totalLab;
    map['TATMETPercentage'] = tATMETPercentage;
    map['TodaysEmergencyPatientCount'] = todaysEmergencyPatientCount;
    map['TodaysPhleboPresentPer'] = todaysPhleboPresentPer;
    return map;
  }

}