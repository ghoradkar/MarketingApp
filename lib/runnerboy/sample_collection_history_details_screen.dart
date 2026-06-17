import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marketingapp/runnerboy/model/sample_collection_history_model.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/utils/data_not_found.dart';
import 'package:marketingapp/widgets/custom_text.dart';

class SampleCollectionHistoryDetailsScreen extends StatefulWidget {
  final SampleCollectionHistoryOutput item;
  final String empCode;

  const SampleCollectionHistoryDetailsScreen({
    super.key,
    required this.item,
    required this.empCode,
  });

  @override
  State<SampleCollectionHistoryDetailsScreen> createState() =>
      _SampleCollectionHistoryDetailsScreenState();
}

class _SampleCollectionHistoryDetailsScreenState
    extends State<SampleCollectionHistoryDetailsScreen>
    with TickerProviderStateMixin {
  late final TabController tabController;

  final List<_SampleDetail> collectedList = const [
    _SampleDetail(client: 'Dr. Manoj Deshmukh', tube: '0', trf: '0', temperature: '2°C to 8°C', time: '11:48 am', amount: '580.00'),
    _SampleDetail(client: 'Dr. Manoj Deshmukh', tube: '0', trf: '0', temperature: '2°C to 8°C', time: '11:48 am', amount: '580.00'),
    _SampleDetail(client: 'Mrs. Anjali Kapoor', tube: '1', trf: '2', temperature: '25°C to 75°C', time: '9:30 am', amount: '720.00'),
    _SampleDetail(client: 'Mr. Rajesh Iyer', tube: '2', trf: '1', temperature: '22°C to 78°C', time: '2:15 pm', amount: '640.00'),
    _SampleDetail(client: 'Ms. Priya Singh', tube: '3', trf: '3', temperature: '18°C to 82°C', time: '5:45 pm', amount: '900.00'),
  ];

  final List<_SampleDetail> submittedList = const [
    _SampleDetail(client: 'Dr. Ravi Kumar', tube: '1', trf: '1', temperature: '2°C to 8°C', time: '10:00 am', amount: '450.00'),
    _SampleDetail(client: 'Mrs. Sunita Patil', tube: '2', trf: '2', temperature: '15°C to 30°C', time: '12:30 pm', amount: '620.00'),
    _SampleDetail(client: 'Mr. Anil Sharma', tube: '1', trf: '1', temperature: '25°C to 75°C', time: '3:00 pm', amount: '380.00'),
    _SampleDetail(client: 'Dr. Priya Mehta', tube: '3', trf: '2', temperature: '2°C to 8°C', time: '4:15 pm', amount: '810.00'),
  ];

  final List<_SampleDetail> acceptedList = const [
    _SampleDetail(client: 'Dr. Ravi Kumar', tube: '1', trf: '1', temperature: '2°C to 8°C', time: '10:00 am', amount: '450.00'),
    _SampleDetail(client: 'Mrs. Sunita Patil', tube: '2', trf: '2', temperature: '15°C to 30°C', time: '12:30 pm', amount: '620.00'),
    _SampleDetail(client: 'Mr. Anil Sharma', tube: '1', trf: '1', temperature: '25°C to 75°C', time: '3:00 pm', amount: '380.00'),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  String _ordinalSuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  DateTime? _parseDate(String? dateStr) {
    if (dateStr == null) return null;
    try {
      return DateFormat('yyyy-MM-dd').parse(dateStr);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = _parseDate(widget.item.collectionDate);
    final day = date?.day ?? 0;
    final suffix = _ordinalSuffix(day);
    final monthYear =
        date != null ? DateFormat('MMM yyyy').format(date) : '';
    final dayName = widget.item.dayName ??
        (date != null ? DateFormat('EEEE').format(date) : '');

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
          text: 'Sample Collection History Details',
          fontSize: 13.sp,
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
          // Summary card
          Padding(
            padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0.5,
              color: Colors.white,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/history_calender.png',
                      width: 30.w,
                      height: 30.h,
                    ),
                    SizedBox(width: 8.w),
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
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          Expanded(
                            child: _StatBox(
                              count: widget.item.collectedCount,
                              label: 'Collected',
                              icon: Icons.inbox_outlined,
                              color: AppColor.orange,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: _StatBox(
                              count: widget.item.submittedCount,
                              label: 'Submitted',
                              icon: Icons.send_outlined,
                              color: const Color(0xFF3F51B5),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: _StatBox(
                              count: widget.item.acceptedCount,
                              label: 'Accepted',
                              icon: Icons.check_circle_outline,
                              color: AppColor.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Tab bar
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: TabBar(
              controller: tabController,
              isScrollable: false,
              dividerColor: Colors.transparent,
              indicatorColor: Colors.transparent,
              padding: EdgeInsets.zero,
              indicatorPadding: EdgeInsets.zero,
              labelPadding: EdgeInsets.zero,
              tabs: [
                _buildTab(0, 'Collected'),
                _buildTab(1, 'Submitted'),
                _buildTab(2, 'Accepted'),
              ],
            ),
          ),
          // List
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                _buildList(collectedList, _tabColors[0]),
                _buildList(submittedList, _tabColors[1]),
                _buildList(acceptedList, _tabColors[2]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static final _tabColors = [
    AppColor.orange,
    const Color(0xFF3F51B5),
    AppColor.green,
  ];

  Widget _buildTab(int index, String text) {
    final isSelected = tabController.index == index;
    final tabColor = _tabColors[index];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: isSelected ? tabColor : Colors.transparent,
        borderRadius: _tabBorderRadius(index),
        border: Border.all(
          color: isSelected ? tabColor : const Color(0xffE1E1E1),
        ),
      ),
      child: Center(
        child: CustomText(
          text: text,
          fontSize: 12.sp,
          fontFam: 'Lato',
          fontWeight: FontWeight.normal,
          textColor: isSelected ? Colors.white : const Color(0xff777777),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  BorderRadius _tabBorderRadius(int index) {
    if (index == 0) {
      return const BorderRadius.only(
        topLeft: Radius.circular(10),
        bottomLeft: Radius.circular(10),
      );
    } else if (index == 2) {
      return const BorderRadius.only(
        topRight: Radius.circular(10),
        bottomRight: Radius.circular(10),
      );
    }
    return BorderRadius.zero;
  }

  Widget _buildList(List<_SampleDetail> list, Color color) {
    if (list.isEmpty) return const DataNotFound();
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      itemCount: list.length,
      itemBuilder: (context, index) =>
          _DetailCard(item: list[index], color: color),
    );
  }
}

// ── Data holder ──────────────────────────────────────────────────────────────

class _SampleDetail {
  final String client;
  final String tube;
  final String trf;
  final String temperature;
  final String time;
  final String amount;

  const _SampleDetail({
    required this.client,
    required this.tube,
    required this.trf,
    required this.temperature,
    required this.time,
    required this.amount,
  });
}

// ── Detail card ───────────────────────────────────────────────────────────────

class _DetailCard extends StatelessWidget {
  final _SampleDetail item;
  final Color color;

  const _DetailCard({required this.item, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: _labelValue('Client', item.client),
              ),
              SizedBox(width: 10.w),
              _labelValue('Tube', item.tube),
              SizedBox(width: 10.w),
              _labelValue("TRF's", item.trf),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Flexible(child: _labelValue('Temperature', item.temperature)),
              SizedBox(width: 10.w),
              _labelValue('Time', item.time),
            ],
          ),
          SizedBox(height: 6.h),
          _labelValue('Amount', item.amount),
        ],
      ),
    );
  }

  Widget _labelValue(String label, String value) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label : ',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontFamily: 'Nunito Sans',
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.normal,
              fontFamily: 'Nunito Sans',
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stat box (same as history screen) ────────────────────────────────────────

class _StatBox extends StatelessWidget {
  final int? count;
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
            text: (count ?? 0).toString(),
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
