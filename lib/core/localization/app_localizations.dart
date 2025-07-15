import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class AppLocalizations {
  final Locale locale;
  late Map<String, String> _localizedStrings;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Future<bool> load() async {
    String jsonString = await rootBundle
        .loadString('assets/lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  // Common translations
  String get appName => translate('app_name');
  String get home => translate('home');
  String get reports => translate('reports');
  String get profile => translate('profile');
  String get settings => translate('settings');
  String get reportIssue => translate('report_issue');
  String get myReports => translate('my_reports');
  String get notifications => translate('notifications');
  String get search => translate('search');
  String get filter => translate('filter');
  String get sort => translate('sort');
  String get cancel => translate('cancel');
  String get save => translate('save');
  String get delete => translate('delete');
  String get edit => translate('edit');
  String get submit => translate('submit');
  String get loading => translate('loading');
  String get error => translate('error');
  String get success => translate('success');
  String get retry => translate('retry');
  String get ok => translate('ok');
  String get yes => translate('yes');
  String get no => translate('no');

  // Authentication
  String get signIn => translate('sign_in');
  String get signUp => translate('sign_up');
  String get signOut => translate('sign_out');
  String get email => translate('email');
  String get password => translate('password');
  String get confirmPassword => translate('confirm_password');
  String get forgotPassword => translate('forgot_password');
  String get phoneNumber => translate('phone_number');
  String get fullName => translate('full_name');
  String get location => translate('location');

  // Report Issue
  String get issueTitle => translate('issue_title');
  String get issueDescription => translate('issue_description');
  String get issueCategory => translate('issue_category');
  String get issuePriority => translate('issue_priority');
  String get addPhotos => translate('add_photos');
  String get addVideos => translate('add_videos');
  String get selectLocation => translate('select_location');
  String get currentLocation => translate('current_location');
  String get submitReport => translate('submit_report');

  // Issue Categories
  String get roadDamage => translate('road_damage');
  String get streetLighting => translate('street_lighting');
  String get drainage => translate('drainage');
  String get wasteManagement => translate('waste_management');
  String get waterSupply => translate('water_supply');
  String get publicSafety => translate('public_safety');
  String get parkingViolation => translate('parking_violation');
  String get noiseComplaint => translate('noise_complaint');
  String get environmentalIssue => translate('environmental_issue');
  String get other => translate('other');

  // Issue Status
  String get pending => translate('pending');
  String get inProgress => translate('in_progress');
  String get resolved => translate('resolved');
  String get rejected => translate('rejected');

  // Priority Levels
  String get low => translate('low');
  String get medium => translate('medium');
  String get high => translate('high');
  String get urgent => translate('urgent');

  // Profile & Settings
  String get personalInfo => translate('personal_info');
  String get contactInfo => translate('contact_info');
  String get accountInfo => translate('account_info');
  String get notificationSettings => translate('notification_settings');
  String get privacySettings => translate('privacy_settings');
  String get languageSettings => translate('language_settings');
  String get aboutApp => translate('about_app');
  String get helpSupport => translate('help_support');
  String get termsOfService => translate('terms_of_service');
  String get privacyPolicy => translate('privacy_policy');

  // Statistics
  String get totalReports => translate('total_reports');
  String get resolvedReports => translate('resolved_reports');
  String get pendingReports => translate('pending_reports');
  String get communityImpact => translate('community_impact');
  String get responseTime => translate('response_time');
  String get userRating => translate('user_rating');

  // Notifications
  String get statusUpdates => translate('status_updates');
  String get communityAlerts => translate('community_alerts');
  String get governmentResponse => translate('government_response');
  String get nearbyReports => translate('nearby_reports');
  String get emailNotifications => translate('email_notifications');

  // Privacy
  String get dataSharing => translate('data_sharing');
  String get locationAccess => translate('location_access');
  String get profileVisibility => translate('profile_visibility');
  String get analyticsTracking => translate('analytics_tracking');
  String get marketingCommunications => translate('marketing_communications');

  // About
  String get version => translate('version');
  String get developer => translate('developer');
  String get contact => translate('contact');
  String get feedback => translate('feedback');
  String get rateApp => translate('rate_app');
  String get shareApp => translate('share_app');
  String get licenses => translate('licenses');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'yo', 'ig', 'ha'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
