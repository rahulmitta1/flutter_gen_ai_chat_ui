import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/advanced_theme.dart';

/// Advanced settings drawer for theme and configuration management
class AdvancedSettingsDrawer extends StatelessWidget {
  const AdvancedSettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<AdvancedThemeProvider>(
        builder: (context, themeProvider, child) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.settings,
                      size: 48,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Advanced Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Theme Selection Section
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Bubble Theme',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              // Theme Options
              ...themeProvider.availableThemes.map((themeKey) {
                return RadioListTile<String>(
                  title: Text(themeProvider.getThemeDisplayName(themeKey)),
                  subtitle: _getThemeDescription(themeKey),
                  value: themeKey,
                  groupValue: themeProvider.currentTheme,
                  onChanged: (value) {
                    if (value != null) {
                      themeProvider.setTheme(value);
                    }
                  },
                );
              }).toList(),
              
              const Divider(),
              
              // Dark Mode Toggle
              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Toggle between light and dark theme'),
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.setDarkMode(value);
                },
                secondary: Icon(
                  themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                ),
              ),
              
              const Divider(),
              
              // Additional Settings
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Chat Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              ListTile(
                leading: const Icon(Icons.speed),
                title: const Text('Animation Speed'),
                subtitle: const Text('Adjust message animation speed'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showAnimationSpeedDialog(context);
                },
              ),
              
              ListTile(
                leading: const Icon(Icons.text_fields),
                title: const Text('Font Size'),
                subtitle: const Text('Adjust chat text size'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showFontSizeDialog(context);
                },
              ),
              
              ListTile(
                leading: const Icon(Icons.palette),
                title: const Text('Custom Colors'),
                subtitle: const Text('Customize chat bubble colors'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showColorCustomizationDialog(context);
                },
              ),
              
              const Divider(),
              
              // Reset Settings
              ListTile(
                leading: const Icon(Icons.restore, color: Colors.red),
                title: const Text(
                  'Reset to Defaults',
                  style: TextStyle(color: Colors.red),
                ),
                subtitle: const Text('Reset all settings to default values'),
                onTap: () {
                  _showResetConfirmationDialog(context, themeProvider);
                },
              ),
              
              // About
              const AboutListTile(
                icon: Icon(Icons.info),
                applicationName: 'AI Chat UI Demo',
                applicationVersion: '2.5.2',
                aboutBoxChildren: [
                  Text('Advanced chat UI components for AI applications.'),
                  Text('Built with Flutter and designed for seamless AI integration.'),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _getThemeDescription(String themeKey) {
    String description;
    switch (themeKey) {
      case AdvancedTheme.gradient:
        description = 'Colorful gradients with vibrant effects';
        break;
      case AdvancedTheme.neon:
        description = 'Bright neon colors with glow effects';
        break;
      case AdvancedTheme.glassmorphic:
        description = 'Transparent glass-like appearance';
        break;
      case AdvancedTheme.elegant:
        description = 'Sophisticated and professional styling';
        break;
      case AdvancedTheme.minimal:
        description = 'Clean and simple design';
        break;
      default:
        description = 'Custom theme configuration';
    }
    
    return Text(
      description,
      style: const TextStyle(fontSize: 12),
    );
  }

  void _showAnimationSpeedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Animation Speed'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose animation speed for message streaming:'),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Slow (50ms)'),
              leading: Radio(value: 50, groupValue: 30, onChanged: null),
            ),
            ListTile(
              title: const Text('Normal (30ms)'),
              leading: Radio(value: 30, groupValue: 30, onChanged: null),
            ),
            ListTile(
              title: const Text('Fast (15ms)'),
              leading: Radio(value: 15, groupValue: 30, onChanged: null),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showFontSizeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Font Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Adjust the font size for chat messages:'),
            const SizedBox(height: 16),
            Slider(
              value: 14,
              min: 12,
              max: 20,
              divisions: 8,
              label: '14pt',
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showColorCustomizationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Custom Colors'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Color customization is available in the premium version.'),
            SizedBox(height: 16),
            Text('Choose from predefined themes or create your own color palette.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmationDialog(BuildContext context, AdvancedThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text(
          'Are you sure you want to reset all settings to their default values? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Reset to default theme
              themeProvider.setTheme(AdvancedTheme.gradient);
              themeProvider.setDarkMode(false);
              Navigator.pop(context);
              
              // Show confirmation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings reset to defaults'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}