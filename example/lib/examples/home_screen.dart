import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';

/// The main navigation page for all Flutter Gen AI Chat UI examples
class ExamplesHomeScreen extends StatelessWidget {
  const ExamplesHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0f0f0f)
          : const Color(0xFFFAFAFA),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildModernHeader(context, appState, isDark),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildListDelegate([
                _buildModernExampleCard(
                  context,
                  title: 'UI Gallery',
                  description: 'New components: suggestions, results, voice UI',
                  icon: Icons.widgets_outlined,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF06B6D4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  routeName: '/ui-gallery',
                  isDark: isDark,
                ),
                _buildModernExampleCard(
                  context,
                  title: 'Basic',
                  description:
                      'Simple ChatGPT-style interface with essential features',
                  icon: Icons.chat_bubble_outline_rounded,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  routeName: '/basic',
                  isDark: isDark,
                ),
                _buildModernExampleCard(
                  context,
                  title: 'Intermediate',
                  description:
                      'Claude-style UI with markdown and streaming responses',
                  icon: Icons.auto_awesome_rounded,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF059669), Color(0xFF0D9488)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  routeName: '/intermediate',
                  isDark: isDark,
                ),
                _buildModernExampleCard(
                  context,
                  title: 'Advanced',
                  description:
                      'Full-featured chat with custom themes and animations',
                  icon: Icons.psychology_rounded,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C2D12), Color(0xFFDC2626)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  routeName: '/advanced',
                  isDark: isDark,
                ),
                _buildModernExampleCard(
                  context,
                  title: 'File Attachments',
                  description:
                      'Multi-media chat with image, document, and file support',
                  icon: Icons.attach_file_rounded,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F766E), Color(0xFF06B6D4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  routeName: '/file-attachments',
                  isDark: isDark,
                ),
                _buildModernExampleCard(
                  context,
                  title: 'Real File Upload',
                  description:
                      'Upload and process actual files from your device',
                  icon: Icons.cloud_upload_rounded,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFBE185D), Color(0xFFEC4899)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  routeName: '/real-file-upload',
                  isDark: isDark,
                ),
                _buildModernExampleCard(
                  context,
                  title: 'Scroll Behavior',
                  description: 'Advanced scroll control for long AI responses',
                  icon: Icons.swipe_vertical_rounded,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEA580C), Color(0xFFF59E0B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  routeName: '/scroll-behavior',
                  isDark: isDark,
                ),
                _buildModernExampleCard(
                  context,
                  title: 'AI Actions',
                  description:
                      'Function calling with parameter validation and UI rendering',
                  icon: Icons.functions_rounded,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9333EA), Color(0xFFC084FC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  routeName: '/ai-actions',
                  isDark: isDark,
                ),
                _buildModernExampleCard(
                  context,
                  title: 'Simple AI Actions',
                  description: 'Streamlined AI actions with clean integration patterns',
                  icon: Icons.auto_awesome,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF059669), Color(0xFF10B981)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  routeName: '/simple-ai-actions',
                  isDark: isDark,
                ),
                _buildModernExampleCard(
                  context,
                  title: 'Context Aware',
                  description:
                      'AI with application state awareness and smart actions',
                  icon: Icons.psychology_alt_rounded,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0EA5E9), Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  routeName: '/context-aware',
                  isDark: isDark,
                ),
                _buildModernExampleCard(
                  context,
                  title: 'CopilotKit Features',
                  description:
                      'Complete CopilotKit-inspired features: multi-chat, AI text input, agent orchestration',
                  icon: Icons.rocket_launch_rounded,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFDB2777), Color(0xFFFF6B6B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  routeName: '/advanced-features',
                  isDark: isDark,
                ),
                _buildModernExampleCard(
                  context,
                  title: 'Advanced Theme System',
                  description:
                      '50+ theme properties, gradient backgrounds, platform optimizations, ChatGPT/Claude/Gemini styles',
                  icon: Icons.palette_rounded,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  routeName: '/advanced-theme-showcase',
                  isDark: isDark,
                ),
              ]),
            ),
          ),
          SliverToBoxAdapter(child: _buildFooter(context, isDark)),
        ],
      ),
    );
  }

  Widget _buildModernHeader(
    BuildContext context,
    AppState appState,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        24.0,
        MediaQuery.of(context).padding.top + 16.0,
        24.0,
        32.0,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1F2937), const Color(0xFF111827)]
              : [const Color(0xFFFFFFFF), const Color(0xFFF8FAFC)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
            blurRadius: 20,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Flutter Package',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Gen AI Chat UI',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1F2937),
                            fontWeight: FontWeight.w800,
                            fontSize: 32,
                            letterSpacing: -0.5,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Interactive Examples Gallery',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isDark
                            ? Colors.white.withOpacity(0.7)
                            : const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Theme toggle button
              Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  onPressed: () => appState.toggleTheme(),
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      isDark
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      key: ValueKey(isDark),
                      color: isDark ? Colors.yellow : const Color(0xFF4F46E5),
                      size: 24,
                    ),
                  ),
                  tooltip: isDark
                      ? 'Switch to Light Theme'
                      : 'Switch to Dark Theme',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Explore powerful AI chat interfaces with streaming responses, markdown support, file attachments, and more. Each example demonstrates different capabilities of the Flutter Gen AI Chat UI package.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: isDark
                  ? Colors.white.withOpacity(0.8)
                  : const Color(0xFF64748B),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernExampleCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required LinearGradient gradient,
    required String routeName,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.pushNamed(context, routeName);
          },
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon with gradient background
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: gradient.colors.first.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(height: 14),

                // Title
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),

                // Description - Now with more space and better visibility
                Expanded(
                  child: Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? Colors.white.withOpacity(0.8)
                          : const Color(0xFF64748B),
                      height: 1.5,
                      fontSize: 14,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1F2937), const Color(0xFF111827)]
              : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: 32,
            color: isDark
                ? Colors.white.withOpacity(0.8)
                : const Color(0xFF64748B),
          ),
          const SizedBox(height: 12),
          Text(
            'Flutter Gen AI Chat UI',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: isDark ? Colors.white : const Color(0xFF1F2937),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Build powerful AI chat interfaces with streaming responses,\nmarkdown support, and customizable themes.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? Colors.white.withOpacity(0.7)
                  : const Color(0xFF64748B),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
