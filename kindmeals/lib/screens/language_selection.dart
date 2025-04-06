import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String _selectedLanguage = 'en';

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

  Future<void> saveLanguagePreference(String userId, String language) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/setLanguage'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'language': language}),
    );

    if (response.statusCode == 200) {
      print('Language preference saved successfully');
    } else {
      print('Failed to save language preference');
    }
  }

  void _setLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Language'),
        content: Text('You have selected ${languages[language]}. Proceed?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.language, size: 50, color: Colors.blueAccent),
                  SizedBox(height: 16),
                  Text(
                    'भाषा चुनें / Select Your Language',
                    style: GoogleFonts.lato(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedLanguage,
                    icon: Icon(Icons.arrow_drop_down),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    items: languages.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.key,
                        child: Row(
                          children: [
                            Icon(Icons.flag, size: 20, color: Colors.grey),
                            SizedBox(width: 8),
                            Text(entry.value,
                                style: GoogleFonts.lato(fontSize: 16)),
                          ],
                        ),
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
        ),
      ),
    );
  }
}

