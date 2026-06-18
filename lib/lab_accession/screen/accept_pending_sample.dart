import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketingapp/lab_accession/controller/receive_sample_controller.dart';
import 'package:marketingapp/lab_accession/model/sample_pending_from_accession.dart';
import 'package:marketingapp/lab_accession/screen/show_collected_sample.dart';
import 'package:marketingapp/runnerboy/controller/sample_collection_controller.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/utils/data_not_found.dart';
import 'package:marketingapp/utils/shared_pref_constants.dart';
import 'package:marketingapp/utils/shared_preference.dart';
import 'package:marketingapp/widgets/cust_toast.dart';
import 'package:marketingapp/widgets/custom_button.dart';
import 'package:marketingapp/widgets/custom_text.dart';
import 'package:marketingapp/widgets/custom_text_field.dart';
import 'package:marketingapp/widgets/no_internet_connectivity.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class AcceptPendingSample extends StatefulWidget {
  final String date;
  final String userId;
  final String labCode;

  const AcceptPendingSample(
      {super.key,
      required this.date,
      required this.userId,
      required this.labCode});

  @override
  State<AcceptPendingSample> createState() => _AcceptPendingSampleState();
}

class _AcceptPendingSampleState extends State<AcceptPendingSample>
    with TickerProviderStateMixin {
  late final TabController tabController;
  final ReceiveSampleController receiveSampleCollection =
      Get.find<ReceiveSampleController>();

  final SampleCollectionController collectSampleController =
      Get.put(SampleCollectionController());

  var userData;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      receiveSampleCollection.update();
    });

    checkInternetAndLoadData();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<void> getUserData() async {
    userData = await SharedPref().read(const SharedPrefConstant().kUserData);
    await receiveSampleCollection.getCollectedSampleList(
        widget.date, widget.userId, widget.labCode);
    receiveSampleCollection.update();
  }

  checkInternetAndLoadData() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      receiveSampleCollection.hasInternet = true;
    } else {
      receiveSampleCollection.hasInternet = false;
    }
    receiveSampleCollection.update();
    receiveSampleCollection.pendingList?.clear();
    receiveSampleCollection.acceptedList?.clear();

    if (receiveSampleCollection.hasInternet) {
      getUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReceiveSampleController>(
        init: receiveSampleCollection,
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColor.primaryBackgroundColor.withValues(alpha: 0.3),
                      AppColor.secondaryColor.withValues(alpha: 0.3)
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              title: CustomText(
                text: 'Accept Sample',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                textColor: AppColor.black,
                textAlign: TextAlign.start,
                fontFam: 'Nunito Sans',
              ),
              leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back)),
            ),
            body: controller.hasInternet
                ? Column(
                    children: [
                      TabBar(
                        controller: tabController,
                        isScrollable: false,
                        dividerColor: Colors.transparent,
                        indicatorColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        indicatorPadding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.zero,
                        tabs: [
                          buildTab(0, "Sample Received"),
                          buildTab(1, "Sample Accepted"),
                        ],
                      ).paddingSymmetric(vertical: 10, horizontal: 10),
                      if (controller.pendingList != null &&
                          controller.pendingList!.isNotEmpty &&
                          tabController.index == 0)
                        Row(
                          children: [
                            Checkbox(
                              value: controller.selectAll,
                              onChanged: (_) => controller.toggleSelectAll(),
                            ),
                            const Text('Select All'),
                          ],
                        ).paddingOnly(left: 10, right: 10, bottom: 6),
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            SampleCollectionCollectedOrSubmitted(
                              collectedAndSubmittedList: controller.pendingList,
                              isAccepted: false,
                              isLoading: controller.isListLoading,
                            ),
                            SampleCollectionCollectedOrSubmitted(
                              collectedAndSubmittedList:
                                  controller.acceptedList,
                              isAccepted: true,
                              isLoading: controller.isListLoading,
                            )
                          ],
                        ),
                      ),
                      if (controller.pendingList != null &&
                          controller.pendingList!.isNotEmpty &&
                          tabController.index == 0)
                        CustomTextField(
                          // shouldValidate: controller.shouldValidate,
                          autofocus: false,
                          txtController: controller.remark,
                          labelText: 'Remark',
                          hintText: 'Remark',
                          isRequired: true,
                          keyBoardType: TextInputType.text,
                          fillColor: AppColor.white,
                          isReadOnly: false,
                          maxLines: 1,
                          fontSize: 16,
                          prefixIcon: Image.asset(
                            "assets/file.png",
                            color: AppColor.secondaryColor,
                          ),
                        ).paddingOnly(bottom: 10, left: 10, right: 10),
                      if (controller.pendingList != null &&
                          controller.pendingList!.isNotEmpty &&
                          tabController.index == 0)
                        CustomButton(
                          buttonFontSize: 16,
                          buttonText: 'Accept Sample',
                          path: 'assets/arrow_nav.svg',
                          callB: () async {
                            final c = receiveSampleCollection;

                            if (c.remark.text.isEmpty) {
                              CustomMessage.toast("Remark is mandatory");
                              return;
                            }
                            final remarkText = c.remark.text.trim();
                            List<AcceptedPendingOutput> selected =
                                c.selectedPending;
                            if (selected.isEmpty) {
                              CustomMessage.toast(
                                  "Please select at least one sample");
                              return;
                            }

                            for (final item in selected) {
                              await c.acceptCollectedSampleFromRunnerBoy(
                                item.locid.toString(),
                                widget.userId,
                                userData['output'][0]['EmpCode'].toString(),
                                remarkText,
                                userData['output'][0]['EmpCode'].toString(),
                              );
                            }

                            CustomMessage.toast("Sample Accepted Successfully");
                            await c.getCollectedSampleList(
                                widget.date, widget.userId, widget.labCode);
                          },
                          // buttonWidth: double.infinity,
                          primColor: AppColor.primaryBackgroundColor,
                          secColor: AppColor.secondaryColor,
                          textColor: AppColor.white,
                          iconColor: AppColor.white,
                          buttonWidth: 180,
                        ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  )
                : InternetIssue(
                    onRetryPressed: () {
                      checkInternetAndLoadData();
                    },
                  ),
          );
        });
  }

  Widget buildTab(int index, String text) {
    bool isSelected = tabController.index == index;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
                colors: [
                  AppColor.primaryBackgroundColor,
                  AppColor.secondaryColor
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
              )
            : const LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
              ),
        borderRadius: setBorderRadiusIndexWise(index),
        border: Border.all(color: const Color(0xffE1E1E1)),
      ),
      child: Center(
        child: CustomText(
          text: text,
          fontSize: 12.0,
          fontFam: 'Lato',
          fontWeight: FontWeight.normal,
          textColor: isSelected ? Colors.white : const Color(0xff777777),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  setBorderRadiusIndexWise(index) {
    if (index == 0) {
      return const BorderRadius.only(
          topLeft: Radius.circular(10), bottomLeft: Radius.circular(10));
    } else if (index == 1) {
      // return BorderRadius.zero;
      return const BorderRadius.only(
          topRight: Radius.circular(10), bottomRight: Radius.circular(10));
    }
  }
}

class SampleCollectionCollectedOrSubmitted extends StatelessWidget {
  final bool isAccepted;
  final bool isLoading;
  final List<AcceptedPendingOutput>? collectedAndSubmittedList;

  const SampleCollectionCollectedOrSubmitted({
    super.key,
    required this.isAccepted,
    this.collectedAndSubmittedList,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return _buildSkeletonList();

    final list = collectedAndSubmittedList ?? const <AcceptedPendingOutput>[];
    if (list.isEmpty) return const DataNotFound();

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];

        return InkWell(
          onTap: () {
            Get.to(ShowCollectSample(
              hospitalDetails: null,
              sampleCollectionItem: collectedAndSubmittedList?[index],
              isEdit: true,
            ));
          },
          child: Container(
            key: ValueKey(item.locid), // helps diffing
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: isAccepted
                  ? AppColor.green.withValues(alpha: 0.09)
                  : AppColor.borderGrey.withValues(alpha: 0.08),
              border: Border.all(color: AppColor.borderGrey),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    clientDet("Client", item.customerName),
                    clientDet("Tube", item.sampleCount.toString()),
                    clientDet("TRF’s", item.trfCount),
                    clientDet("Temperature", item.sampleTempName),
                    clientDet("Time", item.sampleCollTime),
                    clientDet("Amount", item.amount.toString()),
                  ],
                ),
                if (!isAccepted)
                  GetBuilder<ReceiveSampleController>(
                    builder: (c) => Align(
                      alignment: Alignment.centerRight,
                      child: Checkbox(
                        value: item.isSelected, // non-null
                        onChanged: (v) => c.toggleItem(item, v),
                      ),
                    ),
                  ),
                if (isAccepted == true)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.remove_red_eye_outlined,
                      color: AppColor.primaryBackgroundColor,
                    ),
                  )
              ],
            ),
          ).paddingSymmetric(vertical: 8, horizontal: 16),
        );
      },
    );
  }

  Widget _buildSkeletonList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (_, __) => _buildSkeletonCard(),
    );
  }

  Widget _buildSkeletonCard() {
    return Shimmer(
      colorOpacity: 0.6,
      duration: const Duration(seconds: 2),
      direction: const ShimmerDirection.fromLeftToRight(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppColor.borderGrey.withValues(alpha: 0.08),
          border: Border.all(color: AppColor.borderGrey),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _skeletonRow(140),
                _skeletonRow(60),
                _skeletonRow(50),
                _skeletonRow(100),
                _skeletonRow(70),
                _skeletonRow(80),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _skeletonRow(double width) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Container(
        width: width,
        height: 14,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget clientDet(String h, String v) => Padding(
    padding: const EdgeInsets.only(top: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$h : ",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: "Nunito Sans",
          ),
        ),
        Expanded(
          child: Text(
            v,
            softWrap: true,
            overflow: TextOverflow.visible,
            maxLines: null,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              fontFamily: "Nunito Sans",
            ),
          ),
        ),
      ],
    ),
  );

}


