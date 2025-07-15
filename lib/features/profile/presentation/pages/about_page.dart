// import 'package:flutter/material.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../../../../core/constants/app_constants.dart';
// import '../../../../core/localization/app_localizations.dart';
// import '../../../../shared/widgets/settings_section.dart';
// import '../../../../shared/widgets/settings_tile.dart';

// class AboutPage extends StatefulWidget {
//   @override
//   _AboutPageState createState() => _AboutPageState();
// }

// class _AboutPageState extends State<AboutPage> {
//   String _appVersion = '';
//   String _buildNumber = '';

//   @override
//   void initState() {
//     super.initState();
//     _getAppInfo();
//   }

//   Future<void> _getAppInfo() async {
//     final packageInfo = await PackageInfo.fromPlatform();
//     setState(() {
//       _appVersion = packageInfo.version;
//       _buildNumber = packageInfo.buildNumber;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(l10n.aboutApp),
//       ),
//       body: ListView(
//         padding: EdgeInsets.all(AppConstants.paddingMedium),
//         children: [
//           // App Header
//           _buildAppHeader(context, l10n),
          
//           SizedBox(height: AppConstants.paddingLarge),
          
//           // App Information
//           SettingsSection(
//             title: 'App Information',
//             children: [
//               SettingsTile(
//                 leading: Icon(Icons.info, color: AppConstants.primaryGreen),
//                 title: l10n.version,
//                 subtitle: '$_appVersion ($_buildNumber)',
//               ),
//               SettingsTile(
//                 leading: Icon(Icons.update, color: AppConstants.primaryGreen),
//                 title: 'Last Updated',
//                 subtitle: 'December 2024',
//               ),
//               SettingsTile(
//                 leading: Icon(Icons.storage, color: AppConstants.primaryGreen),
//                 title: 'App Size',
//                 subtitle: '45.2 MB',
//               ),
//               SettingsTile(
//                 leading: Icon(Icons.android, color: AppConstants.primaryGreen),
//                 title: 'Minimum OS Version',
//                 subtitle: 'Android 6.0 / iOS 12.0',
//               ),
//             ],
//           ),
          
//           SizedBox(height: AppConstants.paddingLarge),
          
//           // Developer Information
//           SettingsSection(
//             title: 'Developer',
//             children: [
//               SettingsTile(
//                 leading: Icon(Icons.business, color: AppConstants.primaryGreen),
//                 title: 'Organization',
//                 subtitle: 'Lagos State Government',
//               ),
//               SettingsTile(
//                 leading: Icon(Icons.code, color: AppConstants.primaryGreen),
//                 title: 'Development Team',
//                 subtitle: 'Lagos State ICT Department',
//               ),
//               SettingsTile(
//                 leading: Icon(Icons.email, color: AppConstants.primaryGreen),
//                 title: l10n.contact,
//                 subtitle: AppConstants.supportEmail,
//                 onTap: () => _launchEmail(AppConstants.supportEmail),
//               ),
//               SettingsTile(
//                 leading: Icon(Icons.phone, color: AppConstants.primaryGreen),
//                 title: 'Support Phone',
//                 subtitle: AppConstants.supportPhone,
//                 onTap: () => _launchPhone(AppConstants.supportPhone),
//               ),
//             ],
//           ),
          
//           SizedBox(height: AppConstants.paddingLarge),
          
//           // Features & Services
//           SettingsSection(
//             title: 'Features & Services',
//             children: [
//               SettingsTile(
//                 leading: Icon(Icons.report, color: AppConstants.primaryGreen),
//                 title: 'Issue Reporting',
//                 subtitle: 'Report infrastructure issues in Lagos State',
//               ),
//               SettingsTile(
//                 leading: Icon(Icons.track_changes, color: AppConstants.primaryGreen),
//                 title: 'Real-time Tracking',
//                 subtitle: 'Track the status of your reported issues',
//               ),
//               SettingsTile(
//                 leading: Icon(Icons.notifications, color: AppConstants.primaryGreen),
//                 title: 'Push Notifications',
//                 subtitle: 'Get updates on your reports and community alerts',
//               ),
//               SettingsTile(
//                 leading: Icon(Icons.offline_bolt, color: AppConstants.primaryGreen),
//                 title: 'Offline Support',
//                 subtitle: 'Submit reports even without internet connection',
//               ),
//               SettingsTile(
//                 leading: Icon(Icons.language, color: AppConstants.primaryGreen),
//                 title: 'Multi-language',
//                 subtitle: 'Available in English, Yoruba, Igbo, and Hausa',
//               ),
//             ],
//           ),
          
//           SizedBox(height: AppConstants.paddingLarge),
          
