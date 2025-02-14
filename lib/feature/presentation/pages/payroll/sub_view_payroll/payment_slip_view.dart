import 'dart:developer';

import 'package:ams/config/resources/images.dart';
import 'package:ams/config/resources/shimmer.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/payroll/controller/payroll_controller.dart';
import 'package:ams/feature/presentation/pages/payroll/model/payroll_detail_model.dart';
import 'package:ams/feature/presentation/widget/components/app_bar.dart';
import 'package:double_to_words/double_to_words.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class PaymentSlip extends StatefulWidget {
  final String payrollId;

  const PaymentSlip({
    super.key,
    required this.payrollId,
  });

  @override
  State<PaymentSlip> createState() => _PaymentSlipState();
}

String capitalizeFirstLetter(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

class _PaymentSlipState extends State<PaymentSlip> {
  final PayrollController payrollcontroller =
      Get.put(PayrollController(payrollRepo: Get.find()));

  @override
  void initState() {
    super.initState();
    payrollcontroller.getPayrollDetailData(widget.payrollId);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const ConstantAppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ayata Incorporation',
                          style: smallStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          'Anamnagar, Kathmandu',
                          style: smallStyle.copyWith(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Image.asset(AppImages.appLogo),
                  ],
                ),
                const SizedBox(height: 10.0),
                const Divider(
                  thickness: 0.5,
                  color: Colors.grey,
                ),
                Center(
                  child: Text(
                    'Pay Slip',
                    style: normalStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 5.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Obx(() {
                      final payrollDate = payrollcontroller.payrollDetail.value;

                      return Text(
                        "Date: ${payrollDate.dateOfPayment != null ? DateFormat.yMMMd('en_US').format(payrollDate.dateOfPayment!) : "---"}",
                        style: smallStyle.copyWith(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      );
                    }),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Pay Summary',
                          style: normalStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                // Payment details section
                Obx(() {
                  if (payrollcontroller.isLoading.value) {
                    return const Center(
                      child: ShrimmerEffect.rectangular(height: 200),
                    );
                  }
                  final payroll = payrollcontroller.payrollDetail.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPaymentDetailRow(
                          'Employee Name :', payroll.username.toString()),
                      _buildPaymentDetailRow(
                          'Designation :', payroll.designation.toString()),
                      _buildPaymentDetailRow(
                          'Pay Period :', payroll.payPeriod.toString()),
                      _buildPaymentDetailRow(
                          'Pay Date :',
                          payroll.dateOfPayment != null
                              ? DateFormat.yMd().format(payroll.dateOfPayment!)
                              : "---"),
                      _buildPaymentDetailRow('Mode of Payment :',
                          payroll.modeOfPayment.toString()),
                      if (payroll.chequeNo != null &&
                          payroll.chequeNo!.isNotEmpty)
                        _buildPaymentDetailRow(
                            'Cheque No :', payroll.chequeNo!),
                      if (payroll.modeOfPayment != "Cash Payment") ...[
                        _buildPaymentDetailRow(
                            'A/c Number :',
                            payroll.bankAccountNumber != null
                                ? payroll.bankAccountNumber!
                                : "---"),
                        _buildPaymentDetailRow(
                            'A/c Name :',
                            payroll.accountName != null
                                ? payroll.accountName!
                                : "---"),
                      ],
                      _buildPaymentDetailRow(
                          'PAN Number :',
                          payroll.panNumber != null
                              ? payroll.panNumber!
                              : "---"),
                      _buildPaymentDetailRow(
                          'Tax Deduction :', "Rs. ${payroll.tax.toString()}"),
                    ],
                  );
                }),
                const SizedBox(height: 10.0),
                const Divider(
                  thickness: 0.5,
                  color: Colors.grey,
                ),
                const SizedBox(height: 10.0),
                Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey[100],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Earning',
                              style: smallStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Grand Total',
                              style: smallStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Obx(() {
                  if (payrollcontroller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final payrolldata = payrollcontroller.payrollDetail.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Basic',
                              style: smallStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "Rs. ${payrolldata.totalSalary.toString()}",
                              style: smallStyle.copyWith(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Unpaid Leave Deduction',
                                  style: smallStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "Rs. ${payrolldata.unpaidDeduction.toString()}",
                                  style: smallStyle.copyWith(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tax Deduction',
                                      style: smallStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "Rs. ${payrolldata.tax.toString()}",
                                      style: smallStyle.copyWith(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Reimbursement',
                                          style: smallStyle.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          "Rs. ${payrolldata.reimbursement.toString()}",
                                          style: smallStyle.copyWith(
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 10.0),
                const Divider(
                  thickness: 0.5,
                  color: Colors.grey,
                ),
                Obx(() {
                  if (payrollcontroller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final payrollData = payrollcontroller.payrollDetail.value;

                  return SizedBox(
                    height: 50.0,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Net Salary',
                                style: smallStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "Rs. ${payrollData.netTotal.toString()}",
                                style: smallStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 10.0),
                Obx(() {
                  final payrollTotal = payrollcontroller.payrollDetail.value;

                  return Container(
                    height: 90.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.green[50],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 14.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Net Payable Rs. ${payrollTotal.netTotal}',
                                style: smallStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "(Rupees: ${capitalizeFirstLetter(DoubleToWords.convert(
                                        payrollTotal.netTotal.toDouble(),
                                      ))} only)",
                                      style: smallStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 10.0),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: isDarkMode
                          ? MaterialStateProperty.all(Colors.white)
                          : MaterialStateProperty.all(Colors.blue),
                      foregroundColor: isDarkMode
                          ? MaterialStateProperty.all(Colors.black)
                          : MaterialStateProperty.all(Colors.white),
                    ),
                    onPressed: () {
                      // final payrollDetail =
                      //     payrollcontroller.payrollDetail.value;
                      // generateAndSavePDF(context, payrollDetail);
                    },
                    child: Text(
                      'Download',
                      style: smallStyle.copyWith(
                        color: isDarkMode ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
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

  Widget _buildPaymentDetailRow(String label, String value) {
    return Builder(builder: (context) {
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;

      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              label,
              style: smallStyle.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const Spacer(),
            Text(
              // textDirection: TextDirection.ltr,
              value,
              style: smallStyle.copyWith(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      );
    });
  }
}

/* Future<void> generateAndSavePDF(
    BuildContext context, PayrollDetailModel payrollDetail) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Ayata Incorporation',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Anamnagar, Kathmandu'),
            pw.Divider(),
            pw.Center(
                child: pw.Text('Pay Slip',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
            pw.SizedBox(height: 10),

            pw.Text('Employee Name: ${payrollDetail.username ?? "---"}'),
            pw.Text('Designation: ${payrollDetail.designation ?? "---"}'),
            pw.Text('Pay Period: ${payrollDetail.payPeriod ?? "---"}'),
            pw.Text(
                'Pay Date: ${payrollDetail.dateOfPayment != null ? DateFormat.yMd().format(payrollDetail.dateOfPayment!) : "---"}'),
            pw.Text('Mode of Payment: ${payrollDetail.modeOfPayment ?? "---"}'),

            // ✅ Show cheque number ONLY if provided
            if (payrollDetail.chequeNo != null &&
                payrollDetail.chequeNo!.isNotEmpty)
              pw.Text('Cheque No: ${payrollDetail.chequeNo}'),

            // ✅ Show bank details only for non-cash payments
            if (payrollDetail.modeOfPayment != "Cash Payment") ...[
              pw.Text(
                  'A/c Number: ${payrollDetail.bankAccountNumber ?? "---"}'),
              pw.Text(
                  'A/c Name: ${payrollDetail.username ?? "---"}'), // Using username as placeholder
            ],

            pw.Text('PAN Number: ${payrollDetail.panNumber ?? "---"}'),
            pw.Text('Tax Deduction: Rs. ${payrollDetail.tax}'),
            pw.SizedBox(height: 10),
            pw.Divider(),

            pw.Text('Earning',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Basic: Rs. ${payrollDetail.totalSalary ?? "0.00"}'),
            pw.Text(
                'Unpaid Leave Deduction: Rs. ${payrollDetail.unpaidDeduction ?? "0.00"}'),
            pw.Text('Tax Deduction: Rs. ${payrollDetail.tax}'),
            pw.Text(
                'Reimbursement: Rs. ${payrollDetail.reimbursement ?? "0.00"}'),

            pw.SizedBox(height: 10),
            pw.Divider(),

            pw.Text('Net Salary: Rs. ${payrollDetail.netTotal}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text('Total Net Payable Rs. ${payrollDetail.netTotal}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

            // ✅ Fix capitalization of the amount in words
            pw.Text(
                '(Rupees: ${capitalizeFirstLetter(DoubleToWords.convert(payrollDetail.netTotal.toDouble()))} only)'),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );

  // Save/share the PDF
  await Printing.sharePdf(
    bytes: await pdf.save(),
    filename: 'payroll-${payrollDetail.dateOfPayment}.pdf',
  );
}
 */
