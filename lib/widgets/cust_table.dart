import 'package:flutter/material.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/utils/data_not_found.dart';
import 'package:marketingapp/widgets/cust_toast.dart';
import 'package:marketingapp/widgets/custom_text.dart';

class CustTable extends StatefulWidget {
  final List<String> l1;
  final List<dynamic> l2;
  final List<dynamic>? l3;
  final List<dynamic>? l4;
  final List<dynamic>? l5;
  final List<dynamic>? l6;
  final List<String> tableHeader;
  final Function? onCLick;
  final bool? isClickable;

  const CustTable(
      {super.key,
      required this.l1,
      required this.l2,
      this.l3,
      required this.tableHeader,
      this.l4,
      this.l5,
      this.l6,
      this.onCLick,
      this.isClickable});

  @override
  State<CustTable> createState() => _CustTableState();
}

class _CustTableState extends State<CustTable> {
  bool isLoading = true;

  @override
  void initState() {
    // CustomMessage.showLoader();

    // shwProgressIndicator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width, // Makes table full width
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical, // Enables vertical scrolling
        child: Table(
          columnWidths: {
            // for (int i = 0; i < widget.tableHeader.length; i++)
            //   i: const FlexColumnWidth()
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(2.8), // L2 - More space here
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1.2),
          },
          // border: TableBorder.all(color: Colors.grey),
          children: [
            widget.l1.isNotEmpty
                ? _buildRoundedTableRow(widget.tableHeader)
                : const TableRow(children: [DataNotFound()]),
            for (int i = 0; i < widget.l1.length; i++)
              widget.l1.isNotEmpty
                  ? _buildTableRow(i)
                  : const TableRow(children: [Text('')]),
          ],
        ),
      ),
    );
  }

  shwProgressIndicator() async {
    await Future.delayed(const Duration(seconds: 0));
    setState(() {
      CustomMessage.showLoader();
    });
  }

  TableRow _buildRoundedTableRow(List<String> data) {
    return TableRow(
      children: List.generate(
        data.length,
        (index) => TableCell(
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.primaryBackgroundColor,
              // Background color of the first row
              borderRadius: BorderRadius.only(
                topLeft: index == 0 ? const Radius.circular(10.0) : Radius.zero,
                topRight: index == data.length - 1
                    ? const Radius.circular(10.0)
                    : Radius.zero,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
            child: CustomText(
              text: data[index],
              fontSize: 10,
              fontFam: 'Nunito Sans',
              fontWeight: FontWeight.bold,
              textColor: AppColor.white,
              textAlign: TextAlign.center, // Text color
            ),
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(int index) {
    return TableRow(
      children: List.generate(
        widget.tableHeader.length,
        (i) {
          List<dynamic> dataSources = [
            widget.l1,
            widget.l2,
            if (widget.l3 != null) widget.l3!,
            if (widget.l4 != null) widget.l4!,
            if (widget.l5 != null) widget.l5!,
            if (widget.l6 != null) widget.l6!,
          ];

          // Ensure index is within bounds
          if (i < dataSources.length && index < dataSources[i].length) {
            Widget cellContent = Text(
              dataSources[i][index].toString(),
              textAlign: TextAlign.center,
            );

            // Make `l3` Clickable
            if (i == 2 && widget.l3 != null) {
              cellContent = TextButton(
                onPressed: widget.isClickable == true
                    ? () {
                        widget.onCLick!(index);
                      }
                    : null,
                child: Text(
                  widget.l3![index].toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.isClickable == true
                        ? AppColor.primaryBackgroundColor
                        : AppColor.black,
                    // decoration: TextDecoration.underline,
                  ),
                ),
              );
            }

            return TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: cellContent,
              ),
            );
          }
          return const TableCell(child: SizedBox.shrink());
        },
      ),
    );
  }
}

class BusinessTable extends StatefulWidget {
  final List<String> l1;
  final List<dynamic> l2;
  final List<dynamic>? l3;
  final List<dynamic>? l4;
  final List<dynamic>? l5;
  final List<dynamic>? l6;
  final List<String> tableHeader;
  final Function? onCLick;
  final bool? isClickable;

  const BusinessTable(
      {super.key,
      required this.l1,
      required this.l2,
      this.l3,
      required this.tableHeader,
      this.l4,
      this.l5,
      this.l6,
      this.onCLick,
      this.isClickable});

  @override
  State<BusinessTable> createState() => _BusinessTableState();
}

class _BusinessTableState extends State<BusinessTable> {
  bool isLoading = true;

  @override
  void initState() {
    // CustomMessage.showLoader();

    // shwProgressIndicator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width, // Makes table full width
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical, // Enables vertical scrolling
        child: Table(
          columnWidths: {
            // for (int i = 0; i < widget.tableHeader.length; i++)
            //   i: const FlexColumnWidth()
            0: FlexColumnWidth(1), // Sr.No
            1: FlexColumnWidth(1.5), // L2 - More space here
            2: FlexColumnWidth(1), // L3
            3: FlexColumnWidth(1), // L4
          },
          // border: TableBorder.all(color: Colors.grey),
          children: [
            widget.l1.isNotEmpty
                ? _buildRoundedTableRow(widget.tableHeader)
                : const TableRow(children: [DataNotFound()]),
            for (int i = 0; i < widget.l1.length; i++)
              widget.l1.isNotEmpty
                  ? _buildTableRow(i)
                  : const TableRow(children: [Text('')]),
          ],
        ),
      ),
    );
  }

  shwProgressIndicator() async {
    await Future.delayed(const Duration(seconds: 0));
    setState(() {
      CustomMessage.showLoader();
    });
  }

  TableRow _buildRoundedTableRow(List<String> data) {
    return TableRow(
      children: List.generate(
        data.length,
        (index) => TableCell(
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.primaryBackgroundColor,
              // Background color of the first row
              borderRadius: BorderRadius.only(
                topLeft: index == 0 ? const Radius.circular(10.0) : Radius.zero,
                topRight: index == data.length - 1
                    ? const Radius.circular(10.0)
                    : Radius.zero,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
            child: CustomText(
              text: data[index],
              fontSize: 9,
              fontFam: 'Nunito Sans',
              fontWeight: FontWeight.normal,
              textColor: AppColor.white,
              textAlign: TextAlign.center, // Text color
            ),
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(int index) {
    return TableRow(
      children: List.generate(
        widget.tableHeader.length,
        (i) {
          List<dynamic> dataSources = [
            widget.l1,
            widget.l2,
            if (widget.l3 != null) widget.l3!,
            if (widget.l4 != null) widget.l4!,
            if (widget.l5 != null) widget.l5!,
            if (widget.l6 != null) widget.l6!,
          ];

          // Ensure index is within bounds
          if (i < dataSources.length && index < dataSources[i].length) {
            Widget cellContent = Text(
              dataSources[i][index].toString(),
              textAlign: TextAlign.center,
            );

            // Make `l3` Clickable
            if (i == 2 && widget.l3 != null) {
              cellContent = TextButton(
                onPressed: widget.isClickable == true
                    ? () {
                        widget.onCLick!(index);
                      }
                    : null,
                child: Text(
                  widget.l3![index].toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.isClickable == true
                        ? AppColor.primaryBackgroundColor
                        : AppColor.black,
                    // decoration: TextDecoration.underline,
                  ),
                ),
              );
            }

            return TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: cellContent,
              ),
            );
          }
          return const TableCell(child: SizedBox.shrink());
        },
      ),
    );
  }
}
