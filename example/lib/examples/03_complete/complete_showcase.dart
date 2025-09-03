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

/// Professional showcase demonstrating Flutter Gen AI Chat UI capabilities
/// with elegant design and sophisticated theming using the package's built-in systems
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
  int _currentThemeIndex = 0;

  // Professional theme collection using package's AdvancedChatTheme
  late final List<HarmonizedTheme> _themes;

  // Example questions with refined styling
  late final List<ExampleQuestion> _exampleQuestions;

  @override
  void initState() {
    super.initState();
    _initializeComponents();
    _setupThemes();
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
      avatar:
          'https://ui-avatars.com/api/?name=User&background=6366f1&color=fff',
    );

    _aiUser = ChatUser(
      id: 'ai123',
      firstName: 'AI Assistant',
      avatar: 'https://ui-avatars.com/api/?name=AI&background=10b981&color=fff',
    );

    _chatController.setScrollController(_scrollController);
  }

  void _setupThemes() {
    _themes = [
      HarmonizedTheme.modern(),
      HarmonizedTheme.classic(),
      HarmonizedTheme.minimal(),
      HarmonizedTheme.dark(),
      HarmonizedTheme.enterprise(),
    ];
  }

  void _setupExampleQuestions() {
    _exampleQuestions = [
      ExampleQuestion(
        question: "Show me theme variations",
        config: ExampleQuestionConfig(
          iconData: Icons.palette_outlined,
          containerDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.blue.withOpacity(0.08),
            border: Border.all(color: Colors.blue.withOpacity(0.2), width: 1),
          ),
        ),
      ),
      ExampleQuestion(
        question: "Demonstrate features",
        config: ExampleQuestionConfig(
          iconData: Icons.auto_awesome_outlined,
          containerDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.purple.withOpacity(0.08),
            border: Border.all(color: Colors.purple.withOpacity(0.2), width: 1),
          ),
        ),
      ),
      ExampleQuestion(
        question: "What can you do?",
        config: ExampleQuestionConfig(
          iconData: Icons.help_outline,
          containerDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.green.withOpacity(0.08),
            border: Border.all(color: Colors.green.withOpacity(0.2), width: 1),
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
# Welcome to Flutter Gen AI Chat UI

This showcase demonstrates the **professional capabilities** and **design flexibility** of our chat interface package.

## 🎨 **Design System**
- **5 Professional Themes**: Modern, Classic, Minimal, Dark, Enterprise
- **Sophisticated Typography**: Carefully crafted text hierarchies
- **Refined Color Palettes**: Professional and accessible color schemes
- **Consistent Spacing**: Systematic layout and spacing patterns

## ⚡ **Core Features**
- **Streaming Responses**: Real-time text generation with smooth animations
- **Smart Scrolling**: Intelligent conversation navigation
- **Rich Formatting**: Full markdown support with code highlighting
- **Responsive Design**: Adapts seamlessly across all screen sizes
- **Accessibility**: WCAG compliant with screen reader support

## 🔧 **Customization Options**
- **Theme Switching**: Dynamic theme changes with smooth transitions
- **Layout Control**: Flexible width, padding, and spacing options
- **Input Customization**: Tailored input fields and send buttons
- **Message Styling**: Custom bubble designs and typography

## 💼 **Professional Use Cases**
- **Customer Support**: Professional chat interfaces for businesses
- **AI Assistants**: Enterprise-grade AI conversation platforms
- **Team Collaboration**: Internal communication tools
- **Product Demos**: Interactive product showcases

*Try switching themes using the palette button, or ask me to demonstrate specific features.*
""";
  }

  Future<void> _handleSendMessage(ChatMessage message) async {
    _chatController.addMessage(message);

    final text = message.text.toLowerCase();
    if (text.contains('theme') || text.contains('design')) {
      await _handleThemeDemo();
    } else if (text.contains('feature') || text.contains('capability')) {
      await _handleFeatureDemo();
    } else {
      await _handleRegularResponse(message.text);
    }
  }

  Future<void> _handleThemeDemo() async {
    setState(() => _isGenerating = true);

    await Future.delayed(const Duration(milliseconds: 600));

    _switchTheme();

    final currentTheme = _themes[_currentThemeIndex];
    _chatController.addMessage(
      ChatMessage(
        text:
            '🎨 **Theme Updated: ${currentTheme.name}**\n\n'
            'This theme demonstrates our **harmonized design system**:\n\n'
            '• **Color Harmony**: ${currentTheme.description}\n'
            '• **Typography**: ${currentTheme.typographyDescription}\n'
            '• **Layout**: ${currentTheme.layoutDescription}\n\n'
            'Notice how the entire interface adapts consistently!',
        user: _aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
      ),
    );

    setState(() => _isGenerating = false);
  }

  Future<void> _handleFeatureDemo() async {
    setState(() => _isGenerating = true);

    await Future.delayed(const Duration(milliseconds: 800));

    _chatController.addMessage(
      ChatMessage(
        text:
            '✨ **Feature Demonstration**\n\n'
            '**Advanced Capabilities:**\n\n'
            '• **Streaming Text**: Real-time response generation\n'
            '• **Smart Scrolling**: Intelligent conversation navigation\n'
            '• **Markdown Support**: Rich text formatting and code blocks\n'
            '• **Theme System**: Dynamic visual customization\n'
            '• **Responsive Layout**: Adaptive design across devices\n\n'
            '**Professional Features:**\n\n'
            '• **Accessibility**: Screen reader and keyboard navigation\n'
            '• **Performance**: Optimized rendering and animations\n'
            '• **Customization**: Extensive theming and layout options\n'
            '• **Integration**: Seamless Flutter ecosystem compatibility',
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
      setState(() => _isGenerating = true);

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
        setState(() => _isGenerating = false);
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

  void _switchTheme() {
    HapticFeedback.lightImpact();
    setState(() {
      _currentThemeIndex = (_currentThemeIndex + 1) % _themes.length;
    });

    _showThemeChangedSnackBar(_themes[_currentThemeIndex].name);
  }

  void _showThemeChangedSnackBar(String themeName) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.palette_outlined, color: Colors.white, size: 18),
            const SizedBox(width: 12),
            Text(
              'Theme: $themeName',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: _themes[_currentThemeIndex].accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    final currentTheme = _themes[_currentThemeIndex];

    return ChangeNotifierProvider(
      create: (context) => AdvancedThemeProvider(),
      child: Theme(
        data: currentTheme.themeData,
        child: Builder(
          builder: (context) {
            return Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: currentTheme.advancedTheme.backgroundGradientBegin,
                    end: currentTheme.advancedTheme.backgroundGradientEnd,
                    colors: currentTheme.advancedTheme.backgroundGradient,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      _buildHarmonizedAppBar(appState, currentTheme),
                      Expanded(
                        child: _buildHarmonizedChatContent(
                          appState,
                          currentTheme,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              endDrawer: const AdvancedSettingsDrawer(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHarmonizedAppBar(
    AppState appState,
    HarmonizedTheme currentTheme,
  ) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: currentTheme.appBarGradient,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: currentTheme.advancedTheme.inputFieldBorderColor,
          width: 1,
        ),
        boxShadow: currentTheme.advancedTheme.floatingActionShadows,
      ),
      child: Row(
        children: [
          // Professional back button
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: currentTheme.advancedTheme.primaryActionColor,
                  size: 18,
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),

          // Refined title section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Complete Showcase (${_currentThemeIndex + 1}/${_themes.length})',
                  style: currentTheme.advancedTheme.typography.titleLarge
                      .copyWith(
                        color: currentTheme.advancedTheme.primaryActionColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentTheme.name,
                  style: currentTheme.advancedTheme.typography.bodyMedium
                      .copyWith(
                        color: currentTheme.advancedTheme.secondaryActionColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),

          // Professional action buttons
          _buildThemeSwitchButton(currentTheme),
        ],
      ),
    );
  }

  Widget _buildHarmonizedActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
    required HarmonizedTheme currentTheme,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: currentTheme.buttonGradient,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: currentTheme.advancedTheme.inputFieldBorderColor,
                width: 1,
              ),
              boxShadow: currentTheme.advancedTheme.floatingActionShadows,
            ),
            child: Icon(
              icon,
              color: currentTheme.advancedTheme.primaryActionColor,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeToggleButton(HarmonizedTheme currentTheme) {
    final appState = Provider.of<AppState>(context, listen: false);
    return _buildHarmonizedActionButton(
      icon: appState.themeMode == ThemeMode.dark
          ? Icons.light_mode_rounded
          : Icons.dark_mode_rounded,
      onTap: appState.toggleTheme,
      tooltip: 'Toggle theme mode',
      currentTheme: currentTheme,
    );
  }

  Widget _buildThemeSwitchButton(HarmonizedTheme currentTheme) {
    return _buildHarmonizedActionButton(
      icon: Icons.palette_rounded,
      onTap: _switchTheme,
      tooltip: 'Switch theme',
      currentTheme: currentTheme,
    );
  }

  Widget _buildSettingsButton(HarmonizedTheme currentTheme) {
    return Builder(
      builder: (context) => _buildHarmonizedActionButton(
        icon: Icons.settings_rounded,
        onTap: () => Scaffold.of(context).openEndDrawer(),
        tooltip: 'Settings',
        currentTheme: currentTheme,
      ),
    );
  }

  Widget _buildHarmonizedChatContent(
    AppState appState,
    HarmonizedTheme currentTheme,
  ) {
    return AiChatWidget(
      currentUser: _currentUser,
      aiUser: _aiUser,
      controller: _chatController,
      onSendMessage: _handleSendMessage,
      scrollController: _scrollController,

      // Use package's built-in theming system properly
      messageOptions: MessageOptions(
        // Use BubbleStyle for proper bubble theming
        bubbleStyle: currentTheme.bubbleStyle,

        // Additional message customization
        padding: currentTheme.messagePadding,
        showUserName: true,
        showTime: true,
        showCopyButton: true,

        // Custom markdown styling using package's typography
        markdownStyleSheet: MarkdownStyleSheet(
          h1: currentTheme.advancedTheme.typography.headlineLarge.copyWith(
            color: currentTheme.advancedTheme.primaryActionColor,
          ),
          h2: currentTheme.advancedTheme.typography.headlineMedium.copyWith(
            color: currentTheme.advancedTheme.primaryActionColor,
          ),
          h3: currentTheme.advancedTheme.typography.headlineSmall.copyWith(
            color: currentTheme.advancedTheme.primaryActionColor,
          ),
          p: currentTheme.advancedTheme.typography.messageBody.copyWith(
            fontSize: appState.fontSize,
          ),
          strong: currentTheme.advancedTheme.typography.messageBody.copyWith(
            fontWeight: FontWeight.w600,
            color: currentTheme.advancedTheme.primaryActionColor,
          ),
          code: currentTheme.advancedTheme.typography.inlineCode.copyWith(
            backgroundColor:
                currentTheme.advancedTheme.inputFieldGradient.first,
          ),
          blockquote: currentTheme.advancedTheme.typography.bodyMedium.copyWith(
            fontStyle: FontStyle.italic,
            color: currentTheme.advancedTheme.secondaryActionColor,
          ),
        ),
      ),

      // Loading configuration
      loadingConfig: LoadingConfig(
        isLoading: _isGenerating && !appState.isStreaming,
        typingIndicatorColor: currentTheme.advancedTheme.typingIndicatorColor,
      ),

      // Example questions
      exampleQuestions: _exampleQuestions,
      persistentExampleQuestions: appState.persistentExampleQuestions,

      // Width constraint
      maxWidth: appState.chatMaxWidth,

      // Professional input styling using package's theming
      inputOptions: InputOptions(
        decoration: currentTheme.inputDecoration,
        textStyle: currentTheme.advancedTheme.typography.inputText,
        sendButtonIcon: Icons.send_rounded,
        sendButtonColor: currentTheme.advancedTheme.primaryActionColor,
      ),

      // Animation settings
      enableAnimation: appState.enableAnimation,
      enableMarkdownStreaming: appState.isStreaming,
      streamingDuration: const Duration(milliseconds: 20),

      // Pagination configuration
      paginationConfig: const PaginationConfig(
        enabled: true,
        loadingIndicatorOffset: 100,
      ),
    );
  }
}

// Harmonized theme system using package's AdvancedChatTheme
class HarmonizedTheme {
  final String name;
  final String description;
  final String typographyDescription;
  final String layoutDescription;

  // Package theming - using AdvancedChatTheme properly
  final AdvancedChatTheme advancedTheme;
  final BubbleStyle bubbleStyle;
  final EdgeInsets messagePadding;
  final InputDecoration inputDecoration;

  // Harmonized gradients for consistent theming
  final List<Color> appBarGradient;
  final List<Color> buttonGradient;
  final Color accentColor;

  const HarmonizedTheme({
    required this.name,
    required this.description,
    required this.typographyDescription,
    required this.layoutDescription,
    required this.advancedTheme,
    required this.bubbleStyle,
    required this.messagePadding,
    required this.inputDecoration,
    required this.appBarGradient,
    required this.buttonGradient,
    required this.accentColor,
  });

  // Get Flutter ThemeData for consistent theming
  ThemeData get themeData => ThemeData(
    useMaterial3: true,
    brightness: _getBrightness(),
    primaryColor: advancedTheme.primaryActionColor,
    scaffoldBackgroundColor: advancedTheme.backgroundGradient.first,
    colorScheme: ColorScheme.fromSeed(
      seedColor: advancedTheme.primaryActionColor,
      brightness: _getBrightness(),
    ),
  );

  Brightness _getBrightness() {
    // Determine brightness based on background colors
    final firstColor = advancedTheme.backgroundGradient.first;
    final luminance = firstColor.computeLuminance();
    return luminance > 0.5 ? Brightness.light : Brightness.dark;
  }

  factory HarmonizedTheme.modern() {
    final theme =
        ChatThemeBuilder.fromBrand(
              primaryColor: const Color(0xFF3B82F6),
              secondaryColor: const Color(0xFF6366F1),
              backgroundColor: const Color(0xFFFAFBFC),
            )
            .withBackgroundGradient([
              const Color(0xFFFAFBFC),
              const Color(0xFFF1F5F9),
            ])
            .withMessageBubbleGradient([Colors.white, const Color(0xFFF8FAFC)])
            .withUserBubbleGradient([
              const Color(0xFF3B82F6),
              const Color(0xFF2563EB),
            ])
            .withShadows(
              messageBubbleShadows: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
              userBubbleShadows: [
                BoxShadow(
                  color: const Color(0xFF3B82F6).withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            )
            .build();

    return HarmonizedTheme(
      name: 'Modern',
      description:
          'Clean, contemporary design with subtle shadows and rounded corners',
      typographyDescription: 'Clear hierarchy with balanced font weights',
      layoutDescription: 'Generous spacing with consistent margins and padding',
      advancedTheme: theme,
      bubbleStyle: const BubbleStyle(
        userBubbleColor: Color(0xFF3B82F6),
        aiBubbleColor: Colors.white,
        userBubbleTopLeftRadius: 18,
        userBubbleTopRightRadius: 4,
        aiBubbleTopLeftRadius: 4,
        aiBubbleTopRightRadius: 18,
        bottomLeftRadius: 18,
        bottomRightRadius: 18,
        enableShadow: true,
        shadowOpacity: 0.08,
        shadowBlurRadius: 12,
        shadowOffset: Offset(0, 4),
      ),
      messagePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      inputDecoration: InputDecoration(
        hintText: 'Type your message...',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: const Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: const Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: const Color(0xFF3B82F6), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      appBarGradient: [Colors.white, const Color(0xFFF8F9FA)],
      buttonGradient: [const Color(0xFFF9FAFB), const Color(0xFFF3F4F6)],
      accentColor: const Color(0xFF3B82F6),
    );
  }

  factory HarmonizedTheme.classic() {
    final theme =
        ChatThemeBuilder.fromBrand(
              primaryColor: const Color(0xFFD4AF37),
              secondaryColor: const Color(0xFF8B7355),
              backgroundColor: const Color(0xFFF8F6F1),
            )
            .withBackgroundGradient([
              const Color(0xFFF8F6F1),
              const Color(0xFFF0E6D6),
            ])
            .withMessageBubbleGradient([Colors.white, const Color(0xFFFFFEFC)])
            .withUserBubbleGradient([
              const Color(0xFFD4AF37),
              const Color(0xFFB8941F),
            ])
            .withShadows(
              messageBubbleShadows: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
              userBubbleShadows: [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            )
            .build();

    return HarmonizedTheme(
      name: 'Classic',
      description:
          'Timeless design with traditional proportions and elegant typography',
      typographyDescription: 'Serif fonts with refined letter spacing',
      layoutDescription: 'Balanced proportions with golden ratio spacing',
      advancedTheme: theme,
      bubbleStyle: const BubbleStyle(
        userBubbleColor: Color(0xFFD4AF37),
        aiBubbleColor: Colors.white,
        userBubbleTopLeftRadius: 15,
        userBubbleTopRightRadius: 4,
        aiBubbleTopLeftRadius: 4,
        aiBubbleTopRightRadius: 15,
        bottomLeftRadius: 15,
        bottomRightRadius: 15,
        enableShadow: true,
        shadowOpacity: 0.12,
        shadowBlurRadius: 16,
        shadowOffset: Offset(0, 6),
      ),
      messagePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      inputDecoration: InputDecoration(
        hintText: 'Compose your message...',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: const Color(0xFFD4AF37)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: const Color(0xFFD4AF37)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: const Color(0xFFD4AF37), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
      ),
      appBarGradient: [const Color(0xFF2C2C2C), const Color(0xFF1A1A1A)],
      buttonGradient: [const Color(0xFFF0E6D6), const Color(0xFFE8DCC8)],
      accentColor: const Color(0xFFD4AF37),
    );
  }

  factory HarmonizedTheme.minimal() {
    final theme =
        ChatThemeBuilder.fromBrand(
              primaryColor: const Color(0xFF007BFF),
              secondaryColor: const Color(0xFF6C757D),
              backgroundColor: Colors.white,
            )
            .withBackgroundGradient([Colors.white, const Color(0xFFF8F9FA)])
            .withMessageBubbleGradient([
              const Color(0xFFF8F9FA),
              const Color(0xFFF1F3F4),
            ])
            .withUserBubbleGradient([
              const Color(0xFF007BFF),
              const Color(0xFF0056CC),
            ])
            .withShadows(
              messageBubbleShadows: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
              userBubbleShadows: [
                BoxShadow(
                  color: const Color(0xFF007BFF).withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            )
            .build();

    return HarmonizedTheme(
      name: 'Minimal',
      description: 'Essential elements with maximum whitespace and clean lines',
      typographyDescription: 'Simple sans-serif with generous line height',
      layoutDescription: 'Ample breathing room with minimal visual noise',
      advancedTheme: theme,
      bubbleStyle: const BubbleStyle(
        userBubbleColor: Color(0xFF007BFF),
        aiBubbleColor: const Color(0xFFF8F9FA),
        userBubbleTopLeftRadius: 12,
        userBubbleTopRightRadius: 4,
        aiBubbleTopLeftRadius: 4,
        aiBubbleTopRightRadius: 12,
        bottomLeftRadius: 12,
        bottomRightRadius: 12,
        enableShadow: false,
      ),
      messagePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      inputDecoration: InputDecoration(
        hintText: 'Message...',
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      appBarGradient: [const Color(0xFFF8F9FA), const Color(0xFFE9ECEF)],
      buttonGradient: [const Color(0xFFF8F9FA), const Color(0xFFE9ECEF)],
      accentColor: const Color(0xFF007BFF),
    );
  }

  factory HarmonizedTheme.dark() {
    final theme =
        ChatThemeBuilder.fromBrand(
              primaryColor: const Color(0xFF00D4FF),
              secondaryColor: const Color(0xFF999999),
              backgroundColor: const Color(0xFF0A0A0A),
            )
            .withBackgroundGradient([
              const Color(0xFF0A0A0A),
              const Color(0xFF1A1A1A),
            ])
            .withMessageBubbleGradient([
              const Color(0xFF1A1A1A),
              const Color(0xFF2D2D2D),
            ])
            .withUserBubbleGradient([
              const Color(0xFF00D4FF),
              const Color(0xFF0099CC),
            ])
            .withShadows(
              messageBubbleShadows: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              userBubbleShadows: [
                BoxShadow(
                  color: const Color(0xFF00D4FF).withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            )
            .build();

    return HarmonizedTheme(
      name: 'Dark',
      description:
          'Sophisticated dark theme with high contrast and modern aesthetics',
      typographyDescription: 'High contrast text with careful color balance',
      layoutDescription: 'Strategic use of shadows and depth',
      advancedTheme: theme,
      bubbleStyle: const BubbleStyle(
        userBubbleColor: Color(0xFF00D4FF),
        aiBubbleColor: const Color(0xFF1A1A1A),
        userBubbleTopLeftRadius: 18,
        userBubbleTopRightRadius: 4,
        aiBubbleTopLeftRadius: 4,
        aiBubbleTopRightRadius: 18,
        bottomLeftRadius: 18,
        bottomRightRadius: 18,
        enableShadow: true,
        shadowOpacity: 0.3,
        shadowBlurRadius: 8,
        shadowOffset: Offset(0, 2),
      ),
      messagePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      inputDecoration: InputDecoration(
        hintText: 'Type your message...',
        filled: true,
        fillColor: const Color(0xFF1A1A1A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: const Color(0xFF333333)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: const Color(0xFF333333)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: const Color(0xFF00D4FF), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      appBarGradient: [const Color(0xFF1A1A1A), const Color(0xFF0A0A0A)],
      buttonGradient: [const Color(0xFF1A1A1A), const Color(0xFF0A0A0A)],
      accentColor: const Color(0xFF00D4FF),
    );
  }

  factory HarmonizedTheme.enterprise() {
    final theme =
        ChatThemeBuilder.fromBrand(
              primaryColor: const Color(0xFF3498DB),
              secondaryColor: const Color(0xFF7F8C8D),
              backgroundColor: const Color(0xFFF5F7FA),
            )
            .withBackgroundGradient([
              const Color(0xFFF5F7FA),
              const Color(0xFFECF0F1),
            ])
            .withMessageBubbleGradient([Colors.white, const Color(0xFFF8F9FA)])
            .withUserBubbleGradient([
              const Color(0xFF3498DB),
              const Color(0xFF2980B9),
            ])
            .withShadows(
              messageBubbleShadows: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              userBubbleShadows: [
                BoxShadow(
                  color: const Color(0xFF3498DB).withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            )
            .build();

    return HarmonizedTheme(
      name: 'Enterprise',
      description:
          'Corporate design with structured layout and professional color scheme',
      typographyDescription:
          'Clear hierarchy optimized for business applications',
      layoutDescription: 'Structured grid system with consistent spacing',
      advancedTheme: theme,
      bubbleStyle: const BubbleStyle(
        userBubbleColor: Color(0xFF3498DB),
        aiBubbleColor: Colors.white,
        userBubbleTopLeftRadius: 12,
        userBubbleTopRightRadius: 4,
        aiBubbleTopLeftRadius: 4,
        aiBubbleTopRightRadius: 12,
        bottomLeftRadius: 12,
        bottomRightRadius: 12,
        enableShadow: true,
        shadowOpacity: 0.1,
        shadowBlurRadius: 8,
        shadowOffset: Offset(0, 2),
      ),
      messagePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      inputDecoration: InputDecoration(
        hintText: 'Enter your message...',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: const Color(0xFFBDC3C7)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: const Color(0xFFBDC3C7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: const Color(0xFF3498DB), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      appBarGradient: [const Color(0xFF2C3E50), const Color(0xFF34495E)],
      buttonGradient: [const Color(0xFFECF0F1), const Color(0xFFBDC3C7)],
      accentColor: const Color(0xFF3498DB),
    );
  }
}
