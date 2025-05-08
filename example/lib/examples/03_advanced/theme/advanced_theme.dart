import 'package:flutter/material.dart';

/// Custom theme provider for the advanced example
/// Provides custom colors and theme options
class AdvancedTheme extends InheritedWidget {
  final Color gradientStart;
  final Color gradientEnd;
  final Color userBubbleColor;
  final Color aiBubbleColor;
  final Color userTextColor;
  final Color aiTextColor;
  final Color inputBackground;
  final Color sendButtonColor;
  final Color codeBlockBackground;
  final Color shimmerBaseColor;
  final Color shimmerHighlightColor;

  const AdvancedTheme({
    super.key,
    required super.child,
    required this.gradientStart,
    required this.gradientEnd,
    required this.userBubbleColor,
    required this.aiBubbleColor,
    required this.userTextColor,
    required this.aiTextColor,
    required this.inputBackground,
    required this.sendButtonColor,
    required this.codeBlockBackground,
    required this.shimmerBaseColor,
    required this.shimmerHighlightColor,
  });

  /// Light theme
  factory AdvancedTheme.light({required Widget child}) {
    return AdvancedTheme(
      gradientStart: const Color(0xFFEBF4FF),
      gradientEnd: const Color(0xFFF5F8FF),
      userBubbleColor: const Color(0xFF2979FF),
      aiBubbleColor: const Color(0xFFF5F8FF),
      userTextColor: Colors.white,
      aiTextColor: const Color(0xFF202124),
      inputBackground: const Color(0xFFEBF4FF),
      sendButtonColor: const Color(0xFF2979FF),
      codeBlockBackground: const Color(0xFFF6F8FA),
      shimmerBaseColor: Colors.grey[300]!,
      shimmerHighlightColor: Colors.grey[100]!,
      child: child,
    );
  }

  /// Dark theme
  factory AdvancedTheme.dark({required Widget child}) {
    return AdvancedTheme(
      gradientStart: const Color(0xFF121212),
      gradientEnd: const Color(0xFF1E1E1E),
      userBubbleColor: const Color(0xFF2979FF),
      aiBubbleColor: const Color(0xFF2D2D2D),
      userTextColor: Colors.white,
      aiTextColor: const Color(0xFFEBEBEB),
      inputBackground: const Color(0xFF2D2D2D),
      sendButtonColor: const Color(0xFF2979FF),
      codeBlockBackground: const Color(0xFF2D2D2D),
      shimmerBaseColor: Colors.grey[800]!,
      shimmerHighlightColor: Colors.grey[700]!,
      child: child,
    );
  }

  static AdvancedTheme of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AdvancedTheme>();
    assert(result != null, 'No AdvancedTheme found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AdvancedTheme oldWidget) {
    return gradientStart != oldWidget.gradientStart ||
        gradientEnd != oldWidget.gradientEnd ||
        userBubbleColor != oldWidget.userBubbleColor ||
        aiBubbleColor != oldWidget.aiBubbleColor ||
        userTextColor != oldWidget.userTextColor ||
        aiTextColor != oldWidget.aiTextColor ||
        inputBackground != oldWidget.inputBackground ||
        sendButtonColor != oldWidget.sendButtonColor ||
        codeBlockBackground != oldWidget.codeBlockBackground ||
        shimmerBaseColor != oldWidget.shimmerBaseColor ||
        shimmerHighlightColor != oldWidget.shimmerHighlightColor;
  }
}

/// Theme provider widget for the advanced example
class AdvancedThemeProvider extends StatelessWidget {
  final Widget child;
  final ThemeMode? themeMode;

  const AdvancedThemeProvider({
    super.key,
    required this.child,
    this.themeMode,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = themeMode == ThemeMode.dark
        ? Brightness.dark
        : (themeMode == ThemeMode.light
            ? Brightness.light
            : Theme.of(context).brightness);

    return brightness == Brightness.dark
        ? AdvancedTheme.dark(child: child)
        : AdvancedTheme.light(child: child);
  }
}
