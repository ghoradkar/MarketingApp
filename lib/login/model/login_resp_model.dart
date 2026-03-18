class LoginRespModel {
  LoginRespModel({
      this.status, 
      this.message, 
      this.output,});

  LoginRespModel.fromJson(dynamic json) {
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
      this.id, 
      this.empCode, 
      this.suborgwisedesgid, 
      this.subOrgId, 
      this.subOrgName, 
      this.orgId, 
      this.orgName, 
      this.projectId, 
      this.projectName, 
      this.username, 
      this.name, 
      this.firstName, 
      this.middleName, 
      this.lastName, 
      this.spouseName, 
      this.children, 
      this.motherName, 
      this.fatherName, 
      this.voterId, 
      this.perEmail, 
      this.perMobile, 
      this.pAddress, 
      this.cAddress, 
      this.dob, 
      this.age, 
      this.aadhar, 
      this.pancard, 
      this.imagePath, 
      this.joiningdate, 
      this.bloodgroup, 
      this.bloodid, 
      this.educdtlid, 
      this.edu, 
      this.universityname, 
      this.qualification, 
      this.qualid, 
      this.edtypeid, 
      this.univid, 
      this.yearofpassing, 
      this.percentage, 
      this.cast, 
      this.religion, 
      this.religionId, 
      this.category, 
      this.maritialstatus, 
      this.anniversarydate, 
      this.workLocationName, 
      this.designation, 
      this.desgid, 
      this.worklocid, 
      this.statelgdcode, 
      this.distlgdcode, 
      this.tallgdcode, 
      this.gplgdcode, 
      this.desglevelid, 
      this.state, 
      this.district, 
      this.taluka, 
      this.accountno, 
      this.bankname, 
      this.bankid, 
      this.branchname, 
      this.ifsccode, 
      this.omtcscid, 
      this.ipaddress, 
      this.bCompany, 
      this.bAddress, 
      this.bEmail, 
      this.bMobile, 
      this.categoryId, 
      this.maritialstatusId, 
      this.hlldistrictid, 
      this.pincode, 
      this.bankaddress, 
      this.centerTypeID, 
      this.centerID, 
      this.centerName, 
      this.address, 
      this.facilityID, 
      this.facilityName, 
      this.labName, 
      this.labIncharge, 
      this.lABAddress, 
      this.lABdetails, 
      this.typeid, 
      this.typename, 
      this.passbook, 
      this.gender, 
      this.patchCode, 
      this.patchName, 
      this.cityCode, 
      this.cityName, 
      this.latitude, 
      this.longitude, 
      this.avgPatient, 
      this.avgTest, 
      this.interestinfranch, 
      this.typeofsetup, 
      this.noOfBed, 
      this.hospitalcontact, 
      this.islabavailable, 
      this.liname, 
      this.limobno, 
      this.hpid, 
      this.lIHostGender, 
      this.lIEmail, 
      this.lpid, 
      this.labcontact, 
      this.istieups, 
      this.labCode, 
      this.istest, 
      this.docid, 
      this.specialityid, 
      this.specialityname, 
      this.pracspeciality, 
      this.setuptype, 
      this.hoscontact, 
      this.hosemailid, 
      this.hosmobno, 
      this.isattached, 
      this.attchhospitalname, 
      this.islabavialable, 
      this.lidocname, 
      this.licontact, 
      this.ligender, 
      this.vlePId, 
      this.cscvleid, 
      this.landlineno, 
      this.customerCode, 
      this.potliuid, 
      this.potliuserId, 
      this.potliwalletId, 
      this.isaspirant, 
      this.maplabCode, 
      this.mapDISTCode,});

  Output.fromJson(dynamic json) {
    id = json['ID'];
    empCode = json['EmpCode'];
    suborgwisedesgid = json['SUBORGWISEDESGID'];
    subOrgId = json['SubOrgId'];
    subOrgName = json['SubOrgName'];
    orgId = json['OrgId'];
    orgName = json['OrgName'];
    projectId = json['ProjectId'];
    projectName = json['ProjectName'];
    username = json['USERNAME'];
    name = json['name'];
    firstName = json['FirstName'];
    middleName = json['MiddleName'];
    lastName = json['LastName'];
    spouseName = json['SpouseName'];
    children = json['Children'];
    motherName = json['MotherName'];
    fatherName = json['FatherName'];
    voterId = json['VoterId'];
    perEmail = json['per_email'];
    perMobile = json['per_mobile'];
    pAddress = json['PAddress'];
    cAddress = json['CAddress'];
    dob = json['dob'];
    age = json['AGE'];
    aadhar = json['Aadhar'];
    pancard = json['pancard'];
    imagePath = json['ImagePath'];
    joiningdate = json['joiningdate'];
    bloodgroup = json['bloodgroup'];
    bloodid = json['BLOODID'];
    educdtlid = json['EDUCDTLID'];
    edu = json['edu'];
    universityname = json['universityname'];
    qualification = json['qualification'];
    qualid = json['QUALID'];
    edtypeid = json['EDTYPEID'];
    univid = json['UNIVID'];
    yearofpassing = json['yearofpassing'];
    percentage = json['percentage'];
    cast = json['cast'];
    religion = json['religion'];
    religionId = json['ReligionId'];
    category = json['category'];
    maritialstatus = json['Maritialstatus'];
    anniversarydate = json['anniversarydate'];
    workLocationName = json['WorkLocationName'];
    designation = json['Designation'];
    desgid = json['DESGID'];
    worklocid = json['WORKLOCID'];
    statelgdcode = json['STATELGDCODE'];
    distlgdcode = json['DISTLGDCODE'];
    tallgdcode = json['TALLGDCODE'];
    gplgdcode = json['GPLGDCODE'];
    desglevelid = json['DESGLEVELID'];
    state = json['STATE'];
    district = json['district'];
    taluka = json['taluka'];
    accountno = json['accountno'];
    bankname = json['bankname'];
    bankid = json['BANKID'];
    branchname = json['branchname'];
    ifsccode = json['ifsccode'];
    omtcscid = json['OMTCSCID'];
    ipaddress = json['IPADDRESS'];
    bCompany = json['BCompany'];
    bAddress = json['BAddress'];
    bEmail = json['BEmail'];
    bMobile = json['BMobile'];
    categoryId = json['CategoryId'];
    maritialstatusId = json['MaritialstatusId'];
    hlldistrictid = json['HLLDISTRICTID'];
    pincode = json['pincode'];
    bankaddress = json['bankaddress'];
    centerTypeID = json['CenterTypeID'];
    centerID = json['CenterID'];
    centerName = json['CenterName'];
    address = json['Address'];
    facilityID = json['FacilityID'];
    facilityName = json['FacilityName'];
    labName = json['LabName'];
    labIncharge = json['LabIncharge'];
    lABAddress = json['LABAddress'];
    lABdetails = json['LABdetails'];
    typeid = json['TYPEID'];
    typename = json['TYPENAME'];
    passbook = json['passbook'];
    gender = json['Gender'];
    patchCode = json['PatchCode'];
    patchName = json['PatchName'];
    cityCode = json['CityCode'];
    cityName = json['CityName'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    avgPatient = json['AvgPatient'];
    avgTest = json['AvgTest'];
    interestinfranch = json['INTERESTINFRANCH'];
    typeofsetup = json['TYPEOFSETUP'];
    noOfBed = json['NoOfBed'];
    hospitalcontact = json['HOSPITAL_CONTACT'];
    islabavailable = json['ISLABAVAILABLE'];
    liname = json['LI_NAME'];
    limobno = json['LI_MOBNO'];
    hpid = json['HPID'];
    lIHostGender = json['LI_HostGender'];
    lIEmail = json['LI_Email'];
    lpid = json['LPID'];
    labcontact = json['LAB_CONTACT'];
    istieups = json['ISTIEUPS'];
    labCode = json['LabCode'];
    istest = json['ISTEST'];
    docid = json['DOCID'];
    specialityid = json['SPECIALITYID'];
    specialityname = json['SPECIALITYNAME'];
    pracspeciality = json['PRAC_SPECIALITY'];
    setuptype = json['SETUPTYPE'];
    hoscontact = json['HOS_CONTACT'];
    hosemailid = json['HOS_EMAILID'];
    hosmobno = json['HOS_MOBNO'];
    isattached = json['ISATTACHED'];
    attchhospitalname = json['ATTCH_HOSPITAL_NAME'];
    islabavialable = json['ISLABAVIALABLE'];
    lidocname = json['LI_DOCNAME'];
    licontact = json['LI_CONTACT'];
    ligender = json['LI_GENDER'];
    vlePId = json['VlePId'];
    cscvleid = json['CSC_VLE_ID'];
    landlineno = json['Landlineno'];
    customerCode = json['CustomerCode'];
    potliuid = json['Potliuid'];
    potliuserId = json['Potliuser_id'];
    potliwalletId = json['Potliwallet_id'];
    isaspirant = json['ISASPIRANT'];
    maplabCode = json['MaplabCode'];
    mapDISTCode = json['MapDISTCode'];
  }
  int? id;
  int? empCode;
  int? suborgwisedesgid;
  int? subOrgId;
  String? subOrgName;
  int? orgId;
  String? orgName;
  String? projectId;
  String? projectName;
  String? username;
  String? name;
  String? firstName;
  String? middleName;
  String? lastName;
  String? spouseName;
  int? children;
  String? motherName;
  String? fatherName;
  String? voterId;
  String? perEmail;
  String? perMobile;
  String? pAddress;
  String? cAddress;
  String? dob;
  int? age;
  String? aadhar;
  String? pancard;
  String? imagePath;
  String? joiningdate;
  dynamic bloodgroup;
  dynamic bloodid;
  int? educdtlid;
  String? edu;
  String? universityname;
  String? qualification;
  dynamic qualid;
  dynamic edtypeid;
  dynamic univid;
  int? yearofpassing;
  int? percentage;
  String? cast;
  String? religion;
  dynamic religionId;
  String? category;
  String? maritialstatus;
  String? anniversarydate;
  String? workLocationName;
  String? designation;
  int? desgid;
  int? worklocid;
  int? statelgdcode;
  int? distlgdcode;
  int? tallgdcode;
  int? gplgdcode;
  int? desglevelid;
  String? state;
  String? district;
  String? taluka;
  String? accountno;
  String? bankname;
  int? bankid;
  String? branchname;
  String? ifsccode;
  String? omtcscid;
  String? ipaddress;
  String? bCompany;
  String? bAddress;
  String? bEmail;
  String? bMobile;
  String? categoryId;
  String? maritialstatusId;
  int? hlldistrictid;
  int? pincode;
  String? bankaddress;
  dynamic centerTypeID;
  int? centerID;
  String? centerName;
  dynamic address;
  int? facilityID;
  String? facilityName;
  String? labName;
  String? labIncharge;
  String? lABAddress;
  String? lABdetails;
  int? typeid;
  String? typename;
  String? passbook;
  int? gender;
  int? patchCode;
  dynamic patchName;
  int? cityCode;
  String? cityName;
  dynamic latitude;
  dynamic longitude;
  int? avgPatient;
  int? avgTest;
  bool? interestinfranch;
  String? typeofsetup;
  dynamic noOfBed;
  dynamic hospitalcontact;
  dynamic islabavailable;
  String? liname;
  String? limobno;
  dynamic hpid;
  dynamic lIHostGender;
  dynamic lIEmail;
  dynamic lpid;
  String? labcontact;
  dynamic istieups;
  dynamic labCode;
  dynamic istest;
  dynamic docid;
  dynamic specialityid;
  dynamic specialityname;
  dynamic pracspeciality;
  dynamic setuptype;
  dynamic hoscontact;
  dynamic hosemailid;
  dynamic hosmobno;
  dynamic isattached;
  String? attchhospitalname;
  dynamic islabavialable;
  String? lidocname;
  String? licontact;
  dynamic ligender;
  dynamic vlePId;
  dynamic cscvleid;
  dynamic landlineno;
  dynamic customerCode;
  dynamic potliuid;
  dynamic potliuserId;
  dynamic potliwalletId;
  int? isaspirant;
  dynamic maplabCode;
  dynamic mapDISTCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ID'] = id;
    map['EmpCode'] = empCode;
    map['SUBORGWISEDESGID'] = suborgwisedesgid;
    map['SubOrgId'] = subOrgId;
    map['SubOrgName'] = subOrgName;
    map['OrgId'] = orgId;
    map['OrgName'] = orgName;
    map['ProjectId'] = projectId;
    map['ProjectName'] = projectName;
    map['USERNAME'] = username;
    map['name'] = name;
    map['FirstName'] = firstName;
    map['MiddleName'] = middleName;
    map['LastName'] = lastName;
    map['SpouseName'] = spouseName;
    map['Children'] = children;
    map['MotherName'] = motherName;
    map['FatherName'] = fatherName;
    map['VoterId'] = voterId;
    map['per_email'] = perEmail;
    map['per_mobile'] = perMobile;
    map['PAddress'] = pAddress;
    map['CAddress'] = cAddress;
    map['dob'] = dob;
    map['AGE'] = age;
    map['Aadhar'] = aadhar;
    map['pancard'] = pancard;
    map['ImagePath'] = imagePath;
    map['joiningdate'] = joiningdate;
    map['bloodgroup'] = bloodgroup;
    map['BLOODID'] = bloodid;
    map['EDUCDTLID'] = educdtlid;
    map['edu'] = edu;
    map['universityname'] = universityname;
    map['qualification'] = qualification;
    map['QUALID'] = qualid;
    map['EDTYPEID'] = edtypeid;
    map['UNIVID'] = univid;
    map['yearofpassing'] = yearofpassing;
    map['percentage'] = percentage;
    map['cast'] = cast;
    map['religion'] = religion;
    map['ReligionId'] = religionId;
    map['category'] = category;
    map['Maritialstatus'] = maritialstatus;
    map['anniversarydate'] = anniversarydate;
    map['WorkLocationName'] = workLocationName;
    map['Designation'] = designation;
    map['DESGID'] = desgid;
    map['WORKLOCID'] = worklocid;
    map['STATELGDCODE'] = statelgdcode;
    map['DISTLGDCODE'] = distlgdcode;
    map['TALLGDCODE'] = tallgdcode;
    map['GPLGDCODE'] = gplgdcode;
    map['DESGLEVELID'] = desglevelid;
    map['STATE'] = state;
    map['district'] = district;
    map['taluka'] = taluka;
    map['accountno'] = accountno;
    map['bankname'] = bankname;
    map['BANKID'] = bankid;
    map['branchname'] = branchname;
    map['ifsccode'] = ifsccode;
    map['OMTCSCID'] = omtcscid;
    map['IPADDRESS'] = ipaddress;
    map['BCompany'] = bCompany;
    map['BAddress'] = bAddress;
    map['BEmail'] = bEmail;
    map['BMobile'] = bMobile;
    map['CategoryId'] = categoryId;
    map['MaritialstatusId'] = maritialstatusId;
    map['HLLDISTRICTID'] = hlldistrictid;
    map['pincode'] = pincode;
    map['bankaddress'] = bankaddress;
    map['CenterTypeID'] = centerTypeID;
    map['CenterID'] = centerID;
    map['CenterName'] = centerName;
    map['Address'] = address;
    map['FacilityID'] = facilityID;
    map['FacilityName'] = facilityName;
    map['LabName'] = labName;
    map['LabIncharge'] = labIncharge;
    map['LABAddress'] = lABAddress;
    map['LABdetails'] = lABdetails;
    map['TYPEID'] = typeid;
    map['TYPENAME'] = typename;
    map['passbook'] = passbook;
    map['Gender'] = gender;
    map['PatchCode'] = patchCode;
    map['PatchName'] = patchName;
    map['CityCode'] = cityCode;
    map['CityName'] = cityName;
    map['Latitude'] = latitude;
    map['Longitude'] = longitude;
    map['AvgPatient'] = avgPatient;
    map['AvgTest'] = avgTest;
    map['INTERESTINFRANCH'] = interestinfranch;
    map['TYPEOFSETUP'] = typeofsetup;
    map['NoOfBed'] = noOfBed;
    map['HOSPITAL_CONTACT'] = hospitalcontact;
    map['ISLABAVAILABLE'] = islabavailable;
    map['LI_NAME'] = liname;
    map['LI_MOBNO'] = limobno;
    map['HPID'] = hpid;
    map['LI_HostGender'] = lIHostGender;
    map['LI_Email'] = lIEmail;
    map['LPID'] = lpid;
    map['LAB_CONTACT'] = labcontact;
    map['ISTIEUPS'] = istieups;
    map['LabCode'] = labCode;
    map['ISTEST'] = istest;
    map['DOCID'] = docid;
    map['SPECIALITYID'] = specialityid;
    map['SPECIALITYNAME'] = specialityname;
    map['PRAC_SPECIALITY'] = pracspeciality;
    map['SETUPTYPE'] = setuptype;
    map['HOS_CONTACT'] = hoscontact;
    map['HOS_EMAILID'] = hosemailid;
    map['HOS_MOBNO'] = hosmobno;
    map['ISATTACHED'] = isattached;
    map['ATTCH_HOSPITAL_NAME'] = attchhospitalname;
    map['ISLABAVIALABLE'] = islabavialable;
    map['LI_DOCNAME'] = lidocname;
    map['LI_CONTACT'] = licontact;
    map['LI_GENDER'] = ligender;
    map['VlePId'] = vlePId;
    map['CSC_VLE_ID'] = cscvleid;
    map['Landlineno'] = landlineno;
    map['CustomerCode'] = customerCode;
    map['Potliuid'] = potliuid;
    map['Potliuser_id'] = potliuserId;
    map['Potliwallet_id'] = potliwalletId;
    map['ISASPIRANT'] = isaspirant;
    map['MaplabCode'] = maplabCode;
    map['MapDISTCode'] = mapDISTCode;
    return map;
  }

}