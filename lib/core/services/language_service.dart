import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageKey = 'selected_language';
  static const String _defaultLanguage = 'en';

  static final Map<String, String> _supportedLanguages = {
    'en': 'English',
    'yo': 'Yoruba',
    'ig': 'Igbo',
    'ha': 'Hausa',
  };

  static Map<String, String> get supportedLanguages => _supportedLanguages;

  /// Get current language code
  static Future<String> getCurrentLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? _defaultLanguage;
  }

  /// Set language
  static Future<void> setLanguage(String languageCode) async {
    if (!_supportedLanguages.containsKey(languageCode)) {
      throw ArgumentError('Unsupported language: $languageCode');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  /// Get locale from language code
  static Locale getLocaleFromLanguageCode(String languageCode) {
    return Locale(languageCode);
  }

  /// Get language name from code
  static String getLanguageName(String languageCode) {
    return _supportedLanguages[languageCode] ?? 'Unknown';
  }

  /// Get system language if supported, otherwise return default
  static String getSystemLanguage() {
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
    final systemLanguageCode = systemLocale.languageCode;
    
    if (_supportedLanguages.containsKey(systemLanguageCode)) {
      return systemLanguageCode;
    }
    
    return _defaultLanguage;
  }

  /// Initialize language service
  static Future<void> initialize() async {
    final currentLanguage = await getCurrentLanguage();
    if (currentLanguage == _defaultLanguage) {
      // Set system language if no language is set
      final systemLanguage = getSystemLanguage();
      if (systemLanguage != _defaultLanguage) {
        await setLanguage(systemLanguage);
      }
    }
  }
}
