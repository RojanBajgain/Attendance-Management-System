import 'package:ams/config/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LeaveView extends StatefulWidget {
  int? profileId;
  final String? apiKey;
  LeaveView({super.key, this.profileId, this.apiKey});

  @override
  State<LeaveView> createState() => _LeaveViewState();
}

class _LeaveViewState extends State<LeaveView> {
  int selectedTypeId = 1;
  String selectedTypeName = "Sick Leave";
  final ScrollController horizontalScrollController = ScrollController();
  void scrollToItem(int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    double tabWidth = 100;
    double targetOffset =
        (index * tabWidth) - (screenWidth / 3) + (tabWidth / 2);
    if (targetOffset < 0) targetOffset = 0;
    horizontalScrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    selectedTypeId = 1;
  }

  void selectType(int id, String name) {
    setState(() {
      selectedTypeId = id;
      selectedTypeName = name;
    });
  }

  // Leave type list with IDs
  final List<Map<String, dynamic>> leaveTypes = [
    {"id": 1, "name": "Sick Leave"},
    {"id": 2, "name": "Emergency Leave"},
    {"id": 3, "name": "Unpaid Leave"},
    {"id": 4, "name": "Prorated Leave"},
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            // Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: horizontalScrollController,
              child: Row(
                children: leaveTypes.map((leave) {
                  final id = leave["id"] as int;
                  final name = leave["name"] as String;
                  final isSelected = selectedTypeId == id;

                  return GestureDetector(
                    onTap: () {
                      scrollToItem(id);
                      selectType(id, name);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDarkMode
                                ? Colors.grey.shade300
                                : Colors.grey.shade300)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        name,
                        style: smallNStyle.copyWith(
                          color: isSelected
                              ? (isDarkMode ? Colors.black : Colors.black)
                              : (isDarkMode ? Colors.white70 : Colors.black54),
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 14.0.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Show selected tab content
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              margin: const EdgeInsets.only(top: 16),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedTypeName,
                          style: smallStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0.sp,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Remaining Leaves: ",
                              style: smallStyle.copyWith(
                                fontSize: 14.0.sp,
                                color: Colors.grey,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  '0',
                                  style: smallStyle.copyWith(
                                      color: Colors.white, fontSize: 14.sp),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 2,
                            child: buildInfoColumn(
                                title: 'Last Year balance', value: '0')),
                        Expanded(
                            flex: 2,
                            child: buildInfoColumn(
                                title: 'Added This Year', value: '0')),
                        Expanded(
                            child:
                                buildInfoColumn(title: 'Adjusted', value: '0')),
                      ],
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey.shade300,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildInfoColumn(title: 'Total', value: '0'),
                        buildInfoColumn(title: 'Leave Used', value: '0'),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column buildInfoColumn({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: smallStyle.copyWith(fontSize: 14.0.sp, color: Colors.grey),
        ),
        Text(
          value,
          style: smallStyle.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 14.0.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
