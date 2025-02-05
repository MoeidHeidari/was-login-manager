import 'package:flutter/material.dart';

// Enum for theme values
enum AppTheme { dark, light }

class Apothems extends ChangeNotifier {
  AppTheme _currentTheme = AppTheme.light;

  AppTheme get currentTheme => _currentTheme;
  void toggleTheme() {
    _currentTheme = _currentTheme == AppTheme.light ? AppTheme.dark : AppTheme.light;
    notifyListeners();
  }

  void setTheme(AppTheme theme) {
    if (_currentTheme != theme) {
      _currentTheme = theme;
      notifyListeners();
    }
  }
}
