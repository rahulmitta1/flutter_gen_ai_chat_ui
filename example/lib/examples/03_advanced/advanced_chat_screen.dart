import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen_ai_chat_ui/src/utils/color_extensions.dart';

import '../../models/app_state.dart';
import '../../services/ai_service.dart';
import 'widgets/advanced_settings_drawer.dart';
import 'theme/advanced_theme.dart';

/// Advanced example of Flutter Gen AI Chat UI demonstrating all features
class AdvancedChatScreen extends StatefulWidget {
  const AdvancedChatScreen({super.key});

  @override
  State<AdvancedChatScreen> createState() => _AdvancedChatScreenState();
}

class _AdvancedChatScreenState extends State<AdvancedChatScreen> {
  // Controller for managing chat messages
  final _chatController = ChatMessagesController();

  // Service to generate AI responses
  final _aiService = AiService();

  // User definitions with avatars
  final _currentUser = ChatUser(
    id: 'user123',
    firstName: 'You',
    avatar: 'https://ui-avatars.com/api/?name=User&background=6366f1&color=fff',
  );

  final _aiUser = ChatUser(
    id: 'ai123',
    firstName: 'Insight AI',
    avatar: 'https://ui-avatars.com/api/?name=AI&background=10b981&color=fff',
  );

  // State management
  String _streamingMessageId = '';
  bool _isGenerating = false;

  // Example questions with different styles
  late final List<ExampleQuestion> _exampleQuestions;

