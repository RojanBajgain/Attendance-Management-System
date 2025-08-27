import 'package:ams/config/resources/styles.dart';
import 'package:flutter/material.dart';

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
                      margin: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 2),
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDarkMode
                                ? Colors.grey.shade300
                                : Colors.grey.shade300)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        //   boxShadow: isSelected
                        //       ? [
                        //           BoxShadow(
                        //             color: Colors.black.withOpacity(0.1),
                        //             blurRadius: 4,
                        //             offset: const Offset(0, 2),
                        //           )
                        //         ]
                        //       : null,
                      ),
                      child: Text(
                        name,
                        style: smallNStyle.copyWith(
                          color: isSelected
                              ? (isDarkMode ? Colors.black : Colors.black)
                              : (isDarkMode ? Colors.white70 : Colors.black54),
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12.0,
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
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.only(top: 16),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$selectedTypeName",
                      style: smallStyle.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Last Year balance',
                              style: smallStyle,
                            ),
                            Text('0',
                                style: smallStyle.copyWith(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Added This Year',
                              style: smallStyle,
                            ),
                            Text(
                              '0',
                              style: smallStyle.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Adjusted',
                              style: smallStyle,
                            ),
                            Text(
                              '0',
                              style: smallStyle.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Total',
                              style: smallStyle,
                            ),
                            Text('0'),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Leave Used',
                              style: smallStyle,
                            ),
                            Text(
                              '0',
                              style: smallStyle,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Remaining Leaves',
                              style: smallStyle,
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
                                  style:
                                      smallStyle.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
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
}
