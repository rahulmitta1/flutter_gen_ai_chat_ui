import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:provider/provider.dart';

import '../../models/app_state.dart';
import '../../services/ai_service.dart';

/// A basic example showing the minimal implementation of Flutter Gen AI Chat UI.
/// This example demonstrates essential features with clean, well-documented code.
class BasicChatScreen extends StatefulWidget {
  const BasicChatScreen({super.key});

  @override
  State<BasicChatScreen> createState() => _BasicChatScreenState();
}

class _BasicChatScreenState extends State<BasicChatScreen> {
  // Create a controller to manage chat messages
  final _chatController = ChatMessagesController();

  // Mock AI service
  final _aiService = AiService();

  // Define users for the chat
  final _currentUser = const ChatUser(id: 'user123', firstName: 'You');
  final _aiUser = const ChatUser(id: 'ai123', firstName: 'AI Assistant');

  // Track loading state
  bool _isLoading = false;

  // Text controller for input field (to fix memory leak)
  late TextEditingController _textController;

  // Example questions for the welcome message
  final _exampleQuestions = [
    const ExampleQuestion(question: "What can you help me with?"),
    const ExampleQuestion(question: "Tell me about Flutter"),
    const ExampleQuestion(question: "How does this UI work?"),
    const ExampleQuestion(question: "Show me some examples"),
  ];

  @override
  void initState() {
    super.initState();

    // Instead of adding a welcome message directly to the chat,
    // we'll use the welcome message feature with example questions
    // The controller's showWelcomeMessage property controls this
    _chatController.showWelcomeMessage = true;

    // Initialize text controller
    _textController = TextEditingController();
    _textController.addListener(() {
      if (_textController.text.endsWith('\n')) {
        _textController.text = _textController.text.trim();
        if (_textController.text.isNotEmpty) {
          _handleSendMessage(ChatMessage(
            text: _textController.text,
            user: _currentUser,
            createdAt: DateTime.now(),
          ));
          _textController.clear();
        }
      }
    });

    // No initial messages added to chat
  }

  @override
  void dispose() {
    // Dispose the controller to avoid memory leaks
    _chatController.dispose();
    _textController.dispose();  // Fix memory leak
    super.dispose();
  }

