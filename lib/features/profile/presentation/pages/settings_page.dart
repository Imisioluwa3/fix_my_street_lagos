// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:package_info_plus/package_info_plus.dart';

// import '../../../../core/constants/app_constants.dart';
// import '../../../../core/services/notification_service.dart';
// import '../../../../core/services/hive_service.dart';
// import '../../../../features/authentication/presentation/bloc/auth_bloc.dart';
// import '../bloc/profile_bloc.dart';
// import '../widgets/settings_section.dart';
// import '../widgets/settings_tile.dart';
// import 'notification_settings_page.dart';
// import 'privacy_settings_page.dart';
// import 'about_page.dart';

// class SettingsPage extends StatefulWidget {
//   @override
//   _SettingsPageState createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   bool _darkMode = false;
//   String _selectedLanguage = 'English';
//   bool _offlineMode = false;
//   String _appVersion = '';

//   @override
//   void initState() {
//     super.initState();
//     _loadSettings();
//     _getAppVersion();
//   }

//   void _loadSettings() {
//     _darkMode = HiveService.getSetting<bool>('dark_mode', defaultValue: false) ?? false;
//     _selectedLanguage = HiveService.getSetting<String>('language', defaultValue: 'English') ?? 'English';
//     _offlineMode = HiveService.isOfflineMode();
//   }

//   Future<void> _getAppVersion() async {
//     final packageInfo = await PackageInfo.fromPlatform();
//     setState(() {
//       _appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Settings'),
//       ),
//       body: ListView(
//         padding: EdgeInsets.all(AppConstants.paddingMedium),
//         children: [
//           _buildAccountSection(),
//           SizedBox(height: AppConstants.paddingLarge),
//           _buildNotificationSection(),
//           SizedBox(height: AppConstants.paddingLarge),
//           _buildAppearanceSection(),
//           SizedBox(height: AppConstants.paddingLarge),
//           _buildDataSection(),
//           SizedBox(height: AppConstants.paddingLarge),
//           _buildSupportSection(),
//           SizedBox(height: AppConstants.paddingLarge),
//           _buildAboutSection(),
//           SizedBox(height: AppConstants.paddingLarge),
//           _buildDangerZone(),
//         ],
//       ),
//     );
//   }

//   Widget _buildAccountSection() {
//     return SettingsSection(
//       title: 'Account',
//       children: [
//         SettingsTile(
//           leading: Icon(Icons.person, color: AppConstants.primaryGreen),
//           title: 'Edit Profile',
//           subtitle: 'Update your personal information',
//           onTap: () => Navigator.pop(context),
//         ),
//         SettingsTile(
//           leading: Icon(Icons.security, color: AppConstants.primaryGreen),
//           title: 'Privacy & Security',
//           subtitle: 'Manage your privacy settings',
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => PrivacySettingsPage()),
//           ),
//         ),
//         SettingsTile(
//           leading: Icon(Icons.verified_user, color: AppConstants.primaryGreen),
//           title: 'Account Verification',
//           subtitle: 'Verify your identity',
//           onTap: () => _showVerificationDialog(),
//         ),
//       ],
//     );
//   }

//   Widget _buildNotificationSection() {
//     return SettingsSection(
//       title: 'Notifications',
//       children: [
//         SettingsTile(
//           leading: Icon(Icons.notifications, color: AppConstants.primaryGreen),
//           title: 'Notification Settings',
//           subtitle: 'Manage your notification preferences',
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => NotificationSettingsPage()),
//           ),
//         ),
//         SettingsTile(
//           leading: Icon(Icons.location_on, color: AppConstants.primaryGreen),
//           title: 'Location-based Alerts',
//           subtitle: 'Get alerts for issues in your area',
//           trailing: Switch(
//             value: true,
//             onChanged: (value) {
//               // Handle location alerts toggle
//             },
//             activeColor: AppConstants.primaryGreen,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildAppearanceSection() {
//     return SettingsSection(
//       title: 'Appearance',
//       children: [
//         SettingsTile(
//           leading: Icon(Icons.dark_mode, color: AppConstants.primaryGreen),
//           title: 'Dark Mode',
//           subtitle: 'Switch to dark theme',
//           trailing: Switch(
//             value: _darkMode,
//             onChanged: (value) {
//               setState(() {
//                 _darkMode = value;
//               });
//               HiveService.saveSetting('dark_mode', value);
//               // Apply theme change
//             },
//             activeColor: AppConstants.primaryGreen,
//           ),
//         ),
//         SettingsTile(
//           leading: Icon(Icons.language, color: AppConstants.primaryGreen),
//           title: 'Language',
//           subtitle: _selectedLanguage,
//           onTap: () => _showLanguageDialog(),
//         ),
//       ],
//     );
//   }

