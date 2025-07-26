import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

import '../models/app_state.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      width: 340,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [const Color(0xFF1F2937), const Color(0xFF111827)]
                : [const Color(0xFFFFFFFF), const Color(0xFFF8FAFC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            bottomLeft: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacityCompat(isDarkMode ? 0.4 : 0.15),
              blurRadius: 25,
              offset: const Offset(-8, 0),
            ),
          ],
          border: Border.all(
            color: isDarkMode 
                ? Colors.white.withOpacityCompat(0.1) 
                : Colors.black.withOpacityCompat(0.05),
            width: 1,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Column(
            children: [
              _buildHeader(context),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildSectionHeader(context, 'Display Settings'),
                    _buildAnimatedSettingTile(
                      context: context,
                      title: 'Dark Mode',
                      subtitle: 'Toggle between light and dark themes',
                      value: appState.themeMode == ThemeMode.dark,
                      onChanged: (value) {
                        appState.toggleTheme();
                      },
                      icon: Icons.dark_mode_rounded,
                      color: Colors.amber,
                    ),
                    const Divider(indent: 72, endIndent: 20),

                    _buildSectionHeader(context, 'Chat Features'),
                    _buildAnimatedSettingTile(
                      context: context,
                      title: 'Text Streaming',
                      subtitle: 'Enable word-by-word streaming of responses',
                      value: appState.isStreaming,
                      onChanged: (value) {
                        appState.toggleStreaming();
                      },
                      icon: Icons.text_format_rounded,
                      color: colorScheme.primary,
                    ),
                    _buildAnimatedSettingTile(
                      context: context,
                      title: 'Animations',
                      subtitle: 'Enable animations throughout the UI',
                      value: appState.enableAnimation,
                      onChanged: (value) {
                        appState.toggleAnimation();
                      },
                      icon: Icons.animation_rounded,
                      color: colorScheme.tertiary,
                    ),
                    _buildAnimatedSettingTile(
                      context: context,
                      title: 'Code Blocks',
                      subtitle: 'Enable code block formatting in responses',
                      value: appState.showCodeBlocks,
                      onChanged: (value) {
                        appState.toggleCodeBlocks();
                      },
                      icon: Icons.code_rounded,
                      color: colorScheme.secondary,
                    ),
                    _buildAnimatedSettingTile(
                      context: context,
                      title: 'Welcome Message',
                      subtitle: 'Show welcome message on startup',
                      value: appState.showWelcomeMessage,
                      onChanged: (value) {
                        appState.toggleWelcomeMessage();
                      },
                      icon: Icons.chat_bubble_outline_rounded,
                      color: Colors.green,
                    ),
                    _buildAnimatedSettingTile(
                      context: context,
                      title: 'Persistent Questions',
                      subtitle:
                          'Keep example questions visible after selection',
                      value: appState.persistentExampleQuestions,
                      onChanged: (value) {
                        appState.togglePersistentExampleQuestions();
                      },
                      icon: Icons.question_answer_rounded,
                      color: Colors.orange,
                    ),
                    const Divider(indent: 72, endIndent: 20),

                    // UI Customization
                    _buildSectionHeader(context, 'UI Customization'),
                    _buildSliderSettingTile(
                      context: context,
                      title: 'Chat Width',
                      subtitle: 'Maximum width of the chat interface',
                      value: appState.chatMaxWidth,
                      min: 600,
                      max: 1200,
                      divisions: 6,
                      onChanged: (value) {
                        appState.setChatMaxWidth(value);
                      },
                      icon: Icons.width_normal_rounded,
                      color: colorScheme.primary,
                    ),
                    _buildSliderSettingTile(
                      context: context,
                      title: 'Font Size',
                      subtitle: 'Size of text in messages',
                      value: appState.fontSize,
                      min: 12,
                      max: 18,
                      divisions: 6,
                      onChanged: (value) {
                        appState.setFontSize(value);
                      },
                      icon: Icons.format_size_rounded,
                      color: colorScheme.secondary,
                    ),
                    _buildSliderSettingTile(
                      context: context,
                      title: 'Bubble Radius',
                      subtitle: 'Roundness of message bubbles',
                      value: appState.messageBorderRadius,
                      min: 8,
                      max: 24,
                      divisions: 8,
                      onChanged: (value) {
                        appState.setMessageBorderRadius(value);
                      },
                      icon: Icons.rounded_corner,
                      color: colorScheme.tertiary,
                    ),
                    const Divider(indent: 72, endIndent: 20),

                    // Help section
                    _buildSectionHeader(context, 'Help & About'),
                    _buildInfoTile(
                      context: context,
                      title: 'About Dila Assistant',
                      subtitle: 'Learn more about Flutter Gen AI Chat UI',
                      icon: Icons.info_outline_rounded,
                      color: colorScheme.primary,
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'Dila Assistant Demo',
                          applicationVersion: '1.0.0',
                          applicationIcon: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.chat_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                          applicationLegalese: '© 2023 Flutter Gen AI Chat UI',
                          children: [
                            const SizedBox(height: 16),
                            Card(
                              elevation: 0,
                              color: isDarkMode
                                  ? Colors.white.withOpacityCompat(0.1)
                                  : colorScheme.primary.withOpacityCompat(0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'This demo showcases the features of the Flutter Gen AI Chat UI package, a customizable chat interface for AI applications.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Features:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    _buildFeatureItem(context, 'Modern Design'),
                                    _buildFeatureItem(
                                        context, 'Markdown Support'),
                                    _buildFeatureItem(
                                        context, 'Code Highlighting'),
                                    _buildFeatureItem(
                                        context, 'Streaming Text'),
                                    _buildFeatureItem(
                                        context, 'Dark Mode Support'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    _buildInfoTile(
                      context: context,
                      title: 'View Documentation',
                      subtitle: 'Read the package documentation',
                      icon: Icons.menu_book_rounded,
                      color: Colors.green,
                      onTap: () {
                        // TODO: Open documentation
                      },
                    ),
                    _buildInfoTile(
                      context: context,
                      title: 'Reset All Settings',
                      subtitle: 'Restore default settings',
                      icon: Icons.restore_rounded,
                      color: Colors.red,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Reset Settings?'),
                            content: const Text(
                              'This will restore all settings to their default values. This action cannot be undone.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('CANCEL'),
                              ),
                              FilledButton(
                                onPressed: () {
                                  appState.resetToDefaults();
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Settings reset to defaults'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                child: const Text('RESET'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Modern Footer
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [const Color(0xFF374151), const Color(0xFF1F2937)]
                        : [const Color(0xFFF1F5F9), const Color(0xFFE2E8F0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDarkMode 
                        ? Colors.white.withOpacityCompat(0.1) 
                        : Colors.black.withOpacityCompat(0.06),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Flutter Gen AI Chat UI',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
                                ),
                              ),
                              Text(
                                'Version 2.3.0',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDarkMode 
                                      ? Colors.white.withOpacityCompat(0.6) 
                                      : const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacityCompat(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacityCompat(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Configuration',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 26,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacityCompat(0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withOpacityCompat(0.2),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  iconSize: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Customize your Gen AI Chat UI experience with these settings',
            style: TextStyle(
              color: Colors.white.withOpacityCompat(0.85),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 28, bottom: 12, right: 24),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedSettingTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
    required Color color,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isDarkMode 
            ? Colors.white.withOpacityCompat(0.05) 
            : Colors.black.withOpacityCompat(0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode 
              ? Colors.white.withOpacityCompat(0.1) 
              : Colors.black.withOpacityCompat(0.06),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacityCompat(0.2),
                color.withOpacityCompat(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: color.withOpacityCompat(0.3),
              width: 1,
            ),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: isDarkMode ? Colors.white : const Color(0xFF1F2937),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isDarkMode 
                ? Colors.white.withOpacityCompat(0.7) 
                : const Color(0xFF64748B),
            height: 1.3,
          ),
        ),
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: color,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }

  Widget _buildSliderSettingTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacityCompat(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            trailing: Text(
              value.toStringAsFixed(0),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 72, right: 20, bottom: 8),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: color,
                inactiveTrackColor: color.withOpacityCompat(0.2),
                thumbColor: color,
                overlayColor: color.withOpacityCompat(0.2),
              ),
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: divisions,
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacityCompat(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: Theme.of(context).colorScheme.primary,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, String feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            feature,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
