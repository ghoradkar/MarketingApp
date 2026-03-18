import 'package:flutter/material.dart';

class AutocompleteField extends StatelessWidget {
  final List<String> cityList;
  final String? selectedCity;
  final Function(String) onSelected;
  final TextEditingController controller;

  const AutocompleteField({
    super.key,
    required this.cityList,
    required this.onSelected,
    required this.controller,
    this.selectedCity,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: selectedCity ?? ''),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) return const Iterable<String>.empty();
        return cityList.where((city) =>
            city.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      onSelected: onSelected,
      fieldViewBuilder: (context, textFieldController, focusNode, onFieldSubmitted) {
        textFieldController.text = controller.text;

        return TextFormField(
          controller: textFieldController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: 'City',
            hintText: 'Enter city name',
            prefixIcon: const Icon(Icons.location_city),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      },
    );
  }
}
