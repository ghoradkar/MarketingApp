import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:marketingapp/utils/color_constants.dart';

class SearchableDropDown extends StatelessWidget {
  final bool isViewPatient;
  final dynamic selectedItem;
  final List<String> list;
  final Function onChanged;
  final String hintText;
  final String iconPath;

  const SearchableDropDown({
    super.key,
    required this.isViewPatient,
    this.selectedItem,
    required this.list,
    required this.onChanged,
    required this.hintText,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              hintText,
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColor.borderGrey),
            ),
            child: DropdownSearch<String>(
              enabled: isViewPatient,
              selectedItem: selectedItem,
              items: (f, cs) => list,
              onChanged: (value) {
                onChanged(value);
              },
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  prefixIcon: Image.asset(
                    iconPath,
                    color: AppColor.primaryBackgroundColor,
                  ),
                  // suffixIcon: const Icon(Icons.clear), // Clear icon
                ),
              ),
              popupProps: const PopupProps.menu(
                showSearchBox: true,
                showSelectedItems: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// import 'package:animated_custom_dropdown/custom_dropdown.dart';
// import 'package:flutter/material.dart';
// import 'package:marketingapp/utils/color_constants.dart';
//
// class SearchableDropDown extends StatelessWidget {
//   final bool isViewPatient;
//   final dynamic selectedItem;
//   final List<dynamic> list;
//   final Function onChanged;
//   final Function onSearched;
//   final String hintText;
//   final String iconPath;
//
//   const SearchableDropDown(
//       {super.key,
//       required this.isViewPatient,
//       this.selectedItem,
//       required this.list,
//       required this.onChanged,
//       required this.onSearched,
//       required this.hintText,
//       required this.iconPath});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
//           child: Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 hintText,
//                 textAlign: TextAlign.left,
//               )),
//         ),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(color: AppColor.borderGrey),
//             ),
//             child: CustomDropdown.searchRequest(
//               decoration: CustomDropdownDecoration(
//                   prefixIcon: Image.asset(
//                 iconPath,
//                 color: AppColor.primaryBackgroundColor,
//               )),
//               enabled: isViewPatient,
//               initialItem: selectedItem,
//               hintText: hintText,
//               closeDropDownOnClearFilterSearch: true,
//               items: list,
//               onChanged: (value) {
//                 onChanged(value);
//               },
//               futureRequest: (searched) {
//                 return onSearched(searched);
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
