import 'package:flutter/material.dart';
import 'dart:ui'; // Add this import for ImageFilter
import 'package:provider/provider.dart';
import 'package:flutter_gen_ai_chat_ui/src/utils/color_extensions.dart';

import '../../../models/app_state.dart';

/// Settings drawer for the advanced example with extensive customization options
class AdvancedSettingsDrawer extends StatelessWidget {
  const AdvancedSettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      width: 340,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
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
              color: Colors.black.withOpacityCompat(isDark ? 0.4 : 0.15),
              blurRadius: 25,
              offset: const Offset(-8, 0),
            ),
          ],
          border: Border.all(
            color: isDark
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
                    _buildSwitchTile(
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
                    _buildSwitchTile(
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
                    _buildSwitchTile(
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
                    _buildSwitchTile(
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
                    _buildSwitchTile(
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
                    _buildSwitchTile(
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
                    _buildSliderTile(
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
                    _buildSliderTile(
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

                    // About section
                    _buildSectionHeader(context, 'About'),
                    _buildInfoTile(
                      context: context,
                      title: 'Flutter Gen AI Chat UI',
                      subtitle: 'A customizable AI chat interface for Flutter',
                      icon: Icons.info_outline_rounded,
                      color: colorScheme.primary,
                    ),
                    _buildInfoTile(
                      context: context,
                      title: 'Reset Settings',
                      subtitle: 'Restore default settings',
                      icon: Icons.restore_rounded,
                      color: Colors.red,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Reset Settings?'),
                            content: const Text(
                              'This will restore all settings to their default values.',
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

              // Footer
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Advanced Example v1.0.0',
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 12,
                      ),
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

  /// Header section of the settings drawer
  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primary
                .withBlue((colorScheme.primary.blue + 40).clamp(0, 255)),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacityCompat(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacityCompat(0.2),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Customize your chat experience',
            style: TextStyle(
              color: Colors.white.withOpacityCompat(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Section header
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 24, bottom: 8, right: 20),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  /// Switch setting tile
  Widget _buildSwitchTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
    required Color color,
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
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: color,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Slider setting tile
  Widget _buildSliderTile({
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

  /// Info tile
  Widget _buildInfoTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
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
        trailing: onTap != null
            ? Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context).colorScheme.primary,
              )
            : null,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
