import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateTimeWidget extends StatefulWidget {
  const DateTimeWidget({super.key});

  @override
  State<DateTimeWidget> createState() => _DateTimeWidgetState();
}

class _DateTimeWidgetState extends State<DateTimeWidget> {
  DateTime _focusDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return EasyDateTimeLine(
        initialDate: DateTime.now(),
        onDateChange: (selectedDate) {
          setState(() {
            _focusDate = selectedDate;
          });
        },
        headerProps: const EasyHeaderProps(
            // monthPickerType: MonthPickerType.switcher,
            // dateFormatter: DateFormatter.fullDateDMY(),
            ),
        dayProps: EasyDayProps(
          dayStructure: DayStructure.dayStrDayNum,
          activeDayStyle: DayStyle(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  isDarkMode ? Colors.white : Color(0xFF131213),
                  isDarkMode ? Colors.black : Colors.white,
                ],
              ),
            ),
          ),
          inactiveDayStyle: DayStyle(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: isDarkMode ? Colors.grey.shade300 : Colors.white,
            ),
          ),
        ));
  }
}
