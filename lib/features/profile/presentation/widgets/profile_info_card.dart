// import 'package:flutter/material.dart';
// import '../../../../core/constants/app_constants.dart';

// class ProfileInfoCard extends StatelessWidget {
//   final String title;
//   final List<Widget> children;

//   const ProfileInfoCard({
//     Key? key,
//     required this.title,
//     required this.children,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: EdgeInsets.all(AppConstants.paddingMedium),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                 color: AppConstants.primaryGreen,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             SizedBox(height: AppConstants.paddingMedium),
//             ...children,
//           ],
//         ),
//       ),
//     );
//   }
// }
