import 'package:ams/feature/presentation/widget/components/app_bar.dart';
import 'package:ams/feature/presentation/pages/timeoff/time_off_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AddTimeoff extends StatefulWidget {
  const AddTimeoff({super.key});

  @override
  _AddTimeoffState createState() => _AddTimeoffState();
}

class _AddTimeoffState extends State<AddTimeoff> {
  String? _selectedValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ConstantAppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TimeOffPage(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.arrow_back_sharp,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 15.0),
                      const Text(
                        'Add Time Off',
                        style: TextStyle(
                          fontFamily: 'Mukta',
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30.0),
                Column(
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Time Off Type  ',
                            style: TextStyle(
                              fontFamily: 'Mukta',
                              fontSize: 15.0,
                            ),
                          ),
                          const TextSpan(
                            text: '*',
                            style: TextStyle(
                              fontFamily: 'Mukta',
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13.0),
                    color: Colors.grey.shade50,
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      // right: 10.0,
                    ),
                    child: FormBuilderDropdown<String>(
                      onChanged: (value) {
                        setState(() {
                          _selectedValue = value;
                        });
                      },
                      name: 'leave',
                      hint: const Text(
                        'Select',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      decoration: const InputDecoration(
                        // labelText: 'Select',
                        border: InputBorder.none,
                      ),
                      items: [
                        'Sick Leave',
                        'Casual Leave',
                        'Annual Leave',
                      ]
                          .map((leave) => DropdownMenuItem(
                                value: leave,
                                child: Text(leave),
                              ))
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Column(
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Start Date  ',
                            style: TextStyle(
                              fontFamily: 'Mukta',
                              fontSize: 15.0,
                            ),
                          ),
                          const TextSpan(
                            text: '*',
                            style: TextStyle(
                              fontFamily: 'Mukta',
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13.0),
                    color: Colors.grey.shade50,
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                    ),
                    child: FormBuilderDateTimePicker(
                      name: 'start_date',
                      decoration: const InputDecoration(
                          icon: Icon(
                            Icons.calendar_month_outlined,
                            color: Colors.grey,
                          ),
                          hintText: 'Start Date',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          )),
                      inputType: InputType.date,
                      onChanged: (value) {
                        setState(() {});
                      },
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Column(
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'End Date  ',
                            style: TextStyle(
                              fontFamily: 'Mukta',
                              fontSize: 15.0,
                            ),
                          ),
                          const TextSpan(
                            text: '*',
                            style: TextStyle(
                              fontFamily: 'Mukta',
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13.0),
                    color: Colors.grey.shade50,
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                    ),
                    child: FormBuilderDateTimePicker(
                      name: 'end_date',
                      decoration: const InputDecoration(
                          icon: Icon(
                            Icons.calendar_month_outlined,
                            color: Colors.grey,
                          ),
                          hintText: 'End Date',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          )),
                      inputType: InputType.date,
                      onChanged: (value) {
                        setState(() {});
                      },
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Column(
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Reason  ',
                            style: TextStyle(
                              fontFamily: 'Mukta',
                              fontSize: 15.0,
                            ),
                          ),
                          const TextSpan(
                            text: '*',
                            style: TextStyle(
                              fontFamily: 'Mukta',
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Container(
                  height: 180.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13.0),
                    color: Colors.grey.shade50,
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      top: 16.0,
                    ),
                    child: TextField(
                      onChanged: (text) {
                        print('Text changed: $text');
                      },
                      maxLines: 8,
                      decoration: InputDecoration.collapsed(
                        hintText: "Write Your Reason",
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 105.0,
                        // right: 100.0,
                      ),
                      child: Container(
                        height: 45.0,
                        width: 120.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.transparent,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.sort,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              "Clear",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Mukta',
                                fontSize: 16.0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 15.0),
                    Container(
                      height: 45.0,
                      width: 120.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.black,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.save_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5.0),
                          Text(
                            "Save",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Mukta',
                              fontSize: 16.0,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
