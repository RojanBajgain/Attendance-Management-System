import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/payroll/sub_view_payroll/payment_slip_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PayRollSlip extends StatefulWidget {
  final String dop;
  final String mop;
  final String bank;
  final String cheque;
  final String salary;

  const PayRollSlip({
    super.key,
    required this.dop,
    required this.mop,
    required this.bank,
    required this.cheque,
    required this.salary,
  });

  @override
  State<PayRollSlip> createState() => _PayRollSlipState();
}

class _PayRollSlipState extends State<PayRollSlip> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Get.to(
          () => const PaymentSlip(),
          transition: Transition.rightToLeft,
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
            begin: const Alignment(-1.0, -1.0),
            end: const Alignment(-1.0, 1.0),
            colors: [
              isDarkMode ? Colors.grey.shade700 : Colors.black,
              isDarkMode ? Colors.grey.shade700 : Colors.black,
              isDarkMode ? Colors.black : Colors.white,
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
            top: 20.0,
            left: 15.0,
            right: 15.0,
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Date of Payment',
                    style: smallStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(width: 80.0),
                  Text(
                    'Mode of Payment',
                    style: smallStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    widget.dop,
                    style: smallStyle.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 120.0),
                  Text(
                    widget.mop,
                    style: smallStyle.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bank',
                        style: smallStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        widget.bank,
                        style: smallStyle.copyWith(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cheque no.',
                        style: smallStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        widget.cheque,
                        style: smallStyle.copyWith(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Salary',
                        style: smallStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        widget.salary,
                        style: smallStyle.copyWith(
                          color: isDarkMode ? Colors.white : Colors.black,
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
