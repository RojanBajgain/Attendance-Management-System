import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:ams/feature/presentation/pages/profile/model/country_list_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ams/config/resources/styles.dart';

class CountryDropdown extends StatefulWidget {
  final String? valueId;
  final String? title;
  final String? valueName;
  final Function(CountryData?)? onChanged;
  final bool isDarkMode;
  final String? errorText;

  const CountryDropdown({
    Key? key,
    this.valueId,
    this.title,
    this.valueName,
    this.onChanged,
    required this.isDarkMode,
    this.errorText,
  }) : super(key: key);

  @override
  State<CountryDropdown> createState() => _CountryDropdownState();
}

class _CountryDropdownState extends State<CountryDropdown> {
  final ProfileController profileController = Get.find<ProfileController>();

  // Create CountryData objects from CountryListModel objects
  List<CountryData> _getCountries() {
    if (profileController.countrylist.isEmpty) {
      // Fallback to default if no countries are loaded yet
      return [CountryData(id: 1, name: "Nepal")];
    }
    return profileController.countrylist
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
        final hasError =
            widget.errorText != null && widget.errorText!.isNotEmpty;

        return Column(
          children: [
            DropdownButtonFormField2<CountryData>(
              isExpanded: true,
              value: selected,
              hint: Text(
                'Country',
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: hasError
                        ? Colors.red
                        : widget.isDarkMode
                            ? Colors.white70
                            : Colors.black54,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: hasError
                        ? Colors.red
                        : widget.isDarkMode
                            ? Colors.white70
                            : Colors.black54,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: hasError
                        ? Colors.red
                        : widget.isDarkMode
                            ? Colors.blueAccent
                            : Colors.black,
                    width: 2.0,
                  ),
                ),
                filled: true,
                fillColor:
                    widget.isDarkMode ? Colors.grey[800] : Colors.grey[50],
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: hasError
                      ? Colors.red
                      : widget.isDarkMode
                          ? Colors.grey[800]
                          : Colors.white,
                ),
              ),
              iconStyleData: IconStyleData(
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                ),
                iconSize: 24,
              ),
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 8),
                height: 20,
              ),
              items: countries.map((country) {
                return DropdownMenuItem<CountryData>(
                  value: country,
                  child: Text(
                    country.name,
                    style: smallStyle.copyWith(
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (CountryData? newValue) {
                if (widget.onChanged != null) {
                  widget.onChanged!(newValue);
                }
              },
            ),
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 12),
                child: Text(
                  widget.errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
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
