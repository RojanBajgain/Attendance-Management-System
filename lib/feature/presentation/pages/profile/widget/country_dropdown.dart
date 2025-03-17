import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:ams/feature/presentation/pages/profile/model/country_list_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ams/config/resources/styles.dart';

class CountryDropdown extends StatefulWidget {
  final String? valueId;
  final String? valueName;
  final Function(CountryData?)? onChanged;
  final bool isDarkMode;

  const CountryDropdown({
    Key? key,
    this.valueId,
    this.valueName,
    this.onChanged,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<CountryDropdown> createState() => _CountryDropdownState();
}

class _CountryDropdownState extends State<CountryDropdown> {
  final ProfileController profileController = Get.find<ProfileController>();

  // Create CountryData objects from CountryListModel objects
  List<CountryData> _getCountries() {
    if (profileController.countryList.isEmpty) {
      // Fallback to default if no countries are loaded yet
      return [CountryData(id: 1, name: "Nepal")];
    }
    return profileController.countryList
        .map((country) =>
            CountryData(id: country.id ?? 0, name: country.name ?? ""))
        .toList();
  }

  // Find the selected country from the current list
  CountryData? _findSelectedCountry(List<CountryData> countries) {
    if (widget.valueId != null && widget.valueId!.isNotEmpty) {
      try {
        int id = int.parse(widget.valueId!);
        for (var country in countries) {
          if (country.id == id) {
            return country;
          }
        }
      } catch (e) {
        // Handle parsing error
      }
    }

    // If no country found by ID but name is provided, try finding by name
    if (widget.valueName != null && widget.valueName!.isNotEmpty) {
      String valueName = widget.valueName!.toLowerCase();
      for (var country in countries) {
        if (country.name.toLowerCase() == valueName) {
          return country;
        }
      }
    }

    // Return null if no match found, which will make the dropdown show the hint text
    return null;
  }

  // In your CountryDropdown widget's build method
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Obx(() {
        // Get the current list of countries
        List<CountryData> countries = _getCountries();

        // Find the selected country in the current list
        CountryData? selected = _findSelectedCountry(countries);

        // Debug: Print selected country info
        print("Selected country: ${selected?.id}, ${selected?.name}");
        print("Value ID: ${widget.valueId}, Value Name: ${widget.valueName}");

        return DropdownButtonFormField<CountryData>(
          value: selected,
          decoration: InputDecoration(
            labelText: "Country",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            labelStyle: smallStyle.copyWith(
                color: widget.isDarkMode ? Colors.white70 : Colors.black54),
          ),
          style: smallStyle.copyWith(
              color: widget.isDarkMode ? Colors.white : Colors.black),
          dropdownColor: widget.isDarkMode ? Colors.grey[800] : Colors.white,
          items: countries
              .map<DropdownMenuItem<CountryData>>((CountryData country) {
            return DropdownMenuItem<CountryData>(
              value: country,
              child: Text(country.name),
            );
          }).toList(),
          onChanged: (CountryData? newValue) {
            if (widget.onChanged != null) {
              widget.onChanged!(newValue);
            }
          },
          hint: Text(
            "Select Country",
            style: smallStyle.copyWith(
                color: widget.isDarkMode ? Colors.white70 : Colors.grey),
          ),
        );
      }),
    );
  }
}

// Update the CountryData class with proper equality
class CountryData {
  final int id;
  final String name;

  CountryData({required this.id, required this.name});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CountryData && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