  /// Handle sending a user message and generating a response
  Future<void> _handleSendMessage(ChatMessage message) async {
    // Prevent multiple concurrent requests
    if (_isLoading) return;

    // Hide welcome message if it's currently shown
    if (_chatController.showWelcomeMessage) {
      _chatController.hideWelcomeMessage();
    }

    // Add the user's message to the chat immediately
    _chatController.addMessage(message);

    // Set loading state to show typing indicator (immediately like intermediate example)
    setState(() => _isLoading = true);

    // Add a small delay for visual feedback
    await Future.delayed(const Duration(milliseconds: 600));

    try {
      // Simulate API call to generate response
      final response = await _aiService.generateResponse(message.text,
          includeCodeBlock: false);

      // Reset loading state before adding response
      setState(() => _isLoading = false);

      // Small delay to make the transition smoother
      await Future.delayed(const Duration(milliseconds: 200));

      // Add the AI response to the chat
      _chatController.addMessage(
        ChatMessage(
          text: response.text,
          user: _aiUser,
          createdAt: DateTime.now(),
          isMarkdown: response.isMarkdown,
        ),
      );
    } catch (error) {
      // Reset loading state on error
      setState(() => _isLoading = false);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get app state for theme and settings
    final appState = Provider.of<AppState>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // ChatGPT-inspired color scheme
    final backgroundColor = isDark ? const Color(0xFF212121) : const Color(0xFFFFFFFF);
    final surfaceColor = isDark ? const Color(0xFF2f2f2f) : const Color(0xFFF7F7F8);
    final borderColor = isDark ? const Color(0xFF565869) : const Color(0xFFD1D5DB);
    final accentColor = isDark ? const Color(0xFF10a37f) : const Color(0xFF10a37f);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
        title: Text(
          'ChatGPT',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: borderColor,
          ),
        ),
        actions: [
          // Theme toggle button
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
            onPressed: appState.toggleTheme,
            tooltip: 'Toggle theme',
          ),
          // Reset conversation button
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () {
              // Clear all messages
              _chatController.clearMessages();
              // Show the welcome message again
              _chatController.showWelcomeMessage = true;
            },
            tooltip: 'New conversation',
          ),
        ],
      ),
      body: AiChatWidget(
        // Required parameters
        currentUser: _currentUser,
        aiUser: _aiUser,
        controller: _chatController,
        onSendMessage: _handleSendMessage,

        // Max width for better readability
        maxWidth: 600,

        // Loading state with built-in shimmer
        loadingConfig: LoadingConfig(
          isLoading: _isLoading,
          loadingIndicator: LoadingWidget(
            texts: const [
              'Thinking...',
              'Processing your request...',
              'Generating response...',
            ],
            interval: const Duration(seconds: 2),
            shimmerBaseColor: isDark 
                ? Colors.grey[700] 
                : Colors.grey[300],
            shimmerHighlightColor: isDark 
                ? Colors.grey[600] 
                : Colors.grey[100],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),

        // Welcome message configuration (keeping it intact as requested)
        welcomeMessageConfig: WelcomeMessageConfig(
          title: "How can I help you today?",
          titleStyle: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Colors.black,
          ),
          questionsSectionTitle: "Examples",
          questionsSectionTitleStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white60 : Colors.black54,
          ),
          containerDecoration: BoxDecoration(
            color: backgroundColor,
          ),
          containerPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          questionsSectionPadding: const EdgeInsets.all(16),
        ),

        // ChatGPT-style example questions
        exampleQuestions: _exampleQuestions
            .map((q) => ExampleQuestion(
                  question: q.question,
                  config: ExampleQuestionConfig(
                    iconData: Icons.lightbulb_outline,
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    containerPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    containerDecoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: borderColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    iconColor: isDark ? Colors.white60 : Colors.black54,
                    iconSize: 16,
                  ),
                ))
            .toList(),

        // ChatGPT-style input field
        inputOptions: InputOptions(
          unfocusOnTapOutside: false,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          sendOnEnter: true,
          maxLines: 6,
          minLines: 1,
          textController: _textController,
          sendButtonBuilder: (onSend) => Container(
            margin: const EdgeInsets.only(left: 8),
            child: Material(
              color: accentColor,
              borderRadius: BorderRadius.circular(6),
              child: InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: onSend,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.arrow_upward,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          decoration: InputDecoration(
            hintText: 'Message ChatGPT...',
            hintStyle: TextStyle(
              color: isDark ? Colors.white60 : Colors.black54,
              fontSize: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(
                color: borderColor,
                width: 1.5,
              ),
            ),
            filled: true,
            fillColor: surfaceColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.white : Colors.black,
            height: 1.4,
          ),
        ),

        // ChatGPT-style message styling
        messageOptions: MessageOptions(
          showUserName: false,
          showTime: false,
          showCopyButton: true,
          containerMargin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          bubbleStyle: BubbleStyle(
            // User messages - ChatGPT style (right aligned, darker)
            userBubbleColor: isDark ? const Color(0xFF2f2f2f) : const Color(0xFFF7F7F8),
            userBubbleTopLeftRadius: 18,
            userBubbleTopRightRadius: 18,
            userBubbleMaxWidth: MediaQuery.of(context).size.width * 0.85,
            
            // AI messages - ChatGPT style (left aligned, different color)
            aiBubbleColor: isDark ? const Color(0xFF444654) : Colors.white,
            aiBubbleTopLeftRadius: 18,
            aiBubbleTopRightRadius: 18,
            aiBubbleMaxWidth: MediaQuery.of(context).size.width * 0.85,
            
            // Shared properties
            bottomLeftRadius: 18,
            bottomRightRadius: 18,
            enableShadow: false,
            
            // Copy button styling
            copyIconColor: isDark ? Colors.white60 : Colors.black54,
          ),
          userTextColor: isDark ? Colors.white : Colors.black,
          aiTextColor: isDark ? Colors.white : Colors.black,
          textStyle: const TextStyle(
            fontSize: 16,
            height: 1.5,
            fontWeight: FontWeight.w400,
          ),
        ),

        // Smooth animations
        enableAnimation: true,
        streamingDuration: const Duration(milliseconds: 50),
      ),
    );
  }

}
