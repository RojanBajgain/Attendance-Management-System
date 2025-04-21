import 'dart:typed_data';

import 'package:ams/config/resources/images.dart';
import 'package:ams/feature/presentation/pages/payroll/sub_view_payroll/payment_slip_view.dart';
import 'package:double_to_words/double_to_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

pw.Widget _buildPdfDetailRow(pw.Font font, String label, String value) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 3),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
              font: font, fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(font: font, fontSize: 12),
        ),
      ],
    ),
  );
}

pw.Widget _buildPdfAmountRow(pw.Font font, String label, String amount) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 3),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
              font: font, fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(
          amount,
          style: pw.TextStyle(font: font, fontSize: 12),
        ),
      ],
    ),
  );
}

Future<void> generateAndSavePDF(
    BuildContext context, dynamic payrollDetail) async {
  final pdf = pw.Document();

  // Add a standard font
  final font = await PdfGoogleFonts.nunitoRegular();
  final fontBold = await PdfGoogleFonts.nunitoBold();

  // Create company logo image
  final ByteData logoData = await rootBundle.load(AppImages.appLogo);
  final Uint8List logoBytes = logoData.buffer.asUint8List();
  final logo = pw.MemoryImage(logoBytes);

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Container(
          padding: const pw.EdgeInsets.all(20),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header with company name and logo
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Ayata Incorporation',
                        style: pw.TextStyle(font: fontBold, fontSize: 16),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'Anamnagar, Kathmandu',
                        style: pw.TextStyle(font: font, fontSize: 12),
                      ),
                    ],
                  ),
                  pw.Spacer(),
                  pw.Image(logo, width: 80, height: 80),
                ],
              ),

              pw.Divider(thickness: 0.5),

              // Pay Slip title
              pw.Center(
                child: pw.Text(
                  'Pay Slip',
                  style: pw.TextStyle(font: fontBold, fontSize: 18),
                ),
              ),
              pw.SizedBox(height: 10),

              // Date
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  "Date: ${payrollDetail.dateOfPayment != null ? DateFormat.yMMMd('en_US').format(payrollDetail.dateOfPayment!) : "---"}",
                  style: pw.TextStyle(font: font, fontSize: 12),
                ),
              ),
              pw.SizedBox(height: 5),

              // Pay Summary title
              pw.Text(
                'Pay Summary',
                style: pw.TextStyle(font: fontBold, fontSize: 14),
              ),
              pw.SizedBox(height: 10),

              // Payment details section
              _buildPdfDetailRow(
                  font, 'Employee Name :', payrollDetail.username.toString()),
              _buildPdfDetailRow(
                  font, 'Designation :', payrollDetail.designation.toString()),
              _buildPdfDetailRow(
                  font, 'Pay Period :', payrollDetail.payPeriod.toString()),
              _buildPdfDetailRow(
                  font,
                  'Pay Date :',
                  payrollDetail.dateOfPayment != null
                      ? DateFormat.yMd().format(payrollDetail.dateOfPayment!)
                      : "---"),
              _buildPdfDetailRow(font, 'Mode of Payment :',
                  payrollDetail.modeOfPayment.toString()),

              if (payrollDetail.chequeNo != null &&
                  payrollDetail.chequeNo!.isNotEmpty)
                _buildPdfDetailRow(
                    font, 'Cheque No :', payrollDetail.chequeNo!),

              if (payrollDetail.modeOfPayment != "Cash Payment") ...[
                _buildPdfDetailRow(
                    font,
                    'A/c Number :',
                    payrollDetail.bankAccountNumber != null
                        ? payrollDetail.bankAccountNumber!
                        : "---"),
                _buildPdfDetailRow(
                    font,
                    'A/c Name :',
                    payrollDetail.accountName != null
                        ? payrollDetail.accountName!
                        : "---"),
              ],

              _buildPdfDetailRow(
                  font,
                  'PAN Number :',
                  payrollDetail.panNumber != null
                      ? payrollDetail.panNumber!
                      : "---"),
              _buildPdfDetailRow(font, 'Tax Deduction :',
                  "Rs. ${payrollDetail.tax.toString()}"),

              pw.SizedBox(height: 10),
              pw.Divider(thickness: 0.5),
              pw.SizedBox(height: 10),

              // Earnings header
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                color: PdfColors.grey100,
                child: pw.Row(
                  children: [
                    pw.Text('Earning',
                        style: pw.TextStyle(font: fontBold, fontSize: 12)),
                    pw.Spacer(),
                    pw.Text('Grand Total',
                        style: pw.TextStyle(font: fontBold, fontSize: 12)),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              // Earnings details
              _buildPdfAmountRow(
                  font, 'Basic', "Rs. ${payrollDetail.totalSalary.toString()}"),
              _buildPdfAmountRow(font, 'Unpaid Leave Deduction',
                  "Rs. ${payrollDetail.unpaidDeduction.toString()}"),
              _buildPdfAmountRow(
                  font, 'Tax Deduction', "Rs. ${payrollDetail.tax.toString()}"),
              _buildPdfAmountRow(font, 'Reimbursement',
                  "Rs. ${payrollDetail.reimbursement.toString()}"),

              pw.SizedBox(height: 10),
              pw.Divider(thickness: 0.5),

              // Net salary
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Row(
                  children: [
                    pw.Text('Net Salary',
                        style: pw.TextStyle(font: fontBold, fontSize: 12)),
                    pw.Spacer(),
                    pw.Text("Rs. ${payrollDetail.netTotal.toString()}",
                        style: pw.TextStyle(font: fontBold, fontSize: 12)),
                  ],
                ),
              ),

              pw.SizedBox(height: 10),

              // Total in words
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                color: PdfColors.green50,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Total Net Payable Rs. ${payrollDetail.netTotal}',
                      style: pw.TextStyle(font: fontBold, fontSize: 12),
                    ),
                    pw.Text(
                      "(Rupees: ${capitalizeFirstLetter(DoubleToWords.convert(payrollDetail.netTotal.toDouble()))} only)",
                      style: pw.TextStyle(font: fontBold, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );

  try {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name:
          'payslip_${payrollDetail.username}_${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
    );

    // Show success message
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text('Pay slip generated successfully!')),
    // );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to generate PDF: $e')),
    );
  }
}
