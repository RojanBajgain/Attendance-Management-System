import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/payroll/sub_view_payroll/payroll_slip_view.dart';
import 'package:ams/feature/presentation/widget/components/app_bar.dart';
import 'package:ams/feature/presentation/pages/payroll/sub_view_payroll/payment_slip_view.dart';
import 'package:flutter/material.dart';

class PayrollPage extends StatefulWidget {
  const PayrollPage({super.key});

  @override
  State<PayrollPage> createState() => _PayrollPageState();
}

class _PayrollPageState extends State<PayrollPage> {
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
                        height: 45.0,
                        width: 45.0,
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
                const PayRollSlip(
                  dop: 'Jan 5, 2024',
                  mop: 'Cheque',
                  bank: 'NMB BANK',
                  cheque: '25458687',
                  salary: 'Rs. 30,000',
                ),
                // const SizedBox(height: 20.0),
                // PayRollSlip(
                //   DOP: 'Dec 5, 2023',
                //   MOP: 'Bank',
                //   Bank: 'NMB BANK',
                //   Cheque: '-',
                //   Salary: 'Rs. 40,000',
                // ),
                // const SizedBox(height: 20.0),
                // PayRollSlip(
                //   DOP: 'Nov 5, 2024',
                //   MOP: 'Cheque',
                //   Bank: 'NMB BANK',
                //   Cheque: '25664478',
                //   Salary: 'Rs. 25,000',
                // ),
                // const SizedBox(height: 20.0),
                // PayRollSlip(
                //   DOP: 'Jan 5, 2024',
                //   MOP: 'Bank',
                //   Bank: 'NMB BANK',
                //   Cheque: '-',
                //   Salary: 'Rs. 22,000',
                // ),
                // const SizedBox(height: 20.0),
                // PayRollSlip(
                //   DOP: 'Jan 5, 2024',
                //   MOP: 'Cash',
                //   Bank: 'NMB BANK',
                //   Cheque: '-',
                //   Salary: 'Rs. 5,000',
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
