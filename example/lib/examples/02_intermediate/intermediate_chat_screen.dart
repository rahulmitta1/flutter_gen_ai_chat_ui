import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:provider/provider.dart';

import '../../models/app_state.dart';

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

  // User definitions
  final _currentUser = const ChatUser(id: 'user123', firstName: 'You');
  final _aiUser = const ChatUser(
    id: 'ai123',
    firstName: 'Claude',
    avatar:
        'https://ui-avatars.com/api/?name=Claude&background=6366f1&color=fff',
  );

  // Streaming state management
  bool _isGenerating = false;
  bool _useStreaming = true;

  @override
  void initState() {
    super.initState();

    // Add Claude-style welcome message
    _chatController.addMessage(
      ChatMessage(
        text:
            'Hello! I\'m Claude, an AI assistant. I can help you with a wide variety of tasks like analysis, math, coding, creative writing, and thoughtful conversation.\n\nHow can I assist you today?',
        user: _aiUser,
        createdAt: DateTime.now(),
        isMarkdown: false,
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
    // Add the user message first
    _chatController.addMessage(message);

    // Set loading state immediately to show loading widget
    setState(() {
      _isGenerating = true;
    });

    if (_useStreaming) {
      // Simulate AI processing time with loading widget visible
      await Future.delayed(const Duration(milliseconds: 300));

      // Generate complete response text first
      final fullResponse = _generateResponse(message.text);
      
      // Create message ID for tracking
      final messageId = 'ai_${DateTime.now().millisecondsSinceEpoch}';
      final messageCreatedAt = DateTime.now();

      // Add the message with complete text - let flutter_streaming_text_markdown handle the animation
      _chatController.addMessage(
        ChatMessage(
          text: fullResponse,
          user: _aiUser,
          createdAt: messageCreatedAt,
          isMarkdown: true,
          customProperties: {
            'id': messageId,
            'isStreaming': true, // Mark as streaming so the package handles the animation
          },
        ),
      );

      // Simulate the time it would take to stream (for loading state)
      await Future.delayed(Duration(milliseconds: fullResponse.length * 25));
      
      // Mark streaming as complete - check if widget is still mounted
      if (mounted) {
        _chatController.updateMessage(
          ChatMessage(
            text: fullResponse,
            user: _aiUser,
            createdAt: messageCreatedAt,
            isMarkdown: true,
            customProperties: {
              'id': messageId,
              'isStreaming': false, // Mark as complete
            },
          ),
        );
      }
    } else {
      // Simulate AI processing time (loading state already set above)
      await Future.delayed(const Duration(milliseconds: 800));

      // Just add the complete response
      final response = _generateResponse(message.text);

      _chatController.addMessage(
        ChatMessage(
          text: response,
          user: _aiUser,
          createdAt: DateTime.now(),
          isMarkdown: true,
        ),
      );
    }

    if (mounted) {
      setState(() => _isGenerating = false);
    }
  }

  // Generate a Claude-style response based on the user's input
  String _generateResponse(String input) {
    var lowercaseInput = input.toLowerCase();
    if (lowercaseInput.contains('hello') ||
        lowercaseInput.contains('hi') ||
        lowercaseInput.contains('hey')) {
      return "Hello! It's nice to meet you. I'm here to help with whatever you need - whether that's answering questions, helping with analysis, creative writing, coding, or just having a thoughtful conversation. What would you like to explore today?";
    } else if (lowercaseInput.contains('help') &&
        lowercaseInput.contains('email')) {
      return "I'd be happy to help you write an email! To get started, could you tell me:\n\n• Who is the email for?\n• What's the main purpose or topic?\n• What tone would you like (formal, casual, etc.)?\n• Any specific points you want to include?\n\nOnce I know these details, I can draft something for you to review and refine.";
    } else if (lowercaseInput.contains('quantum') &&
        lowercaseInput.contains('computing')) {
      return "Quantum computing is a fascinating field that leverages quantum mechanical phenomena to process information in fundamentally different ways than classical computers.\n\n**Key Concepts:**\n\n• **Qubits**: Unlike classical bits (0 or 1), qubits can exist in \"superposition\" - simultaneously 0 and 1 until measured\n\n• **Entanglement**: Qubits can be correlated in ways that classical particles cannot, allowing coordinated behavior across distances\n\n• **Quantum Gates**: Operations that manipulate qubits, analogous to logic gates in classical computing\n\n**Potential Applications:**\n- Cryptography and security\n- Drug discovery and molecular modeling\n- Financial optimization\n- Machine learning acceleration\n\nThe field is still emerging, with companies like IBM, Google, and others making significant progress. Would you like me to dive deeper into any particular aspect?";
    } else if (lowercaseInput.contains('python') &&
        lowercaseInput.contains('function')) {
      return "I'd be happy to help you write a Python function! Here's a simple example to get started:\n\n```python\ndef greet_user(name, greeting=\"Hello\"):\n    \"\"\"\n    Greets a user with a personalized message.\n    \n    Args:\n        name (str): The user's name\n        greeting (str): The greeting to use (default: \"Hello\")\n    \n    Returns:\n        str: A formatted greeting message\n    \"\"\"\n    return f\"{greeting}, {name}! Welcome to our application.\"\n\n# Example usage\nmessage = greet_user(\"Alice\")\nprint(message)  # Output: Hello, Alice! Welcome to our application.\n```\n\nThis function demonstrates:\n• Parameter handling with defaults\n• Docstring documentation\n• F-string formatting\n• Return values\n\nWhat specific functionality would you like your function to have? I can help you build something more tailored to your needs.";
    } else if (lowercaseInput.contains('analyze') &&
        lowercaseInput.contains('data')) {
      return "I can definitely help with data analysis! I'm able to:\n\n**Statistical Analysis:**\n• Descriptive statistics and summaries\n• Hypothesis testing\n• Correlation and regression analysis\n• Time series analysis\n\n**Data Processing:**\n• Cleaning and preprocessing\n• Transformation and normalization\n• Handling missing values\n• Feature engineering\n\n**Visualization Guidance:**\n• Choosing appropriate chart types\n• Creating meaningful visualizations\n• Interpreting results\n\n**Tools I can help with:**\n• Python (pandas, numpy, matplotlib, seaborn)\n• R for statistical computing\n• SQL for database queries\n• Excel for simpler analyses\n\nWhat kind of data are you working with? If you can share some details about your dataset or analysis goals, I can provide more specific guidance.";
    } else if (lowercaseInput.contains('markdown')) {
      return "This interface supports **Markdown formatting** for rich text display! Here are some key features:\n\n## Text Formatting\n**Bold text** and *italic text*\n~~Strikethrough text~~\n\n## Lists\n• Bulleted lists\n• Multiple items\n• Easy to read\n\n1. Numbered lists\n2. Sequential items\n3. Well organized\n\n## Code\nInline `code snippets` and full code blocks:\n\n```python\n# Python example\nfor i in range(3):\n    print(f\"Hello, world {i}!\")\n```\n\n## Quotes\n> \"Markdown makes formatting text intuitive and readable.\"\n\nThe formatting renders beautifully in both light and dark modes. Try using some Markdown in your next message!";
    } else if (lowercaseInput.contains('streaming') ||
        lowercaseInput.contains('typing')) {
      return "# Streaming Text\n\nThe chat UI supports streaming responses word by word, creating a realistic typing effect. This is done by:\n\n1. Creating an empty message\n2. Continuously updating it with new words\n3. Using the `updateMessage` method\n\nThis creates a natural conversational feel and lets users start reading responses as they're being generated.";
    } else if (lowercaseInput.contains('upload') ||
        lowercaseInput.contains('file') ||
        lowercaseInput.contains('image') ||
        lowercaseInput.contains('document')) {
      return "# File Upload Support\n\nThis chat UI supports file attachments like:\n\n- Images (PNG, JPEG, GIF)\n- Documents (PDF, DOC, XLS)\n- Audio files\n- Video files\n\nThe UI provides default display components for each file type, with customization options for:\n\n- Custom file previews\n- File size limits\n- Allowed file types\n- Custom upload buttons\n\nThe actual file processing is handled by your app code.";
    } else {
      return "I'm here to help with a wide range of tasks! Whether you need assistance with writing, analysis, coding, creative projects, or just want to explore ideas through conversation, I'm ready to assist.\n\nSome things I'm particularly good at:\n• Breaking down complex problems\n• Providing detailed explanations\n• Creative and technical writing\n• Code review and debugging\n• Research and analysis\n• Brainstorming and ideation\n\nWhat would you like to work on together?";
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Claude-inspired color scheme
    final backgroundColor =
        isDark ? const Color(0xFF1a1a1a) : const Color(0xFFFAFAFA);
    final surfaceColor = isDark ? const Color(0xFF2d2d2d) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF404040) : const Color(0xFFE5E5E5);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
        title: Text(
          'Claude-Style Chat',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: borderColor,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Theme toggle
          IconButton(
            icon: Icon(
              appState.isDarkMode(context)
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            onPressed: appState.toggleTheme,
            tooltip: 'Toggle theme',
          ),
          // Streaming toggle
          IconButton(
            icon: Icon(
              _useStreaming ? Icons.pause_outlined : Icons.play_arrow_outlined,
            ),
            onPressed: () {
              setState(() => _useStreaming = !_useStreaming);
            },
            tooltip: _useStreaming ? 'Disable streaming' : 'Enable streaming',
          ),
          // Reset conversation
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () {
              _chatController.clearMessages();
              // Re-add welcome message
              _chatController.addMessage(
                ChatMessage(
                  text:
                      'Hello! I\'m Claude, an AI assistant. I can help you with a wide variety of tasks like analysis, math, coding, creative writing, and thoughtful conversation.\n\nHow can I assist you today?',
                  user: _aiUser,
                  createdAt: DateTime.now(),
                  isMarkdown: false,
                ),
              );
            },
            tooltip: 'New conversation',
          ),
        ],
      ),
      body: SafeArea(
        child: AiChatWidget(
          // Required parameters
          currentUser: _currentUser,
          aiUser: _aiUser,
          controller: _chatController,
          onSendMessage: _handleSendMessage,

          // Max width constraint - Claude style
          maxWidth: 768,

          // Loading configuration
          loadingConfig: LoadingConfig(
            isLoading: _isGenerating,
            loadingIndicator: _isGenerating
                ? _buildClaudeStyleLoadingIndicator(isDark)
                : null,
          ),

          // Enable streaming markdown rendering  
          enableMarkdownStreaming: _useStreaming,
          streamingDuration: const Duration(milliseconds: 35), // Claude-style natural typing speed

          // Configure scroll behavior for smooth streaming experience
          scrollBehaviorConfig: const ScrollBehaviorConfig(
            autoScrollBehavior: AutoScrollBehavior
                .onNewMessage, // Only scroll on new messages, not during streaming updates
            scrollToFirstResponseMessage:
                true, // Scroll to first message of response to keep it visible
            scrollAnimationDuration: Duration(milliseconds: 200),
            scrollAnimationCurve: Curves.easeOut,
          ),

          // Welcome message config - Claude style
          welcomeMessageConfig: WelcomeMessageConfig(
            title: "Claude",
            titleStyle: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w300,
              color: isDark ? Colors.white : Colors.black87,
              letterSpacing: -0.5,
            ),
            questionsSectionTitle: "Here are some things I can help with:",
            questionsSectionTitleStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            containerDecoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(0),
            ),
            containerPadding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          ),

          // Example questions - Claude style
          exampleQuestions: [
            const ExampleQuestion(question: "Help me write an email"),
            const ExampleQuestion(question: "Explain quantum computing"),
            const ExampleQuestion(question: "Write a Python function"),
            const ExampleQuestion(question: "Analyze this data"),
          ]
              .map((q) => ExampleQuestion(
                    question: q.question,
                    config: ExampleQuestionConfig(
                      containerPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      containerDecoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor, width: 1),
                      ),
                      textStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      iconData: Icons.chat_bubble_outline,
                      iconColor: isDark ? Colors.white54 : Colors.black54,
                      iconSize: 18,
                      trailingIconData: Icons.arrow_forward,
                      trailingIconColor:
                          isDark ? Colors.white38 : Colors.black38,
                      trailingIconSize: 16,
                    ),
                  ))
              .toList(),

          // Input customization - Claude style
          inputOptions: InputOptions(
            unfocusOnTapOutside: false,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            sendOnEnter: true,
            maxLines: 8,
            minLines: 1,
            sendButtonBuilder: (onSend) => Container(
              margin: const EdgeInsets.only(left: 8),
              child: Material(
                color: isDark ? Colors.white : Colors.black87,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: onSend,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.arrow_upward,
                      size: 20,
                      color: isDark ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            decoration: InputDecoration(
              hintText: 'Message Claude...',
              hintStyle: TextStyle(
                color: isDark ? Colors.white54 : Colors.black54,
                fontSize: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? Colors.white : Colors.black87,
                  width: 1.5,
                ),
              ),
              filled: true,
              fillColor: surfaceColor,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            textStyle: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black87,
              height: 1.4,
            ),
          ),

          // Message customization - Claude style
          messageOptions: MessageOptions(
            showUserName: false,
            showTime: false,
            showCopyButton: true,
            containerMargin:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            bubbleStyle: BubbleStyle(
              // User messages - right aligned with darker color
              userBubbleColor:
                  isDark ? const Color(0xFF3d3d3d) : const Color(0xFFF0F0F0),
              userBubbleTopLeftRadius: 18,
              userBubbleTopRightRadius: 4,
              userBubbleMaxWidth: MediaQuery.of(context).size.width * 0.8,

              // AI messages - left aligned, clean background
              aiBubbleColor: surfaceColor,
              aiBubbleTopLeftRadius: 4,
              aiBubbleTopRightRadius: 18,
              aiBubbleMaxWidth: MediaQuery.of(context).size.width * 0.9,

              // Shared properties
              bottomLeftRadius: 18,
              bottomRightRadius: 18,
              enableShadow: false,

              // Copy button styling
              copyIconColor: isDark ? Colors.white70 : Colors.black54,
            ),
            userTextColor: isDark ? Colors.white : Colors.black87,
            aiTextColor: isDark ? Colors.white : Colors.black87,
            textStyle: const TextStyle(
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
            markdownStyleSheet: MarkdownStyleSheet(
              p: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: isDark ? Colors.white : Colors.black87,
              ),
              code: TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                backgroundColor:
                    isDark ? const Color(0xFF1e1e1e) : const Color(0xFFF5F5F5),
                color: isDark ? Colors.white : Colors.black87,
              ),
              codeblockDecoration: BoxDecoration(
                color:
                    isDark ? const Color(0xFF1e1e1e) : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor),
              ),
              h1: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
              h2: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
              h3: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
              blockquote: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
              listBullet: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),

          // Animation settings
          enableAnimation: true,

          // File upload - Claude style
          fileUploadOptions: const FileUploadOptions(
            enabled: false, // Disable for cleaner Claude-like interface
          ),
        ),
      ),
    );
  }

  /// Claude-style loading indicator
  Widget _buildClaudeStyleLoadingIndicator(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3d3d3d) : const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Icon(
                Icons.smart_toy_outlined,
                size: 16,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2d2d2d) : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTypingDot(delay: 0),
                  const SizedBox(width: 4),
                  _buildTypingDot(delay: 0.15),
                  const SizedBox(width: 4),
                  _buildTypingDot(delay: 0.3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Individual typing dot animation
  Widget _buildTypingDot({required double delay}) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.3, end: 1.0),
      onEnd: () {
        if (mounted) {
          setState(() {}); // Restart animation
        }
      },
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white54
                  : Colors.black54,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
