import 'package:ams/config/resources/shimmer.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/timeoff/controller/timeoff_controller.dart';
import 'package:ams/feature/presentation/pages/timeoff/sub_view_timeoff/time_off_view.dart';
import 'package:ams/feature/presentation/widget/components/app_bar.dart';
import 'package:ams/feature/presentation/pages/timeoff/sub_view_timeoff/add_timeoff.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeOffPage extends StatefulWidget {
  const TimeOffPage({super.key});

  @override
  State<TimeOffPage> createState() => _TimeOffPageState();
}

class _TimeOffPageState extends State<TimeOffPage> {
  final authcontroller = Get.find<AuthController>();

  final TimeoffController timeoffcontroller =
      Get.put(TimeoffController(timeoffRepo: Get.find()));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timeoffcontroller.getTimeoff();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const ConstantAppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Time offs",
                      style: smallNStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 10.0),
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          () => const AddTimeoff(),
                          transition: Transition.rightToLeft,
                        );
                      },
                      child: Container(
                        height: 35.0,
                        width: 35.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(70.0),
                          color:
                              isDarkMode ? Colors.grey.shade400 : Colors.black,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: isDarkMode ? Colors.black : Colors.white,
                            ),
                            // const SizedBox(width: 5.0),
                            // Text(
                            //   "Add Time off",
                            //   style: smallStyle.copyWith(
                            //     fontWeight: FontWeight.bold,
                            //     color: isDarkMode ? Colors.black : Colors.white,
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    // FILTER BUTTON
                    Obx(() => Container(
                          height: 40.0,
                          // width: 80.0,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                            color: isDarkMode
                                ? Colors.grey.shade400
                                : Colors.black,
                          ),
                          child: DropdownButton<String>(
                            value: timeoffcontroller.selectedFilter.value,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                timeoffcontroller.filterTimeoff(newValue);
                              }
                            },
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: isDarkMode ? Colors.black : Colors.white,
                            ),
                            dropdownColor: isDarkMode
                                ? Colors.grey.shade400
                                : Colors.black,
                            underline: const SizedBox(),
                            style: TextStyle(
                              color: isDarkMode ? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            items: [
                              DropdownMenuItem(
                                  value: 'All',
                                  child: Text(
                                    'All',
                                    style: smallStyle.copyWith(
                                      color: isDarkMode
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  )),
                              DropdownMenuItem(
                                  value: 'Pending',
                                  child: Text(
                                    'Pending',
                                    style: smallStyle.copyWith(
                                      color: isDarkMode
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  )),
                              DropdownMenuItem(
                                  value: 'Approved',
                                  child: Text(
                                    'Approved',
                                    style: smallStyle.copyWith(
                                      color: isDarkMode
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  )),
                              DropdownMenuItem(
                                  value: 'Rejected',
                                  child: Text(
                                    'Rejected',
                                    style: smallStyle.copyWith(
                                      color: isDarkMode
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  )),
                              DropdownMenuItem(
                                value: 're-apply',
                                child: Text(
                                  'Reapplied',
                                  style: smallStyle.copyWith(
                                    color: isDarkMode
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
                const SizedBox(height: 20.0),
                SingleChildScrollView(
                  child: SizedBox(
                    // height: 655,
                    child: Obx(() {
                      if (timeoffcontroller.isLoading.value) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: ShrimmerEffect.rectangular(
                              height: 150,
                              width: MediaQuery.sizeOf(context).width,
                            ),
                          ),
                        );
                      } else if (timeoffcontroller.timeoff.isEmpty) {
                        return SizedBox(
                          height: 600,
                          child: Center(
                            child: Text(
                              "No available Timeoff data",
                              style: smallStyle.copyWith(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: timeoffcontroller.filteredTimeoff.length,
                            itemBuilder: (context, index) {
                              final timeoff =
                                  timeoffcontroller.filteredTimeoff[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TimeOffSheet(timeoffdata: timeoff),
                              );
                            });
                      }
                    }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
