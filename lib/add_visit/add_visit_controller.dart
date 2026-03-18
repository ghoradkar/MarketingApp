import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:marketingapp/add_visit/model/check_route_flag_model.dart';
import 'package:marketingapp/add_visit/model/client_status_model.dart';
import 'package:marketingapp/add_visit/model/contact_person_designation_model.dart';
import 'package:marketingapp/add_visit/model/contact_person_name_model.dart';
import 'package:marketingapp/add_visit/model/contact_person_status_model.dart';
import 'package:marketingapp/add_visit/model/customer_list_model.dart';
import 'package:marketingapp/add_visit/model/marketing_person_model.dart';
import 'package:marketingapp/add_visit/model/punch_in_details_model.dart';
import 'package:marketingapp/add_visit/model/purpose_of_visit_model.dart';
import 'package:marketingapp/add_visit/model/services_model.dart';
import 'package:marketingapp/add_visit/model/start_route_model.dart';
import 'package:marketingapp/add_visit/model/visit_type_model.dart';
import 'package:marketingapp/dashboard/dashboard_screen.dart';
import 'package:marketingapp/dashboard/model/dash_count_model.dart';
import 'package:marketingapp/dashboard/model/district_list_model.dart';
import 'package:marketingapp/dashboard/my_visit_controller.dart';
import 'package:marketingapp/dashboard/my_visits_screen.dart';
import 'package:marketingapp/utils/api_urls.dart';
import 'package:marketingapp/utils/network_call.dart';
import 'package:marketingapp/widgets/cust_toast.dart';

class AddVisitController extends GetxController {
  // bool isLoading = false;
  bool shouldValidateFields = false;
  String? selectedDist;
  String? status;
  IOClient ioClient = IOClient(ByPassCert().httpClient);
  TextEditingController searchController = TextEditingController();
  TextEditingController contactPersonNameField = TextEditingController();
  TextEditingController contactNumberField = TextEditingController();
  DistrictListModel? districtRespModel;
  CheckRouteFlagModel? checkRouteFlagModel;
  ContactPersonNameModel? contactPersonNameModel;
  PunchInDetailsModel? punchInDetailsModel;
  PurposeOfVisitModel? purposeOfVisitModel;
  MarketingPersonModel? marketingPersonModel;
  ServicesModel? servicesModel;
  VisitTypeModel? visitTypeModel;
  ClientStatusModel? clientStatusModel;
  ContactPersonDesignationModel? contactPersonDesignationModel;
  ContactPersonStatusModel? contactPersonStatusModel;
  StartRouteModel? startRouteModel;
  DashCountModel? dashCountModel;
  List<OutputCustomer> filteredCustomerList = [];
  bool hasInternet = true;
  bool hasInternetVisit = true;

  // late Location location;
  String? todayStr;

  Map<String, List<Map<String, dynamic>>>? serviceJsonData;
  Map<String, List<Map<String, dynamic>>>? marketingJsonData;
  String? locationMessage;

  // LocationData? currentLocation;

  CustomerListModel? customerListModel;

  String? selectedVisitType;

  String? selectedClientStat;
  VisitTypeOutput? selectedVisit;
  ClientStatusOutput? clientStatus;

  String? selectedContPersonDesig;
  String? addSelectedContactPersonDesig;
  DesignationOutput? selectedAddContPersonObj;
  DesignationOutput? selectedDesig;
  ContactPersonNameOutput? selectedContName;
  ContPersonStatOutput? selectedContPersonStatObj;

  String? selectedContactPersonName;
  String? selectedContPersonStat;
  PurposeOutput? selectedPurposeVisit;
  String? selectedServices;
  TextEditingController discussionPoints = TextEditingController();
  TextEditingController docName = TextEditingController();
  TextEditingController other = TextEditingController();

  // bool? isRoute;

  // getRouteFlagValue() {
  //   if (checkRouteFlagModel?.output?.first.startRoute == 1 &&
  //       checkRouteFlagModel?.output?.first.createdDate ==
  //           DateFormat('yyyy-MM-dd').format(DateTime.now())) {
  //     // isRoute = true;
  //   } else {
  //     // isRoute = false;
  //   }
  //   update();
  // }

