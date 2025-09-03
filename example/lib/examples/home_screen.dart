import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';

/// The main navigation page for all Flutter Gen AI Chat UI examples
/// Now streamlined with 6 focused, comprehensive examples
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
                // Hero Demo - Featured first with special styling
                _buildHeroExampleCard(
                  context,
                  title: '🚀 Hero Demo',
                  description: 
                      '30-second showcase of unique features - streaming animations, live themes, file handling, and performance excellence!',
                  icon: Icons.auto_awesome_rounded,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  routeName: '/hero-demo',
                  isDark: isDark,
                  isHero: true,
                ),
                _buildModernExampleCard(
                  context,
                  title: 'Basic Chat',
                  description:
                      'Simple ChatGPT-style interface with essential messaging features',
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
                      'Claude-style UI with markdown rendering and streaming text responses',
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
                  title: 'Complete Showcase',
                  description:
                      'Advanced themes with 5 bubble styles, settings drawer, and comprehensive UI features',
                  icon: Icons.palette_rounded,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  routeName: '/complete-showcase',
                  isDark: isDark,
                ),
                _buildModernExampleCard(
                  context,
                  title: 'File & Media Chat',
                  description:
                      'Comprehensive file handling with mock previews and real device uploads',
                  icon: Icons.attach_file_rounded,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F766E), Color(0xFF06B6D4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  routeName: '/file-media-chat',
                  isDark: isDark,
                ),
                _buildModernExampleCard(
                  context,
                  title: 'Welcome Message Bug',
                  description:
                      'Reproduces issue #22: Welcome message overlay bug for testing and debugging',
                  icon: Icons.bug_report_rounded,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  routeName: '/welcome-bug',
                  isDark: isDark,
                ),
              ]),
            ),
          ),
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
                        'Flutter Package • Streamlined Examples',
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
                      'Some examples to see different features',
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
        ],
      ),
    );
  }

  Widget _buildHeroExampleCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required LinearGradient gradient,
    required String routeName,
    required bool isDark,
    bool isHero = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.15),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFFFD700).withOpacity(0.3),
          width: 2,
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
                // Special hero badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '⭐ FEATURED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Icon with special animation
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: gradient.colors.first.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 32),
                ),
                const SizedBox(height: 16),

                // Title with special styling
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Enhanced description
                Expanded(
                  child: Text(
                    description,
                    style: TextStyle(
                      color: isDark
                          ? Colors.white.withOpacity(0.9)
                          : const Color(0xFF64748B),
                      height: 1.5,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Call to action
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFFFD700).withOpacity(0.3),
                    ),
                  ),
                  child: const Text(
                    '▶ Start Demo',
                    style: TextStyle(
                      color: Color(0xFFFF8C00),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
                  maxLines: 2,
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
}
