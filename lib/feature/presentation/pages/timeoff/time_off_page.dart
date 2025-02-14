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
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Time offs",
                      style: normalStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        // Handle the selected date if needed
                      },
                      child: Container(
                        height: 45.0,
                        width: 45.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(70.0),
                          color: Colors.grey.shade400,
                        ),
                        child: const Icon(
                          Icons.date_range_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          () => const AddTimeoff(),
                          transition: Transition.rightToLeft,
                        );
                      },
                      child: Container(
                        height: 45.0,
                        width: 140.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10.0),
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
                            const SizedBox(width: 5.0),
                            Text(
                              "Add Time off",
                              style: smallStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.black : Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
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
                          child: ShrimmerEffect.rectangular(
                            height: 200,
                            width: MediaQuery.sizeOf(context).width,
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
                            itemCount: timeoffcontroller.timeoff.length,
                            itemBuilder: (context, index) {
                              final timeoff = timeoffcontroller.timeoff[index];
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
