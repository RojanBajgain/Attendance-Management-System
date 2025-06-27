// import 'package:ams/config/resources/colors.dart';
// import 'package:ams/config/resources/shimmer.dart';
// import 'package:ams/config/resources/styles.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// //
// class PrivacyPage extends StatelessWidget {
//   PrivacyPage({super.key});

//   // final controller = Get.put(AboutController(aboutrepo: Get.find()));

//   @override
//   Widget build(BuildContext context) {
//     controller.getaboutdata("2");

//     return Scaffold(
//       backgroundColor: AppColors.white,
//       appBar: AppBar(
//         backgroundColor: AppColors.white,
//         surfaceTintColor: Colors.transparent,
//         titleSpacing: 0,
//         title: Text(
//           "Privacy Policy",
//           style: smallStyle.copyWith(fontWeight: FontWeight.w700),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Obx(() {
//               if (controller.isloading.value) {
//                 return ListView.builder(
//                   itemCount: 5,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: ShrimmerEffect.rectangular(height: 100),
//                     );
//                   },
//                 );
//               } else {
//                 return ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: controller.aboutdata.length,
//                   itemBuilder: (context, index) {
//                     final data = controller.aboutdata[index];
//                     return Container(
//                       padding: EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           HtmlConverter(data: data.description ?? ''),
//                           SizedBox(height: 8),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               }
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }
