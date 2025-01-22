import 'package:ams/feature/presentation/widget/components/app_bar.dart';
import 'package:ams/feature/presentation/pages/payroll/sub_view_payroll/payment_slip.dart';
import 'package:ams/feature/presentation/pages/timesheet/sub_view_timesheet/timesheet_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PayrollPage extends StatelessWidget {
  const PayrollPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ConstantAppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Pay Roll",
                      style: TextStyle(
                        fontFamily: 'Mukta',
                        fontSize: 23.0,
                        fontWeight: FontWeight.bold,
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
                PayRollSlip(
                  DOP: 'Jan 5, 2024',
                  MOP: 'Cheque',
                  Bank: 'NMB BANK',
                  Cheque: '25458687',
                  Salary: 'Rs. 30,000',
                ),
                const SizedBox(height: 20.0),
                PayRollSlip(
                  DOP: 'Dec 5, 2023',
                  MOP: 'Bank',
                  Bank: 'NMB BANK',
                  Cheque: '-',
                  Salary: 'Rs. 40,000',
                ),
                const SizedBox(height: 20.0),
                PayRollSlip(
                  DOP: 'Nov 5, 2024',
                  MOP: 'Cheque',
                  Bank: 'NMB BANK',
                  Cheque: '25664478',
                  Salary: 'Rs. 25,000',
                ),
                const SizedBox(height: 20.0),
                PayRollSlip(
                  DOP: 'Jan 5, 2024',
                  MOP: 'Bank',
                  Bank: 'NMB BANK',
                  Cheque: '-',
                  Salary: 'Rs. 22,000',
                ),
                const SizedBox(height: 20.0),
                PayRollSlip(
                  DOP: 'Jan 5, 2024',
                  MOP: 'Cash',
                  Bank: 'NMB BANK',
                  Cheque: '-',
                  Salary: 'Rs. 5,000',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PayRollSlip extends StatefulWidget {
  final String DOP;
  final String MOP;
  final String Bank;
  final String Cheque;
  final String Salary;

  const PayRollSlip({
    super.key,
    required this.DOP,
    required this.MOP,
    required this.Bank,
    required this.Cheque,
    required this.Salary,
  });

  @override
  State<PayRollSlip> createState() => _PayRollSlipState();
}

class _PayRollSlipState extends State<PayRollSlip> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentSlip(),
          ),
        );
      },
      child: Container(
        height: 150.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment(-1.0, -1.0),
            end: Alignment(-1.0, 1.0),
            colors: [
              Colors.black,
              Colors.black,
              Colors.grey.shade200,
            ],
            stops: const [
              0.0,
              0.08,
              0.0,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 15.0,
            left: 15.0,
            right: 15.0,
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text(
                    'Date of Payment',
                    style: TextStyle(
                      fontFamily: 'Mukta',
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0,
                    ),
                  ),
                  SizedBox(width: 80.0),
                  Text(
                    'Mode of Payment',
                    style: TextStyle(
                      fontFamily: 'Mukta',
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 5.0),
              Row(
                children: [
                  Text(
                    widget.DOP,
                    style: const TextStyle(
                      fontFamily: 'Mukta',
                      fontWeight: FontWeight.w600,
                      fontSize: 15.0,
                    ),
                  ),
                  const SizedBox(width: 120.0),
                  Text(
                    widget.MOP,
                    style: const TextStyle(
                      fontFamily: 'Mukta',
                      fontWeight: FontWeight.w600,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Optional: for spacing
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bank',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      Text(
                        widget.Bank,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Mukta',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cheque no.',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      Text(
                        widget.Cheque,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Mukta',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Salary',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      Text(
                        widget.Salary,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Mukta',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
