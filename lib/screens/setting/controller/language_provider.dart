import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_provider.g.dart';

@riverpod
class LanguageNotifier extends _$LanguageNotifier {
  static const String _languageKey = 'selected_language';

  @override
  Locale build() {
    _loadSavedLanguage();
    return const Locale('vi');
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_languageKey) ?? 'vi';
      state = Locale(savedLanguage);
    } catch (e) {
      print('Error loading saved language: $e');
      state = const Locale('vi');
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
      state = Locale(languageCode);
    } catch (e) {
      print('Error saving language preference: $e');
    }
  }

  Future<void> toggleLanguage() async {
    final newLanguage = state.languageCode == 'vi' ? 'en' : 'vi';
    await changeLanguage(newLanguage);
  }

  String get currentLanguageName {
    return state.languageCode == 'vi' ? 'Tiếng Việt' : 'English';
  }

  String get currentLanguageCode => state.languageCode;
}