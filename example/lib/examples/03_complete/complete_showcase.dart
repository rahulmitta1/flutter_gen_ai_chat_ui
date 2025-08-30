import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../../models/app_state.dart';
import '../../services/ai_service.dart' as example_ai;
import '../../widgets/advanced_settings_drawer.dart';
import '../../theme/advanced_theme.dart';

/// Complete showcase merging Advanced Chat + Essential AI + Advanced Theme + UI Gallery
/// Demonstrates all visual themes, comprehensive features, and UI components
class CompleteShowcase extends StatefulWidget {
  const CompleteShowcase({super.key});

  @override
  State<CompleteShowcase> createState() => _CompleteShowcaseState();
}

class _CompleteShowcaseState extends State<CompleteShowcase> {
  late ChatMessagesController _chatController;
  late example_ai.AiService _aiService;
  late ChatUser _currentUser;
  late ChatUser _aiUser;
  late ScrollController _scrollController;

  // State management
  bool _isGenerating = false;
  int _currentBubbleThemeIndex = 0;
  
  // Available bubble design themes (from Essential AI)
  final List<BubbleTheme> _bubbleThemes = [
    BubbleTheme.gradient(),
    BubbleTheme.neon(),
    BubbleTheme.glassmorphic(),
    BubbleTheme.elegant(),
    BubbleTheme.minimal(),
  ];

  // Advanced theme options (from Advanced Theme System)
  final List<ThemeOption> _advancedThemes = [
    ThemeOption(
      name: 'ChatGPT Style',
      description: 'OpenAI ChatGPT-inspired with vibrant green',
      primaryColor: const Color(0xFF10A37F),
      backgroundColor: const Color(0xFFF0F9F5),
      surfaceColor: const Color(0xFFE8F5E8),
      userBubbleColor: const Color(0xFF10A37F),
      aiBubbleColor: const Color(0xFFE8F5E8),
      brightness: Brightness.light,
    ),
    ThemeOption(
      name: 'Claude Style', 
      description: 'Anthropic Claude-inspired with warm orange',
      primaryColor: const Color(0xFFFF7A00),
      backgroundColor: const Color(0xFFFFF5E6),
      surfaceColor: const Color(0xFFFFE8CC),
      userBubbleColor: const Color(0xFFFF7A00),
      aiBubbleColor: const Color(0xFFFFE8CC),
      brightness: Brightness.light,
    ),
    ThemeOption(
      name: 'Cyber Dark',
      description: 'Futuristic cyber theme with neon green',
      primaryColor: const Color(0xFF00FF41),
      backgroundColor: const Color(0xFF0A0A0A),
      surfaceColor: const Color(0xFF1A1A1A),
      userBubbleColor: const Color(0xFF00FF41),
      aiBubbleColor: const Color(0xFF1A1A1A),
      brightness: Brightness.dark,
    ),
  ];

  int _currentAdvancedThemeIndex = 0;
  bool _useAdvancedThemes = false;

  // Example questions with different styles
  late final List<ExampleQuestion> _exampleQuestions;

  @override
  void initState() {
    super.initState();
    _initializeComponents();
    _setupExampleQuestions();
    _addWelcomeMessage();
  }

  void _initializeComponents() {
    _chatController = ChatMessagesController();
    _aiService = example_ai.AiService();
    _scrollController = ScrollController();
    
    _currentUser = ChatUser(
      id: 'user123',
      firstName: 'You',
      avatar: 'https://ui-avatars.com/api/?name=User&background=6366f1&color=fff',
    );

    _aiUser = ChatUser(
      id: 'ai123',
      firstName: 'Complete AI',
      avatar: 'https://ui-avatars.com/api/?name=AI&background=10b981&color=fff',
    );

    _chatController.setScrollController(_scrollController);
  }