//   Widget _buildDataSection() {
//     return SettingsSection(
//       title: 'Data & Storage',
//       children: [
//         SettingsTile(
//           leading: Icon(Icons.cloud_off, color: AppConstants.primaryGreen),
//           title: 'Offline Mode',
//           subtitle: _offlineMode ? 'Currently offline' : 'Online',
//           trailing: Switch(
//             value: _offlineMode,
//             onChanged: (value) {
//               setState(() {
//                 _offlineMode = value;
//               });
//               HiveService.setOfflineMode(value);
//             },
//             activeColor: AppConstants.primaryGreen,
//           ),
//         ),
//         SettingsTile(
//           leading: Icon(Icons.sync, color: AppConstants.primaryGreen),
//           title: 'Sync Data',
//           subtitle: 'Sync your data with the server',
//           onTap: () => _syncData(),
//         ),
//         SettingsTile(
//           leading: Icon(Icons.storage, color: AppConstants.primaryGreen),
//           title: 'Storage Usage',
//           subtitle: 'Manage app storage',
//           onTap: () => _showStorageDialog(),
//         ),
//         SettingsTile(
//           leading: Icon(Icons.clear_all, color: AppConstants.warningAmber),
//           title: 'Clear Cache',
//           subtitle: 'Free up storage space',
//           onTap: () => _clearCache(),
//         ),
//       ],
//     );
//   }

//   Widget _buildSupportSection() {
//     return SettingsSection(
//       title: 'Support',
//       children: [
//         SettingsTile(
//           leading: Icon(Icons.help, color: AppConstants.primaryGreen),
//           title: 'Help & FAQ',
//           subtitle: 'Get help and find answers',
//           onTap: () => _showHelpDialog(),
//         ),
//         SettingsTile(
//           leading: Icon(Icons.feedback, color: AppConstants.primaryGreen),
//           title: 'Send Feedback',
//           subtitle: 'Help us improve the app',
//           onTap: () => _sendFeedback(),
//         ),
//         SettingsTile(
//           leading: Icon(Icons.bug_report, color: AppConstants.primaryGreen),
//           title: 'Report a Bug',
//           subtitle: 'Report technical issues',
//           onTap: () => _reportBug(),
//         ),
//         SettingsTile(
//           leading: Icon(Icons.contact_support, color: AppConstants.primaryGreen),
//           title: 'Contact Support',
//           subtitle: 'Get in touch with our team',
//           onTap: () => _contactSupport(),
//         ),
//       ],
//     );
//   }

//   Widget _buildAboutSection() {
//     return SettingsSection(
//       title: 'About',
//       children: [
//         SettingsTile(
//           leading: Icon(Icons.info, color: AppConstants.primaryGreen),
//           title: 'About FixMyStreet Lagos',
//           subtitle: 'Learn more about the app',
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => AboutPage()),
//           ),
//         ),
//         SettingsTile(
//           leading: Icon(Icons.policy, color: AppConstants.primaryGreen),
//           title: 'Privacy Policy',
//           subtitle: 'Read our privacy policy',
//           onTap: () => _showPrivacyPolicy(),
//         ),
//         SettingsTile(
//           leading: Icon(Icons.description, color: AppConstants.primaryGreen),
//           title: 'Terms of Service',
//           subtitle: 'Read our terms of service',
//           onTap: () => _showTermsOfService(),
//         ),
//         SettingsTile(
//           leading: Icon(Icons.code, color: AppConstants.primaryGreen),
//           title: 'Version',
//           subtitle: _appVersion,
//         ),
//       ],
//     );
//   }

