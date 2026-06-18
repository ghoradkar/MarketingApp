import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marketingapp/runnerboy/controller/sample_collection_controller.dart';
import 'package:marketingapp/runnerboy/model/sample_collection_overview_model.dart';
import 'package:marketingapp/runnerboy/sample_collection_overview_details_screen.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/utils/data_not_found.dart';
import 'package:marketingapp/widgets/custom_text.dart';
import 'package:marketingapp/widgets/custom_text_field.dart';

class SampleCollectionOverviewScreen extends StatefulWidget {
  final String empCode;

  const SampleCollectionOverviewScreen({super.key, required this.empCode});

  @override
  State<SampleCollectionOverviewScreen> createState() =>
      _SampleCollectionOverviewScreenState();
}

class _SampleCollectionOverviewScreenState
    extends State<SampleCollectionOverviewScreen> {
  final SampleCollectionController controller =
      Get.find<SampleCollectionController>();

  final DateTime today = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  late DateTime fromDate;
  late DateTime toDate;
  late TextEditingController fromDateController;
  late TextEditingController toDateController;

  @override
  void initState() {
    super.initState();
    fromDate = DateTime(today.year, today.month, 1);
    toDate = today;
    fromDateController = TextEditingController(text: _formatDisplay(fromDate));
    toDateController = TextEditingController(text: _formatDisplay(toDate));
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
    await controller.getOverviewData(
      widget.empCode,
      DateFormat('yyyy-MM-dd').format(fromDate),
      DateFormat('yyyy-MM-dd').format(toDate),
    );
  }

  Future<void> _pickDate(bool isFrom) async {
    final firstDate = isFrom ? DateTime(today.year, today.month, 1) : today;
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? fromDate : toDate,
      firstDate: firstDate,
      lastDate: today,
    );
    if (picked == null) return;
    setState(() {
      if (isFrom) {
        fromDate = picked;
        fromDateController.text = _formatDisplay(picked);
      } else {
        toDate = picked;
        toDateController.text = _formatDisplay(picked);
      }
    });
    _loadData();
  }

  String _summarySubtitle() {
    final day = fromDate.day;
    final suffix = _ordinalSuffix(day);
    final rest = DateFormat('MMM yyyy').format(fromDate);
    final dayName = DateFormat('EEEE').format(fromDate);
    return '$day$suffix $rest - $dayName';
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
          // Date filter
          Container(
            padding: EdgeInsets.only(top: 4, bottom: 12, right: 10, left: 10),
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
                  child: GestureDetector(
                    onTap: () => _pickDate(true),
                    child: AbsorbPointer(
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
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickDate(false),
                    child: AbsorbPointer(
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
                  ),
                ),
              ],
            ),
          ).paddingOnly(top: 12, bottom: 0, left: 10, right: 10),
          // Content
          Expanded(
            child: GetBuilder<SampleCollectionController>(
              init: controller,
              builder: (ctrl) {
                final members = ctrl.overviewMembers;
                if (members == null || members.isEmpty) {
                  return const DataNotFound();
                }
                final totalCollected = members.fold(
                    0, (sum, m) => sum + (m.collectedCount ?? 0));
                final totalSubmitted = members.fold(
                    0, (sum, m) => sum + (m.submittedCount ?? 0));
                final totalAccepted = members.fold(
                    0, (sum, m) => sum + (m.acceptedCount ?? 0));

                return Column(
                  children: [
                    // Team summary card
                    _SummaryCard(
                      title: 'Team Summary',
                      subtitle: _summarySubtitle(),
                      collected: totalCollected,
                      submitted: totalSubmitted,
                      accepted: totalAccepted,
                    ),
                    // Member list
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 8.h),
                        itemCount: members.length,
                        itemBuilder: (ctx, i) {
                          final member = members[i];
                          return _MemberCard(
                            member: member,
                            onTap: () => Get.to(
                              () => SampleCollectionOverviewDetailsScreen(
                                member: member,
                                fromDate: fromDate,
                                toDate: toDate,
                                empCode: widget.empCode,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Summary card (Team Summary) ───────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int collected;
  final int submitted;
  final int accepted;

  const _SummaryCard({
    required this.title,
    required this.subtitle,
    required this.collected,
    required this.submitted,
    required this.accepted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 12.h, 8.w, 0),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0.5,
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
                        text: title,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        textColor: AppColor.black,
                        textAlign: TextAlign.start,
                        fontFam: 'Nunito Sans',
                      ),
                      SizedBox(height: 4.h),
                      CustomText(
                        text: subtitle,
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
                            count: collected,
                            label: 'Collected',
                            icon: Icons.inbox_outlined,
                            color: AppColor.orange,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: _StatBox(
                            count: submitted,
                            label: 'Submitted',
                            icon: Icons.send_outlined,
                            color: const Color(0xFF3F51B5),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: _StatBox(
                            count: accepted,
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

// ── Member card ───────────────────────────────────────────────────────────────

class _MemberCard extends StatelessWidget {
  final SampleCollectionOverviewMember member;
  final VoidCallback onTap;

  const _MemberCard({required this.member, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.only(bottom: 10.h),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0.5,
        color: Colors.white,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
          child: Row(
            children: [
              // Name + zone
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: member.name ?? '',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      textColor: AppColor.black,
                      textAlign: TextAlign.start,
                      fontFam: 'Nunito Sans',
                    ),
                    SizedBox(height: 3.h),
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
                flex: 5,
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
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            textColor: color,
            textAlign: TextAlign.center,
            fontFam: 'Nunito Sans',
          ),
          CustomText(
            text: label,
            fontSize: 10.sp,
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
