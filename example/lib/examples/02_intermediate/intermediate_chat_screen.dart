import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/src/utils/color_extensions.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:flutter_gen_ai_chat_ui/src/utils/color_extensions.dart';
import 'package:provider/provider.dart';

import '../../models/app_state.dart';
import '../../services/ai_service.dart';

/// Intermediate example of Flutter Gen AI Chat UI demonstrating streaming text responses
/// and additional customization options.
class IntermediateChatScreen extends StatefulWidget {
  const IntermediateChatScreen({super.key});

  @override
  State<IntermediateChatScreen> createState() => _IntermediateChatScreenState();
}

class _IntermediateChatScreenState extends State<IntermediateChatScreen> {
  // Chat controller to manage messages
  final _chatController = ChatMessagesController();

  // Service to generate AI responses
  final _aiService = AiService();

  // User definitions
  final _currentUser = ChatUser(id: 'user123', firstName: 'You');
  final _aiUser = ChatUser(
    id: 'ai123',
    firstName: 'AI Assistant',
    avatar: 'https://ui-avatars.com/api/?name=AI&background=6366f1&color=fff',
  );

  // Streaming state management
  bool _isGenerating = false;

  // Example questions
  final _exampleQuestions = [
    const ExampleQuestion(question: "What can you help me with?"),
    const ExampleQuestion(question: "Show me a code example"),
    const ExampleQuestion(question: "How does streaming text work?"),
    const ExampleQuestion(question: "Tell me about markdown support"),
  ];

  @override
  void initState() {
    super.initState();

    // Add welcome message
    _chatController.addMessage(
      ChatMessage(
        text:
            "👋 Welcome to the **Intermediate Example**! This example demonstrates:\n\n"
            "- ⚡ Streaming text responses word by word\n"
            "- 📝 Rich markdown formatting\n"
            "- 🎨 Custom styling options\n"
            "- 💬 Enhanced example questions\n\n"
            "Try asking a question to see these features in action.",
        user: _aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
      ),
    );
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  /// Handle sending a message and generating a streaming response
  Future<void> _handleSendMessage(ChatMessage message) async {
    // Add the user's message to the chat
    _chatController.addMessage(message);

    // Get application state
    final appState = Provider.of<AppState>(context, listen: false);

    // Only enable streaming if it's enabled in settings
    final useStreaming = appState.isStreaming;

    // Generate a unique ID for this message
    final messageId = 'msg_${DateTime.now().millisecondsSinceEpoch}';

    if (useStreaming) {
      // For streaming: Add empty message that will be updated incrementally
      final aiMessage = ChatMessage(
        text: "",
        user: _aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
        customProperties: {'id': messageId},
      );

      _chatController.addMessage(aiMessage);

      // Set streaming state
      setState(() {
        _isGenerating = true;
      });

      try {
        // Start streaming response
        final stream = _aiService.streamResponse(
          message.text,
          includeCodeBlock: appState.showCodeBlocks,
        );

        // Listen to stream and update message text incrementally
        await for (final text in stream) {
          // Find message by ID and update it with new text
          final updatedMessage = aiMessage.copyWith(text: text);
          _chatController.updateMessage(updatedMessage);
        }
      } finally {
        // Reset streaming state when done or on error
        setState(() {
          _isGenerating = false;
        });
      }
    } else {
      // Non-streaming approach: Show loading indicator
      setState(() => _isGenerating = true);

      try {
        // Simulate API call with delay
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
    final appState = Provider.of<AppState>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Intermediate Example'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Theme toggle
          IconButton(
            icon: Icon(
              appState.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: appState.toggleTheme,
            tooltip: 'Toggle theme',
          ),
          // Streaming toggle
          IconButton(
            icon: Icon(
              appState.isStreaming ? Icons.autorenew : Icons.text_fields,
            ),
            onPressed: appState.toggleStreaming,
            tooltip: 'Toggle streaming',
          ),
          // Reset conversation
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _chatController.clearMessages();
              // Re-add welcome message
              _chatController.addMessage(
                ChatMessage(
                  text:
                      "👋 Welcome to the **Intermediate Example**! This example demonstrates:\n\n"
                      "- ⚡ Streaming text responses word by word\n"
                      "- 📝 Rich markdown formatting\n"
                      "- 🎨 Custom styling options\n"
                      "- 💬 Enhanced example questions\n\n"
                      "Try asking a question to see these features in action.",
                  user: _aiUser,
                  createdAt: DateTime.now(),
                  isMarkdown: true,
                ),
              );
            },
            tooltip: 'Reset conversation',
          ),
        ],
      ),
      body: AiChatWidget(
        // Required parameters
        currentUser: _currentUser,
        aiUser: _aiUser,
        controller: _chatController,
        onSendMessage: _handleSendMessage,

        // Max width constraint from app state
        maxWidth: appState.chatMaxWidth,

        // Loading configuration
        loadingConfig: LoadingConfig(
          isLoading: _isGenerating,
          loadingIndicator:
              _isGenerating ? _buildCustomLoadingIndicator(colorScheme) : null,
        ),

        // Enable streaming markdown rendering
        enableMarkdownStreaming: appState.isStreaming,
        streamingDuration: const Duration(milliseconds: 15),

        // Welcome message config
        welcomeMessageConfig: WelcomeMessageConfig(
          title: "Interactive AI Chat Example",
          questionsSectionTitle: "Try asking:",
          containerDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primaryContainer,
                colorScheme.primary.withOpacityCompat(0.1 * 255),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.primary.withOpacityCompat(0.3 * 255),
              width: 1.5,
            ),
          ),
        ),

        // Example questions
        exampleQuestions: _exampleQuestions,
        persistentExampleQuestions: appState.persistentExampleQuestions,

        // Input customization
        inputOptions: InputOptions(
          unfocusOnTapOutside: false,
          margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
          sendOnEnter: true,
          sendButtonPadding: const EdgeInsets.only(right: 8),
          sendButtonIconSize: 24,
          decoration: InputDecoration(
            hintText: 'Ask anything...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest
                .withOpacityCompat(0.8 * 255),

            // suffixIcon: const Icon(Icons.send_rounded),
          ),
        ),

        // Message customization
        messageOptions: MessageOptions(
          showUserName: true,
          showTime: true,
          timeFormat: (dateTime) => '${dateTime.hour}:${dateTime.minute}',
          bubbleStyle: BubbleStyle(
            userBubbleColor: colorScheme.primaryContainer,
            aiBubbleColor: colorScheme.surfaceContainerHighest,
          ),
        ),

        // Animation settings
        enableAnimation: appState.enableAnimation,
      ),
    );
  }

  /// Custom typing indicator with blinking dots
  Widget _buildCustomLoadingIndicator(ColorScheme colorScheme) {
    return LoadingWidget(
      texts: [
        "Generating response...",
        "Thinking...",
        "Loading...",
        "Please wait...",
        "Loading data...",
        "Processing...",
        "Please wait...",
      ],
      shimmerBaseColor: colorScheme.primary,
      shimmerHighlightColor: colorScheme.primaryContainer,
    );
  }

  /// Blinking animation for typing indicator dots
  Widget _buildBlinkingDot({required Duration duration}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.4, end: 1.0),
      duration: duration,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: Container(),
      onEnd: () {
        setState(() {}); // Trigger rebuild to restart animation
      },
    );
  }
}
