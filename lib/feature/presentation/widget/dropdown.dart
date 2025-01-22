import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/resources/colors.dart';

class DropDownWidget<T> extends StatelessWidget {
  const DropDownWidget(
      {super.key,
      this.list,
      required this.currentValue,
      required this.hintText,
      required this.textController,
      this.onChanged,
      required this.textFormate});

  final List<T>? list;
  final Rx<T?>? currentValue;

  final String? hintText;

  final TextEditingController textController;
  final Function(T? value)? onChanged;
  final String? Function(T? value) textFormate;

  @override
  Widget build(BuildContext context) {
    return Obx(() => DropdownButtonHideUnderline(
          child: DropdownButton2<T>(
            isExpanded: true,
            hint: Text(
              hintText ?? "",
              style: Get.textTheme.bodyMedium!.copyWith(color: AppColors.grey),
            ),
            items: list
                ?.map((value) => DropdownMenuItem(
                      value: value,
                      child: Text(
                        textFormate(value) ?? "",
                        style: Get.textTheme.bodyMedium,
                      ),
                    ))
                .toList(),
            value: currentValue?.value,
            onChanged: onChanged,
            buttonStyleData: ButtonStyleData(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 40,
              decoration: BoxDecoration(
                  border:
                      Border.all(color: Get.theme.colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(8)),
              width: Get.width,
            ),
            dropdownStyleData: const DropdownStyleData(
              maxHeight: 300,
            ),
            menuItemStyleData: const MenuItemStyleData(
                // height: 40,
                ),
            dropdownSearchData: DropdownSearchData(
              searchController: textController,
              searchInnerWidgetHeight: 50,
              searchInnerWidget: Container(
                height: 50,
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 4,
                  right: 8,
                  left: 8,
                ),
                child: TextFormField(
                  expands: true,
                  maxLines: null,
                  controller: textController,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintText: hintText,
                    hintStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                return item.value.toString().contains(searchValue);
              },
            ),
            //This to clear the search value when you close the menu
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                textController.clear();
              }
            },
          ),
        ));
  }
}
