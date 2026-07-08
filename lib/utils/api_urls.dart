import 'package:flutter_flavor/flutter_flavor.dart';

class ApiConstants {
  static String baseUrl = FlavorConfig.instance.variables["baseUrl"];
  static String baseUrl1 = FlavorConfig.instance.variables["baseUrl1"];
  static String baseUrl3 = "http://mahahindlabs.com/api/data-home.php";
  static String baseUrl4 = FlavorConfig.instance.variables["baseUrl2"];

  static const String login = "/UserLoginApp";
  static const String sendOpt = "/ForgotPassword";
  static const String districtList = "/GetAllDistrictList";
  static const String sampleCollectedList =
      "/GetAllSampleCollectedByRunnerBoy_New";
  static const String availability = "/GetUserAttendanceDays";
  static const String tempList = "/GetSampleTemperature";

  // static String todaysVisitListManager =
  //     (FlavorConfig.instance.name == 'PlusCare Operational' ||
  //             FlavorConfig.instance.name == 'Lifenity Operational')
  //         ? "/VisitDashboardForManagerLoginForFlutter"
  //         : "/VisitDashboardForManagerLogin";
  static String todaysVisitListManager =
      (FlavorConfig.instance.name == 'PlusCare Operational')
          ? "/VisitDashboardForManagerLoginForFlutter"
          : "/VisitDashboardForManagerLogin";

  static const String todaysVisitRouteTime = "/UserStartAndEndRouteDetails";
  static const String todaysVisitCustomerDet =
      "/MEDashboardForSampleCutOutPutApp";
  static const String todaysVisitDetailsList = "/MarketingExDashboardForApp";
  static const String monthlyBusinessTarget =
      "/GetVisitDashboardForMarketingExec";
  static const String getCityList = "/GetCity";
  static const String getCityListHindLab = "/GetCityOnDistrict";
  static const String getAreaList = "/GetPatchOnDisitrict";
  static const String getCustomerTypeList = "/GetCustomerTypeNew";
  static const String addClient = "/InsertCustmerdetails";
  static const String editProfile = "/EditPersonalProfileLSRForApp";
  static const String editProfileBankDet = "/UpdateBankdetails";
  static const String saveAvailability = "/InsertUserAttendance";
  static const String addArea = "/InsertAreaMaster";
  static const String saveSampleCollection = "/RunnerBoySampleCollectionData";
  static const String addCustomerType = "/InsertCustmerType";

  // static String dashCount =
  //     (FlavorConfig.instance.name == 'PlusCare Operational' ||
  //             FlavorConfig.instance.name == 'Lifenity Operational')
  //         ? "/VisitDashboardForManagerDistrictWiseFlutter"
  //         : "/VisitDashboardForManagerDistrictWise";

  static String dashCount =
      (FlavorConfig.instance.name == 'PlusCare Operational')
          ? "/VisitDashboardForManagerDistrictWiseFlutter"
          : "/VisitDashboardForManagerDistrictWise";

  // static const String dashCount = "/VisitDashboardForManagerDistrictWise";
  static const String dashCountHindLab = "/GetVisitDashboard";
  static const String checkRouteFlag = "/GetRouteFlagStartOrEND";
  static const String startRoute = "/InsertCustomerRouteStart";
  static const String getCenterId =
      "/GetAllCustomerFromLabcodeNew_DistrictWise";
  static const String startRouteSampleCollection =
      "/StartRouteForSampleCollection";
  static const String customerList = "/GetCustomerSearch";
  static const String punchIn = "/InsertCustomerVisitPunchingDetails";
  static const String getPunchInDetails = "/GetCustomerVisitPunchingDetails";
  static const String getVisitType = "/GetVisitType";
  static const String clientStatus = "/GetClientStatus";
  static const String contactPersonDesig = "/GetContactPersonDesignation";
  static const String contactPersonName =
      "/GetContactPersonNameFromDesignation";
  static const String contactPersonStatus = "/GetContactPersonStatus";
  static const String perposeOfVisit = "/GetCustomerVisitActionListMarketing";
  static const String servicesList = "/GetCustomerVisitServicesList";
  static const String getMarketingPersons = "/GetMarketpersonList";
  static const String savePunchIn = "/InsertCustomerVisitDetailsNewCPWise";
  static const String submitToLab = "/SampleSubmittedToLab";
  static const String endRoute = "/ENDRouteForSampleCollection";
  static const String changePassword = "/ChangePassword";
  static const String addContactPerson = "/InsertContactPersonDetetails";
  static const String labNameList = "/GetAllLabOnDistrictCode_New";
  static const String labNameListSampleTracking = "/GetAllLabOnDistrictCode";
  static const String getLatLonSampleCollectedList =
      "/GetSampleCollectionDataForMap_Admin";
  static const String sampleCollectionTrackingList =
      "/GetAllSampleCountForAdminNew";
  static const String resourceNameList =
      "/GetReSourcesListForSampleCollection_New";
  static const String collectedSampleList =
      "/GetAllSampleCollectedByLabTechnition_New";
  static const String acceptCollectedSampleList = "/SampleAcceptedINLab";
  static const String getStateList = "/GetStatesForBD";
  static const String getDisrtictList = "/GetUserDistrictsForBD";
  static const String patchList = "/GetPatchUsingDistrictCode";
  static const String labListBusiness = "/GetUserDistrictsLabsForBD";
  static const String getCustomerList = "/GetUserCustomersForBD";
  static const String searchBusiness = "/GetBuisnessDashboard";
  static const String bloodGroupList = "/GetBloodGroupList";
  static const String getBankDetailsList = "/GetBank";
  static const String sampleCollectionHistory =
      "/GetSampleCollectionHistoryDateWise";
  static const String sampleCollectionHistoryRunnerBoy =
      "/GetSampleCollectionHistory_RunnerBoy";
  static const String sampleCollectionHistoryManager =
      "/GetSampleCollectionHistory_Manager";
  static const String sampleCollectionOverview =
      "/GetSampleCollectionOverview";
  static const String sampleCollectionOverviewDateWise =
      "/GetSampleCollectionOverviewDateWise";
}