//           // Community & Social
//           SettingsSection(
//             title: 'Community & Social',
//             children: [
//               SettingsTile(
//                 leading: Icon(Icons.star, color: AppConstants.primaryGreen),
//                 title: l10n.rateApp,
//                 subtitle: 'Rate us on the app store',
//                 onTap: () => _rateApp(),
//               ),
//               SettingsTile(
//                 leading: Icon(Icons.share, color: AppConstants.primaryGreen),
//                 title: l10n.shareApp,
//                 subtitle: 'Share with friends and family',
//                 onTap: () => _shareApp(),
//               ),
//               SettingsTile(
//                 leading: Icon(Icons.feedback, color: AppConstants.primaryGreen),
//                 title: l10n.feedback,
//                 subtitle: 'Send us your feedback and suggestions',
//                 onTap: () => _sendFeedback(),
//               ),
//               SettingsTile(
//                 leading: Icon(Icons.bug_report, color: AppConstants.primaryGreen),
//                 title: 'Report Bug',
//                 subtitle: 'Help us improve by reporting bugs',
//                 onTap: () => _reportBug(),
//               ),
//             ],
//           ),
          
//           SizedBox(height: AppConstants.paddingLarge),
          
//           // Legal & Compliance
//           SettingsSection(
//             title: 'Legal & Compliance',
//             children: [
//               SettingsTile(
//                 leading: Icon(Icons.policy, color: AppConstants.primaryGreen),
//                 title: l10n.privacyPolicy,
//                 subtitle: 'How we handle your data',
//                 onTap: () => _showPrivacyPolicy(),
//               ),
//               SettingsTile(
//                 leading: Icon(Icons.description, color: AppConstants.primaryGreen),
//                 title: l10n.termsOfService,
//                 subtitle: 'Terms and conditions of use',
//                 onTap: () => _showTermsOfService(),
//               ),
//               SettingsTile(
//                 leading: Icon(Icons.security, color: AppConstants.primaryGreen),
//                 title: 'Data Security',
//                 subtitle: 'Learn about our security measures',
//                 onTap: () => _showDataSecurity(),
//               ),
//               SettingsTile(
//                 leading: Icon(Icons.accessibility, color: AppConstants.primaryGreen),
//                 title: 'Accessibility',
//                 subtitle: 'Accessibility features and support',
//                 onTap: () => _showAccessibilityInfo(),
//               ),
//             ],
//           ),
          
//           SizedBox(height: AppConstants.paddingLarge),
          
//           // Technical Information
//           SettingsSection(
//             title: 'Technical Information',
//             children: [
//               SettingsTile(
//                 leading: Icon(Icons.code, color: AppConstants.primaryGreen),
//                 title: 'Open Source Libraries',
//                 subtitle: 'View third-party licenses',
//                 onTap: () => _showLicenses(),
//               ),
//               SettingsTile(
//                 leading: Icon(Icons.api, color: AppConstants.primaryGreen),
//                 title: 'API Version',
//                 subtitle: 'v2.1.0',
//               ),
//               SettingsTile(
//                 leading: Icon(Icons.build, color: AppConstants.primaryGreen),
//                 title: 'Build Environment',
//                 subtitle: 'Flutter 3.16.0 • Dart 3.2.0',
//               ),
//             ],
//           ),
          
//           SizedBox(height: AppConstants.paddingLarge),
          
//           // Acknowledgments
//           _buildAcknowledgments(context, l10n),
          
//           SizedBox(height: AppConstants.paddingLarge),
          
//           // Footer
//           _buildFooter(context, l10n),
//         ],
//       ),
//     );
//   }

//   Widget _buildAppHeader(BuildContext context, AppLocalizations l10n) {
//     return Card(
//       child: Padding(
//         padding: EdgeInsets.all(AppConstants.paddingLarge),
//         child: Column(
//           children: [
//             // App Icon
//             Container(
//               width: 80,
//               height: 80,
//               decoration: BoxDecoration(
//                 color: AppConstants.primaryGreen,
//                 borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
//               ),
//               child: Icon(
//                 Icons.build,
//                 size: 40,
//                 color: Colors.white,
//               ),
//             ),
            
//             SizedBox(height: AppConstants.paddingMedium),
            
//             Text(
//               AppConstants.appName,
//               style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                 color: AppConstants.primaryGreen,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
            
//             SizedBox(height: AppConstants.paddingSmall),
            
//             Text(
//               'Empowering Lagos Citizens to Report and Track Infrastructure Issues',
//               textAlign: TextAlign.center,
//               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                 color: AppConstants.textSecondary,
//               ),
//             ),
            
