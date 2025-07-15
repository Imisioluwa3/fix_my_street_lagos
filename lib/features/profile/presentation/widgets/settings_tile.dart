// import 'package:flutter/material.dart';
// import '../../../../core/constants/app_constants.dart';

// class SettingsTile extends StatelessWidget {
//   final Widget leading;
//   final String title;
//   final String? subtitle;
//   final Widget? trailing;
//   final VoidCallback? onTap;
//   final Color? titleColor;

//   const SettingsTile({
//     Key? key,
//     required this.leading,
//     required this.title,
//     this.subtitle,
//     this.trailing,
//     this.onTap,
//     this.titleColor,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: leading,
//       title: Text(
//         title,
//         style: TextStyle(
//           color: titleColor,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       subtitle: subtitle != null ? Text(subtitle!) : null,
//       trailing: trailing ?? (onTap != null ? Icon(Icons.chevron_right) : null),
//       onTap: onTap,
//       contentPadding: EdgeInsets.symmetric(
//         horizontal: AppConstants.paddingMedium,
//         vertical: AppConstants.paddingSmall,
//       ),
//     );
//   }
// }
