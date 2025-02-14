// import 'package:ams/feature/presentation/pages/timesheet/controller/timesheet_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';

// class ReuseTimeSheet extends StatefulWidget {
//   final String timesheetId;

//   const ReuseTimeSheet({
//     super.key,
//     required this.timesheetId,
//   });

//   @override
//   State<ReuseTimeSheet> createState() => _ReuseTimeSheetState();
// }

// class _ReuseTimeSheetState extends State<ReuseTimeSheet> {
//   final TimesheetController timesheetcontroller =
//       Get.put(TimesheetController(timesheetRepo: Get.find()));

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 265.0,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(30.0),
//         // color: Colors.grey.shade50,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             // blurRadius: 5,
//             spreadRadius: 2,
//             offset: const Offset(0, 5), // vertical offset
//           ),
//         ],
//       ),
//       child: const Padding(
//         padding: EdgeInsets.only(
//           left: 25.0,
//           top: 15.0,
//           right: 20.0,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Date',
//                   style: TextStyle(
//                     fontFamily: 'Mukta',
//                     fontWeight: FontWeight.w600,
//                     fontSize: 15.0,
//                   ),
//                 ),
//                 Text(
//                   '02/16/2024',
//                   style: TextStyle(
//                     fontFamily: 'Mukta',
//                     fontWeight: FontWeight.w400,
//                     fontSize: 15.0,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Entry Time',
//                   style: TextStyle(
//                     fontFamily: 'Mukta',
//                     fontWeight: FontWeight.w600,
//                     fontSize: 15.0,
//                   ),
//                 ),
//                 Text(
//                   '10:15:02 AM',
//                   style: TextStyle(
//                     fontFamily: 'Mukta',
//                     fontWeight: FontWeight.w400,
//                     fontSize: 15.0,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Exit Time',
//                   style: TextStyle(
//                     fontFamily: 'Mukta',
//                     fontWeight: FontWeight.w600,
//                     fontSize: 15.0,
//                   ),
//                 ),
//                 Text(
//                   '06:45:02 AM',
//                   style: TextStyle(
//                     fontFamily: 'Mukta',
//                     fontWeight: FontWeight.w400,
//                     fontSize: 15.0,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Entry Remarks',
//                   style: TextStyle(
//                     fontFamily: 'Mukta',
//                     fontWeight: FontWeight.w600,
//                     fontSize: 15.0,
//                   ),
//                 ),
//                 Text(
//                   'On Time',
//                   style: TextStyle(
//                     fontFamily: 'Mukta',
//                     fontWeight: FontWeight.w400,
//                     fontSize: 15.0,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Exit Remarks',
//                   style: TextStyle(
//                     fontFamily: 'Mukta',
//                     fontWeight: FontWeight.w600,
//                     fontSize: 15.0,
//                   ),
//                 ),
//                 Text(
//                   'Late',
//                   style: TextStyle(
//                     fontFamily: 'Mukta',
//                     fontWeight: FontWeight.w400,
//                     fontSize: 15.0,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Shift',
//                   style: TextStyle(
//                     fontFamily: 'Mukta',
//                     fontWeight: FontWeight.w600,
//                     fontSize: 15.0,
//                   ),
//                 ),
//                 Text(
//                   'Day',
//                   style: TextStyle(
//                     fontFamily: 'Mukta',
//                     fontWeight: FontWeight.w400,
//                     fontSize: 15.0,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Total Hour',
//                   style: TextStyle(
//                     fontFamily: 'Mukta',
//                     fontWeight: FontWeight.w600,
//                     fontSize: 15.0,
//                   ),
//                 ),
//                 Text(
//                   '8 Hrs',
//                   style: TextStyle(
//                     fontFamily: 'Mukta',
//                     fontWeight: FontWeight.w400,
//                     fontSize: 15.0,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Overtime',
//                   style: TextStyle(
//                     fontFamily: 'Mukta',
//                     fontWeight: FontWeight.w600,
//                     fontSize: 15.0,
//                   ),
//                 ),
//                 Text(
//                   '2 Hrs',
//                   style: TextStyle(
//                     fontFamily: 'Mukta',
//                     fontWeight: FontWeight.w400,
//                     fontSize: 15.0,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
