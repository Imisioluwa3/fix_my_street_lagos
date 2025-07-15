// import 'package:flutter/material.dart';
// import '../../../../core/constants/app_constants.dart';

// class StatsCard extends StatelessWidget {
//   final String title;
//   final String value;
//   final IconData icon;
//   final Color color;

//   const StatsCard({
//     Key? key,
//     required this.title,
//     required this.value,
//     required this.icon,
//     required this.color,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: EdgeInsets.all(AppConstants.paddingMedium),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               icon,
//               size: 32,
//               color: color,
//             ),
//             SizedBox(height: AppConstants.paddingSmall),
//             Text(
//               value,
//               style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                 color: color,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 4),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                 color: AppConstants.textSecondary,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
