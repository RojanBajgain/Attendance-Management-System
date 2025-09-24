import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/payroll/controller/payroll_controller.dart';
import 'package:ams/feature/presentation/pages/payroll/sub_view_payroll/payment_slip_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PayslipView extends StatefulWidget {
  const PayslipView({super.key});

  @override
  State<PayslipView> createState() => _PayslipViewState();
}

class _PayslipViewState extends State<PayslipView> {
  final PayrollController payrollController = Get.find<PayrollController>();

  @override
  void initState() {
    super.initState();
    // Load payroll data when the page loads
    _loadPayrollData();
  }

  void _loadPayrollData() {
    // Use the existing getPayroll method
    payrollController.getPayroll();
  }

  void _downloadLatestPayslip() {
    // Get the payroll list from the controller
    final payrollList = payrollController.payroll;

    if (payrollList.isEmpty) {
      Get.snackbar(
        'No Data',
        'No payroll records found',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Sort by date and get the latest record
    final latestPayroll = payrollList.reduce((a, b) {
      final dateA = DateTime.parse(a.dateOfPayment?.toString() ?? '1970-01-01');
      final dateB = DateTime.parse(b.dateOfPayment?.toString() ?? '1970-01-01');
      return dateA.isAfter(dateB) ? a : b;
    });

    // Navigate to PaymentSlip with the latest payroll ID
    Get.to(
      () => PaymentSlip(payrollId: latestPayroll.id.toString()),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PaySlip',
                style: smallNStyle.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 16.sp),
              ),
              Obx(() {
                return GestureDetector(
                  onTap: payrollController.isLoading.value
                      ? null
                      : _downloadLatestPayslip,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: payrollController.isLoading.value
                          ? Colors.grey
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (payrollController.isLoading.value)
                          SizedBox(
                            width: 16.sp,
                            height: 16.sp,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        else
                          Icon(
                            Icons.download,
                            color: Colors.white,
                            size: 16.sp,
                          ),
                        const SizedBox(width: 4),
                        Text(
                          payrollController.isLoading.value
                              ? 'Loading...'
                              : 'Download',
                          style: smallStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 20),

          // Display latest payroll info if available
          Obx(() {
            if (payrollController.payroll.isNotEmpty) {
              final latestPayroll = payrollController.payroll.reduce((a, b) {
                final dateA =
                    DateTime.parse(a.dateOfPayment?.toString() ?? '1970-01-01');
                final dateB =
                    DateTime.parse(b.dateOfPayment?.toString() ?? '1970-01-01');
                return dateA.isAfter(dateB) ? a : b;
              });

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border.all(color: Colors.blue.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Latest Payslip',
                      style: smallNStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pay Period: ${latestPayroll.payPeriod ?? "N/A"}',
                      style: smallStyle.copyWith(fontSize: 13.sp),
                    ),
                    // Text(
                    //   'Net Total: Rs. ${latestPayroll.netTotal ?? "0"}',
                    //   style: smallStyle.copyWith(
                    //     fontSize: 12.sp,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey.shade200,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monthly Regular Income',
                  style: smallNStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0.sp,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Basic Salary',
                            style: smallStyle.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 14.sp),
                          ),
                          Text(
                            'Effective From: -',
                            style: smallStyle.copyWith(
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Obx(() {
                            if (payrollController.payroll.isNotEmpty) {
                              final latestPayroll =
                                  payrollController.payroll.reduce((a, b) {
                                final dateA = DateTime.parse(
                                    a.dateOfPayment?.toString() ??
                                        '1970-01-01');
                                final dateB = DateTime.parse(
                                    b.dateOfPayment?.toString() ??
                                        '1970-01-01');
                                return dateA.isAfter(dateB) ? a : b;
                              });
                              return Text(
                                '${latestPayroll.totalSalary ?? "0"} / Monthly',
                                style: smallStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp),
                              );
                            }
                            return Text(
                              '0.00 / Monthly',
                              style: smallStyle.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 14.sp),
                            );
                          }),
                          const SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4),
                              child: Text(
                                'Fixed',
                                style: smallStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 14.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SSF Contribution',
                            style: smallStyle.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 14.sp),
                          ),
                          Text(
                            'Effective From: -',
                            style: smallStyle.copyWith(
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '0.00 / Monthly',
                            style: smallStyle.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 14.sp),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4),
                              child: Text(
                                'Percentage',
                                style: smallStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 14.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey.shade200,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SSF Contribution',
                  style: smallNStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0.sp,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SSF Contribution',
                            style: smallStyle.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 14.sp),
                          ),
                          Text(
                            'Effective From: -',
                            style: smallStyle.copyWith(
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '0.00 / Monthly',
                            style: smallStyle.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 14.sp),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4),
                              child: Text(
                                'Percentage',
                                style: smallStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 14.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey.shade200,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deduction, Loans and Advances',
                  style: smallNStyle.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.red),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SSF Deduction',
                            style: smallStyle.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 14.sp),
                          ),
                          Text(
                            'Effective From: -',
                            style: smallStyle.copyWith(
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '00.00 / Monthly',
                            style: smallStyle.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 14.sp),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4),
                              child: Text(
                                'Percentage',
                                style: smallStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 14.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WHT Leave Deduction',
                            style: smallStyle.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 14.sp),
                          ),
                          Text(
                            'Effective From: -',
                            style: smallStyle.copyWith(
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Obx(() {
                            if (payrollController.payroll.isNotEmpty) {
                              final latestPayroll =
                                  payrollController.payroll.reduce((a, b) {
                                final dateA = DateTime.parse(
                                    a.dateOfPayment?.toString() ??
                                        '1970-01-01');
                                final dateB = DateTime.parse(
                                    b.dateOfPayment?.toString() ??
                                        '1970-01-01');
                                return dateA.isAfter(dateB) ? a : b;
                              });
                              return Text(
                                '${latestPayroll.tax ?? "0.00"} / Monthly',
                                style: smallStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp),
                              );
                            }
                            return Text(
                              '00.00 / Monthly',
                              style: smallStyle.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 14.sp),
                            );
                          }),
                          const SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4),
                              child: Text(
                                'Variable',
                                style: smallStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 14.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