  void _setupExampleQuestions() {
    _exampleQuestions = [
      ExampleQuestion(
        question: "Show me different bubble themes",
        config: ExampleQuestionConfig(
          iconData: Icons.bubble_chart,
          containerDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                Colors.purple.withOpacityCompat(0.1),
                Colors.blue.withOpacityCompat(0.1)
              ],
            ),
          ),
        ),
      ),
      ExampleQuestion(
        question: "Demonstrate advanced theming",
        config: ExampleQuestionConfig(
          iconData: Icons.palette,
          containerDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                Colors.green.withOpacityCompat(0.1),
                Colors.teal.withOpacityCompat(0.1)
              ],
            ),
          ),
        ),
      ),
      ExampleQuestion(
        question: "Show UI gallery components",
        config: ExampleQuestionConfig(
          iconData: Icons.widgets,
          containerDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                Colors.amber.withOpacityCompat(0.1),
                Colors.orange.withOpacityCompat(0.1)
              ],
            ),
          ),
        ),
      ),
      ExampleQuestion(
        question: "What are all your capabilities?",
        config: ExampleQuestionConfig(
          iconData: Icons.psychology,
          containerDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                Colors.pink.withOpacityCompat(0.1),
                Colors.red.withOpacityCompat(0.1)
              ],
            ),
          ),
        ),
      ),
    ];
  }

  void _addWelcomeMessage() {
    _chatController.addMessage(
      ChatMessage(
        text: _buildWelcomeMessage(),
        user: _aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
        customProperties: {'type': 'welcome'},
      ),
    );
  }

  String _buildWelcomeMessage() {
    return """
# Complete Showcase! 🎨✨

Welcome to the **ultimate demonstration** of Flutter Gen AI Chat UI capabilities! This example merges:

## 🎨 Visual Features
- **5 Bubble Themes**: Gradient, Neon, Glassmorphic, Elegant, Minimal
- **3 Advanced Themes**: ChatGPT, Claude, Cyber styles
- **50+ Theme Properties**: Complete customization system

## ⚡ Advanced Features
- **Streaming Responses** with word-by-word animation
- **Smart Scroll Behavior** for long conversations  
- **Rich Message Formatting** with markdown
- **Settings Panel** with all configurations
- **UI Gallery Components** showcase

## 🎯 Interactive Elements
- Switch bubble themes with top-right button
- Toggle between basic and advanced theming
- Explore settings drawer for full control
- Try different example questions

Ask me to demonstrate any feature or theme!
""";
  }

  Future<void> _handleSendMessage(ChatMessage message) async {
    _chatController.addMessage(message);
    
    // Handle special commands
    final text = message.text.toLowerCase();
    if (text.contains('bubble') || text.contains('theme')) {
      await _handleThemeDemo(message.text);
    } else if (text.contains('ui') || text.contains('component')) {
      await _handleUIGalleryDemo();
    } else {
      await _handleRegularResponse(message.text);
    }
  }

  Future<void> _handleThemeDemo(String originalText) async {
    setState(() => _isGenerating = true);
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Switch to next bubble theme
    _switchBubbleTheme();
    
    final currentTheme = _bubbleThemes[_currentBubbleThemeIndex];
    _chatController.addMessage(
      ChatMessage(
        text: '🎨 **Theme switched to: ${currentTheme.name}**\n\n'
              'This demonstrates our advanced theming system with:\n'
              '• Custom bubble designs\n'
              '• Gradient backgrounds\n'
              '• Professional styling\n'
              '• Cross-platform optimization\n\n'
              'Notice how the entire interface adapts to the new theme!',
        user: _aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
      ),
    );
    
    setState(() => _isGenerating = false);
  }

  Future<void> _handleUIGalleryDemo() async {
    setState(() => _isGenerating = true);
    
    await Future.delayed(const Duration(milliseconds: 800));
    
    _chatController.addMessage(
      ChatMessage(
        text: '🔧 **UI Gallery Components:**\n\n'
              '**Available Components:**\n'
              '• **AI Suggestions Bar** - Smart quick replies\n'
              '• **Result Renderers** - Structured data display\n'
              '• **Voice UI Wrappers** - Audio interaction elements\n'
              '• **Rich Message Content** - Enhanced message display\n'
              '• **Animated Widgets** - Smooth micro-interactions\n'
              '• **Smart Input Fields** - Intelligent text input\n\n'
              '**Integration Patterns:**\n'
              '• Professional AI components\n'
              '• Material Design 3 compliance\n'
              '• Accessibility optimized\n'
              '• Production-ready implementations\n\n'
              'These components work seamlessly with all theme variations!',
        user: _aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
      ),
    );
    
    setState(() => _isGenerating = false);
  }

  Future<void> _handleRegularResponse(String userText) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final useStreaming = appState.isStreaming;
    final messageId = 'msg_${DateTime.now().millisecondsSinceEpoch}';

    if (useStreaming) {
      final aiMessage = ChatMessage(
        text: "",
        user: _aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
        customProperties: {'id': messageId},
      );

      _chatController.addMessage(aiMessage);
      setState(() {
        _isGenerating = true;
      });

      try {
        final stream = _aiService.streamResponse(
          userText,
          includeCodeBlock: appState.showCodeBlocks,
        );

        await for (final text in stream) {
          final updatedMessage = aiMessage.copyWith(text: text);
          _chatController.updateMessage(updatedMessage);
        }
      } finally {
        setState(() {
          _isGenerating = false;
        });
      }
    } else {
      setState(() => _isGenerating = true);

      try {
        final response = await _aiService.generateResponse(
          userText,
          includeCodeBlock: appState.showCodeBlocks,
        );

        _chatController.addMessage(
          ChatMessage(
            text: response.text,
            user: _aiUser,
            createdAt: DateTime.now(),
            isMarkdown: response.isMarkdown,
          ),
        );
      } finally {
        setState(() => _isGenerating = false);
      }
    }
  }

  void _switchBubbleTheme() {
    // Add smooth transition with haptic feedback
    HapticFeedback.lightImpact();
    setState(() {
      _currentBubbleThemeIndex = (_currentBubbleThemeIndex + 1) % _bubbleThemes.length;
    });
    
    // Show elegant theme name snackbar
    _showThemeChangedSnackBar(_bubbleThemes[_currentBubbleThemeIndex].name);
  }

  void _toggleAdvancedThemes() {
    HapticFeedback.mediumImpact();
    setState(() {
      _useAdvancedThemes = !_useAdvancedThemes;
      if (_useAdvancedThemes) {
        _currentAdvancedThemeIndex = (_currentAdvancedThemeIndex + 1) % _advancedThemes.length;
      }
    });
    
    // Show status feedback
    final message = _useAdvancedThemes 
        ? 'Advanced themes enabled' 
        : 'Standard themes enabled';
    _showThemeChangedSnackBar(message);
  }

  void _showThemeChangedSnackBar(String themeName) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.palette_outlined,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'Theme: $themeName',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Choose current theme
    final currentBubbleTheme = isDark 
        ? _bubbleThemes[_currentBubbleThemeIndex].darkVariant() 
        : _bubbleThemes[_currentBubbleThemeIndex];
    
    Widget chatWidget = _buildChatContent(appState, colorScheme, isDark, currentBubbleTheme);
    
    // Wrap with advanced theme if enabled
    if (_useAdvancedThemes) {
      final advancedTheme = _advancedThemes[_currentAdvancedThemeIndex];
      chatWidget = Theme(
        data: advancedTheme.themeData,
        child: chatWidget,
      );
    }

    return ChangeNotifierProvider(
      create: (context) => AdvancedThemeProvider(),
      child: Scaffold(
        body: Builder(
          builder: (context) {
            final advancedTheme = AdvancedTheme.of(context);

            return AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    advancedTheme?.gradientStart ?? Colors.blue,
                    advancedTheme?.gradientEnd ?? Colors.purple,
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _buildAppBar(appState, colorScheme, currentBubbleTheme),
                    ),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        switchInCurve: Curves.easeInOutCubic,
                        switchOutCurve: Curves.easeInOutCubic,
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: animation.drive(
                                Tween(begin: const Offset(0.0, 0.02), end: Offset.zero)
                                    .chain(CurveTween(curve: Curves.easeOutCubic)),
                              ),
                              child: child,
                            ),
                          );
                        },
                        child: Container(
                          key: ValueKey('$_currentBubbleThemeIndex\_$_useAdvancedThemes\_$_currentAdvancedThemeIndex'),
                          child: chatWidget,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        endDrawer: const AdvancedSettingsDrawer(),
      ),
    );
  }

  Widget _buildAppBar(AppState appState, ColorScheme colorScheme, BubbleTheme currentTheme) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Elegant back button
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.arrow_back_ios_rounded, 
                  color: colorScheme.onSurface,
                  size: 18,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Sophisticated title with animated theme indicator
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Complete Showcase',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    currentTheme.name,
                    key: ValueKey(currentTheme.name),
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Elegant floating action buttons
          _buildFloatingActionButton(
            icon: appState.themeMode == ThemeMode.dark
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
            onTap: appState.toggleTheme,
            tooltip: 'Toggle theme',
            colorScheme: colorScheme,
          ),
          
          const SizedBox(width: 12),
          
          _buildFloatingActionButton(
            icon: Icons.palette_rounded,
            onTap: _switchBubbleTheme,
            tooltip: 'Switch theme',
            colorScheme: colorScheme,
          ),
          
          const SizedBox(width: 12),
          
          _buildFloatingActionButton(
            icon: _useAdvancedThemes ? Icons.auto_awesome : Icons.auto_awesome_outlined,
            onTap: _toggleAdvancedThemes,
            tooltip: 'Advanced themes',
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
    required ColorScheme colorScheme,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          onHighlightChanged: (highlighted) {
            // Future: Add micro-interaction on press
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOutCubic,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                key: ValueKey(icon.codePoint),
                color: colorScheme.primary,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatContent(AppState appState, ColorScheme colorScheme, bool isDark, BubbleTheme currentTheme) {
    return AiChatWidget(
      currentUser: _currentUser,
      aiUser: _aiUser,
      controller: _chatController,
      onSendMessage: _handleSendMessage,
      scrollController: _scrollController,

      // Use current bubble theme styling
      messageOptions: MessageOptions(
        bubbleStyle: null, // Disable default bubble style
        decoration: currentTheme.messageDecoration,
        containerDecoration: currentTheme.userMessageDecoration,
        textStyle: currentTheme.messageTextStyle,
        aiTextColor: currentTheme.messageTextStyle?.color,
        userTextColor: currentTheme.userMessageTextStyle?.color,
        padding: currentTheme.messagePadding,
        showUserName: true,
        showTime: true,
        showCopyButton: true,
        markdownStyleSheet: MarkdownStyleSheet(
          p: TextStyle(
            fontSize: appState.fontSize,
            color: isDark ? Colors.white : Colors.black87,
          ),
          code: TextStyle(
            fontFamily: 'monospace',
            backgroundColor: isDark
                ? Colors.black.withOpacityCompat(0.3)
                : Colors.grey.withOpacityCompat(0.2),
          ),
        ),
      ),

      // Loading configuration
      loadingConfig: LoadingConfig(
        isLoading: _isGenerating && !appState.isStreaming,
        typingIndicatorColor: colorScheme.primary,
      ),

      // Example questions
      exampleQuestions: _exampleQuestions,
      persistentExampleQuestions: appState.persistentExampleQuestions,

      // Width constraint
      maxWidth: appState.chatMaxWidth,

      // Input customization with current theme
      inputOptions: InputOptions(
        decoration: currentTheme.inputDecoration,
        textStyle: currentTheme.inputTextStyle,
        sendButtonIcon: Icons.send_rounded,
      ),

      // Animation settings
      enableAnimation: appState.enableAnimation,
      enableMarkdownStreaming: appState.isStreaming,
      streamingDuration: const Duration(milliseconds: 15),

      // Pagination configuration
      paginationConfig: const PaginationConfig(
        enabled: true,
        loadingIndicatorOffset: 100,
      ),
    );
  }
}

// Bubble theme classes (from Essential AI example)
class BubbleTheme {
  final String name;
  final Color backgroundColor;
  final Color appBarColor;
  final Color appBarTextColor;
  final BoxDecoration messageDecoration;
  final BoxDecoration userMessageDecoration;
  final TextStyle messageTextStyle;
  final TextStyle userMessageTextStyle;
  final TextStyle inputTextStyle;
  final InputDecoration inputDecoration;
  final EdgeInsets messagePadding;
  final EdgeInsets messageMargin;
  final BorderRadius borderRadius;

  const BubbleTheme({
    required this.name,
    required this.backgroundColor,
    required this.appBarColor,
    required this.appBarTextColor,
    required this.messageDecoration,
    required this.userMessageDecoration,
    required this.messageTextStyle,
    required this.userMessageTextStyle,
    required this.inputTextStyle,
    required this.inputDecoration,
    required this.messagePadding,
    required this.messageMargin,
    required this.borderRadius,
  });

  BubbleTheme darkVariant() {
    switch (name) {
      case 'Gradient':
        return BubbleTheme.gradientDark();
      case 'Neon':
        return this; // Neon is already dark
      case 'Glassmorphic':
        return BubbleTheme.glassmorphicDark();
      case 'Elegant':
        return BubbleTheme.elegantDark();
      case 'Minimal':
        return BubbleTheme.minimalDark();
      default:
        return this;
    }
  }

  factory BubbleTheme.gradient() {
    return BubbleTheme(
      name: 'Gradient',
      backgroundColor: const Color(0xFFF8F9FA),
      appBarColor: const Color(0xFF667EEA),
      appBarTextColor: Colors.white,
      messageDecoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      userMessageDecoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9A9E), Color(0xFFFECFEF)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      messageTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
      userMessageTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
      inputTextStyle: const TextStyle(fontSize: 16),
      inputDecoration: InputDecoration(
        hintText: '🌈 Message with gradient magic...',
        filled: true,
        fillColor: const Color(0xFFF8F9FF),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
      messagePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      messageMargin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      borderRadius: BorderRadius.circular(18),
    );
  }

  factory BubbleTheme.neon() {
    return BubbleTheme(
      name: 'Neon',
      backgroundColor: const Color(0xFF0D1117),
      appBarColor: const Color(0xFF21262D),
      appBarTextColor: const Color(0xFF00D9FF),
      messageDecoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00D9FF), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D9FF).withValues(alpha: 0.5),
            blurRadius: 12,
          ),
        ],
      ),
      userMessageDecoration: BoxDecoration(
        color: const Color(0xFF2D1B69),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFF0080), width: 2),
      ),
      messageTextStyle: const TextStyle(color: Color(0xFF00D9FF), fontSize: 16),
      userMessageTextStyle: const TextStyle(color: Color(0xFFFF0080), fontSize: 16),
      inputTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
      inputDecoration: InputDecoration(
        hintText: '⚡ EXECUTE_COMMAND.exe',
        filled: true,
        fillColor: const Color(0xFF0A0A0A),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      messagePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      messageMargin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      borderRadius: BorderRadius.circular(16),
    );
  }

  factory BubbleTheme.glassmorphic() {
    return BubbleTheme(
      name: 'Glassmorphic',
      backgroundColor: const Color(0xFFF0F2F5),
      appBarColor: Colors.white.withValues(alpha: 0.8),
      appBarTextColor: const Color(0xFF2E3A59),
      messageDecoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      userMessageDecoration: BoxDecoration(
        color: const Color(0xFF007AFF).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      messageTextStyle: const TextStyle(color: Color(0xFF2E3A59), fontSize: 16),
      userMessageTextStyle: const TextStyle(color: Color(0xFF007AFF), fontSize: 16),
      inputTextStyle: const TextStyle(fontSize: 16, color: Color(0xFF2E3A59)),
      inputDecoration: InputDecoration(
        hintText: '🔮 Type through the glass...',
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      ),
      messagePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      messageMargin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      borderRadius: BorderRadius.circular(20),
    );
  }

  factory BubbleTheme.elegant() {
    return BubbleTheme(
      name: 'Elegant',
      backgroundColor: const Color(0xFFFAF9F7),
      appBarColor: const Color(0xFF2C2C2C),
      appBarTextColor: const Color(0xFFD4AF37),
      messageDecoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFD4AF37)),
      ),
      userMessageDecoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD4AF37), Color(0xFFE6C35C)],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      messageTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
      userMessageTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
      inputTextStyle: const TextStyle(fontSize: 16, color: Color(0xFF2C2C2C)),
      inputDecoration: InputDecoration(
        hintText: '💎 Craft your elegant message...',
        filled: true,
        fillColor: const Color(0xFFFFFCF7),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      messagePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      messageMargin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      borderRadius: BorderRadius.circular(15),
    );
  }

  factory BubbleTheme.minimal() {
    return BubbleTheme(
      name: 'Minimal',
      backgroundColor: Colors.white,
      appBarColor: Colors.white,
      appBarTextColor: const Color(0xFF1D1D1F),
      messageDecoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(12),
      ),
      userMessageDecoration: BoxDecoration(
        color: const Color(0xFF007AFF),
        borderRadius: BorderRadius.circular(12),
      ),
      messageTextStyle: const TextStyle(color: Color(0xFF1D1D1F), fontSize: 16),
      userMessageTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
      inputTextStyle: const TextStyle(fontSize: 16, color: Color(0xFF1D1D1F)),
      inputDecoration: InputDecoration(
        hintText: '🎯 Simple and clean...',
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
      ),
      messagePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      messageMargin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      borderRadius: BorderRadius.circular(12),
    );
  }

  // Dark variants
  factory BubbleTheme.gradientDark() {
    return BubbleTheme(
      name: 'Gradient',
      backgroundColor: const Color(0xFF1A1A1A),
      appBarColor: const Color(0xFF2A2A2A),
      appBarTextColor: const Color(0xFF667EEA),
      messageDecoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      userMessageDecoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B9D), Color(0xFFFF8E7F)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      messageTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
      userMessageTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
      inputTextStyle: const TextStyle(fontSize: 16, color: Colors.white),
      inputDecoration: InputDecoration(
        hintText: '🌈 Message with gradient magic...',
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
      messagePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      messageMargin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      borderRadius: BorderRadius.circular(18),
    );
  }

  factory BubbleTheme.glassmorphicDark() {
    return BubbleTheme(
      name: 'Glassmorphic',
      backgroundColor: const Color(0xFF0F0F23),
      appBarColor: const Color(0xFF1A1A2E).withValues(alpha: 0.9),
      appBarTextColor: const Color(0xFF9D4EDD),
      messageDecoration: BoxDecoration(
        color: const Color(0xFF16213E).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      userMessageDecoration: BoxDecoration(
        color: const Color(0xFF7209B7).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      messageTextStyle: const TextStyle(color: Color(0xFFE0AAFF), fontSize: 16),
      userMessageTextStyle: const TextStyle(color: Color(0xFFE0AAFF), fontSize: 16),
      inputTextStyle: const TextStyle(fontSize: 16, color: Color(0xFFE0AAFF)),
      inputDecoration: InputDecoration(
        hintText: '🔮 Type through the glass...',
        filled: true,
        fillColor: const Color(0xFF16213E).withValues(alpha: 0.2),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      ),
      messagePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      messageMargin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      borderRadius: BorderRadius.circular(20),
    );
  }

  factory BubbleTheme.elegantDark() {
    return BubbleTheme(
      name: 'Elegant',
      backgroundColor: const Color(0xFF0A0A0A),
      appBarColor: const Color(0xFF1A1A1A),
      appBarTextColor: const Color(0xFFFFD700),
      messageDecoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFFFD700)),
      ),
      userMessageDecoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFC107)],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      messageTextStyle: const TextStyle(color: Color(0xFFFFD700), fontSize: 16),
      userMessageTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
      inputTextStyle: const TextStyle(fontSize: 16, color: Color(0xFFFFD700)),
      inputDecoration: InputDecoration(
        hintText: '💎 Craft your elegant message...',
        filled: true,
        fillColor: const Color(0xFF1A1A1A),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      messagePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      messageMargin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      borderRadius: BorderRadius.circular(15),
    );
  }

  factory BubbleTheme.minimalDark() {
    return BubbleTheme(
      name: 'Minimal',
      backgroundColor: const Color(0xFF000000),
      appBarColor: const Color(0xFF1C1C1E),
      appBarTextColor: Colors.white,
      messageDecoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
      ),
      userMessageDecoration: BoxDecoration(
        color: const Color(0xFF007AFF),
        borderRadius: BorderRadius.circular(12),
      ),
      messageTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
      userMessageTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
      inputTextStyle: const TextStyle(fontSize: 16, color: Colors.white),
      inputDecoration: InputDecoration(
        hintText: '🎯 Simple and clean...',
        filled: true,
        fillColor: const Color(0xFF1C1C1E),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
      ),
      messagePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      messageMargin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      borderRadius: BorderRadius.circular(12),
    );
  }
}

// Theme option class (from Advanced Theme System)
class ThemeOption {
  final String name;
  final String description;
  final Color primaryColor;
  final Color backgroundColor;
  final Color surfaceColor;
  final Color userBubbleColor;
  final Color aiBubbleColor;
  final Brightness brightness;

  ThemeOption({
    required this.name,
    required this.description,
    required this.primaryColor,
    required this.backgroundColor,
    required this.surfaceColor,
    required this.userBubbleColor,
    required this.aiBubbleColor,
    required this.brightness,
  });

  ThemeData get themeData => ThemeData(
    useMaterial3: true,
    brightness: brightness,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: brightness,
      surface: surfaceColor,
    ),
  );
}