// lib/services/language_service.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String LANGUAGE_CODE = 'languageCode';
  
  static final List<Locale> supportedLocales = [
    const Locale('en', ''), // English
    const Locale('hi', ''), // Hindi
  ];
  
  static Future<Locale> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String languageCode = prefs.getString(LANGUAGE_CODE) ?? 'en';
    return Locale(languageCode);
  }
  
  static Future<void> changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LANGUAGE_CODE, languageCode);
  }
}