  getRouteFlag(String? userID) async {
    CustomMessage.showLoader();
    final uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.checkRouteFlag}?UserID=$userID");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");
    DateTime today = DateTime.now();

    todayStr = "${today.year.toString().padLeft(4, '0')}"
        "-${today.month.toString().padLeft(2, '0')}"
        "-${today.day.toString().padLeft(2, '0')}";
    if (response.statusCode == 200) {
      // isLoading = false;
      CustomMessage.hideLoader();

      //getDeviceDetails
      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        checkRouteFlagModel = CheckRouteFlagModel.fromJson(data);
        status = data['message'];

        // await  getRouteFlagValue();
      } else {
        checkRouteFlagModel = CheckRouteFlagModel.fromJson(data);

        status = data['message'];
        // isLoading = false;
        CustomMessage.hideLoader();
        CustomMessage.toast(status);
      }
    }
    update();
  }

  saveAddContactPerson(String desgId, String cpName, String cpContactNo,
      String createdBy, String userId) async {
    // isLoading = true;
    // update();
    CustomMessage.showLoader();

    final uri =
        Uri.parse("${ApiConstants.baseUrl1}${ApiConstants.addContactPerson}");

    debugPrint(uri.path);

    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request('POST', uri);
    request.bodyFields = {
      'UserID': userId,
      'DesgId': desgId,
      'CPName': cpName,
      'CPContactNo': cpContactNo,
      'CreatedBy': createdBy
    };

    request.headers.addAll(headers);
    var response = await ioClient.send(request);
    // final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    // debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      // isLoading = false;
      CustomMessage.hideLoader();

      //getDeviceDetails
      final data = json.decode(await response.stream.bytesToString());
      if (data['status'] == 'Success') {
        checkRouteFlagModel = CheckRouteFlagModel.fromJson(data);
        status = data['message'];
        CustomMessage.toast(status);
        await contactPersonName(userId, desgId);
        contactPersonNameField.clear();
        addSelectedContactPersonDesig = null;
        selectedAddContPersonObj = null;
        contactNumberField.clear();
        Get.back();
      } else {
        status = data['message'];
        // isLoading = false;
        CustomMessage.hideLoader();
      }
    } else {
      CustomMessage.toast("Fail adding contact person");
      // isLoading = false;
      CustomMessage.hideLoader();
    }
    update();
  }

  savePunchIn(
      String userID,
      String isConverted,
      String createdBy,
      String logitude,
      String latitude,
      String contactPerson,
      var marketingUsers,
      var visitServices,
      String clientStatusId,
      String desgID,
      String mVisitActionID,
      String punchOutLatitude,
      String punchOutLogitude,
      String visitTypeID,
      String disscussionPoint,
      String cPId,
      String cPStatusId,
      MyVisitControllerController myVisitControllerController,
      String districtId,
      String userType) async {
    // isLoading = true;
    // update();
    CustomMessage.showLoader();

    final uri =
        Uri.parse("${ApiConstants.baseUrl1}${ApiConstants.savePunchIn}");

    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request('POST', uri);
    request.bodyFields = {
      'UserId': userID.toString(),
      'ISConverted': isConverted.toString(),
      'CreatedBy': createdBy.toString(),
      'logitude': logitude,
      'latitude': latitude,
      // "ContactPerson": contactPerson,
      'MarketingUsers':
          marketingUsers == null ? "" : jsonEncode(marketingUsers),
      'VisitServices': jsonEncode(visitServices),
      'ClientStatusId': clientStatusId.toString(),
      'DesgID': desgID.toString(),
      'MVisitActionID': mVisitActionID.toString(),
      'PunchOutLatitude': punchOutLatitude,
      'PunchOutLogitude': punchOutLogitude,
      'VisitTypeID': visitTypeID.toString(),
      'DisscussionPoint': disscussionPoint,
      'CPId': cPId.toString(),
      'CPStatusId': cPStatusId.toString()
    };
    request.headers.addAll(headers);
    debugPrint("${ApiConstants.baseUrl1}${ApiConstants.savePunchIn}");
    debugPrint(jsonEncode(request.bodyFields));
    var ioStreamedResponse = await ioClient.send(request);

    if (ioStreamedResponse.statusCode == 200) {
      CustomMessage.hideLoader();

      final data = json.decode(await ioStreamedResponse.stream.bytesToString());
      if (data['status'] == 'Success') {
        status = data['message'];

        await myVisitControllerController.getDistrictList(districtId);
        selectedVisitType = null;
        selectedVisit = null;
        selectedClientStat = null;
        clientStatus = null;
        selectedContPersonDesig = null;
        selectedDesig = null;
        selectedContName = null;
        selectedContactPersonName = null;
        selectedContPersonStat = null;
        selectedContPersonStatObj = null;
        selectedPurposeVisit = null;
        // selectedPurposeObj = null;
        serviceJsonData = null;
        marketingJsonData = null;
        discussionPoints.text = '';
        filteredCustomerList = [];
        selectedDist = null;

        customerListModel = null;
        punchInDetailsModel = null;

        CustomMessage.toast(status);

        Get.offUntil(
          GetPageRoute(
              page: () => MyVisitsScreen(),
              settings:
                  RouteSettings(name: MyVisitsScreen.routeName, arguments: {
                'appBarTitle':
                (userType == "Manager" || userType == "Lab Sales Manager") ? "Visit Dashboard" : 'My Visits',
              })),
          (route) => route.settings.name == DashboardScreen.routeName,
        );
      } else {
        punchInDetailsModel = null;

        status = data['message'];
        // isLoading = false;
        CustomMessage.hideLoader();
      }
    }
    update();
  }

  getPunchInDetails(String userID, String punchId) async {
    CustomMessage.showLoader();

    final uri = Uri.parse(
        "${ApiConstants.baseUrl1}${ApiConstants.getPunchInDetails}?UserID=$punchId&MEUserID=$userID");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      //getDeviceDetails
      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        punchInDetailsModel = PunchInDetailsModel.fromJson(data);
        status = data['message'];
        CustomMessage.hideLoader();
        update();
      } else {
        punchInDetailsModel = PunchInDetailsModel.fromJson(data);

        status = data['message'];
        CustomMessage.hideLoader();
        update();
      }
    }
  }

  insetPunchIn(String userID, String punchId, String lat, String long) async {
    // isLoading = true;
    // update();
    CustomMessage.showLoader();

    final uri = Uri.parse(
        "${ApiConstants.baseUrl1}${ApiConstants.punchIn}?UserID=$userID&PunchInBy=$punchId&PunchInLatitude=$lat&PunchInLogitude=$long");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      // isLoading = false;
      CustomMessage.hideLoader();

      //getDeviceDetails
      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        // checkRouteFlagModel = CheckRouteFlagModel.fromJson(data);

        status = data['message'];
        CustomMessage.toast(data['message']);
      } else {
        status = data['message'];
        // isLoading = false;
        CustomMessage.hideLoader();
      }
    }
    update();
  }

  contactPersonName(String userID, String desigId) async {
    // isLoading = true;
    // update();
    CustomMessage.showLoader();

    final uri = Uri.parse(
        "${ApiConstants.baseUrl1}${ApiConstants.contactPersonName}?UserID=$userID&DesgId=$desigId");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      // isLoading = false;
      CustomMessage.hideLoader();

      //getDeviceDetails
      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        contactPersonNameModel = ContactPersonNameModel.fromJson(data);

        status = data['message'];
        // CustomMessage.toast(data['message']);
      } else {
        contactPersonNameModel = null;
        status = data['message'];
        CustomMessage.toast(data['message']);
        // isLoading = false;
        CustomMessage.hideLoader();
      }
    }
    update();
  }

  getVisitType() async {
    CustomMessage.showLoader();

    final uri =
        Uri.parse("${ApiConstants.baseUrl1}${ApiConstants.getVisitType}");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      //getDeviceDetails
      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        visitTypeModel = VisitTypeModel.fromJson(data);

        status = data['message'];
        CustomMessage.hideLoader();
      } else {
        status = data['message'];
        // isLoading = false;
        CustomMessage.hideLoader();
      }
    }
    update();
  }

  getClientStatus() async {
    CustomMessage.showLoader();

    final uri =
        Uri.parse("${ApiConstants.baseUrl1}${ApiConstants.clientStatus}");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      // isLoading = false;

      //getDeviceDetails
      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        clientStatusModel = ClientStatusModel.fromJson(data);

        status = data['message'];
        CustomMessage.hideLoader();
      } else {
        status = data['message'];
        // isLoading = false;
        CustomMessage.hideLoader();
      }
    }
    update();
  }

  getContactPersonDesig() async {
    CustomMessage.showLoader();

    final uri =
        Uri.parse("${ApiConstants.baseUrl1}${ApiConstants.contactPersonDesig}");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        contactPersonDesignationModel =
            ContactPersonDesignationModel.fromJson(data);

        status = data['message'];
        CustomMessage.hideLoader();
      } else {
        status = data['message'];
        // isLoading = false;
        CustomMessage.hideLoader();
      }
    }
    update();
  }

  getContactPersonStatus() async {
    CustomMessage.showLoader();

    final uri = Uri.parse(
        "${ApiConstants.baseUrl1}${ApiConstants.contactPersonStatus}");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        contactPersonStatusModel = ContactPersonStatusModel.fromJson(data);

        status = data['message'];
        CustomMessage.hideLoader();
      } else {
        status = data['message'];
        // isLoading = false;
        CustomMessage.hideLoader();
      }
    }
    update();
  }

  getPurposeOfVisit(String clientStatusId) async {
    // isLoading = true;
    // update();
    CustomMessage.showLoader();

    final uri = Uri.parse(
        "${ApiConstants.baseUrl1}${ApiConstants.perposeOfVisit}?ClientStatusId=$clientStatusId");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      // isLoading = false;
      CustomMessage.hideLoader();

      //getDeviceDetails
      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        purposeOfVisitModel = PurposeOfVisitModel.fromJson(data);

        status = data['message'];
      } else {
        status = data['message'];
        // isLoading = false;
        CustomMessage.hideLoader();
      }
    }
    update();
  }

  getMarketingPersons(String userId) async {
    // isLoading = true;
    // update();
    CustomMessage.showLoader();

    final uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.getMarketingPersons}?USERID=$userId");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      // isLoading = false;
      CustomMessage.hideLoader();

      //getDeviceDetails
      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        marketingPersonModel = MarketingPersonModel.fromJson(data);

        status = data['message'];
      } else {
        status = data['message'];
        // isLoading = false;
        CustomMessage.hideLoader();
      }
    }
    update();
  }

  getServicesList() async {
    CustomMessage.showLoader();

    final uri =
        Uri.parse("${ApiConstants.baseUrl}${ApiConstants.servicesList}");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        servicesModel = ServicesModel.fromJson(data);

        status = data['message'];
        CustomMessage.hideLoader();
      } else {
        status = data['message'];
        // isLoading = false;
        CustomMessage.hideLoader();
      }
    }
    update();
  }

  startRoute(String? userID, String startRoute, String lat, String long,
      String routeDate, String createdBy) async {
    CustomMessage.showLoader();

    final uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.startRoute}?UserID=$userID&StartRoute=$startRoute&StartLatitude=$lat&StartLongitude=$long&RouteDate=$routeDate&Createdby=$createdBy");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      CustomMessage.hideLoader();

      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        startRouteModel = StartRouteModel.fromJson(data);

        status = data['message'];
      } else {
        status = data['message'];

        CustomMessage.hideLoader();
      }
    }
    update();
  }

  getCustomerList(String userID) async {
    // isLoading = true;
    // update();
    CustomMessage.showLoader();

    final uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.customerList}?DISTLGDCODE=$userID");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      // isLoading = false;
      CustomMessage.hideLoader();

      //getDeviceDetails
      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        customerListModel = CustomerListModel.fromJson(data);

        status = data['message'];
      } else {
        status = data['message'];
        // isLoading = false;
        customerListModel = null;
        filteredCustomerList.clear();
        CustomMessage.hideLoader();
      }
    }
    update();
  }
}
