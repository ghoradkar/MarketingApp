import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'package:http_parser/http_parser.dart';
import 'package:marketingapp/dashboard/controller/my_visit_controller.dart';
import 'package:marketingapp/dashboard/model/district_list_model.dart';
import 'package:marketingapp/dashboard/screen/dashboard_screen.dart';
import 'package:marketingapp/lab_accession/model/sample_pending_from_accession.dart';
import 'package:marketingapp/runnerboy/screen/camera_capture_screen.dart';
import 'package:marketingapp/runnerboy/screen/collect_sample.dart';
import 'package:marketingapp/runnerboy/model/get_center_id_and_available_fund.dart';
import 'package:marketingapp/runnerboy/model/sample_collected_submitted_model.dart';
import 'package:marketingapp/runnerboy/model/sample_collection_history_detail_model.dart';
import 'package:marketingapp/runnerboy/model/sample_collection_history_model.dart';
import 'package:marketingapp/runnerboy/model/sample_collection_overview_model.dart';
import 'package:marketingapp/runnerboy/model/start_route_sample_collection.dart';
import 'package:marketingapp/runnerboy/model/temprature_model.dart';
import 'package:marketingapp/runnerboy/screen/sample_collection_start_route.dart';
import 'package:marketingapp/utils/api_urls.dart';
import 'package:marketingapp/utils/network_call.dart';
import 'package:marketingapp/widgets/cust_toast.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class SampleCollectionController extends GetxController {
  IOClient ioClient = IOClient(ByPassCert().httpClient);
  String? status;
  List<CenterIdAndAvailableFundOutput> filteredCustomerList = [];
  bool showStartRoute = false;
  List<SampleCollectedSubmitedOutput>? collectedList;

  List<SampleCollectedSubmitedOutput>? submittedList;

  bool hasInternet = true;
  bool isListLoading = true;
  bool isCenterLoading = false;
  bool isSubmitting = false;

  // bool shouldValidate = false;

  bool showAmountFiled = true;

  bool showOtherTextField = true;
  TextEditingController tubeContainerCount = TextEditingController();
  TextEditingController trfCountTextField = TextEditingController();
  TextEditingController amountCollected = TextEditingController();
  TextEditingController contactPersonName = TextEditingController();
  TextEditingController docName = TextEditingController();
  TextEditingController transactionNo = TextEditingController();
  TextEditingController tubeCountSampleQty = TextEditingController();
  TextEditingController tubeCountSampleCollectedNonPluscare =
      TextEditingController();
  TextEditingController tubeCounttrfFilledAccurately = TextEditingController();
  TextEditingController tubeCountbarcodeNameMention = TextEditingController();

  String? paymentMode;
  String? temp;
  String? sampleQtySufficient;
  String? sampleCollectedNonPluscareTube;
  String? barcodeNameMention;
  String? otherDocCollected;
  String? trfFilledAccurately;

  List<TempratureOutput>? tempList;

  bool isHistoryLoading = false;
  List<SampleCollectionHistoryOutput>? historyList;

  bool isHistoryDetailLoading = false;
  List<SampleCollectionHistoryDetailOutput>? collectedDetailList;
  List<SampleCollectionHistoryDetailOutput>? submittedDetailList;
  List<SampleCollectionHistoryDetailOutput>? acceptedDetailList;
  bool isOverviewLoading = false;
  List<SampleCollectionOverviewMember>? overviewMembers;
  bool isOverviewDateWiseLoading = false;
  List<SampleCollectionHistoryOutput>? overviewDateWiseList;

  bool isOverviewDetailLoading = false;
  List<SampleCollectionHistoryDetailOutput>? overviewCollectedDetailList;
  List<SampleCollectionHistoryDetailOutput>? overviewSubmittedDetailList;
  List<SampleCollectionHistoryDetailOutput>? overviewAcceptedDetailList;

  StartRouteSampleCollection? startRouteSampleCollectionModel;

  GetCenterIdAndAvailableFund? getCenterIdAndAvailableFund;

  DistrictListModel? districtRespModel;

  CameraController? cameraController;
  List<CameraDescription>? _cameras;
  CameraDescription? selectedCamera;

  List<PaymentMode> paymentModeList = [
    PaymentMode(mode: "Cash", paymentId: 1),
    PaymentMode(mode: "Online", paymentId: 2),
    PaymentMode(mode: "Pay Later", paymentId: 3),
  ];

  List<AllQuestions> allQuestionList = [
    AllQuestions(answer: "Yes", id: 0),
    AllQuestions(answer: "No", id: 1)
  ];

  TextEditingController searchController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  File? pickedImage;
  final bool isFrontCamera = false;

  // final ImagePicker _picker = ImagePicker();

  getSampleCollectedList(userId) async {
    isListLoading = true;
    update();

    try {
      final uri = Uri.parse(
          '${ApiConstants.baseUrl1 + ApiConstants.sampleCollectedList}?LOCID=0&userid=$userId&LabCode=0');

      debugPrint(uri.path);

      final response = await ioClient.get(uri);
      debugPrint(response.statusCode.toString());
      debugPrint("response.body : ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'Success') {
          SampleCollectedSubmittedModel sampleCollectedSubmittedModel =
              SampleCollectedSubmittedModel.fromJson(data);
          List<SampleCollectedSubmitedOutput>? sampleCollectedSubmitedList =
              sampleCollectedSubmittedModel.output;

          collectedList = sampleCollectedSubmitedList
              ?.where((sample) => sample.iSLabSubmit == "0")
              .toList();

          submittedList = sampleCollectedSubmitedList
              ?.where((sample) => sample.iSLabSubmit == "1")
              .toList();
        } else {
          collectedList = null;
          submittedList = null;
          status = data['message'];
          CustomMessage.toast(status);
        }
      }
    } finally {
      isListLoading = false;
      update();
    }
  }

  getSampleCollectionHistory(
      String userId, String fromDate, String toDate) async {
    isHistoryLoading = true;
    update();

    try {
      final uri = Uri.parse(
          "${ApiConstants.baseUrl1}${ApiConstants.sampleCollectionHistoryRunnerBoy}"
          "?UserID=$userId&FromDate=$fromDate&ToDate=$toDate&DetailtType=1&SampleType=1");

      debugPrint(uri.path);

      final response = await ioClient.get(uri);
      debugPrint(response.statusCode.toString());
      debugPrint("response.body : ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'Success') {
          historyList =
              SampleCollectionHistoryModel.fromJson(data).output;
        } else {
          historyList = null;
        }
      } else {
        historyList = null;
      }
    } finally {
      isHistoryLoading = false;
      update();
    }
  }

  Future<List<SampleCollectionHistoryDetailOutput>?>
      _fetchSampleCollectionHistoryDetail(
    String userId,
    String date,
    String sampleType,
  ) async {
    final uri = Uri.parse(
        "${ApiConstants.baseUrl1}${ApiConstants.sampleCollectionHistoryRunnerBoy}"
        "?UserID=$userId&FromDate=$date&ToDate=$date&DetailtType=2&SampleType=$sampleType");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        return SampleCollectionHistoryDetailModel.fromJson(data).output;
      }
    }
    return null;
  }

  Future<void> getSampleCollectionHistoryDetails(
      String userId, String date) async {
    isHistoryDetailLoading = true;
    update();

    try {
      final results = await Future.wait([
        _fetchSampleCollectionHistoryDetail(userId, date, '1'),
        _fetchSampleCollectionHistoryDetail(userId, date, '2'),
        _fetchSampleCollectionHistoryDetail(userId, date, '3'),
      ]);
      collectedDetailList = results[0];
      submittedDetailList = results[1];
      acceptedDetailList = results[2];
    } finally {
      isHistoryDetailLoading = false;
      update();
    }
  }

  Future<void> getOverviewData(
      String userId, String fromDate, String toDate) async {
    isOverviewLoading = true;
    update();

    try {
      final uri = Uri.parse(
          "${ApiConstants.baseUrl1}${ApiConstants.sampleCollectionHistoryManager}"
          "?UserID=$userId&RunnerBoyUserID=0&FromDate=$fromDate&ToDate=$toDate"
          "&DetailtType=1&SampleType=1");

      debugPrint(uri.path);

      final response = await ioClient.get(uri);
      debugPrint(response.statusCode.toString());
      debugPrint("response.body : ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'Success') {
          overviewMembers =
              SampleCollectionOverviewModel.fromJson(data).members;
        } else {
          overviewMembers = null;
        }
      } else {
        overviewMembers = null;
      }
    } finally {
      isOverviewLoading = false;
      update();
    }
  }

  Future<void> getOverviewDateWiseData(String userId, String runnerBoyUserId,
      String fromDate, String toDate) async {
    isOverviewDateWiseLoading = true;
    update();

    try {
      final uri = Uri.parse(
          "${ApiConstants.baseUrl1}${ApiConstants.sampleCollectionHistoryManager}"
          "?UserID=$userId&RunnerBoyUserID=$runnerBoyUserId&FromDate=$fromDate"
          "&ToDate=$toDate&DetailtType=2&SampleType=1");

      debugPrint(uri.path);

      final response = await ioClient.get(uri);
      debugPrint(response.statusCode.toString());
      debugPrint("response.body : ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'Success') {
          overviewDateWiseList =
              SampleCollectionHistoryModel.fromJson(data).output;
        } else {
          overviewDateWiseList = null;
        }
      } else {
        overviewDateWiseList = null;
      }
    } finally {
      isOverviewDateWiseLoading = false;
      update();
    }
  }

  Future<List<SampleCollectionHistoryDetailOutput>?>
      _fetchOverviewSampleDetail(
    String userId,
    String runnerBoyUserId,
    String date,
    String sampleType,
  ) async {
    final uri = Uri.parse(
        "${ApiConstants.baseUrl1}${ApiConstants.sampleCollectionHistoryManager}"
        "?UserID=$userId&RunnerBoyUserID=$runnerBoyUserId&FromDate=$date"
        "&ToDate=$date&DetailtType=3&SampleType=$sampleType");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        return SampleCollectionHistoryDetailModel.fromJson(data).output;
      }
    }
    return null;
  }

  Future<void> getOverviewSampleDetails(
      String userId, String runnerBoyUserId, String date) async {
    isOverviewDetailLoading = true;
    update();

    try {
      final results = await Future.wait([
        _fetchOverviewSampleDetail(userId, runnerBoyUserId, date, '1'),
        _fetchOverviewSampleDetail(userId, runnerBoyUserId, date, '2'),
        _fetchOverviewSampleDetail(userId, runnerBoyUserId, date, '3'),
      ]);
      overviewCollectedDetailList = results[0];
      overviewSubmittedDetailList = results[1];
      overviewAcceptedDetailList = results[2];
    } finally {
      isOverviewDetailLoading = false;
      update();
    }
  }

  submitToLab(String locId, String userId, String labCode,
      MyVisitControllerController myVisitControllerController) async {
    CustomMessage.showLoader();

    final uri = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.submitToLab}");

    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request('POST', uri);
    request.bodyFields = {
      'LOCID': locId,
      'UserID': userId,
      'LabCode': labCode,
    };
    request.headers.addAll(headers);

    debugPrint(jsonEncode(request.bodyFields));

    debugPrint(jsonEncode(request.bodyFields));
    var ioStreamedResponse = await ioClient.send(request);

    if (ioStreamedResponse.statusCode == 200) {
      CustomMessage.hideLoader();

      final data = json.decode(await ioStreamedResponse.stream.bytesToString());
      if (data['status'] == 'Success') {
        status = data['message'];
      } else {
        CustomMessage.hideLoader();
        CustomMessage.toast(status);
      }
      update();
      return true;
    } else {
      debugPrint('failed submitToLab');
      return false;
    }
  }

  endRoute(String routeId, String userId, String endRoute, String latitude,
      String longitude, String modifiedDate, String modifiedBy) async {
    CustomMessage.showLoader();

    final uri = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.endRoute}");

    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request('POST', uri);
    request.bodyFields = {
      'RouteID': routeId,
      'UserID': userId,
      'EndRoute': endRoute,
      'EndLatitude': latitude,
      'EndLongitude': longitude,
      'ModifiedDate': modifiedDate,
      'ModifiedBy': modifiedBy,
    };
    request.headers.addAll(headers);

    debugPrint(jsonEncode(request.bodyFields));
    var ioStreamedResponse = await ioClient.send(request);

    if (ioStreamedResponse.statusCode == 200) {
      CustomMessage.hideLoader();

      final data = json.decode(await ioStreamedResponse.stream.bytesToString());
      if (data['status'] == 'Success') {
        status = data['message'];

        // CustomMessage.toast(status);
        await getSampleCollectedList(userId);
      }
      update();
    } else {
      debugPrint('failed endRoute');
    }
  }

  getSampleTempList() async {
    final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.tempList);

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        TempratureModel tempratureModel = TempratureModel.fromJson(data);
        tempList = tempratureModel.output;
      } else {
        collectedList = null;
        submittedList = null;
      }
    }
    update();
  }

  Future<void> submitSampleCollection({
    required String locId,
    required String userId,
    required String sampleCount,
    required String amount,
    required String submittedBy,
    required String createdBy,
    required String trfCount,
    required String receiptNo,
    required String centerId,
    required String latitude,
    required String longitude,
    required String mapFlag,
    required String isPhotoEdit,
    required File uploadedFile,
    required String temperature,
    required String sampleId,
    required String pTypeId,
    required String availableFund,
    required String paymentModeId,
    required String transactionNo,
    required String contactPerson,
    required String sampleRemark,
    required String sufficientTubeRemark,
    required String allSampleBarcodeRemark,
    required String otherDocumentRemark,
    required String sampleTubeId,
    required String otherDocumentCollectedId,
    required String sufficientTubeId,
    required String allSampleBarcodeId,
    required String detailsOnTrfRemark,
    required String detailsOnTrfId,
    required bool isEdit,
  }) async {
    isSubmitting = true;
    update();

    CustomMessage.showLoader();
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${ApiConstants.baseUrl4}${ApiConstants.saveSampleCollection}.ashx'),
      );

      if (isEdit == false) {
        request.fields.addAll({
          'LOCID': locId,
          'userid': userId,
          'SampleCount': sampleCount,
          'Amount': amount,
          'SubmittedBy': submittedBy,
          'Createdby': createdBy,
          'TRFCount': trfCount,
          'RecieptNo': receiptNo,
          'CenterID': centerId,
          'LATITUDE': latitude,
          'LONGITUDE': longitude,
          'MapFlag': mapFlag,
          'IsPhotoEdit': isPhotoEdit,
          'temprature': temperature,
          'Ptypeid': pTypeId,
          'Availaiblefund': availableFund,
          'PaymentModeId': paymentModeId,
          'tansactionNo': transactionNo,
          'ContactPerson': contactPerson,
          'SampleRemark': sampleRemark,
          'SufficeientTuberemark': sufficientTubeRemark,
          'Allsamplebarcoderemark': allSampleBarcodeRemark,
          'otherdocumentRemark': otherDocumentRemark,
          'SampleTubeId': sampleTubeId,
          'otherdocumentcollectedid': otherDocumentCollectedId,
          'SufficeientTubeId': sufficientTubeId,
          'AllsamplebarcodeId': allSampleBarcodeId,
          'Detailsontrfremark': detailsOnTrfRemark,
          'DetailsontrfId': detailsOnTrfId,
        });
      } else {
        request.fields.addAll({
          'LOCID': locId,
          'userid': userId,
          'SampleCount': sampleCount,
          'Amount': amount,
          'SubmittedBy': submittedBy,
          'Createdby': createdBy,
          'TRFCount': trfCount,
          'RecieptNo': receiptNo,
          'CenterID': centerId,
          'LATITUDE': latitude,
          'LONGITUDE': longitude,
          'MapFlag': mapFlag,
          'IsPhotoEdit': isPhotoEdit,
          'temprature': temperature,
          'SampleID': sampleId,
          'Ptypeid': pTypeId,
          'Availaiblefund': availableFund,
          'PaymentModeId': paymentModeId,
          'tansactionNo': transactionNo,
          'ContactPerson': contactPerson,
          'SampleRemark': sampleRemark,
          'SufficeientTuberemark': sufficientTubeRemark,
          'Allsamplebarcoderemark': allSampleBarcodeRemark,
          'otherdocumentRemark': otherDocumentRemark,
          'SampleTubeId': sampleTubeId,
          'otherdocumentcollectedid': otherDocumentCollectedId,
          'SufficeientTubeId': sufficientTubeId,
          'AllsamplebarcodeId': allSampleBarcodeId,
          'Detailsontrfremark': detailsOnTrfRemark,
          'DetailsontrfId': detailsOnTrfId,
        });
      }

      debugPrint(jsonEncode(request.fields));
      final mimeType = lookupMimeType(uploadedFile.path);
      final fileExtension = path.extension(uploadedFile.path);
      final uniqueFileName =
          '${centerId}_${userId}_sample_${DateTime.now().millisecondsSinceEpoch}$fileExtension';

      request.files.add(
        await http.MultipartFile.fromPath(
          // FlavorConfig.instance.name != "HindLab Operational"
          //     ? 'UploadedFilePath'
          //     : "FileName",
          "UploadedFilePath",
          uploadedFile.path,
          contentType: MediaType.parse(mimeType ?? 'application/octet-stream'),
          filename: uniqueFileName,
        ),
      );

      final response = await ioClient.send(request);
      final responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        CustomMessage.hideLoader();
        final jsonResponse = json.decode(responseString);
        final status = jsonResponse['status'];
        final message = jsonResponse['message'];
        if (status == 'Success') {
          CustomMessage.toast(message);
          await getSampleTempList();
          await getSampleCollectedList(userId);
          isSubmitting = false;
          update();
          tubeContainerCount.clear();
          trfCountTextField.clear();
          amountCollected.clear();
          paymentMode = null;
          temp = null;
          contactPersonName.clear();
          sampleQtySufficient = null;
          sampleCollectedNonPluscareTube = null;
          trfFilledAccurately = null;
          barcodeNameMention = null;
          barcodeNameMention = null;
          otherDocCollected = null;
          docName.clear();
          Get.offAll(() => const DashboardScreen());
          Get.to(() => const SampleCollectionStartRoute());
        } else {
          isSubmitting = false;
          update();
          CustomMessage.toast(message);
          CustomMessage.hideLoader();
        }
      } else {
        isSubmitting = false;
        update();
        CustomMessage.toast("Please try again");
        CustomMessage.hideLoader();
      }
    } catch (e) {
      CustomMessage.toast(e.toString());
      CustomMessage.hideLoader();
      isSubmitting = false;
      update();
    }
  }

  String _normalizeUrl(String url) {
    // Fix Windows-style backslashes.
    var normalized = url.replaceAll('\\', '/');
    // Server only serves over HTTPS; upgrade plain HTTP to avoid 404.
    if (normalized.startsWith('http://')) {
      normalized = 'https://${normalized.substring(7)}';
    }
    // Remove Windows drive letter embedded in URL path (e.g. /E:/ → /).
    normalized = normalized.replaceFirst(RegExp(r'/[A-Za-z]:/'), '/');
    return normalized;
  }

  Uri _withCacheBust(String url) {
    final uri = Uri.parse(_normalizeUrl(url));
    final queryParameters = Map<String, String>.from(uri.queryParameters);
    queryParameters['t'] = DateTime.now().millisecondsSinceEpoch.toString();
    return uri.replace(queryParameters: queryParameters);
  }

  Future<File> downloadFileToTemp(String fileUrl) async {
    final uri = Uri.parse(_normalizeUrl(fileUrl));
    final fileName = p.basename(uri.path);

    final tempDir = await getTemporaryDirectory();

    final safeFileName = fileName.isNotEmpty ? fileName : 'downloaded_file';
    final baseName = p.basenameWithoutExtension(safeFileName);
    final ext = p.extension(safeFileName);
    final uniqueName =
        '${baseName}_${DateTime.now().millisecondsSinceEpoch}$ext';
    final filePath = p.join(tempDir.path, uniqueName);

    debugPrint('Image download URL: ${uri.toString()}');
    final response = await ioClient.get(
      uri,
      headers: const {
        'Accept': 'image/*',
        'User-Agent': 'Mozilla/5.0',
        'Referer': 'http://diagnostics.cschealthcare.in/',
        'Origin': 'http://diagnostics.cschealthcare.in',
        'Accept-Language': 'en-US,en;q=0.9',
      },
    );
    if (response.statusCode != 200) {
      debugPrint('Image download failed status: ${response.statusCode}');
      debugPrint('Image download content-type: ${response.headers['content-type'] ?? ''}');
      throw Exception('Image download failed: ${response.statusCode}');
    }
    final contentType = response.headers['content-type'] ?? '';
    if (!contentType.toLowerCase().startsWith('image/')) {
      throw Exception('Invalid content-type: $contentType');
    }
    if (response.bodyBytes.isEmpty) {
      throw Exception('Empty image response');
    }
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    debugPrint("Downloaded file saved at: $filePath");

    return file;
  }

  startRouteSampleCollection(String userID, String startRoute, String lat,
      String long, String routeDate, String createdBy) async {
    final uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.startRouteSampleCollection}?UserID=$userID&StartRoute=$startRoute&StartLatitude=$lat&StartLongitude=$long&RRouteDate=$routeDate&Createdby=$createdBy");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        startRouteSampleCollectionModel =
            StartRouteSampleCollection.fromJson(data);
      } else if (data['status'] == 'Fail') {
        startRouteSampleCollectionModel =
            StartRouteSampleCollection.fromJson(data);
        CustomMessage.toast(data['message']);
        debugPrint('failed startRouteSampleCollection');
      } else {
        CustomMessage.toast(data['message']);
        debugPrint('failed startRouteSampleCollection');
      }
    }
    update();
  }

  getCenterId(String labCode, String distlgCode) async {
    isCenterLoading = true;
    update();

    try {
      final uri = Uri.parse(
          "${ApiConstants.baseUrl1}${ApiConstants.getCenterId}?LabCode=$labCode&DISTLGDCODE=$distlgCode");

      debugPrint(uri.path);

      final response = await ioClient.get(uri);
      debugPrint(response.statusCode.toString());
      debugPrint("response.body : ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'Success') {
          getCenterIdAndAvailableFund =
              GetCenterIdAndAvailableFund.fromJson(data);
          filteredCustomerList =
              List.from(getCenterIdAndAvailableFund!.output);
        } else {
          getCenterIdAndAvailableFund = null;
          filteredCustomerList.clear();
        }
      }
    } finally {
      isCenterLoading = false;
      update();
    }
  }

  getDistrictList(String stateCode) async {
    final uri = Uri.parse(
        "${ApiConstants.baseUrl}${ApiConstants.districtList}?STATELGDCODE=$stateCode");

    debugPrint(uri.path);

    final response = await ioClient.get(uri);
    debugPrint(response.statusCode.toString());
    debugPrint("response.body : ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'Success') {
        districtRespModel = DistrictListModel.fromJson(data);
        status = data['message'];
      } else {
        status = data['message'];
      }
    }
    update();
  }

  Future<void> setFieldOnEditOnRunnerBoy(
    SampleCollectedSubmitedOutput? sampleCollectionItem,
  ) async {
    try {
      if (sampleCollectionItem == null) return;

      // Download image
      // final File downloadedFile = await downloadFileToTemp(
      //     sampleCollectionItem.viewUploadFilePath ?? '');
      // cameraController.pickedImage = File(downloadedFile.path);

      final imageUrl = sampleCollectionItem.viewUploadFilePath ?? '';
      bool imageExists = false;

      if (imageUrl.isNotEmpty) {
        try {
          final imageUri = Uri.parse(_normalizeUrl(imageUrl));
          final File downloadedFile =
              await downloadFileToTemp(imageUri.toString());
          pickedImage = File(downloadedFile.path);
          imageExists = true;
        } catch (e) {
          try {
            // Retry with cache-bust only if the plain URL fails.
            final imageUri = _withCacheBust(imageUrl);
            final File downloadedFile =
                await downloadFileToTemp(imageUri.toString());
            pickedImage = File(downloadedFile.path);
            imageExists = true;
          } catch (e2) {
            debugPrint('Error checking image URL: $e2');
          }
        }
      }

      if (!imageExists) {
        // Fallback to dummy image
        final dummyAssetPath = 'assets/file-icon.png';
        final byteData = await rootBundle.load(dummyAssetPath);
        final tempFile = File('${Directory.systemTemp.path}/file-icon.png');
        await tempFile.writeAsBytes(
          byteData.buffer
              .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
        );
        pickedImage = tempFile;
      }

      // Assign sample count
      tubeContainerCount.text = sampleCollectionItem.sampleCount.toString();
      showOtherTextField = sampleCollectionItem.sampleCount != 0;

      // Amount
      amountCollected.text = sampleCollectionItem.amount.toString();
      showAmountFiled =
          amountCollected.text != "0" && amountCollected.text != "0.0";

      // Payment mode
      paymentMode = paymentModeList
          .firstWhereOrNull(
            (e) =>
                e.paymentId.toString() ==
                sampleCollectionItem.paymentModeId.toString(),
          )
          ?.mode;

      transactionNo.text = sampleCollectionItem.tansactionNo ?? "";

      // Temp
      temp = tempList
          ?.firstWhereOrNull(
            (e) => e.sampleTempId.toString() == sampleCollectionItem.temprature,
          )
          ?.sampleTempName;

      // TRF
      trfCountTextField.text = sampleCollectionItem.tRFCount.toString();

      // Contact person
      contactPersonName.text = sampleCollectionItem.contactPerson ?? '';

      // Question-based answers
      sampleQtySufficient = allQuestionList
          .firstWhereOrNull(
            (e) => e.id == sampleCollectionItem.sufficeientTubeId,
          )
          ?.answer;
      if (sampleQtySufficient == "Yes") {
        tubeCountSampleQty.text =
            sampleCollectionItem.sufficeientTuberemark ?? "";
      }

      sampleCollectedNonPluscareTube = allQuestionList
          .firstWhereOrNull(
            (e) => e.id == sampleCollectionItem.sampleTubeId,
          )
          ?.answer;
      if (sampleCollectedNonPluscareTube == "Yes") {
        tubeCountSampleCollectedNonPluscare.text =
            sampleCollectionItem.sampleRemark ?? "";
      }

      trfFilledAccurately = allQuestionList
          .firstWhereOrNull(
            (e) => e.id == sampleCollectionItem.detailsontrfId,
          )
          ?.answer;
      if (trfFilledAccurately == "Yes") {
        tubeCounttrfFilledAccurately.text =
            sampleCollectionItem.detailsontrfremark ?? "";
      }

      barcodeNameMention = allQuestionList
          .firstWhereOrNull(
            (e) => e.id == sampleCollectionItem.allsamplebarcodeId,
          )
          ?.answer;
      if (barcodeNameMention == "Yes") {
        tubeCountbarcodeNameMention.text =
            sampleCollectionItem.allsamplebarcoderemark ?? "";
      }

      otherDocCollected = allQuestionList
          .firstWhereOrNull(
            (e) => e.id == sampleCollectionItem.otherdocumentcollectedid,
          )
          ?.answer;
      docName.text = sampleCollectionItem.otherdocumentRemark ?? "";

      update();
    } catch (e) {
      debugPrint("setFieldOnEditOnRunnerBoy error: $e");
    }
  }

  Future<void> setFieldOnEditOnAccessionTeam(
    AcceptedPendingOutput? sampleCollectionItem,
  ) async {
    try {
      CustomMessage.showLoader();

      if (sampleCollectionItem == null) return;

      final imageUrl = sampleCollectionItem.viewUploadFilePath;
      bool imageExists = false;

      if (imageUrl.isNotEmpty) {
        try {
          final imageUri = Uri.parse(_normalizeUrl(imageUrl));
          final File downloadedFile =
              await downloadFileToTemp(imageUri.toString());
          pickedImage = File(downloadedFile.path);
          imageExists = true;
        } catch (e) {
          try {
            // Retry with cache-bust only if the plain URL fails.
            final imageUri = _withCacheBust(imageUrl);
            final File downloadedFile =
                await downloadFileToTemp(imageUri.toString());
            pickedImage = File(downloadedFile.path);
            imageExists = true;
          } catch (e2) {
            debugPrint('Error checking image URL: $e2');
          }
        }
      }

      if (!imageExists) {
        // Fallback to dummy image
        final dummyAssetPath = 'assets/file-icon.png';
        final byteData = await rootBundle.load(dummyAssetPath);
        final tempFile = File('${Directory.systemTemp.path}/file-icon.png');
        await tempFile.writeAsBytes(
          byteData.buffer
              .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
        );
        pickedImage = tempFile;
      }

      tubeContainerCount.text = sampleCollectionItem.sampleCount.toString();
      showOtherTextField = sampleCollectionItem.sampleCount != 0;

      amountCollected.text = sampleCollectionItem.amount.toString();
      showAmountFiled =
          amountCollected.text != "0" && amountCollected.text != "0.0";

      // Payment mode
      paymentMode = paymentModeList
          .firstWhereOrNull(
            (e) => e.paymentId.toString() == sampleCollectionItem.paymentModeId,
          )
          ?.mode;

      transactionNo.text = sampleCollectionItem.tansactionNo;

      temp = tempList
          ?.firstWhereOrNull(
            (e) => e.sampleTempId == sampleCollectionItem.temprature,
          )
          ?.sampleTempName;

      contactPersonName.text = sampleCollectionItem.contactPerson;

      trfCountTextField.text = sampleCollectionItem.trfCount.toString();

      sampleQtySufficient = allQuestionList
          .firstWhereOrNull(
            (e) => e.id == sampleCollectionItem.sufficeientTubeId,
          )
          ?.answer;
      if (sampleQtySufficient == "Yes") {
        tubeCountSampleQty.text = sampleCollectionItem.sufficeientTuberemark;
      }

      sampleCollectedNonPluscareTube = allQuestionList
          .firstWhereOrNull(
            (e) => e.id == sampleCollectionItem.sampleTubeId,
          )
          ?.answer;
      if (sampleCollectedNonPluscareTube == "Yes") {
        tubeCountSampleCollectedNonPluscare.text =
            sampleCollectionItem.sampleRemark;
      }

      trfFilledAccurately = allQuestionList
          .firstWhereOrNull(
            (e) => e.id == sampleCollectionItem.detailsontrfId,
          )
          ?.answer;
      if (trfFilledAccurately == "Yes") {
        tubeCounttrfFilledAccurately.text =
            sampleCollectionItem.detailsontrfremark;
      }

      barcodeNameMention = allQuestionList
          .firstWhereOrNull(
            (e) => e.id == sampleCollectionItem.allsamplebarcodeId,
          )
          ?.answer;
      if (barcodeNameMention == "Yes") {
        tubeCountbarcodeNameMention.text =
            sampleCollectionItem.allsamplebarcoderemark;
      }

      otherDocCollected = allQuestionList
          .firstWhereOrNull(
            (e) => e.id == sampleCollectionItem.otherdocumentcollectedid,
          )
          ?.answer;
      docName.text = sampleCollectionItem.otherdocumentRemark;

      update();
    } catch (e) {
      debugPrint("setFieldOnEditOnAccessionTeam error: $e");
    } finally {
      CustomMessage.hideLoader();
    }
  }

  Future<void> initAvailableCameras() async {
    try {
      // get list of device cameras from plugin
      final cams = await availableCameras(); // <-- plugin function
      _cameras = cams;
      debugPrint('Found cameras: $_cameras');

      if (_cameras!.isNotEmpty) {
        selectedCamera = _cameras!.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.back,
          orElse: () => _cameras!.first,
        );
        debugPrint('Selected camera: $selectedCamera');
      } else {
        debugPrint('No cameras detected');
        selectedCamera = null;
      }
    } catch (e) {
      debugPrint('Error fetching cameras: $e');
      _cameras = [];
      selectedCamera = null;
    }
  }

  Future<void> captureImage() async {
    await initAvailableCameras();

    if (_cameras == null || _cameras!.isEmpty || selectedCamera == null) {
      CustomMessage.toast("No cameras available");
      return;
    }

    final File? file =
        await Get.to<File?>(() => CameraCaptureScreen(camera: selectedCamera!));

    if (file != null) {
      pickedImage = file;
      update();
    } else {
      debugPrint('User cancelled camera or file is null');
    }
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }

  void clearImage() {
    pickedImage = null;
    update();
  }
}
