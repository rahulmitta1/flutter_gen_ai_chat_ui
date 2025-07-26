import 'package:flutter/material.dart';

/// Application state for theme management and global settings
class AppState extends ChangeNotifier {
  // Theme settings
  ThemeMode _themeMode = ThemeMode.system;
  bool _isStreaming = true;
  bool _enableAnimation = true;
  bool _showWelcomeMessage = true;
  bool _showCodeBlocks = true;
  bool _persistentExampleQuestions = false;
  double _chatMaxWidth = 900;
  double _fontSize = 15;
  double _messageBorderRadius = 16;

  // Getters
  ThemeMode get themeMode => _themeMode;
  bool get isStreaming => _isStreaming;
  bool get enableAnimation => _enableAnimation;
  bool get showWelcomeMessage => _showWelcomeMessage;
  bool get showCodeBlocks => _showCodeBlocks;
  bool get persistentExampleQuestions => _persistentExampleQuestions;
  double get chatMaxWidth => _chatMaxWidth;
  double get fontSize => _fontSize;
  double get messageBorderRadius => _messageBorderRadius;

  // Theme management
  void toggleTheme() {
    switch (_themeMode) {
      case ThemeMode.light:
        _themeMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        _themeMode = ThemeMode.light; // Direct toggle between light and dark
        break;
      case ThemeMode.system:
        // When coming from system mode, switch to the opposite of current system theme
        _themeMode = ThemeMode.dark; // Default to dark when leaving system mode
        break;
    }
    notifyListeners();
  }

  // Get effective theme for UI icon display
  bool isDarkMode(BuildContext context) {
    switch (_themeMode) {
      case ThemeMode.light:
        return false;
      case ThemeMode.dark:
        return true;
      case ThemeMode.system:
        return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  // Feature toggles
  void toggleStreaming() {
    _isStreaming = !_isStreaming;
    notifyListeners();
  }

  void toggleAnimation() {
    _enableAnimation = !_enableAnimation;
    notifyListeners();
  }

  void toggleWelcomeMessage() {
    _showWelcomeMessage = !_showWelcomeMessage;
    notifyListeners();
  }

  void toggleCodeBlocks() {
    _showCodeBlocks = !_showCodeBlocks;
    notifyListeners();
  }

  void togglePersistentExampleQuestions() {
    _persistentExampleQuestions = !_persistentExampleQuestions;
    notifyListeners();
  }

  // UI settings
  void setChatMaxWidth(double width) {
    _chatMaxWidth = width;
    notifyListeners();
  }

  void setFontSize(double size) {
    _fontSize = size;
    notifyListeners();
  }

  void setMessageBorderRadius(double radius) {
    _messageBorderRadius = radius;
    notifyListeners();
  }

  // Reset all settings to defaults
  void resetToDefaults() {
    _themeMode = ThemeMode.system;
    _isStreaming = true;
    _enableAnimation = true;
    _showWelcomeMessage = true;
    _showCodeBlocks = true;
    _persistentExampleQuestions = false;
    _chatMaxWidth = 900;
    _fontSize = 15;
    _messageBorderRadius = 16;
    notifyListeners();
  }
}
