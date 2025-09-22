import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/dashboard/widget/skeleton_box.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/payroll/controller/payroll_controller.dart';
import 'package:ams/feature/presentation/pages/payroll/sub_view_payroll/payslip_view.dart';
import 'package:ams/feature/presentation/pages/payroll/sub_view_payroll/profile_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PayrollPage extends StatefulWidget {
  int? profileId;
  final String? apiKey;
  PayrollPage({super.key, this.profileId, this.apiKey});

  @override
  State<PayrollPage> createState() => _PayrollPageState();
}

class _PayrollPageState extends State<PayrollPage> {
  final authcontroller = Get.find<AuthController>();
  final PayrollController payrollcontroller =
      Get.put(PayrollController(payrollRepo: Get.find()));
  bool _isPayrollVisible = false;
  String selectedType = "PROFILE";

  void selectType(String type) {
    setState(() {
      selectedType = type;
    });
  }

  @override
  void initState() {
    super.initState();
    payrollcontroller.getPayroll();
    payrollcontroller.clearSelectedDate();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
          // appBar: const ConstantAppBar(),
          body: RefreshIndicator(
              color: isDarkMode ? Colors.white : Colors.black,
              backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
              onRefresh: () async {
                await payrollcontroller.getPayroll();
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Row(children: [
                    Text(
                      "Payrolls",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => selectType("PROFILE"),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: selectedType == "PROFILE"
                                    ? (isDarkMode ? Colors.white : Colors.white)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: selectedType == "PROFILE"
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Profile',
                                    style: smallNStyle.copyWith(
                                      color: selectedType == "PROFILE"
                                          ? (isDarkMode
                                              ? Colors.black
                                              : Colors.black)
                                          : (isDarkMode
                                              ? Colors.white70
                                              : Colors.black54),
                                      fontWeight: selectedType == "PROFILE"
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 14.0.sp,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => selectType("PAYSLIP"),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: selectedType == "PAYSLIP"
                                    ? (isDarkMode ? Colors.white : Colors.white)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: selectedType == "PAYSLIP"
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Payslip',
                                    style: smallNStyle.copyWith(
                                      color: selectedType == "PAYSLIP"
                                          ? (isDarkMode
                                              ? Colors.black
                                              : Colors.black)
                                          : (isDarkMode
                                              ? Colors.white70
                                              : Colors.black54),
                                      fontWeight: selectedType == "PAYSLIP"
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 14.0.sp,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Builder(
                      builder: (_) {
                        if (selectedType == "PROFILE") {
                          return const ProfileTabView();
                        } else if (selectedType == "PAYSLIP") {
                          return const PayslipView();
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                  // child: ListView(
                  //   physics: const BouncingScrollPhysics(
                  //     parent: AlwaysScrollableScrollPhysics(),
                  //   ),
                  //   padding: const EdgeInsets.all(16.0),
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.only(left: 6.0),
                  //       child: Row(
                  //         children: [
                  //           Text(
                  //             "Pay Roll",
                  //             style: normalStyle.copyWith(
                  //               fontWeight: FontWeight.bold,
                  //               color: isDarkMode ? Colors.white : Colors.black,
                  //             ),
                  //           ),
                  //           const Spacer(),
                  //           GestureDetector(
                  //             onTap: () {
                  //               setState(() {
                  //                 _isPayrollVisible = !_isPayrollVisible;
                  //               });
                  //             },
                  //             child: Container(
                  //               height: 35.0,
                  //               width: 50.0,
                  //               padding: const EdgeInsets.symmetric(horizontal: 10),
                  //               decoration: BoxDecoration(
                  //                 border: Border.all(color: Colors.transparent),
                  //                 borderRadius: BorderRadius.circular(70.0),
                  //                 color: Theme.of(context).colorScheme.surface,
                  //               ),
                  //               child: Icon(
                  //                 _isPayrollVisible
                  //                     ? Icons.visibility
                  //                     : Icons.visibility_off,
                  //                 color: Colors.white,
                  //               ),
                  //             ),
                  //           ),
                  //           const SizedBox(width: 10),
                  //           GestureDetector(
                  //             onTap: () async {
                  //               final ThemeData datePickerTheme = isDarkMode
                  //                   ? ThemeData.dark().copyWith(
                  //                       textTheme: TextTheme(
                  //                         bodyLarge: TextStyle(
                  //                           fontSize: 11.0,
                  //                           color: isDarkMode
                  //                               ? Colors.white
                  //                               : Colors.black,
                  //                         ),
                  //                         bodyMedium: TextStyle(
                  //                           fontSize: 11.0,
                  //                           color: isDarkMode
                  //                               ? Colors.white
                  //                               : Colors.black,
                  //                         ),
                  //                       ),
                  //                       dialogBackgroundColor: Colors.grey[900],
                  //                       colorScheme: const ColorScheme.dark(
                  //                         primary: Colors.blueAccent,
                  //                         onPrimary: Colors.white,
                  //                         onSurface: Colors.white,
                  //                         background: Colors.black,
                  //                       ),
                  //                     )
                  //                   : ThemeData.light().copyWith(
                  //                       textTheme: TextTheme(
                  //                         bodyLarge: TextStyle(
                  //                           fontSize: 11.0,
                  //                           color: isDarkMode
                  //                               ? Colors.white
                  //                               : Colors.black,
                  //                         ),
                  //                         bodyMedium: TextStyle(
                  //                           fontSize: 11.0,
                  //                           color: isDarkMode
                  //                               ? Colors.white
                  //                               : Colors.black,
                  //                         ),
                  //                       ),
                  //                       dialogBackgroundColor: Colors.white,
                  //                       colorScheme: const ColorScheme.light(
                  //                         primary: Colors.black,
                  //                         onPrimary: Colors.white,
                  //                         onSurface: Colors.black,
                  //                         background: Colors.white,
                  //                       ),
                  //                     );
                  //               DateTime? selectedDate = await showDatePicker(
                  //                 context: context,
                  //                 initialDate: DateTime.now(),
                  //                 firstDate: DateTime(2000),
                  //                 lastDate: DateTime(2100),
                  //                 builder: (BuildContext context, Widget? child) {
                  //                   return Theme(
                  //                     data: datePickerTheme,
                  //                     child: child!,
                  //                   );
                  //                 },
                  //               );

                  //               if (selectedDate != null) {
                  //                 payrollcontroller.selectedDate.value = selectedDate;
                  //                 payrollcontroller.filterPayrollByDate(selectedDate);
                  //               }
                  //             },
                  //             child: Obx(() {
                  //               return Container(
                  //                 height: 35.0,
                  //                 width: payrollcontroller.selectedDate.value != null
                  //                     ? 165.0
                  //                     : 50.0,
                  //                 padding: const EdgeInsets.symmetric(horizontal: 10),
                  //                 decoration: BoxDecoration(
                  //                   border: Border.all(color: Colors.transparent),
                  //                   borderRadius: BorderRadius.circular(70.0),
                  //                   color: Theme.of(context).colorScheme.surface,
                  //                 ),
                  //                 child: Row(
                  //                   mainAxisAlignment: MainAxisAlignment.center,
                  //                   children: [
                  //                     const Icon(
                  //                       Icons.date_range_outlined,
                  //                       color: Colors.white,
                  //                     ),
                  //                     if (payrollcontroller.selectedDate.value !=
                  //                         null) ...[
                  //                       const SizedBox(width: 5),
                  //                       Text(
                  //                         DateFormat('MMM d, yyyy').format(
                  //                             payrollcontroller.selectedDate.value!),
                  //                         style:
                  //                             smallStyle.copyWith(color: Colors.white),
                  //                       ),
                  //                       const SizedBox(width: 5),
                  //                       GestureDetector(
                  //                         onTap: () {
                  //                           payrollcontroller.clearSelectedDate();
                  //                         },
                  //                         child: const Icon(
                  //                           Icons.clear,
                  //                           size: 20.0,
                  //                           color: Colors.white,
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ],
                  //                 ),
                  //               );
                  //             }),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     const SizedBox(height: 10.0),
                  //     SizedBox(
                  //       child: _isPayrollVisible
                  //           ? Obx(() {
                  //               if (payrollcontroller.isLoading.value) {
                  //                 return ListView.builder(
                  //                   shrinkWrap: true,
                  //                   physics: const NeverScrollableScrollPhysics(),
                  //                   scrollDirection: Axis.vertical,
                  //                   itemCount: 6,
                  //                   itemBuilder: (context, index) {
                  //                     return const PayrollSkeleton();
                  //                   },
                  //                 );
                  //               } else if (payrollcontroller.payroll.isEmpty) {
                  //                 return SizedBox(
                  //                   height: 600,
                  //                   child: Center(
                  //                     child: Text(
                  //                       "No available payroll data",
                  //                       style: smallStyle.copyWith(
                  //                         color:
                  //                             isDarkMode ? Colors.white : Colors.black,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 );
                  //               } else {
                  //                 return ListView.builder(
                  //                   shrinkWrap: true,
                  //                   physics: const NeverScrollableScrollPhysics(),
                  //                   scrollDirection: Axis.vertical,
                  //                   itemCount: payrollcontroller.filteredPayroll.length,
                  //                   itemBuilder: (context, index) {
                  //                     final payroll =
                  //                         payrollcontroller.filteredPayroll[index];
                  //                     return Padding(
                  //                       padding: const EdgeInsets.all(4.0),
                  //                       child: PayRollSlip(
                  //                         payrolldata: payroll,
                  //                         dop: payroll.dateOfPayment != null
                  //                             ? DateFormat.yMMMd('en_US')
                  //                                 .format(payroll.dateOfPayment!)
                  //                             : "",
                  //                         mop: payroll.modeOfPayment.toString(),
                  //                         bank: payroll.bank ?? "---",
                  //                         cheque: payroll.chequeNo ?? "---",
                  //                         salary: payroll.totalSalary.toString(),
                  //                       ),
                  //                     );
                  //                   },
                  //                 );
                  //               }
                  //             })
                  //           : SizedBox(
                  //               height: 600,
                  //               child: Center(
                  //                 child: Column(
                  //                   mainAxisAlignment: MainAxisAlignment.center,
                  //                   children: [
                  //                     // Image
                  //                     Image.asset(
                  //                       'assets/images/pay.png',
                  //                       height: 150,
                  //                       width: 250,
                  //                       fit: BoxFit.cover,
                  //                     ),
                  //                     const SizedBox(height: 20),
                  //                     // Title
                  //                     Text(
                  //                       "Payroll Hidden",
                  //                       style: smallNStyle.copyWith(
                  //                         fontWeight: FontWeight.bold,
                  //                         color:
                  //                             isDarkMode ? Colors.white : Colors.black,
                  //                       ),
                  //                     ),
                  //                     const SizedBox(height: 10),
                  //                     Text(
                  //                       "Your payroll details are currently hidden.",
                  //                       textAlign: TextAlign.center,
                  //                       style: smallStyle.copyWith(
                  //                         color: isDarkMode
                  //                             ? Colors.grey.shade300
                  //                             : Colors.grey.shade700,
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ),
                  //     ),
                  //   ],
                  // ),
                ]),
              ))),
    );
  }
}

class PayrollSkeleton extends StatelessWidget {
  const PayrollSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(height: 100, width: double.infinity, borderRadius: 8),
        ],
      ),
    );
  }
}
