// import 'package:flutter/material.dart';
// import 'package:runmate_app/presentation/home/home_page.dart';
// import 'package:runmate_app/shared/themes/app_colors.dart';
// import 'package:runmate_app/shared/themes/app_fonts.dart';

// class ChallangeCard extends StatelessWidget {
//   final ChallangeModel challange;

//   const ChallangeCard({super.key, required this.challange});

//   @override
//   Widget build(BuildContext context) {
//     final double progress =
//         (challange.achivedKm / challange.totalKm).clamp(0.0, 1.0);

//     return Container(
//       width: 160,
//       margin: const EdgeInsets.only(right: 12),
//       padding: const EdgeInsets.all(10.0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12.0),
//         color: AppColors.gray42,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             challange.groupName,
//             style: const TextStyle(
//               color: Colors.lightGreenAccent,
//               fontSize: 16.0,
//               fontFamily: AppFonts.poppinsMedium,
//             ),
//           ),
//           const Divider(color: Colors.white24),
//           Text(
//             '${challange.userPosition}º lugar',
//             style: const TextStyle(color: Colors.lightGreenAccent),
//           ),
//           Text(
//             '${challange.membersNumber} participantes',
//             style: const TextStyle(color: Colors.white),
//           ),
//           const SizedBox(height: 8.0),
//           LinearProgressIndicator(
//             value: progress,
//             backgroundColor: AppColors.gray300.withOpacity(0.3),
//             valueColor: const AlwaysStoppedAnimation<Color>(AppColors.green200),
//             minHeight: 6,
//           ),
//           const SizedBox(height: 4),
//           Text(
//             '${challange.achivedKm.toStringAsFixed(1)} km de ${challange.totalKm.toStringAsFixed(1)} km',
//             style: const TextStyle(color: Colors.white70, fontSize: 12),
//           ),
//         ],
//       ),
//     );
//   }
// }
