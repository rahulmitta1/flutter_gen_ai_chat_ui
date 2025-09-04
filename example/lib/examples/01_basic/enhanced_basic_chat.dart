import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:provider/provider.dart';

import '../../models/app_state.dart';
import '../../services/ai_service.dart' as example_ai;
// Import BubbleTheme from complete showcase (custom theme system)
import '../03_complete/complete_showcase.dart' show BubbleTheme;

/// Enhanced Basic Example: Clear value proposition with immediate feature discovery
/// This example solves the "generic ChatGPT clone" problem by showcasing unique features upfront
class EnhancedBasicChat extends StatefulWidget {
  const EnhancedBasicChat({super.key});

  @override
  State<EnhancedBasicChat> createState() => _EnhancedBasicChatState();
}

class _EnhancedBasicChatState extends State<EnhancedBasicChat>
    with TickerProviderStateMixin {
  late ChatMessagesController _chatController;
  late example_ai.AiService _aiService;
  late AnimationController _featurePulseController;
  late AnimationController _themeTransitionController;

  // Users
  final _currentUser = const ChatUser(id: 'user123', firstName: 'You');
  final _aiUser = const ChatUser(
    id: 'ai123',
    firstName: 'Flutter AI',
    avatar: 'https://ui-avatars.com/api/?name=AI&background=6366f1&color=fff',
  );

  // State
  bool _isGenerating = false;
  int _currentThemeIndex = 0;
  bool _showFeatureDiscovery = true;
  bool _streamingEnabled = true;

  // Available themes for instant switching
  final List<BubbleTheme> _quickThemes = [
    BubbleTheme.gradient(),
    BubbleTheme.glassmorphic(),
    BubbleTheme.elegant(),
    BubbleTheme.minimal(),
  ];

  // Feature discovery suggestions
  final List<FeatureSuggestion> _featureSuggestions = [
    FeatureSuggestion(
      icon: Icons.auto_awesome,
      title: 'Try Streaming',
      subtitle: 'Watch text appear word-by-word',
      action: 'Ask me anything to see streaming animation',
      color: Color(0xFF6366F1),
    ),
    FeatureSuggestion(
      icon: Icons.palette,
      title: 'Switch Themes',
      subtitle: 'Tap theme buttons above',
      action: 'Change the entire interface instantly',
      color: Color(0xFF8B5CF6),
    ),
    FeatureSuggestion(
      icon: Icons.speed,
      title: 'Performance',
      subtitle: 'Smooth 60fps scrolling',
      action: 'Send multiple messages to test',
      color: Color(0xFF10B981),
    ),
    FeatureSuggestion(
      icon: Icons.code,
      title: 'Rich Markdown',
      subtitle: 'Code blocks and formatting',
      action: 'Ask for code examples',
      color: Color(0xFFF59E0B),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeComponents();
    _addValuePropositionMessage();
  }

  void _initializeComponents() {
    _chatController = ChatMessagesController();
    _aiService = example_ai.AiService();

    _featurePulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _themeTransitionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  void _addValuePropositionMessage() {
    _chatController.addMessage(
      ChatMessage(
        text: '# Why Choose Flutter Gen AI Chat UI? 🚀\n\n'
            'Unlike other packages, we offer:\n\n'
            '✨ **Unique streaming animations** (word-by-word like ChatGPT)\n'
            '🎨 **Instant theme switching** (try the buttons above!)\n'
            '⚡ **60fps performance** with enterprise optimizations\n'
            '📱 **Production-ready** - ship these examples directly\n\n'
            '**Try the features below to see the difference!**',
        user: _aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
      ),
    );
  }

  Future<void> _handleSendMessage(ChatMessage message) async {
    // Hide feature discovery after first interaction
    if (_showFeatureDiscovery) {
      setState(() => _showFeatureDiscovery = false);
    }

    _chatController.addMessage(message);
    setState(() => _isGenerating = true);

    // Small delay for visual feedback
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final response = await _aiService.generateResponse(
        message.text,
        includeCodeBlock: true, // Enable rich content
      );

      setState(() => _isGenerating = false);
      await Future.delayed(const Duration(milliseconds: 100));

      // Add streaming response using the new system
      if (_streamingEnabled) {
        // Use the new streaming method
        _chatController.addStreamingMessage(
          ChatMessage(
            text: response.text,
            user: _aiUser,
            createdAt: DateTime.now(),
            isMarkdown: response.isMarkdown,
          ),
        );

        // Simulate completion after streaming
        final messageId = _chatController.getMessageId(
          ChatMessage(
            text: response.text,
            user: _aiUser,
            createdAt: DateTime.now(),
            isMarkdown: response.isMarkdown,
          ),
        );
        _chatController.simulateStreamingCompletion(
          messageId,
          delay: Duration(milliseconds: response.text.length * 30),
        );
      } else {
        // Add instant message
        _chatController.addMessage(
          ChatMessage(
            text: response.text,
            user: _aiUser,
            createdAt: DateTime.now(),
            isMarkdown: response.isMarkdown,
          ),
        );
      }
    } catch (error) {
      setState(() => _isGenerating = false);
      // Error handling
    }
  }

  void _switchTheme() {
    HapticFeedback.lightImpact();
    _themeTransitionController.forward().then((_) {
      setState(() {
        _currentThemeIndex = (_currentThemeIndex + 1) % _quickThemes.length;
      });
      _themeTransitionController.reverse();
    });

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎨 Theme: ${_quickThemes[_currentThemeIndex].name}'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleStreaming() {
    HapticFeedback.lightImpact();
    setState(() => _streamingEnabled = !_streamingEnabled);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _streamingEnabled
              ? '✨ Streaming animation enabled'
              : '⚡ Instant messages enabled',
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentTheme = _quickThemes[_currentThemeIndex];

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
                : [const Color(0xFFF8FAFC), const Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildEnhancedHeader(isDark, currentTheme),
              if (_showFeatureDiscovery) _buildFeatureDiscoveryPanel(isDark),
              Expanded(
                child: AnimatedBuilder(
                  animation: _themeTransitionController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 - (_themeTransitionController.value * 0.02),
                      child: _buildChatContent(appState, isDark, currentTheme),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedHeader(bool isDark, BubbleTheme currentTheme) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6366F1).withOpacity(0.9),
            const Color(0xFF8B5CF6).withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Package info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Flutter Gen AI Chat UI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Professional AI Chat Interface',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Close button
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Feature controls
          Row(
            children: [
              // Theme switcher
              Expanded(
                child: _buildFeatureButton(
                  'Theme: ${currentTheme.name}',
                  Icons.palette_rounded,
                  _switchTheme,
                  color: const Color(0xFFFFD700),
                ),
              ),
              const SizedBox(width: 12),

              // Streaming toggle
              Expanded(
                child: _buildFeatureButton(
                  _streamingEnabled ? 'Streaming On' : 'Instant Mode',
                  _streamingEnabled ? Icons.auto_awesome : Icons.flash_on,
                  _toggleStreaming,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Value proposition
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFFFD700),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'The only Flutter package with ChatGPT-style streaming animations',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureButton(
    String text,
    IconData icon,
    VoidCallback onPressed, {
    required Color color,
  }) {
    return AnimatedBuilder(
      animation: _featurePulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_featurePulseController.value * 0.03),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onPressed,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.3), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: color, size: 16),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        text,
                        style: const TextStyle(
                          color: Colors.white,
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
      },
    );
  }

  Widget _buildFeatureDiscoveryPanel(bool isDark) {
    return AnimatedBuilder(
      animation: _featurePulseController,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1F2937).withOpacity(0.8)
                : Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.tips_and_updates,
                    color: const Color(0xFF6366F1),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Try These Features',
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () =>
                        setState(() => _showFeatureDiscovery = false),
                    icon: Icon(
                      Icons.close,
                      size: 18,
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _featureSuggestions
                    .map(
                      (suggestion) =>
                          _buildFeatureSuggestionChip(suggestion, isDark),
                    )
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeatureSuggestionChip(
    FeatureSuggestion suggestion,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: suggestion.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: suggestion.color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(suggestion.icon, size: 16, color: suggestion.color),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                suggestion.title,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1F2937),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                suggestion.subtitle,
                style: TextStyle(
                  color: isDark ? Colors.white70 : const Color(0xFF6B7280),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatContent(
    AppState appState,
    bool isDark,
    BubbleTheme currentTheme,
  ) {
    return AiChatWidget(
      key: ValueKey(_currentThemeIndex),
      currentUser: _currentUser,
      aiUser: _aiUser,
      controller: _chatController,
      onSendMessage: _handleSendMessage,
      maxWidth: 700,

      // Loading state
      loadingConfig: LoadingConfig(
        isLoading: _isGenerating,
        typingIndicatorColor: const Color(0xFF6366F1),
      ),

      // Apply current theme
      messageOptions: MessageOptions(
        decoration: currentTheme.messageDecoration,
        containerDecoration: currentTheme.userMessageDecoration,
        textStyle: currentTheme.messageTextStyle,
        aiTextColor: currentTheme.messageTextStyle?.color,
        userTextColor: currentTheme.userMessageTextStyle?.color,
        padding: currentTheme.messagePadding,
        showUserName: false,
        showTime: false,
        showCopyButton: true,
      ),

      // Enhanced input
      inputOptions: InputOptions(
        decoration: currentTheme.inputDecoration?.copyWith(
              hintText: '💬 Ask anything to see streaming animation...',
            ) ??
            InputDecoration(
              hintText: '💬 Ask anything to see streaming animation...',
            ),
        textStyle: currentTheme.inputTextStyle,
        sendOnEnter: true,
      ),

      // Streaming configuration
      enableMarkdownStreaming: _streamingEnabled,
      streamingDuration: const Duration(milliseconds: 35),

      // Animation
      enableAnimation: true,
    );
  }

  @override
  void dispose() {
    _featurePulseController.dispose();
    _themeTransitionController.dispose();
    _chatController.dispose();
    super.dispose();
  }
}

// Supporting classes
class FeatureSuggestion {
  final IconData icon;
  final String title;
  final String subtitle;
  final String action;
  final Color color;

  FeatureSuggestion({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.action,
    required this.color,
  });
}
