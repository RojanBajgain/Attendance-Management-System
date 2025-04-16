import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/payroll/model/payroll_model.dart';
import 'package:ams/feature/presentation/pages/payroll/sub_view_payroll/payment_slip_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PayRollSlip extends StatelessWidget {
  final Datum payrolldata;
  void Function()? onTap;
  final String dop;
  final String mop;
  final String bank;
  final String cheque;
  final String salary;

  PayRollSlip({
    super.key,
    required this.payrolldata,
    this.onTap,
    required this.dop,
    required this.mop,
    required this.bank,
    required this.cheque,
    required this.salary,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        Get.to(
          () => PaymentSlip(
            payrollId: payrolldata.id.toString(),
          ),
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
              offset: const Offset(0, 1),
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
                  Spacer(),
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
                    dop,
                    style: smallStyle.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  Spacer(),
                  Text(
                    mop,
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
                  Expanded(
                    child: Column(
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
                          bank,
                          style: smallStyle.copyWith(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 30.0),
                  Expanded(
                    child: Column(
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
                          cheque,
                          style: smallStyle.copyWith(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 30.0),
                  Expanded(
                    child: Column(
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
                          salary,
                          style: smallStyle.copyWith(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
