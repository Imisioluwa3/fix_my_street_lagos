// import 'package:flutter/material.dart';
// import '../../../../core/constants/app_constants.dart';

// class SettingsSection extends StatelessWidget {
//   final String title;
//   final List<Widget> children;

//   const SettingsSection({
//     Key? key,
//     required this.title,
//     required this.children,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.only(left: AppConstants.paddingSmall),
//           child: Text(
//             title,
//             style: Theme.of(context).textTheme.titleMedium?.copyWith(
//               color: AppConstants.primaryGreen,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//         SizedBox(height: AppConstants.paddingSmall),
//         Card(
//           child: Column(
//             children: children,
//           ),
//         ),
//       ],
//     );
//   }
// }