//             SizedBox(height: AppConstants.paddingMedium),
            
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.verified,
//                   color: AppConstants.successGreen,
//                   size: 16,
//                 ),
//                 SizedBox(width: 4),
//                 Text(
//                   'Official Lagos State App',
//                   style: TextStyle(
//                     color: AppConstants.successGreen,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAcknowledgments(BuildContext context, AppLocalizations l10n) {
//     return Card(
//       child: Padding(
//         padding: EdgeInsets.all(AppConstants.paddingMedium),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Acknowledgments',
//               style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                 color: AppConstants.primaryGreen,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             SizedBox(height: AppConstants.paddingMedium),
//             Text(
//               'Special thanks to:',
//               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             SizedBox(height: AppConstants.paddingSmall),
//             _buildAcknowledgmentItem('Lagos State Ministry of Environment'),
//             _buildAcknowledgmentItem('Lagos State Emergency Management Agency (LASEMA)'),
//             _buildAcknowledgmentItem('Lagos State Public Works Corporation'),
//             _buildAcknowledgmentItem('Lagos State Waste Management Authority (LAWMA)'),
//             _buildAcknowledgmentItem('All Lagos State citizens who contribute to making our city better'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAcknowledgmentItem(String text) {
//     return Padding(
//       padding: EdgeInsets.only(left: AppConstants.paddingMedium, bottom: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('• ', style: TextStyle(color: AppConstants.primaryGreen)),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(color: AppConstants.textSecondary),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFooter(BuildContext context, AppLocalizations l10n) {
//     return Column(
//       children: [
//         Divider(),
//         SizedBox(height: AppConstants.paddingMedium),
//         Text(
//           '© 2024 Lagos State Government',
//           style: Theme.of(context).textTheme.bodySmall?.copyWith(
//             color: AppConstants.textSecondary,
//           ),
//         ),
//         SizedBox(height: AppConstants.paddingSmall),
//         Text(
//           'Made with ❤️ for Lagos State',
//           style: Theme.of(context).textTheme.bodySmall?.copyWith(
//             color: AppConstants.textSecondary,
//           ),
//         ),
//         SizedBox(height: AppConstants.paddingMedium),
//         Text(
//           'Version $_appVersion ($_buildNumber)',
//           style: Theme.of(context).textTheme.bodySmall?.copyWith(
//             color: AppConstants.textLight,
//           ),
//         ),
//       ],
//     );
//   }

//   Future<void> _launchEmail(String email) async {
//     final Uri emailUri = Uri(
//       scheme: 'mailto',
//       path: email,
//       query: 'subject=FixMyStreet Lagos Support',
//     );
    
//     if (await canLaunchUrl(emailUri)) {
//       await launchUrl(emailUri);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Could not launch email client')),
//       );
//     }
//   }

//   Future<void> _launchPhone(String phone) async {
//     final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    
//     if (await canLaunchUrl(phoneUri)) {
//       await launchUrl(phoneUri);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Could not launch phone dialer')),
//       );
//     }
//   }

//   void _rateApp() {
//     // Launch app store rating
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Rate app feature coming soon')),
//     );
//   }

//   void _shareApp() {
//     // Share app functionality
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Share app feature coming soon')),
//     );
//   }

//   void _sendFeedback() {
//     // Send feedback functionality
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Feedback feature coming soon')),
//     );
//   }

//   void _reportBug() {
//     // Report bug functionality
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Bug reporting feature coming soon')),
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

//   void _showDataSecurity() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Data Security'),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('We take your data security seriously:'),
//               SizedBox(height: 16),
//               Text('• End-to-end encryption for sensitive data'),
//               Text('• Secure cloud storage with Firebase'),
//               Text('• Regular security audits and updates'),
//               Text('• Compliance with data protection regulations'),
//               Text('• No sharing of personal data with third parties'),
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

//   void _showAccessibilityInfo() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Accessibility Features'),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('This app includes the following accessibility features:'),
//               SizedBox(height: 16),
//               Text('• Screen reader support'),
//               Text('• High contrast mode'),
//               Text('• Large text support'),
//               Text('• Voice input for reports'),
//               Text('• Keyboard navigation'),
//               Text('• Multi-language support'),
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

//   void _showLicenses() {
//     showLicensePage(
//       context: context,
//       applicationName: AppConstants.appName,
//       applicationVersion: _appVersion,
//       applicationIcon: Container(
//         width: 48,
//         height: 48,
//         decoration: BoxDecoration(
//           color: AppConstants.primaryGreen,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Icon(
//           Icons.build,
//           color: Colors.white,
//           size: 24,
//         ),
//       ),
//     );
//   }
// }
