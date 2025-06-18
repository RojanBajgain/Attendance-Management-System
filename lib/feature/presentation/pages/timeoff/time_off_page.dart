import 'package:ams/config/resources/shimmer.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/dashboard/widget/skeleton_box.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/timeoff/controller/timeoff_controller.dart';
import 'package:ams/feature/presentation/pages/timeoff/sub_view_timeoff/time_off_view.dart';
import 'package:ams/feature/presentation/widget/components/app_bar.dart';
import 'package:ams/feature/presentation/pages/timeoff/sub_view_timeoff/add_timeoff.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeOffPage extends StatefulWidget {
  final int? profileId;
  final String? apiKey;

  TimeOffPage({super.key, this.profileId, this.apiKey});

  @override
  State<TimeOffPage> createState() => _TimeOffPageState();
}

class _TimeOffPageState extends State<TimeOffPage> {
  final authcontroller = Get.find<AuthController>();

  final TimeoffController timeoffcontroller = Get.put(TimeoffController());

  @override
  void initState() {
    super.initState();
    timeoffcontroller.getTimeoff();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: ConstantAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          await timeoffcontroller.getTimeoff(forceRefresh: true);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
              ),
              child: Row(
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
                      Get.to(() => const AddTimeoff(),
                          transition: Transition.rightToLeft);
                    },
                    child: Container(
                      height: 35.0,
                      width: 35.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(70.0),
                        color: isDarkMode ? Colors.grey.shade400 : Colors.black,
                      ),
                      child: Icon(
                        Icons.add,
                        color: isDarkMode ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  // FILTER BUTTON
                  Obx(() => Container(
                        height: 40.0,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10.0),
                          color:
                              isDarkMode ? Colors.grey.shade400 : Colors.black,
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
                          dropdownColor:
                              isDarkMode ? Colors.grey.shade400 : Colors.black,
                          underline: const SizedBox(),
                          style: TextStyle(
                            color: isDarkMode ? Colors.black : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          items: [
                            'All',
                            'Pending',
                            'Approved',
                            'Rejected',
                            're-apply'
                          ]
                              .map((filter) => DropdownMenuItem(
                                    value: filter,
                                    child: Text(
                                      filter == 're-apply'
                                          ? 'Reapplied'
                                          : filter,
                                      style: smallStyle.copyWith(
                                        color: isDarkMode
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Obx(() {
              if (timeoffcontroller.isLoading.value) {
                // return Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.circular(12.0),
                //     child: ShrimmerEffect.rectangular(
                //       height: 150,
                //       width: MediaQuery.sizeOf(context).width,
                //     ),
                //   ),
                // );
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return const TimeoffSkeleton();
                  },
                );
              } else if (timeoffcontroller.timeoff.isEmpty) {
                return SizedBox(
                  height: 600,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/no_data.png',
                          height: 200,
                          width: 250,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "No Data Available",
                          style: smallStyle.copyWith(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Column(
                  children: timeoffcontroller.filteredTimeoff
                      .map((timeoff) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TimeOffSheet(timeoffdata: timeoff),
                          ))
                      .toList(),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}

class TimeoffSkeleton extends StatelessWidget {
  const TimeoffSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(height: 80, width: double.infinity, borderRadius: 8),
        ],
      ),
    );
  }
}
