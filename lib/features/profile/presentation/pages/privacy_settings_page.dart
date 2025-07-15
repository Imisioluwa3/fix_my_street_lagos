// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../core/constants/app_constants.dart';
// import '../../../../core/localization/app_localizations.dart';
// import '../../../../shared/widgets/settings_section.dart';
// import '../../../../shared/widgets/settings_tile.dart';
// import '../bloc/privacy_bloc.dart';

// class PrivacySettingsPage extends StatefulWidget {
//   @override
//   _PrivacySettingsPageState createState() => _PrivacySettingsPageState();
// }

// class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<PrivacyBloc>().add(LoadPrivacySettingsEvent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(l10n.privacySettings),
//       ),
//       body: BlocListener<PrivacyBloc, PrivacyState>(
//         listener: (context, state) {
//           if (state is PrivacySettingsUpdatedState) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('Privacy settings updated'),
//                 backgroundColor: AppConstants.successGreen,
//               ),
//             );
//           } else if (state is PrivacyErrorState) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: AppConstants.errorRed,
//               ),
//             );
//           }
//         },
//         child: BlocBuilder<PrivacyBloc, PrivacyState>(
//           builder: (context, state) {
//             if (state is PrivacyLoadingState) {
//               return Center(child: CircularProgressIndicator());
//             } else if (state is PrivacySettingsLoadedState) {
//               return _buildPrivacySettings(context, state.settings, l10n);
//             } else if (state is PrivacyErrorState) {
//               return _buildErrorState(context, state.message, l10n);
//             }
            