  // Scroll controller for managing scroll position
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Initialize example questions
    _exampleQuestions = [
      ExampleQuestion(
        question: "What are your capabilities?",
        config: ExampleQuestionConfig(
          iconData: Icons.psychology,
          containerDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                Colors.purple.withOpacityCompat(0.1),
                Colors.blue.withOpacityCompat(0.1)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      ExampleQuestion(
        question: "Show me a code example",
        config: ExampleQuestionConfig(
          iconData: Icons.code,
          containerDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                Colors.green.withOpacityCompat(0.1),
                Colors.teal.withOpacityCompat(0.1)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      ExampleQuestion(
        question: "How does this chat UI work?",
        config: ExampleQuestionConfig(
          iconData: Icons.insights,
          containerDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                Colors.amber.withOpacityCompat(0.1),
                Colors.orange.withOpacityCompat(0.1)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      ExampleQuestion(
        question: "What features does this example show?",
        config: ExampleQuestionConfig(
          iconData: Icons.category,
          containerDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                Colors.pink.withOpacityCompat(0.1),
                Colors.red.withOpacityCompat(0.1)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    ];

    // Add a detailed welcome message with markdown
    _chatController.addMessage(
      ChatMessage(
        text: _buildWelcomeMessage(),
        user: _aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
        customProperties: {
          'type': 'welcome',
        },
      ),
    );

    // Set up the chat controller to use our scroll controller
    _chatController.setScrollController(_scrollController);
  }

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Build a rich markdown welcome message
  String _buildWelcomeMessage() {
    return """
# Welcome to the Advanced Example! 🚀

This example demonstrates **all features** of the Flutter Gen AI Chat UI package in a polished, production-ready implementation.

## Features Showcased

- **🎨 Custom Theming** - Personalized styling and appearance
- **💬 Rich Message Formatting** - Markdown with code highlighting
- **⚡ Streaming Responses** - Word-by-word typing animation
- **🔄 Smart Pagination** - Efficient handling of long conversations
- **⚙️ Settings Panel** - User-configurable options
- **📱 Responsive Layout** - Adapts to any screen size

Try asking questions or exploring the settings panel to see these features in action!
""";
  }

  /// Handle sending a message with support for streaming
  Future<void> _handleSendMessage(ChatMessage message) async {
    // Add the user's message to the chat
    _chatController.addMessage(message);

    // Get app state
    final appState = Provider.of<AppState>(context, listen: false);

    // Determine if we should use streaming based on app state
    final useStreaming = appState.isStreaming;

    // Generate a message ID for tracking
    final messageId = 'msg_${DateTime.now().millisecondsSinceEpoch}';

    if (useStreaming) {
      // Create an empty message to be updated incrementally
      final aiMessage = ChatMessage(
        text: "",
        user: _aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
        customProperties: {'id': messageId},
      );

      // Add the empty message to the chat
      _chatController.addMessage(aiMessage);

      // Update state
      setState(() {
        _streamingMessageId = messageId;
        _isGenerating = true;
      });

      try {
        // Start streaming response
        final stream = _aiService.streamResponse(
          message.text,
          includeCodeBlock: appState.showCodeBlocks,
        );

        // Listen to stream and update message
        await for (final text in stream) {
          final updatedMessage = aiMessage.copyWith(text: text);
          _chatController.updateMessage(updatedMessage);
        }
      } finally {
        // Reset state
        setState(() {
          _streamingMessageId = '';
          _isGenerating = false;
        });
      }
    } else {
      // Non-streaming approach with loading indicator
      setState(() => _isGenerating = true);

      try {
        // Generate response with delay
        final response = await _aiService.generateResponse(
          message.text,
          includeCodeBlock: appState.showCodeBlocks,
        );

        // Add complete response
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

  @override
  Widget build(BuildContext context) {
    // Get current app state
    final appState = Provider.of<AppState>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Gradient background
      body: AdvancedThemeProvider(
        themeMode: appState.themeMode,
        child: Builder(
          builder: (context) {
            final advancedTheme = AdvancedTheme.of(context);

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    advancedTheme.gradientStart,
                    advancedTheme.gradientEnd,
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Custom app bar with settings
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            'AI Assistant',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onBackground,
                            ),
                          ),
                          const Spacer(),
                          // Add a button to navigate to the scroll behavior example
                          IconButton(
                            icon: Icon(
                              Icons.swipe_vertical,
                              color: colorScheme.primary,
                            ),
                            tooltip: 'Scroll Behavior Example',
                            onPressed: () {
                              Navigator.pushNamed(context, '/scroll-behavior');
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              appState.themeMode == ThemeMode.dark
                                  ? Icons.light_mode_rounded
                                  : Icons.dark_mode_rounded,
                              color: colorScheme.primary,
                            ),
                            onPressed: appState.toggleTheme,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.settings,
                              color: colorScheme.primary,
                            ),
                            onPressed: () =>
                                Scaffold.of(context).openEndDrawer(),
                          ),
                        ],
                      ),
                    ),

                    // Chat widget
                    Expanded(
                      child: AiChatWidget(
                        currentUser: _currentUser,
                        aiUser: _aiUser,
                        controller: _chatController,
                        onSendMessage: _handleSendMessage,
                        scrollController: _scrollController,

                        // Message styling
                        messageOptions: MessageOptions(
                          bubbleStyle: BubbleStyle(
                            // User bubble styling (light rounded rectangles with gradient)
                            userBubbleColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.indigo.withOpacityCompat(0.2)
                                    : Colors.indigo.withOpacityCompat(0.07),
                            userBubbleTopRightRadius: 20,
                            userBubbleTopLeftRadius: 2,
                            userBubbleMinWidth: 0,
                            userBubbleMaxWidth:
                                MediaQuery.of(context).size.width * 0.75,
                            userNameColor: Colors.indigo.shade300,

                            // AI bubble styling (white or dark cards)
                            aiBubbleColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? const Color(0xFF1E1E1E)
                                    : Colors.white,
                            aiBubbleTopRightRadius: 2,
                            aiBubbleTopLeftRadius: 20,
                            aiBubbleMaxWidth:
                                MediaQuery.of(context).size.width * 0.85,
                            aiBubbleMinWidth:
                                MediaQuery.of(context).size.width * 0.5,
                            aiNameColor: Colors.teal,

                            // Common styling
                            bottomLeftRadius: 20,
                            bottomRightRadius: 20,
                            enableShadow: true,
                          ),
                          showUserName: true,
                          showTime: true,
                          timeFormat: (dateTime) =>
                              '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}',
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
                            codeblockDecoration: BoxDecoration(
                              color: advancedTheme.codeBlockBackground,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            codeblockPadding: const EdgeInsets.all(12),
                          ),
                        ),

                        // Loading configuration
                        loadingConfig: LoadingConfig(
                          isLoading: _isGenerating && !appState.isStreaming,
                          typingIndicatorColor: colorScheme.primary,
                        ),

                        // Example questions
                        exampleQuestions: _exampleQuestions,
                        persistentExampleQuestions:
                            appState.persistentExampleQuestions,

                        // Width constraint
                        maxWidth: appState.chatMaxWidth,

                        // Input customization
                        inputOptions: InputOptions(
                          decoration: InputDecoration(
                            hintText: 'Ask me anything...',
                            border: InputBorder.none,
                            filled: true,
                            fillColor: advancedTheme.inputBackground,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          textStyle: TextStyle(
                            fontSize: appState.fontSize,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          sendButtonIcon: Icons.send_rounded,
                          sendButtonColor: advancedTheme.sendButtonColor,
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
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      endDrawer: const AdvancedSettingsDrawer(),
    );
  }
}
