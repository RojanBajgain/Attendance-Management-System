import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/payroll/sub_view_payroll/leaves_view.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileTabView extends StatelessWidget {
  const ProfileTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),

              //Leave Header

              Text(
                'Leaves',
                style: smallNStyle.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 16.sp),
              ),
              const SizedBox(height: 5),
              //Leaves body

              LeaveView(),
              const SizedBox(height: 20),

              const MonthlyRegularIncome(),

              const SizedBox(
                height: 30,
              ),

              const SizedBox(
                height: 5,
              ),
              const Deductions(),

              const SizedBox(
                height: 20,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class MonthlyRegularIncome extends StatelessWidget {
  const MonthlyRegularIncome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            offset: const Offset(0, 3), // changes position of shadow
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
                  offset: const Offset(0, 3), // changes position of shadow
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
                    Text(
                      '20000.00 / Monthly',
                      style: smallStyle.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 14.sp),
                    ),
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
                  offset: const Offset(0, 3), // changes position of shadow
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
                      '20000.00 / Monthly',
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
    );
  }
}

class Deductions extends StatelessWidget {
  const Deductions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            offset: const Offset(0, 3), // changes position of shadow
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
                  offset: const Offset(0, 3), // changes position of shadow
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
                  offset: const Offset(0, 3), // changes position of shadow
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
                    Text(
                      '00.00 / Monthly',
                      style: smallStyle.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 14.sp),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4),
                        child: Text(
                          'Varaiable',
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
    );
  }
}
