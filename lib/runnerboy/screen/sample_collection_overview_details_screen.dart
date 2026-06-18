import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marketingapp/runnerboy/controller/sample_collection_controller.dart';
import 'package:marketingapp/runnerboy/model/sample_collection_history_model.dart';
import 'package:marketingapp/runnerboy/model/sample_collection_overview_model.dart';
import 'package:marketingapp/runnerboy/screen/sample_collection_overview_date_details_screen.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/utils/data_not_found.dart';
import 'package:marketingapp/widgets/custom_text.dart';
import 'package:marketingapp/widgets/custom_text_field.dart';

class SampleCollectionOverviewDetailsScreen extends StatefulWidget {
  final SampleCollectionOverviewMember member;
  final DateTime fromDate;
  final DateTime toDate;
  final String empCode;

  const SampleCollectionOverviewDetailsScreen({
    super.key,
    required this.member,
    required this.fromDate,
    required this.toDate,
    required this.empCode,
  });

  @override
  State<SampleCollectionOverviewDetailsScreen> createState() =>
      _SampleCollectionOverviewDetailsScreenState();
}

class _SampleCollectionOverviewDetailsScreenState
    extends State<SampleCollectionOverviewDetailsScreen> {
  final SampleCollectionController controller =
      Get.find<SampleCollectionController>();

  late TextEditingController fromDateController;
  late TextEditingController toDateController;

  @override
  void initState() {
    super.initState();
    fromDateController =
        TextEditingController(text: _formatDisplay(widget.fromDate));
    toDateController =
        TextEditingController(text: _formatDisplay(widget.toDate));
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    super.dispose();
  }

  String _formatDisplay(DateTime d) => DateFormat('dd MMM yyyy').format(d);

  Future<void> _loadData() async {
    await controller.getOverviewDateWiseData(
      widget.member.empCode ?? widget.empCode,
      DateFormat('yyyy-MM-dd').format(widget.fromDate),
      DateFormat('yyyy-MM-dd').format(widget.toDate),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        centerTitle: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                FlavorConfig.instance.name == "HindLab Operational"
                    ? AppColor.primaryBackgroundColor.withValues(alpha: 0.1)
                    : AppColor.primaryBackgroundColor.withValues(alpha: 0.3),
                AppColor.secondaryColor.withValues(alpha: 0.3),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: CustomText(
          text: 'Sample Collection Overview',
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          textColor: AppColor.black,
          textAlign: TextAlign.start,
          fontFam: 'Nunito Sans',
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          // Date filter (read-only display)
          Container(
            padding:
                EdgeInsets.only(top: 4, bottom: 12, right: 10, left: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    labelText: 'From Date',
                    hintText: 'Select date',
                    isRequired: false,
                    keyBoardType: TextInputType.none,
                    fillColor: AppColor.white,
                    isReadOnly: true,
                    txtController: fromDateController,
                    fontSize: 13.sp,
                    autofocus: false,
                    prefixIcon: Center(
                      widthFactor: 1,
                      child: Image.asset(
                        'assets/calendar-event.png',
                        width: 22.w,
                        height: 22.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: CustomTextField(
                    labelText: 'To Date',
                    hintText: 'Select date',
                    isRequired: false,
                    keyBoardType: TextInputType.none,
                    fillColor: AppColor.white,
                    isReadOnly: true,
                    txtController: toDateController,
                    fontSize: 13.sp,
                    autofocus: false,
                    prefixIcon: Center(
                      widthFactor: 1,
                      child: Image.asset(
                        'assets/calendar-event.png',
                        width: 22.w,
                        height: 22.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ).paddingOnly(top: 12, bottom: 0, left: 10, right: 10),
          // Person summary card
          _PersonSummaryCard(member: widget.member),
          // Date-wise list
          Expanded(
            child: GetBuilder<SampleCollectionController>(
              init: controller,
              builder: (ctrl) {
                final list = ctrl.overviewDateWiseList;
                if (list == null || list.isEmpty) return const DataNotFound();
                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                      horizontal: 12.w, vertical: 8.h),
                  itemCount: list.length,
                  itemBuilder: (ctx, i) => _DateWiseCard(
                    item: list[i],
                    member: widget.member,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Person summary card ───────────────────────────────────────────────────────

class _PersonSummaryCard extends StatelessWidget {
  final SampleCollectionOverviewMember member;

  const _PersonSummaryCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1.5,
        color: Colors.white,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Left accent bar
                Container(
                  width: 4,
                  color: AppColor.primaryBackgroundColor,
                ),
                // Left tinted text section
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 14.h),
                  color: AppColor.primaryBackgroundColor
                      .withValues(alpha: 0.08),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: member.name ?? '',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        textColor: AppColor.black,
                        textAlign: TextAlign.start,
                        fontFam: 'Nunito Sans',
                      ),
                      SizedBox(height: 4.h),
                      CustomText(
                        text: member.zone ?? '',
                        fontSize: 10.sp,
                        fontWeight: FontWeight.normal,
                        textColor: AppColor.textGrey,
                        textAlign: TextAlign.start,
                        fontFam: 'Nunito Sans',
                      ),
                    ],
                  ),
                ),
                // 3 stat boxes
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.w, vertical: 8.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: _StatBox(
                            count: member.collectedCount ?? 0,
                            label: 'Collected',
                            icon: Icons.inbox_outlined,
                            color: AppColor.orange,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: _StatBox(
                            count: member.submittedCount ?? 0,
                            label: 'Submitted',
                            icon: Icons.send_outlined,
                            color: const Color(0xFF3F51B5),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: _StatBox(
                            count: member.acceptedCount ?? 0,
                            label: 'Accepted',
                            icon: Icons.check_circle_outline,
                            color: AppColor.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Date-wise card ────────────────────────────────────────────────────────────

class _DateWiseCard extends StatelessWidget {
  final SampleCollectionHistoryOutput item;
  final SampleCollectionOverviewMember member;

  const _DateWiseCard({required this.item, required this.member});

  DateTime? get _date {
    if (item.collectionDate == null) return null;
    try {
      return DateFormat('yyyy-MM-dd').parse(item.collectionDate!);
    } catch (_) {
      return null;
    }
  }

  String _ordinalSuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = _date;
    final day = date?.day ?? 0;
    final suffix = _ordinalSuffix(day);
    final monthYear =
        date != null ? DateFormat('MMM yyyy').format(date) : '';
    final dayName = item.dayName ??
        (date != null ? DateFormat('EEEE').format(date) : '');

    return GestureDetector(
      onTap: () => Get.to(() => SampleCollectionOverviewDateDetailsScreen(
            item: item,
            member: member,
          )),
      child: Card(
      margin: EdgeInsets.only(bottom: 10.h),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1.5,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        child: Row(
          children: [
            // Calendar icon
            Image.asset(
              'assets/history_calender.png',
              width: 30.w,
              height: 30.h,
            ),
            SizedBox(width: 8.w),
            // Date + day name
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '$day',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito Sans',
                            color: AppColor.black,
                          ),
                        ),
                        WidgetSpan(
                          child: Transform.translate(
                            offset: const Offset(0, -4),
                            child: Text(
                              suffix,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Nunito Sans',
                                color: AppColor.black,
                              ),
                            ),
                          ),
                        ),
                        TextSpan(
                          text: ' $monthYear',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito Sans',
                            color: AppColor.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  CustomText(
                    text: dayName,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.normal,
                    textColor: AppColor.textGrey,
                    textAlign: TextAlign.start,
                    fontFam: 'Nunito Sans',
                  ),
                ],
              ),
            ),
            SizedBox(width: 4.w),
            // 3 stat boxes
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  Expanded(
                    child: _StatBox(
                      count: item.collectedCount ?? 0,
                      label: 'Collected',
                      icon: Icons.inbox_outlined,
                      color: AppColor.orange,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: _StatBox(
                      count: item.submittedCount ?? 0,
                      label: 'Submitted',
                      icon: Icons.send_outlined,
                      color: const Color(0xFF3F51B5),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: _StatBox(
                      count: item.acceptedCount ?? 0,
                      label: 'Accepted',
                      icon: Icons.check_circle_outline,
                      color: AppColor.green,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 4.w),
            Icon(Icons.chevron_right, color: AppColor.black, size: 20),
          ],
        ),
      ),
    ),
    );
  }
}

// ── Stat box ──────────────────────────────────────────────────────────────────

class _StatBox extends StatelessWidget {
  final int count;
  final String label;
  final IconData icon;
  final Color color;

  const _StatBox({
    required this.count,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          SizedBox(height: 3.h),
          CustomText(
            text: count.toString(),
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            textColor: color,
            textAlign: TextAlign.center,
            fontFam: 'Nunito Sans',
          ),
          CustomText(
            text: label,
            fontSize: 9.sp,
            fontWeight: FontWeight.normal,
            textColor: color,
            textAlign: TextAlign.center,
            fontFam: 'Nunito Sans',
          ),
        ],
      ),
    );
  }
}
