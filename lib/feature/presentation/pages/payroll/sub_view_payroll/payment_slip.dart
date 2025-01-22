import 'package:ams/feature/presentation/widget/components/app_bar.dart';
import 'package:flutter/material.dart';

class PaymentSlip extends StatelessWidget {
  const PaymentSlip({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Mutka',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          'Anamnagar, Kathmandu',
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Mutka',
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Image.asset(
                      'assets/images/logo.png',
                    ),
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
                    style: TextStyle(
                      fontFamily: 'Mutka',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Date: 2/20/2024',
                      style: TextStyle(
                        fontFamily: 'Mutka',
                        fontSize: 16.0,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Pay Summary',
                          style: TextStyle(
                            fontFamily: 'Mutka',
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                // Payment details section
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPaymentDetailRow('Employee Name', 'Kripa Thapa'),
                      _buildPaymentDetailRow('Designation', 'React Developer'),
                      _buildPaymentDetailRow('Pay Period', 'January 2024'),
                      _buildPaymentDetailRow('Pay Date', '2/20/2024'),
                      _buildPaymentDetailRow(
                          'A/c Number', '123456789015151511'),
                      _buildPaymentDetailRow('A/c Name', 'Kripa Thapa'),
                      _buildPaymentDetailRow('PAN Number', 'P123456789'),
                      _buildPaymentDetailRow('Tax Deduction', '-'),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                const Divider(
                  thickness: 0.5,
                  color: Colors.grey,
                ),
                SizedBox(height: 10.0),
                Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.black),
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
                              style: TextStyle(
                                fontFamily: 'Mutka',
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'Grand Total',
                              style: TextStyle(
                                fontFamily: 'Mutka',
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Basic',
                              style: TextStyle(
                                fontFamily: 'Mutka',
                                fontSize: 15.0,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'Rs. 5,000',
                              style: TextStyle(
                                fontFamily: 'Mutka',
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Unpaid Leave Deduction',
                                  style: TextStyle(
                                    fontFamily: 'Mutka',
                                    fontSize: 15.0,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  'Rs. 500',
                                  style: TextStyle(
                                    fontFamily: 'Mutka',
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tax Deduction',
                                      style: TextStyle(
                                        fontFamily: 'Mutka',
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      'Rs. 0',
                                      style: TextStyle(
                                        fontFamily: 'Mutka',
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Reimbursement',
                                          style: TextStyle(
                                            fontFamily: 'Mutka',
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          'Rs. 200',
                                          style: TextStyle(
                                            fontFamily: 'Mutka',
                                            fontSize: 15.0,
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
                  ),
                ),
                const SizedBox(height: 10.0),
                const Divider(
                  thickness: 0.5,
                  color: Colors.grey,
                ),
                // SizedBox(height: 5.0),
                Container(
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
                              style: TextStyle(
                                fontFamily: 'Mutka',
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'Rs. 4,700',
                              style: TextStyle(
                                fontFamily: 'Mutka',
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  height: 70.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.black),
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
                              'Total Net Payable Rs. 4,600.00',
                              style: TextStyle(
                                fontFamily: 'Mutka',
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '(Rupees: Four thousand six hundred only)',
                                  style: TextStyle(
                                    fontFamily: 'Mutka',
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      // shape: MaterialStateProperty.all(
                      //   const BeveledRectangleBorder(
                      //     borderRadius: BorderRadius.all(
                      //       Radius.circular(3),
                      //     ),
                      //   ),
                      // ),
                    ),
                    onPressed: () {},
                    child: Text('Download'),
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
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              fontFamily: 'Mutka',
            ),
          ),
          Spacer(),
          Text(
            textDirection: TextDirection.ltr,
            value,
            style: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Mutka',
              fontWeight: FontWeight.w400,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
