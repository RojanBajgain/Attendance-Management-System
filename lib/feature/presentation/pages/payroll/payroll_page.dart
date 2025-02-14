import 'package:ams/config/resources/shimmer.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/payroll/controller/payroll_controller.dart';
import 'package:ams/feature/presentation/pages/payroll/sub_view_payroll/payroll_slip_view.dart';
import 'package:ams/feature/presentation/widget/components/app_bar.dart';
import 'package:ams/feature/presentation/pages/payroll/sub_view_payroll/payment_slip_view.dart';
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

  @override
  void initState() {
    super.initState();
    payrollcontroller.getPayroll();
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
                    GestureDetector(
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                      },
                      child: Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(100.0),
                          color: Colors.grey[100],
                        ),
                        child: const Icon(
                          Icons.date_range_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                // PayRollSlip(
                //   dop: 'Jan 5, 2024',
                //   mop: 'Cheque',
                //   bank: 'NMB BANK',
                //   cheque: '25458687',
                //   salary: 'Rs. 30,000',
                // ),

                SizedBox(
                  // height: 600,
                  child: Obx(
                    () {
                      if (payrollcontroller.isLoading.value) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ShrimmerEffect.rectangular(
                            height: 100,
                            // width: MediaQuery.sizeOf(context).width,
                          ),
                        );
                      } else if (payrollcontroller.payroll.isEmpty) {
                        return SizedBox(
                          child: Center(
                            child: Text(
                              "No available payroll data",
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
                            itemCount: payrollcontroller.payroll.length,
                            itemBuilder: (context, index) {
                              final payroll = payrollcontroller.payroll[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: PayRollSlip(
                                  payrolldata: payroll,
                                  dop: payroll.dateOfPayment != null
                                      ? DateFormat.yMMMd('en_US')
                                          .format(payroll.dateOfPayment!)
                                      : "",
                                  mop: payroll.modeOfPayment.toString(),
                                  bank: payroll.bank != null
                                      ? payroll.bank!
                                      : "---",
                                  cheque: payroll.chequeNo != null
                                      ? payroll.chequeNo!
                                      : "---",
                                  salary: payroll.totalSalary.toString(),
                                ),
                              );
                            });
                      }
                    },
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
