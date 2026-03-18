import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketingapp/utils/color_constants.dart';
import 'package:marketingapp/utils/data_not_found.dart';
import 'package:marketingapp/widgets/custom_text.dart';

class CustomerTable extends StatefulWidget {
  final List<String> l1;
  final List<dynamic> l2;
  final List<dynamic>? l3;
  final List<dynamic>? l4;
  final List<dynamic>? l5;
  final List<dynamic>? l6;
  final List<String> tableHeader;
  final Function? onCLick;
  final bool? isOffline; // NEW: Optional offline indicator

  const CustomerTable({
    super.key,
    required this.l1,
    required this.l2,
    this.l3,
    required this.tableHeader,
    this.l4,
    this.l5,
    this.l6,
    this.onCLick,
    this.isOffline, // NEW: Optional offline indicator
  });

  @override
  State<CustomerTable> createState() => _CustomerTableState();
}

class _CustomerTableState extends State<CustomerTable> {
  // bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(1), // Sr.No
            1: FlexColumnWidth(3), // L2 - More space here
            2: FlexColumnWidth(1), // L3
            3: FlexColumnWidth(1), // L4
            4: FlexColumnWidth(1), // L5 (Action)
          },
          children: [
            widget.l1.isNotEmpty
                ? _buildRoundedTableRow(widget.tableHeader)
                : TableRow(children: [DataNotFound()]),
            for (int i = 0; i < widget.l1.length; i++)
              widget.l1.isNotEmpty
                  ? _buildTableRow(i)
                  : const TableRow(children: [Text('')]),
          ],
        ),
      ),
    );
  }

  // shwProgressIndicator() async {
  //   await Future.delayed(const Duration(seconds: 0));
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  TableRow _buildRoundedTableRow(List<String> data) {
    return TableRow(
      children: List.generate(
        data.length,
        (index) => TableCell(
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.primaryBackgroundColor,
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
              fontSize: 12,
              fontWeight: FontWeight.bold,
              textColor: AppColor.white,
              textAlign: TextAlign.center,
              fontFam: "Nunito Sans",
            ),
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(int index) {
    return TableRow(
      children: List.generate(
        5, // Total 5 columns
        (i) {
          List<dynamic> dataSources = [
            widget.l1, // Sr.No
            widget.l2, // Customer
            if (widget.l3 != null) widget.l3!, // In Time
            if (widget.l4 != null) widget.l4!, // Out Time
            if (widget.l5 != null) widget.l5!, // Action
          ];

          // Ensure index is within bounds
          if (i < dataSources.length && index < dataSources[i].length) {
            Widget cellContent = CustomText(
              textAlign: TextAlign.center,
              text: dataSources[i][index].toString(),
              fontSize: 12,
              fontWeight: FontWeight.normal,
              textColor: AppColor.black,
              fontFam: "Nunito Sans",
            ).paddingSymmetric(horizontal: 2);

            // 🔹 Make last column (Action) clickable with offline visual feedback
            if (i == 4) {
              // Check if offline mode is enabled
              bool isOfflineMode = widget.isOffline ?? false;

              cellContent = InkWell(
                onTap: () {
                  if (widget.onCLick != null) {
                    widget.onCLick!(index); // Pass row index
                  }
                },
                child: CustomText(
                  text: "View",
                  fontSize: 14,
                  fontFam: "Nunito Sans",
                  fontWeight: FontWeight.bold,
                  textColor: AppColor.primaryBackgroundColor,
                  textAlign: TextAlign.center,
                ),
              );
            }

            return TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Container(
                height: 70,
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

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:marketingapp/utils/color_constants.dart';
// import 'package:marketingapp/utils/data_not_found.dart';
// import 'package:marketingapp/widgets/custom_text.dart';
//
// class CustomerTable extends StatefulWidget {
//   final List<String> l1;
//   final List<dynamic> l2;
//   final List<dynamic>? l3;
//   final List<dynamic>? l4;
//   final List<dynamic>? l5;
//   final List<dynamic>? l6;
//   final List<String> tableHeader;
//   final Function? onCLick;
//   final bool? isClickable;
//
//   const CustomerTable(
//       {super.key,
//       required this.l1,
//       required this.l2,
//       this.l3,
//       required this.tableHeader,
//       this.l4,
//       this.l5,
//       this.l6,
//       this.onCLick,
//       this.isClickable});
//
//   @override
//   State<CustomerTable> createState() => _CustomerTableState();
// }
//
// class _CustomerTableState extends State<CustomerTable> {
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     // shwProgressIndicator();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width, // Makes table full width
//       child: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Table(
//           columnWidths: const {
//             // for (int i = 0; i < widget.tableHeader.length; i++)
//             //   i: const FlexColumnWidth()
//             0: FlexColumnWidth(1), // Sr.No
//             1: FlexColumnWidth(3), // L2 - More space here
//             2: FlexColumnWidth(1), // L3
//             3: FlexColumnWidth(1), // L4
//             4: FlexColumnWidth(1), // L5 (Action)
//           },
//           // border: TableBorder.all(color: Colors.grey),
//           children: [
//             widget.l1.isNotEmpty
//                 ? _buildRoundedTableRow(widget.tableHeader)
//                 :  TableRow(children: [
//                   DataNotFound()
//                     // CustomText(
//                     //   text: 'Data Not available',
//                     //   fontSize: 16,
//                     //   fontFam: '',
//                     //   fontWeight: FontWeight.bold,
//                     //   textColor: AppColor.black,
//                     //   textAlign: TextAlign.center,
//                     // )
//                   ]),
//             for (int i = 0; i < widget.l1.length; i++)
//               widget.l1.isNotEmpty
//                   ? _buildTableRow(i)
//                   : const TableRow(children: [Text('')]),
//           ],
//         ),
//       ),
//     );
//   }
//
//   shwProgressIndicator() async {
//     await Future.delayed(const Duration(seconds: 0));
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   TableRow _buildRoundedTableRow(List<String> data) {
//     return TableRow(
//       children: List.generate(
//         data.length,
//         (index) => TableCell(
//           child: Container(
//             decoration: BoxDecoration(
//               color: AppColor.primaryBackgroundColor,
//               // Background color of the first row
//               borderRadius: BorderRadius.only(
//                 topLeft: index == 0 ? const Radius.circular(10.0) : Radius.zero,
//                 topRight: index == data.length - 1
//                     ? const Radius.circular(10.0)
//                     : Radius.zero,
//               ),
//             ),
//             padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
//             child: CustomText(
//                 text: data[index],
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//                 textColor: AppColor.white,
//                 textAlign: TextAlign.center,
//                 fontFam: "Nunito Sans" // Text color
//                 ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   TableRow _buildTableRow(int index) {
//     return TableRow(
//       children: List.generate(
//         5, // Total 5 columns
//         (i) {
//           List<dynamic> dataSources = [
//             widget.l1, // Sr.No
//             widget.l2, // Customer
//             if (widget.l3 != null) widget.l3!, // In Time
//             if (widget.l4 != null) widget.l4!, // Out Time
//             if (widget.l5 != null) widget.l5!, // Action
//           ];
//
//           // Ensure index is within bounds
//           if (i < dataSources.length && index < dataSources[i].length) {
//             Widget cellContent = CustomText(
//                     textAlign: TextAlign.center,
//                     text: dataSources[i][index].toString(),
//                     fontSize: 12,
//                     fontWeight: FontWeight.normal,
//                     textColor: AppColor.black,
//                     fontFam: "Nunito Sans")
//                 .paddingSymmetric(horizontal: 2);
//
//             // 🔹 Make last column (Action) clickable
//             if (i == 4) {
//               cellContent = InkWell(
//                   onTap: () {
//                     if (widget.onCLick != null) {
//                       widget.onCLick!(index); // Pass row index
//                     }
//                   },
//                   // child: Image.asset(
//                   //   'assets/eye.png',
//                   //   color: AppColor.primaryBackgroundColor,
//                   // )
//                 child: CustomText(
//                     text: "View",
//                     fontSize: 14,
//                     fontFam: "Nunito Sans",
//                     fontWeight: FontWeight.bold,
//                     textColor: AppColor.primaryBackgroundColor,
//                     textAlign: TextAlign.center),
//               );
//             }
//
//             return TableCell(
//               verticalAlignment: TableCellVerticalAlignment.middle,
//               child: Container(
//                 height: 70,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: const Color(0xFFE0E0E0)),
//                 ),
//                 child: cellContent,
//               ),
//             );
//           }
//           return const TableCell(child: SizedBox.shrink());
//         },
//       ),
//     );
//   }
// }
