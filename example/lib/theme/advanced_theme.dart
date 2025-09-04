import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Advanced theme configuration for the chat UI
class AdvancedTheme {
  // Bubble Theme Types
  static const String gradient = 'gradient';
  static const String neon = 'neon';
  static const String glassmorphic = 'glassmorphic';
  static const String elegant = 'elegant';
  static const String minimal = 'minimal';

  // Theme configurations
  static final Map<String, ThemeData> themes = {
    gradient: _createGradientTheme(),
    neon: _createNeonTheme(),
    glassmorphic: _createGlassmorphicTheme(),
    elegant: _createElegantTheme(),
    minimal: _createMinimalTheme(),
  };

  static ThemeData _createGradientTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      colorScheme: const ColorScheme.light(
        primary: Colors.blue,
        secondary: Colors.purple,
        surface: Colors.white,
        onSurface: Colors.black87,
      ),
      cardTheme: const CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }

  static ThemeData _createNeonTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.cyan,
      colorScheme: const ColorScheme.dark(
        primary: Colors.cyan,
        secondary: Colors.pink,
        surface: Color(0xFF1A1A1A),
        onSurface: Colors.white,
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF2A2A2A),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }

  static ThemeData _createGlassmorphicTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.indigo,
      colorScheme: ColorScheme.light(
        primary: Colors.indigo.shade300,
        secondary: Colors.purple.shade200,
        surface: Colors.white.withOpacity(0.8),
        onSurface: Colors.black87,
      ),
      cardTheme: CardThemeData(
        color: Colors.white.withOpacity(0.2),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }

  static ThemeData _createElegantTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.brown,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF8D6E63),
        secondary: Color(0xFFD4AF37),
        surface: Color(0xFFFAF7F2),
        onSurface: Color(0xFF3E2723),
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFFFFFEFC),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }

  static ThemeData _createMinimalTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.grey,
      colorScheme: const ColorScheme.light(
        primary: Colors.black87,
        secondary: Colors.grey,
        surface: Colors.white,
        onSurface: Colors.black87,
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
    );
  }

  /// Get theme provider from context
  static AdvancedThemeProvider? of(BuildContext context) {
    try {
      return Provider.of<AdvancedThemeProvider>(context, listen: false);
    } catch (e) {
      return null;
    }
  }
}

/// Theme provider for managing advanced themes
class AdvancedThemeProvider extends ChangeNotifier {
  String _currentTheme = AdvancedTheme.gradient;
  bool _isDarkMode = false;

  String get currentTheme => _currentTheme;
  bool get isDarkMode => _isDarkMode;

  ThemeData get themeData {
    final baseTheme = AdvancedTheme.themes[_currentTheme] ??
        AdvancedTheme.themes[AdvancedTheme.gradient]!;

    if (_isDarkMode && baseTheme.brightness == Brightness.light) {
      return _createDarkVariant(baseTheme);
    }

    return baseTheme;
  }

  /// Get gradient start color based on current theme
  Color get gradientStart {
    switch (_currentTheme) {
      case AdvancedTheme.gradient:
        return _isDarkMode ? Colors.purple.shade900 : Colors.blue.shade300;
      case AdvancedTheme.neon:
        return _isDarkMode ? Colors.cyan.shade900 : Colors.cyan.shade300;
      case AdvancedTheme.glassmorphic:
        return _isDarkMode ? Colors.indigo.shade900 : Colors.indigo.shade100;
      case AdvancedTheme.elegant:
        return _isDarkMode ? const Color(0xFF5D4037) : const Color(0xFFBCAAA4);
      case AdvancedTheme.minimal:
        return _isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100;
      default:
        return _isDarkMode ? Colors.purple.shade900 : Colors.blue.shade300;
    }
  }

  /// Get gradient end color based on current theme
  Color get gradientEnd {
    switch (_currentTheme) {
      case AdvancedTheme.gradient:
        return _isDarkMode ? Colors.blue.shade900 : Colors.purple.shade300;
      case AdvancedTheme.neon:
        return _isDarkMode ? Colors.pink.shade900 : Colors.pink.shade300;
      case AdvancedTheme.glassmorphic:
        return _isDarkMode ? Colors.purple.shade900 : Colors.purple.shade100;
      case AdvancedTheme.elegant:
        return _isDarkMode ? const Color(0xFF3E2723) : const Color(0xFFD7CCC8);
      case AdvancedTheme.minimal:
        return _isDarkMode ? Colors.black : Colors.white;
      default:
        return _isDarkMode ? Colors.blue.shade900 : Colors.purple.shade300;
    }
  }

  void setTheme(String themeName) {
    if (_currentTheme != themeName &&
        AdvancedTheme.themes.containsKey(themeName)) {
      _currentTheme = themeName;
      notifyListeners();
    }
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setDarkMode(bool isDark) {
    if (_isDarkMode != isDark) {
      _isDarkMode = isDark;
      notifyListeners();
    }
  }

  ThemeData _createDarkVariant(ThemeData lightTheme) {
    return lightTheme.copyWith(
      brightness: Brightness.dark,
      colorScheme: lightTheme.colorScheme.copyWith(
        brightness: Brightness.dark,
        surface: const Color(0xFF1A1A1A),
        onSurface: Colors.white,
        primary: lightTheme.colorScheme.primary,
        secondary: lightTheme.colorScheme.secondary,
      ),
      cardTheme: lightTheme.cardTheme?.copyWith(
        color: const Color(0xFF2A2A2A),
      ),
    );
  }

  /// Get theme display name
  String getThemeDisplayName(String themeKey) {
    switch (themeKey) {
      case AdvancedTheme.gradient:
        return 'Gradient';
      case AdvancedTheme.neon:
        return 'Neon';
      case AdvancedTheme.glassmorphic:
        return 'Glassmorphic';
      case AdvancedTheme.elegant:
        return 'Elegant';
      case AdvancedTheme.minimal:
        return 'Minimal';
      default:
        return 'Unknown';
    }
  }

  /// Get all available theme keys
  List<String> get availableThemes => AdvancedTheme.themes.keys.toList();

  /// Get theme provider from context
  static AdvancedThemeProvider? of(BuildContext context) {
    try {
      return Provider.of<AdvancedThemeProvider>(context, listen: false);
    } catch (e) {
      return null;
    }
  }
}