//             return Container();
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildPrivacySettings(BuildContext context, Map<String, dynamic> settings, AppLocalizations l10n) {
//     return ListView(
//       padding: EdgeInsets.all(AppConstants.paddingMedium),
//       children: [
//         // Data Collection & Usage
//         SettingsSection(
//           title: 'Data Collection & Usage',
//           children: [
//             SettingsTile(
//               leading: Icon(Icons.analytics, color: AppConstants.primaryGreen),
//               title: l10n.analyticsTracking,
//               subtitle: 'Help improve the app with usage analytics',
//               trailing: Switch(
//                 value: settings['analyticsTracking'] ?? true,
//                 onChanged: (value) {
//                   _updatePrivacySetting('analyticsTracking', value);
//                 },
//                 activeColor: AppConstants.primaryGreen,
//               ),
//             ),
//             SettingsTile(
//               leading: Icon(Icons.bug_report, color: AppConstants.primaryGreen),
//               title: 'Crash Reporting',
//               subtitle: 'Automatically send crash reports to help fix bugs',
//               trailing: Switch(
//                 value: settings['crashReporting'] ?? true,
//                 onChanged: (value) {
//                   _updatePrivacySetting('crashReporting', value);
//                 },
//                 activeColor: AppConstants.primaryGreen,
//               ),
//             ),
//             SettingsTile(
//               leading: Icon(Icons.speed, color: AppConstants.primaryGreen),
//               title: 'Performance Monitoring',
//               subtitle: 'Monitor app performance to improve user experience',
//               trailing: Switch(
//                 value: settings['performanceMonitoring'] ?? true,
//                 onChanged: (value) {
//                   _updatePrivacySetting('performanceMonitoring', value);
//                 },
//                 activeColor: AppConstants.primaryGreen,
//               ),
//             ),
//           ],
//         ),
        
//         SizedBox(height: AppConstants.paddingLarge),
        
//         // Location & Maps
//         SettingsSection(
//           title: 'Location & Maps',
//           children: [
//             SettingsTile(
//               leading: Icon(Icons.location_on, color: AppConstants.primaryGreen),
//               title: l10n.locationAccess,
//               subtitle: 'Allow app to access your location for reporting',
//               trailing: Switch(
//                 value: settings['locationAccess'] ?? true,
//                 onChanged: (value) {
//                   _updatePrivacySetting('locationAccess', value);
//                 },
//                 activeColor: AppConstants.primaryGreen,
//               ),
//             ),
//             SettingsTile(
//               leading: Icon(Icons.history, color: AppConstants.primaryGreen),
//               title: 'Location History',
//               subtitle: 'Store location history for better recommendations',
//               trailing: Switch(
//                 value: settings['locationHistory'] ?? false,
//                 onChanged: (value) {
//                   _updatePrivacySetting('locationHistory', value);
//                 },
//                 activeColor: AppConstants.primaryGreen,
//               ),
//             ),
//             SettingsTile(
//               leading: Icon(Icons.map, color: AppConstants.primaryGreen),
//               title: 'Precise Location',
//               subtitle: 'Use GPS for more accurate location reporting',
//               trailing: Switch(
//                 value: settings['preciseLocation'] ?? true,
//                 onChanged: (value) {
//                   _updatePrivacySetting('preciseLocation', value);
//                 },
//                 activeColor: AppConstants.primaryGreen,
//               ),
//             ),
//           ],
//         ),
        
//         SizedBox(height: AppConstants.paddingLarge),
        
//         // Profile & Social
//         SettingsSection(
//           title: 'Profile & Social',
//           children: [
//             SettingsTile(
//               leading: Icon(Icons.visibility, color: AppConstants.primaryGreen),
//               title: l10n.profileVisibility,
//               subtitle: _getProfileVisibilitySubtitle(settings['profileVisibility']),
//               onTap: () => _showProfileVisibilityDialog(context, settings['profileVisibility']),
//             ),
//             SettingsTile(
//               leading: Icon(Icons.share, color: AppConstants.primaryGreen),
//               title: 'Report Sharing',
//               subtitle: 'Allow others to see your public reports',
//               trailing: Switch(
//                 value: settings['reportSharing'] ?? true,
//                 onChanged: (value) {
//                   _updatePrivacySetting('reportSharing', value);
//                 },
//                 activeColor: AppConstants.primaryGreen,
//               ),
//             ),
//             SettingsTile(
//               leading: Icon(Icons.comment, color: AppConstants.primaryGreen),
//               title: 'Comments & Interactions',
//               subtitle: 'Allow others to comment on your reports',
//               trailing: Switch(
//                 value: settings['allowComments'] ?? true,
//                 onChanged: (value) {
//                   _updatePrivacySetting('allowComments', value);
//                 },
//                 activeColor: AppConstants.primaryGreen,
//               ),
//             ),
//           ],
//         ),
        
//         SizedBox(height: AppConstants.paddingLarge),
        
//         // Communications
//         SettingsSection(
//           title: 'Communications',
//           children: [
//             SettingsTile(
//               leading: Icon(Icons.email, color: AppConstants.primaryGreen),
//               title: l10n.marketingCommunications,
//               subtitle: 'Receive updates about new features and improvements',
//               trailing: Switch(
//                 value: settings['marketingEmails'] ?? false,
//                 onChanged: (value) {
//                   _updatePrivacySetting('marketingEmails', value);
//                 },
//                 activeColor: AppConstants.primaryGreen,
//               ),
//             ),
//             SettingsTile(
//               leading: Icon(Icons.campaign, color: AppConstants.primaryGreen),
//               title: 'Promotional Notifications',
//               subtitle: 'Receive promotional push notifications',
//               trailing: Switch(
//                 value: settings['promotionalNotifications'] ?? false,
//                 onChanged: (value) {
//                   _updatePrivacySetting('promotionalNotifications', value);
//                 },
//                 activeColor: AppConstants.primaryGreen,
//               ),
//             ),
//             SettingsTile(
//               leading: Icon(Icons.poll, color: AppConstants.primaryGreen),
//               title: 'Surveys & Feedback',
//               subtitle: 'Participate in surveys to improve the app',
//               trailing: Switch(
//                 value: settings['surveysAndFeedback'] ?? true,
//                 onChanged: (value) {
//                   _updatePrivacySetting('surveysAndFeedback', value);
//                 },
//                 activeColor: AppConstants.primaryGreen,
//               ),
//             ),
//           ],
//         ),
        
//         SizedBox(height: AppConstants.paddingLarge),
        
//         // Data Management
//         SettingsSection(
//           title: 'Data Management',
//           children: [
//             SettingsTile(
//               leading: Icon(Icons.download, color: AppConstants.primaryGreen),
//               title: 'Download My Data',
//               subtitle: 'Get a copy of your data',
//               onTap: () => _requestDataDownload(context),
//             ),
//             SettingsTile(
//               leading: Icon(Icons.delete_sweep, color: AppConstants.warningAmber),
//               title: 'Clear Activity Data',
//               subtitle: 'Remove stored activity and usage data',
//               titleColor: AppConstants.warningAmber,
//               onTap: () => _showClearDataDialog(context),
//             ),
//             SettingsTile(
//               leading: Icon(Icons.block, color: AppConstants.errorRed),
//               title: 'Deactivate Account',
//               subtitle: 'Temporarily deactivate your account',
//               titleColor: AppConstants.errorRed,
//               onTap: () => _showDeactivateAccountDialog(context),
//             ),
//           ],
//         ),
        
//         SizedBox(height: AppConstants.paddingLarge),
        
//         // Legal & Compliance
//         Card(
//           child: Padding(
//             padding: EdgeInsets.all(AppConstants.paddingMedium),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Legal & Compliance',
//                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     color: AppConstants.primaryGreen,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 SizedBox(height: AppConstants.paddingMedium),
//                 Text(
//                   'Your privacy is important to us. We collect and use your data in accordance with our Privacy Policy and Terms of Service.',
//                   style: Theme.of(context).textTheme.bodyMedium,
//                 ),
//                 SizedBox(height: AppConstants.paddingMedium),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () => _showPrivacyPolicy(context),
//                         child: Text('Privacy Policy'),
//                       ),
//                     ),
//                     SizedBox(width: AppConstants.paddingSmall),
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: () => _showTermsOfService(context),
//                         child: Text('Terms of Service'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildErrorState(BuildContext context, String message, AppLocalizations l10n) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.error_outline,
//             size: 64,
//             color: AppConstants.errorRed,
//           ),
//           SizedBox(height: AppConstants.paddingMedium),
//           Text(
//             'Error Loading Privacy Settings',
//             style: Theme.of(context).textTheme.headlineSmall,
//           ),
//           SizedBox(height: AppConstants.paddingSmall),
//           Text(
//             message,
//             textAlign: TextAlign.center,
//             style: TextStyle(color: AppConstants.textSecondary),
//           ),
//           SizedBox(height: AppConstants.paddingLarge),
//           ElevatedButton(
//             onPressed: () {
//               context.read<PrivacyBloc>().add(LoadPrivacySettingsEvent());
//             },
//             child: Text(l10n.retry),
//           ),
//         ],
//       ),
//     );
//   }

//   void _updatePrivacySetting(String key, dynamic value) {
//     context.read<PrivacyBloc>().add(UpdatePrivacySettingEvent(key, value));
//   }

//   String _getProfileVisibilitySubtitle(String? visibility) {
//     switch (visibility) {
//       case 'public':
//         return 'Anyone can see your profile';
//       case 'community':
//         return 'Only community members can see your profile';
//       case 'private':
//         return 'Only you can see your profile';
//       default:
//         return 'Community members only';
//     }
//   }

//   void _showProfileVisibilityDialog(BuildContext context, String? currentVisibility) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Profile Visibility'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             RadioListTile<String>(
//               title: Text('Public'),
//               subtitle: Text('Anyone can see your profile'),
//               value: 'public',
//               groupValue: currentVisibility ?? 'community',
//               onChanged: (value) {
//                 _updatePrivacySetting('profileVisibility', value);
//                 Navigator.pop(context);
//               },
//               activeColor: AppConstants.primaryGreen,
//             ),
//             RadioListTile<String>(
//               title: Text('Community'),
//               subtitle: Text('Only community members can see your profile'),
//               value: 'community',
//               groupValue: currentVisibility ?? 'community',
//               onChanged: (value) {
//                 _updatePrivacySetting('profileVisibility', value);
//                 Navigator.pop(context);
//               },
//               activeColor: AppConstants.primaryGreen,
//             ),
//             RadioListTile<String>(
//               title: Text('Private'),
//               subtitle: Text('Only you can see your profile'),
//               value: 'private',
//               groupValue: currentVisibility ?? 'community',
//               onChanged: (value) {
//                 _updatePrivacySetting('profileVisibility', value);
//                 Navigator.pop(context);
//               },
//               activeColor: AppConstants.primaryGreen,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _requestDataDownload(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Download Your Data'),
//         content: Text(
//           'We will prepare a copy of your data and send it to your registered email address within 24-48 hours.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               context.read<PrivacyBloc>().add(RequestDataDownloadEvent());
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('Data download request submitted'),
//                   backgroundColor: AppConstants.successGreen,
//                 ),
//               );
//             },
//             child: Text('Request Download'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showClearDataDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Clear Activity Data'),
//         content: Text(
//           'This will remove your stored activity data, search history, and usage analytics. Your reports and profile will not be affected.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               context.read<PrivacyBloc>().add(ClearActivityDataEvent());
//             },
//             style: TextButton.styleFrom(
//               foregroundColor: AppConstants.warningAmber,
//             ),
//             child: Text('Clear Data'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showDeactivateAccountDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Deactivate Account'),
//         content: Text(
//           'Deactivating your account will hide your profile and reports from other users. You can reactivate anytime by signing in.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               context.read<PrivacyBloc>().add(DeactivateAccountEvent());
//             },
//             style: TextButton.styleFrom(
//               foregroundColor: AppConstants.errorRed,
//             ),
//             child: Text('Deactivate'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showPrivacyPolicy(BuildContext context) {
//     // Navigate to privacy policy page or show in web view
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Privacy policy feature coming soon')),
//     );
//   }

//   void _showTermsOfService(BuildContext context) {
//     // Navigate to terms of service page or show in web view
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Terms of service feature coming soon')),
//     );
//   }
// }
