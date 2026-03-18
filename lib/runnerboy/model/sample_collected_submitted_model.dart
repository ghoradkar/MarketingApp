class SampleCollectedSubmittedModel {
  SampleCollectedSubmittedModel({
    this.status,
    this.message,
    this.output,
  });

  SampleCollectedSubmittedModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['output'] != null) {
      output = [];
      json['output'].forEach((v) {
        output?.add(SampleCollectedSubmitedOutput.fromJson(v));
      });
    }
  }

  String? status;
  String? message;
  List<SampleCollectedSubmitedOutput>? output;

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

class SampleCollectedSubmitedOutput {
  SampleCollectedSubmitedOutput(
      {this.facilityName,
      this.facilityCode,
      this.sampleCount,
      this.amount,
      this.sampleCollTime,
      this.locID,
      this.latitude,
      this.paymentModeId,
      this.contactPerson,
      this.sampleRemark,
      this.sufficeientTuberemark,
      this.allsamplebarcoderemark,
      this.otherdocumentRemark,
      this.detailsontrfremark,
      this.sampleTubeId,
      this.otherdocumentcollectedid,
      this.sufficeientTubeId,
      this.allsamplebarcodeId,
      this.detailsontrfId,
      this.tansactionNo,
      this.longitude,
      this.mapFlag,
      this.iSLabSubmit,
      this.iSSampleAccepted,
      this.column1,
      this.tRFCount,
      this.temprature,
      this.sampleTempName,
      this.recieptNo,
      this.sampleID,
      this.uploadedFilePath,
      this.viewUploadFilePath,
      this.centerID,
      this.customerType,
      this.customerTypeName,
      this.paymentType,
      this.ptypeid,
      this.availableFund,
      this.labCode});

  SampleCollectedSubmitedOutput.fromJson(dynamic json) {
    facilityName = json['FacilityName'];
    facilityCode = json['FacilityCode'];
    sampleCount = json['SampleCount'];
    amount = json['Amount'] is String ? double.tryParse(json['Amount']):json['Amount'];
    sampleCollTime = json['SampleCollTime'];
    locID = json['LocID'];
    latitude = json['LATITUDE'];
    paymentModeId = json['PaymentModeId'] is String
        ? int.parse(json['PaymentModeId'])
        : json['PaymentModeId'];
    contactPerson = json['ContactPerson'];
    sampleRemark = json['SampleRemark'];
    sufficeientTuberemark = json['SufficeientTuberemark'];
    allsamplebarcoderemark = json['Allsamplebarcoderemark'];
    otherdocumentRemark = json['otherdocumentRemark'];
    detailsontrfremark = json['Detailsontrfremark'];
    sampleTubeId = json['SampleTubeId'];
    otherdocumentcollectedid = json['otherdocumentcollectedid'];
    sufficeientTubeId = json['SufficeientTubeId'];
    allsamplebarcodeId = json['AllsamplebarcodeId'];
    detailsontrfId = json['DetailsontrfId'];
    tansactionNo = json['tansactionNo'];
    longitude = json['LONGITUDE'];
    mapFlag = json['MapFlag'];
    iSLabSubmit = json['ISLabSubmit'];
    iSSampleAccepted = json['ISSampleAccepted'];
    column1 = json['Column1'];
    tRFCount = json['TRFCount'] is int
        ? json['TRFCount'].toString()
        : json['TRFCount'];
    temprature = json['temprature'] is int
        ? json['temprature'].toString()
        : json['temprature'];
    sampleTempName = json['SampleTempName'];
    recieptNo = json['RecieptNo'];
    sampleID = json['SampleID'];
    uploadedFilePath = json['UploadedFilePath'];
    viewUploadFilePath = json['ViewUploadFilePath'];
    centerID = json['CenterID'];
    customerType = json['CustomerType'];
    customerTypeName = json['CustomerTypeName'];
    paymentType = json['PaymentType'];
    ptypeid = json['Ptypeid'];
    availableFund = json['AvailableFund'];
    labCode = json['LabCode'];
  }

  String? facilityName;
  int? facilityCode;
  int? sampleCount;
  double? amount;
  String? sampleCollTime;
  int? locID;
  String? latitude;
  int? paymentModeId;
  String? contactPerson;
  String? sampleRemark;
  String? sufficeientTuberemark;
  String? allsamplebarcoderemark;
  String? otherdocumentRemark;
  String? detailsontrfremark;
  int? sampleTubeId;
  int? otherdocumentcollectedid;
  int? sufficeientTubeId;
  int? allsamplebarcodeId;
  int? detailsontrfId;
  String? tansactionNo;
  String? longitude;
  int? mapFlag;
  String? iSLabSubmit;
  String? iSSampleAccepted;
  String? column1;
  String? tRFCount;
  String? temprature;
  String? sampleTempName;
  String? recieptNo;
  int? sampleID;
  String? uploadedFilePath;
  String? viewUploadFilePath;
  int? centerID;
  int? customerType;
  String? customerTypeName;
  dynamic paymentType;
  dynamic ptypeid;
  double? availableFund;
  int? labCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['FacilityName'] = facilityName;
    map['FacilityCode'] = facilityCode;
    map['SampleCount'] = sampleCount;
    map['Amount'] = amount;
    map['SampleCollTime'] = sampleCollTime;
    map['LocID'] = locID;
    map['LATITUDE'] = latitude;
    map['PaymentModeId'] = paymentModeId;
    map['ContactPerson'] = contactPerson;
    map['SampleRemark'] = sampleRemark;
    map['SufficeientTuberemark'] = sufficeientTuberemark;
    map['Allsamplebarcoderemark'] = allsamplebarcoderemark;
    map['otherdocumentRemark'] = otherdocumentRemark;
    map['Detailsontrfremark'] = detailsontrfremark;
    map['SampleTubeId'] = sampleTubeId;
    map['otherdocumentcollectedid'] = otherdocumentcollectedid;
    map['SufficeientTubeId'] = sufficeientTubeId;
    map['AllsamplebarcodeId'] = allsamplebarcodeId;
    map['DetailsontrfId'] = detailsontrfId;
    map['tansactionNo'] = tansactionNo;
    map['LONGITUDE'] = longitude;
    map['MapFlag'] = mapFlag;
    map['ISLabSubmit'] = iSLabSubmit;
    map['ISSampleAccepted'] = iSSampleAccepted;
    map['Column1'] = column1;
    map['TRFCount'] = tRFCount;
    map['temprature'] = temprature;
    map['SampleTempName'] = sampleTempName;
    map['RecieptNo'] = recieptNo;
    map['SampleID'] = sampleID;
    map['UploadedFilePath'] = uploadedFilePath;
    map['ViewUploadFilePath'] = viewUploadFilePath;
    map['CenterID'] = centerID;
    map['CustomerType'] = customerType;
    map['CustomerTypeName'] = customerTypeName;
    map['PaymentType'] = paymentType;
    map['Ptypeid'] = ptypeid;
    map['AvailableFund'] = availableFund;
    map['LabCode'] = labCode;
    return map;
  }
}
