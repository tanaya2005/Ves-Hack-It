// ignore_for_file: unused_import, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String _selectedLanguage = 'en'; // Default language

  final Map<String, String> languages = {
    'en': 'English',
    'hi': 'हिन्दी',
    'bn': 'বাংলা',
    'te': 'తెలుగు',
    'mr': 'मराठी',
    'ta': 'தமிழ்',
    'gu': 'ગુજરાતી',
    'ur': 'اردو',
    'kn': 'ಕನ್ನಡ',
    'or': 'ଓଡ଼ିଆ',
    'ml': 'മലയാളം',
    'pa': 'ਪੰਜਾਬੀ',
    'as': 'অসমীয়া',
    'bh': 'भोजपुरी',
    'ks': 'کشميري',
    'sd': 'سنڌي',
    'mni': 'মণিপুরী',
    'kok': 'कोंकणी',
    'doi': 'डोगरी',
    'ne': 'नेपाली',
    'brx': 'बोडो',
    'sant': 'ᱥᱟᱱᱛᱟᱲᱤ',
    'ho': '𑢵𑣉𑣉',
    'mai': 'मैथिली',
    'sa': 'संस्कृतम्',
    'lep': 'ᰛᰩᰵ',
    'new': 'नेपाल भाषा',
    'raj': 'राजस्थानी',
    'sr': 'Српски',
    'mlt': 'Malti',
  };

  void _setLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
    });
    Navigator.pushReplacementNamed(context, '/welcome');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('भाषा चुनें / Select Your Language', style: TextStyle(fontSize: 18)),
              SizedBox(height: 16),
              DropdownButton<String>(
                value: _selectedLanguage,
                items: languages.entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  if (value != null) {
                    _setLanguage(value);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