//   Widget _buildDangerZone() {
//     return SettingsSection(
//       title: 'Danger Zone',
//       children: [
//         SettingsTile(
//           leading: Icon(Icons.logout, color: AppConstants.errorRed),
//           title: 'Sign Out',
//           subtitle: 'Sign out of your account',
//           titleColor: AppConstants.errorRed,
//           onTap: () => _showSignOutDialog(),
//         ),
//         SettingsTile(
//           leading: Icon(Icons.delete_forever, color: AppConstants.errorRed),
//           title: 'Delete Account',
//           subtitle: 'Permanently delete your account',
//           titleColor: AppConstants.errorRed,
//           onTap: () => _showDeleteAccountDialog(),
//         ),
//       ],
//     );
//   }

//   void _showLanguageDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Select Language'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             'English',
//             'Yoruba',
//             'Igbo',
//             'Hausa',
//           ].map((language) => RadioListTile<String>(
//             title: Text(language),
//             value: language,
//             groupValue: _selectedLanguage,
//             onChanged: (value) {
//               setState(() {
//                 _selectedLanguage = value!;
//               });
//               HiveService.saveSetting('language', value!);
//               Navigator.pop(context);
//             },
//             activeColor: AppConstants.primaryGreen,
//           )).toList(),
//         ),
//       ),
//     );
//   }

//   void _showVerificationDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Account Verification'),
//         content: Text(
//           'To verify your account, please contact Lagos State Ministry of Environment or visit any LASEMA office with a valid ID.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _syncData() async {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         content: Row(
//           children: [
//             CircularProgressIndicator(),
//             SizedBox(width: 20),
//             Text('Syncing data...'),
//           ],
//         ),
//       ),
//     );

//     try {
//       // Perform sync operation
//       await Future.delayed(Duration(seconds: 2)); // Simulate sync
//       Navigator.pop(context);
      
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Data synced successfully'),
//           backgroundColor: AppConstants.successGreen,
//         ),
//       );
//     } catch (e) {
//       Navigator.pop(context);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Sync failed: $e'),
//           backgroundColor: AppConstants.errorRed,
//         ),
//       );
//     }
//   }

//   void _showStorageDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Storage Usage'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('App Data: 15.2 MB'),
//             Text('Images: 45.8 MB'),
//             Text('Videos: 120.5 MB'),
//             Text('Cache: 8.3 MB'),
//             Divider(),
//             Text('Total: 189.8 MB', style: TextStyle(fontWeight: FontWeight.bold)),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _clearCache() async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Clear Cache'),
//         content: Text('This will clear all cached data. Are you sure?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: Text('Clear'),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       await HiveService.clearCache();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Cache cleared successfully'),
//           backgroundColor: AppConstants.successGreen,
//         ),
//       );
//     }
//   }

//   void _showHelpDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Help & FAQ'),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('How to report an issue?', style: TextStyle(fontWeight: FontWeight.bold)),
//               Text('Tap the "Report Issue" button and follow the steps.'),
//               SizedBox(height: 16),
//               Text('How to track my reports?', style: TextStyle(fontWeight: FontWeight.bold)),
//               Text('Go to "My Reports" tab to see all your submitted reports.'),
//               SizedBox(height: 16),
//               Text('How to get notifications?', style: TextStyle(fontWeight: FontWeight.bold)),
//               Text('Enable notifications in Settings > Notifications.'),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _sendFeedback() {
//     // Implement feedback functionality
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Feedback feature coming soon')),
//     );
//   }

//   void _reportBug() {
//     // Implement bug reporting functionality
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Bug reporting feature coming soon')),
//     );
//   }

//   void _contactSupport() {
//     // Implement contact support functionality
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Contact support feature coming soon')),
//     );
//   }

//   void _showPrivacyPolicy() {
//     // Show privacy policy
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Privacy policy feature coming soon')),
//     );
//   }

//   void _showTermsOfService() {
//     // Show terms of service
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Terms of service feature coming soon')),
//     );
//   }

//   void _showSignOutDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Sign Out'),
//         content: Text('Are you sure you want to sign out?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               context.read<AuthBloc>().add(SignOutEvent());
//             },
//             style: TextButton.styleFrom(
//               foregroundColor: AppConstants.errorRed,
//             ),
//             child: Text('Sign Out'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showDeleteAccountDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Delete Account'),
//         content: Text(
//           'This action cannot be undone. All your data will be permanently deleted.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               context.read<ProfileBloc>().add(DeleteAccountEvent());
//             },
//             style: TextButton.styleFrom(
//               foregroundColor: AppConstants.errorRed,
//             ),
//             child: Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }
// }
