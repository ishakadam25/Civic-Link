import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'home_title': 'CivicLink Mumbai',
      'home_tagline': 'Build, report, and connect with your city.',
      'quick_open': 'Tap to open',
      'weather': 'Weather',
      'bills': 'Bills',
      'tourist_spots': 'Tourist Spots',
      'raise_complaint': 'Raise Complaint',
      'my_complaints': 'My Complaints',
      'announcements': 'Announcements',
      'discover_city': 'Discover the best of Mumbai',
      'city_description': 'Explore local services, city events, and tourist routes.',
      'search_hint': 'Search tourist places...',
      'select_area': 'Select area',
      'no_places_found': 'No tourist places found',
      'language_label': 'Language',
      'issue_title': 'Issue title',
      'describe_issue': 'Describe the issue',
      'upload_photo': 'Upload Photo',
      'submit_complaint': 'Submit Complaint',
      'announcement_title': 'Title',
      'announcement_message': 'Message',
      'post_announcement': 'Post Announcement',
      'select_area_label': 'Select Area',
    },
    'hi': {
      'home_title': 'सिविक लिंक मुंबई',
      'home_tagline': 'अपने शहर को बनाएँ, रिपोर्ट करें, और इससे जुड़ें।',
      'quick_open': 'खोलने के लिए टैप करें',
      'weather': 'मौसम',
      'bills': 'बिल',
      'tourist_spots': 'पर्यटन स्थल',
      'raise_complaint': 'शिकायत दर्ज करें',
      'my_complaints': 'मेरी शिकायतें',
      'announcements': 'घोषणाएँ',
      'discover_city': 'मुंबई की खोज करें',
      'city_description': 'स्थानीय सेवाओं, शहर की घटनाओं और पर्यटन मार्गों को एक्सप्लोर करें।',
      'search_hint': 'पर्यटन स्थलों को खोजें...',
      'select_area': 'क्षेत्र चुनें',
      'no_places_found': 'कोई पर्यटन स्थल नहीं मिला',
      'issue_title': 'समस्या शीर्षक',
      'describe_issue': 'समस्या का वर्णन करें',
      'upload_photo': 'फोटो अपलोड करें',
      'submit_complaint': 'शिकायत भेजें',
      'announcement_title': 'शीर्षक',
      'announcement_message': 'संदेश',
      'post_announcement': 'घोषणा पोस्ट करें',
      'select_area_label': 'क्षेत्र चुनें',
      'language_label': 'भाषा',
    },
    'mr': {
      'home_title': 'सिव्हिक लिंक मुंबई',
      'home_tagline': 'आपल्या शहराचे बांधकाम, अहवाल, आणि संपर्क करा.',
      'quick_open': 'उघडण्यासाठी टॅप करा',
      'weather': 'हवामान',
      'bills': 'बिल',
      'tourist_spots': 'पर्यटन ठिकाणे',
      'raise_complaint': 'तक्रार नोंदवा',
      'my_complaints': 'माझ्या तक्रारी',
      'announcements': 'जाहीराती',
      'discover_city': 'मुंबईची शोध घ्या',
      'city_description': 'स्थानिक सेवा, शहरातील कार्यक्रम आणि पर्यटन मार्गांची अन्वेषण करा.',
      'search_hint': 'पर्यटन ठिकाणे शोधा...',
      'select_area': 'क्षेत्र निवडा',
      'no_places_found': 'कोणतीही पर्यटन ठिकाणे सापडली नाहीत',
      'issue_title': 'समस्या शीर्षक',
      'describe_issue': 'समस्येचे वर्णन करा',
      'upload_photo': 'फोटो अपलोड करा',
      'submit_complaint': 'तक्रार सबमिट करा',
      'announcement_title': 'शिर्षक',
      'announcement_message': 'संदेश',
      'post_announcement': 'जाहीरात पोस्ट करा',
      'select_area_label': 'क्षेत्र निवडा',
      'language_label': 'भाषा',
    },
  };

  String t(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key] ??
        key;
  }

  static AppLocalizations of(BuildContext context) {
    final localization = Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(localization != null, 'No AppLocalizations found in context');
    return localization!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations._localizedValues.keys.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
