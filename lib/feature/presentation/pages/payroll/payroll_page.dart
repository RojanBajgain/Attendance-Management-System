import 'package:ams/config/resources/shimmer.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/payroll/controller/payroll_controller.dart';
import 'package:ams/feature/presentation/pages/payroll/sub_view_payroll/payroll_slip_view.dart';
import 'package:ams/feature/presentation/widget/components/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PayrollPage extends StatefulWidget {
  const PayrollPage({super.key});

  @override
  State<PayrollPage> createState() => _PayrollPageState();
}

class _PayrollPageState extends State<PayrollPage> {
  final authcontroller = Get.find<AuthController>();

  final PayrollController payrollcontroller =
      Get.put(PayrollController(payrollRepo: Get.find()));

  bool _isPayrollVisible = false;

  @override
  void initState() {
    super.initState();
    payrollcontroller.getPayroll();
    payrollcontroller.clearSelectedDate();
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
                      "Pay Roll",
                      style: normalStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const Spacer(),
                    // Eye Icon Container
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPayrollVisible = !_isPayrollVisible;
                        });
                      },
                      child: Container(
                        height: 40.0,
                        width: 55.0,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(70.0),
                          color:
                              isDarkMode ? Colors.grey.shade500 : Colors.white,
                        ),
                        child: Icon(
                          _isPayrollVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Date Picker Container
                    GestureDetector(
                      onTap: () async {
                        final ThemeData datePickerTheme =
                            Theme.of(context).copyWith(
                          textTheme: TextTheme(
                            bodyLarge: TextStyle(
                              fontSize: 14.0,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            bodyMedium: TextStyle(
                              fontSize: 12.0,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        );
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: datePickerTheme,
                              child: child!,
                            );
                          },
                        );

                        if (selectedDate != null) {
                          payrollcontroller.selectedDate.value = selectedDate;
                          payrollcontroller.filterPayrollByDate(selectedDate);
                        }
                      },
                      child: Obx(() {
                        return Container(
                          height: 40.0,
                          width: payrollcontroller.selectedDate.value != null
                              ? 165.0
                              : 55.0,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(70.0),
                            color: isDarkMode
                                ? Colors.grey.shade500
                                : Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.date_range_outlined,
                                color: Colors.black,
                              ),
                              if (payrollcontroller.selectedDate.value !=
                                  null) ...[
                                const SizedBox(width: 5),
                                Text(
                                  DateFormat('MMM d, yyyy').format(
                                      payrollcontroller.selectedDate.value!),
                                  style:
                                      smallStyle.copyWith(color: Colors.black),
                                ),
                                const SizedBox(width: 5),
                                GestureDetector(
                                  onTap: () {
                                    payrollcontroller.clearSelectedDate();
                                  },
                                  child: const Icon(
                                    Icons.clear,
                                    size: 20.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  child: _isPayrollVisible
                      ? Obx(() {
                          if (payrollcontroller.isLoading.value) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: ShrimmerEffect.rectangular(
                                height: 100,
                              ),
                            );
                          } else if (payrollcontroller.payroll.isEmpty) {
                            return SizedBox(
                              height: 600,
                              child: Center(
                                child: Text(
                                  "No available payroll data",
                                  style: smallStyle.copyWith(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount:
                                  payrollcontroller.filteredPayroll.length,
                              itemBuilder: (context, index) {
                                final payroll =
                                    payrollcontroller.filteredPayroll[index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: PayRollSlip(
                                    payrolldata: payroll,
                                    dop: payroll.dateOfPayment != null
                                        ? DateFormat.yMMMd('en_US')
                                            .format(payroll.dateOfPayment!)
                                        : "",
                                    mop: payroll.modeOfPayment.toString(),
                                    bank: payroll.bank ?? "---",
                                    cheque: payroll.chequeNo ?? "---",
                                    salary: payroll.totalSalary.toString(),
                                  ),
                                );
                              },
                            );
                          }
                        })
                      : SizedBox(
                          height: 600,
                          child: Center(
                            child: Text(
                              "Your Payroll is hidden...",
                              style: normalStyle.copyWith(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
