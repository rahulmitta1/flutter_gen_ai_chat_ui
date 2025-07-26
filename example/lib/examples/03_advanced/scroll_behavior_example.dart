import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:flutter_gen_ai_chat_ui/src/models/example_question.dart';
import 'package:flutter_gen_ai_chat_ui/src/utils/color_extensions.dart';
import 'package:provider/provider.dart';

import '../../models/app_state.dart';
import '../../services/ai_service.dart';

class ScrollBehaviorExample extends StatefulWidget {
  const ScrollBehaviorExample({Key? key}) : super(key: key);

  @override
  State<ScrollBehaviorExample> createState() => _ScrollBehaviorExampleState();
}

class _ScrollBehaviorExampleState extends State<ScrollBehaviorExample> {
  late final ChatMessagesController _controller;
  final _currentUser = const ChatUser(id: 'user', firstName: 'You');
  ChatUser _aiUser = const ChatUser(id: 'ai', firstName: 'AI Assistant');
  bool _isLoading = false;

  // Initialize with onNewMessage for proper scroll-to-first behavior
  AutoScrollBehavior _selectedScrollBehavior =
      AutoScrollBehavior.onNewMessage;
  bool _scrollToFirstMessage = true;

  // Track animation style
  String _selectedAnimationStyle = 'Default';
  final List<String> _animationStyles = [
    'Default',
    'Smooth',
    'Bouncy',
    'Fast',
    'Decelerate',
    'Accelerate'
  ];

  @override
  void initState() {
    super.initState();
    _controller = ChatMessagesController(
      scrollBehaviorConfig: _getCurrentScrollConfig(),
      // Explicitly set pagination to chronological order for better scroll behavior testing
      paginationConfig: const PaginationConfig(
        reverseOrder: false, // Chronological order - oldest at top, newest at bottom
        enabled: false, // Disable pagination for simpler testing
      ),
    );

    // Add welcome message explaining the scroll behavior feature
    _controller.addMessage(
      ChatMessage(
        text: '# 📜 Scroll Behavior Demo\n\n'
            '## The Problem\n'
            'When AI gives long responses with multiple parts, normal chat UIs scroll to the **bottom**, making you miss the beginning of the response.\n\n'
            '## The Solution\n'
            'This demo shows **"scroll to first message"** - when enabled, long AI responses scroll to the **TOP** so you can read from the start.\n\n'
            '## 🎯 Current Settings\n'
            '• **Auto-scroll behavior:** `${_selectedScrollBehavior.name}`\n'
            '• **Scroll to first message:** ${_scrollToFirstMessage ? "✅ **ENABLED**" : "❌ **DISABLED**"}\n'
            '• **Animation style:** `$_selectedAnimationStyle`\n\n'
            '## 🧪 How to Test\n'
            '1. **Use the ⚙️ settings** to change scroll behavior\n'
            '2. **Click the ▶️ test button** to see a demonstration\n'
            '3. **Try example questions** below to generate long responses\n'
            '4. **Watch where the scroll goes** when responses appear!\n\n'
            '💡 **Tip:** Enable "scroll to first message" to never miss the beginning of AI responses!',
        user: _aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
      ),
    );

    // Log the initial configuration
    debugPrint('Initial scroll behavior: $_selectedScrollBehavior, '
        'scrollToFirstMessage: $_scrollToFirstMessage, '
        'animation: $_selectedAnimationStyle');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final appState = Provider.of<AppState>(context);
    
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0A0A0F) : const Color(0xFFF8F9FF),
      appBar: _buildFuturisticAppBar(context, appState, isDarkMode),
      body: Column(
        children: [
          // Futuristic status indicator
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [const Color(0xFF1A1B23), const Color(0xFF0F1419)]
                    : [const Color(0xFFFFFFFF), const Color(0xFFF8F9FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDarkMode 
                    ? const Color(0xFF374151).withOpacity(0.3)
                    : const Color(0xFFE5E7EB),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isDarkMode 
                        ? const Color(0xFF00D4FF)
                        : const Color(0xFF6366F1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (isDarkMode 
                            ? const Color(0xFF00D4FF)
                            : const Color(0xFF6366F1)).withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${_selectedScrollBehavior.name}${_scrollToFirstMessage ? " • First message" : ""} • $_selectedAnimationStyle',
                    style: TextStyle(
                      color: isDarkMode 
                          ? const Color(0xFFF3F4F6)
                          : const Color(0xFF1F2937),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: AiChatWidget(
              key: ValueKey('scroll_${_selectedScrollBehavior.name}_first_${_scrollToFirstMessage}_anim_$_selectedAnimationStyle'),
              currentUser: _currentUser,
              aiUser: _aiUser,
              controller: _controller,
              onSendMessage: _handleSendMessage,
              loadingConfig: LoadingConfig(
                isLoading: _isLoading,
                loadingIndicator: _isLoading ? _buildFuturisticLoadingIndicator() : null,
              ),
              // Configure scroll behavior with dynamic animation styles
              scrollBehaviorConfig: _getCurrentScrollConfig(),
              // Futuristic message styling
              messageOptions: MessageOptions(
                showUserName: true,
                userNameStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDarkMode
                      ? const Color(0xFF00D4FF)
                      : const Color(0xFF6366F1),
                ),
                textStyle: TextStyle(
                  color: isDarkMode
                      ? const Color(0xFFF3F4F6)
                      : const Color(0xFF1F2937),
                  fontSize: 15,
                ),
                bubbleStyle: BubbleStyle(
                  userBubbleColor: isDarkMode 
                      ? const Color(0xFF1A1B23).withOpacity(0.6)
                      : const Color(0xFF6366F1).withOpacity(0.1),
                  aiBubbleColor: isDarkMode
                      ? const Color(0xFF0F1419).withOpacity(0.8)
                      : const Color(0xFFFFFFFF).withOpacity(0.9),
                  userNameColor: isDarkMode
                      ? const Color(0xFF00D4FF)
                      : const Color(0xFF6366F1),
                  aiNameColor: isDarkMode
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF6B7280),
                ),
              ),
              // Futuristic input styling
              inputOptions: InputOptions(
                sendOnEnter: true,
                sendButtonPadding: const EdgeInsets.only(right: 12),
                sendButtonIconSize: 22,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: InputDecoration(
                  hintText: 'Test scroll behavior...',
                  hintStyle: TextStyle(
                    color: isDarkMode 
                        ? const Color(0xFF6B7280)
                        : const Color(0xFF9CA3AF),
                    fontSize: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: isDarkMode 
                          ? const Color(0xFF1F2937).withOpacity(0.6)
                          : const Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: isDarkMode 
                          ? const Color(0xFF1F2937).withOpacity(0.6)
                          : const Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: isDarkMode 
                          ? const Color(0xFF00D4FF)
                          : const Color(0xFF6366F1),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: isDarkMode 
                      ? const Color(0xFF0F1419).withOpacity(0.8)
                      : const Color(0xFFFFFFFF).withOpacity(0.9),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                ),
                textStyle: TextStyle(
                  color: isDarkMode 
                      ? const Color(0xFFF3F4F6)
                      : const Color(0xFF1F2937),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                sendButtonColor: isDarkMode 
                    ? const Color(0xFF00D4FF)
                    : const Color(0xFF6366F1),
              ),
              // Futuristic example questions
              exampleQuestions: [
                ExampleQuestion(
                  question: "Generate a long response",
                  config: ExampleQuestionConfig(
                    textStyle: TextStyle(
                      color: isDarkMode
                          ? const Color(0xFFF3F4F6)
                          : const Color(0xFF1F2937),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    iconData: Icons.chat_bubble_outline_rounded,
                    iconColor: isDarkMode
                        ? const Color(0xFF00D4FF)
                        : const Color(0xFF6366F1),
                    containerDecoration: BoxDecoration(
                      color: isDarkMode
                          ? const Color(0xFF1A1B23).withOpacity(0.6)
                          : const Color(0xFFFFFFFF).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDarkMode
                            ? const Color(0xFF374151).withOpacity(0.3)
                            : const Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                  ),
                ),
                ExampleQuestion(
                  question: "Tell me about auto-scrolling",
                  config: ExampleQuestionConfig(
                    textStyle: TextStyle(
                      color: isDarkMode
                          ? const Color(0xFFF3F4F6)
                          : const Color(0xFF1F2937),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    iconData: Icons.swipe_vertical_rounded,
                    iconColor: isDarkMode
                        ? const Color(0xFF00D4FF)
                        : const Color(0xFF6366F1),
                    containerDecoration: BoxDecoration(
                      color: isDarkMode
                          ? const Color(0xFF1A1B23).withOpacity(0.6)
                          : const Color(0xFFFFFFFF).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDarkMode
                            ? const Color(0xFF374151).withOpacity(0.3)
                            : const Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                  ),
                ),
                ExampleQuestion(
                  question: "Generate a multi-paragraph response",
                  config: ExampleQuestionConfig(
                    textStyle: TextStyle(
                      color: isDarkMode
                          ? const Color(0xFFF3F4F6)
                          : const Color(0xFF1F2937),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    iconData: Icons.format_align_left_rounded,
                    iconColor: isDarkMode
                        ? const Color(0xFF00D4FF)
                        : const Color(0xFF6366F1),
                    containerDecoration: BoxDecoration(
                      color: isDarkMode
                          ? const Color(0xFF1A1B23).withOpacity(0.6)
                          : const Color(0xFFFFFFFF).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDarkMode
                            ? const Color(0xFF374151).withOpacity(0.3)
                            : const Color(0xFFE5E7EB),
                        width: 1,
                      ),
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

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        // Make local copies to track during dialog
        var tempScrollBehavior = _selectedScrollBehavior;
        var tempScrollToFirst = _scrollToFirstMessage;
        var tempAnimationStyle = _selectedAnimationStyle;

        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Scroll Behavior Settings'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Auto-scroll behavior:'),
                  const SizedBox(height: 8),
                  ...AutoScrollBehavior.values.map((behavior) {
                    return RadioListTile<AutoScrollBehavior>(
                      title: Text(behavior.name),
                      subtitle: Text(_getScrollBehaviorDescription(behavior)),
                      value: behavior,
                      groupValue: tempScrollBehavior,
                      onChanged: (value) {
                        setDialogState(() {
                          tempScrollBehavior = value!;
                        });
                      },
                    );
                  }).toList(),
                  const Divider(),
                  CheckboxListTile(
                    title: const Text('Scroll to first message of response'),
                    subtitle: const Text(
                      'When enabled, scrolls to first message of a response rather than the last message',
                    ),
                    value: tempScrollToFirst,
                    onChanged: (value) {
                      setDialogState(() {
                        tempScrollToFirst = value!;
                      });
                    },
                  ),
                  const Divider(),
                  const Text('Animation style:'),
                  const SizedBox(height: 8),
                  ..._animationStyles.map((style) {
                    return RadioListTile<String>(
                      title: Text(style),
                      subtitle: Text(_getAnimationStyleDescription(style)),
                      value: style,
                      groupValue: tempAnimationStyle,
                      onChanged: (value) {
                        setDialogState(() {
                          tempAnimationStyle = value!;
                        });
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      _selectedScrollBehavior = tempScrollBehavior;
                      _scrollToFirstMessage = tempScrollToFirst;
                      _selectedAnimationStyle = tempAnimationStyle;

                      // Explicitly update the controller's scroll behavior configuration
                      _controller.scrollBehaviorConfig =
                          _getCurrentScrollConfig();
                    
                    // Force rebuild of the chat widget by updating the key
                    // This ensures the new scroll configuration is properly applied

                    debugPrint(
                        'Updated scroll behavior: ${_selectedScrollBehavior.name}, '
                        'scroll to first message: $_scrollToFirstMessage, '
                        'animation style: $_selectedAnimationStyle');
                    });
                  }
                  Navigator.pop(context);
                  
                  // Show confirmation of settings change after dialog closes
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '⚙️ Settings Applied!\n'
                          '${_selectedScrollBehavior.name} • '
                          '${_scrollToFirstMessage ? "Scroll to FIRST message" : "Scroll to LAST message"} • '
                          '$_selectedAnimationStyle\n'
                          'Use the ▶️ test button to see the changes!'
                        ),
                        backgroundColor: _getAnimationColor(),
                        duration: const Duration(seconds: 3),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    }
                  });
                },
                child: const Text('Apply'),
              ),
            ],
          );
        });
      },
    );
  }

  String _getScrollBehaviorDescription(AutoScrollBehavior behavior) {
    switch (behavior) {
      case AutoScrollBehavior.always:
        return 'Always scroll to bottom for all messages and updates';
      case AutoScrollBehavior.onNewMessage:
        return 'Only scroll for new messages, not during updates';
      case AutoScrollBehavior.onUserMessageOnly:
        return 'Only scroll when user sends a message';
      case AutoScrollBehavior.never:
        return 'Never auto-scroll (manual scrolling only)';
    }
  }

  String _getAnimationStyleDescription(String style) {
    switch (style) {
      case 'Smooth':
        return 'Smooth easeInOutCubic transition';
      case 'Bouncy':
        return 'Elastic bounce at the end of scroll';
      case 'Fast':
        return 'Quick scrolling with minimal animation';
      case 'Decelerate':
        return 'Starts fast, gradually slows down';
      case 'Accelerate':
        return 'Starts slow, gradually speeds up';
      case 'Default':
      default:
        return 'Standard easeOut animation';
    }
  }

  Future<void> _handleSendMessage(ChatMessage message) async {
    if (mounted) setState(() => _isLoading = true);

    try {
      await Future.delayed(
          const Duration(milliseconds: 500)); // Simulating API call

      // Save the original user message with proper custom properties
      final userMessage = message.copyWith(
        customProperties: {'isUserMessage': true, 'source': 'user'},
      );

      // Actually add the user message to the controller
      _controller.addMessage(userMessage);

      // Check if it's the request for a long response
      if (message.text.toLowerCase().contains("long response") ||
          message.text.toLowerCase().contains("multi-paragraph")) {
        _simulateLongResponse();
      } else if (message.text.toLowerCase().contains("auto-scrolling")) {
        _simulateAutoScrollExplanation();
      } else {
        // Default response
        _controller.addMessage(ChatMessage(
          text:
              "You said: '${message.text}'. Try asking for a 'long response' to see the scroll behavior in action.",
          user: _aiUser,
          createdAt: DateTime.now(),
          isMarkdown: true,
          customProperties: {'isUserMessage': false, 'isStartOfResponse': true},
        ));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _simulateLongResponse() {
    // Generate a unique response ID to link all messages in this response
    final responseId = 'response_${DateTime.now().millisecondsSinceEpoch}';

    // First part of the response
    _controller.addMessage(ChatMessage(
      text:
          "# Long Response Example\n\nThis is a long response that demonstrates how the scrolling behavior works with multi-part responses. Notice how the different scroll behavior settings affect what happens when this message appears.",
      user: _aiUser,
      createdAt: DateTime.now(),
      isMarkdown: true,
      customProperties: {
        'isUserMessage': false,
        'isStartOfResponse': true,
        'responseId': responseId, // Add response chain ID
      },
    ));

    // The scroll behavior is now handled automatically by the ScrollBehaviorConfig
    // No manual scroll forcing needed - the controller will handle this based on configuration

    // Add the other parts with slight delays to simulate streaming
    Future.delayed(const Duration(milliseconds: 800), () {
      _controller.addMessage(ChatMessage(
        text:
            "## Section 1: Introduction\n\nWhen an AI gives a long response with multiple paragraphs or message bubbles, the default behavior in many chat UIs is to scroll to the bottom, showing the most recent part of the response.",
        user: _aiUser,
        createdAt: DateTime.now().add(const Duration(milliseconds: 100)),
        isMarkdown: true,
        customProperties: {
          'isUserMessage': false,
          'responseId': responseId, // Same response chain ID
        },
      ));

      // Automatic scroll behavior handles this based on ScrollBehaviorConfig
    });

    Future.delayed(const Duration(milliseconds: 1600), () {
      _controller.addMessage(ChatMessage(
        text:
            "## Section 2: The Problem\n\nHowever, this can be problematic for users because they might miss the beginning of the response, which often contains important context or the direct answer to their question.",
        user: _aiUser,
        createdAt: DateTime.now().add(const Duration(milliseconds: 200)),
        isMarkdown: true,
        customProperties: {
          'isUserMessage': false,
          'responseId': responseId, // Same response chain ID
        },
      ));
    });

    Future.delayed(const Duration(milliseconds: 2400), () {
      _controller.addMessage(ChatMessage(
        text:
            "## Section 3: The Solution\n\nThe new `scrollBehaviorConfig` allows you to control this behavior. You can:\n\n- Only auto-scroll for user messages (letting users control scrolling for AI responses)\n- Scroll to the first message of a response instead of the last\n- Disable auto-scrolling entirely\n\nTry changing the settings using the gear icon in the app bar!",
        user: _aiUser,
        createdAt: DateTime.now().add(const Duration(milliseconds: 300)),
        isMarkdown: true,
        customProperties: {
          'isUserMessage': false,
          'responseId': responseId, // Same response chain ID
        },
      ));
    });
  }

  void _simulateAutoScrollExplanation() {
    // Generate a unique response ID to link all messages in this response
    final responseId = 'response_${DateTime.now().millisecondsSinceEpoch}';

    _controller.addMessage(ChatMessage(
      text:
          "# Auto-Scrolling Behavior Options\n\nThis chat widget now supports several scrolling behaviors to improve user experience with long responses:",
      user: _aiUser,
      createdAt: DateTime.now(),
      isMarkdown: true,
      customProperties: {
        'isUserMessage': false,
        'isStartOfResponse': true,
        'responseId': responseId, // Add response chain ID
      },
    ));

    // Automatic scroll behavior handles this based on ScrollBehaviorConfig

    Future.delayed(const Duration(milliseconds: 800), () {
      _controller.addMessage(ChatMessage(
        text:
            "## Always\n\nThe widget will always scroll to the bottom whenever messages are added or updated. This ensures you always see the most recent content, but can be disruptive with long responses as it will keep scrolling as each part arrives.",
        user: _aiUser,
        createdAt: DateTime.now().add(const Duration(milliseconds: 100)),
        isMarkdown: true,
        customProperties: {
          'isUserMessage': false,
          'responseId': responseId, // Same response chain ID
        },
      ));

      // Automatic scroll behavior handles this based on ScrollBehaviorConfig
    });

    Future.delayed(const Duration(milliseconds: 1600), () {
      _controller.addMessage(ChatMessage(
        text:
            "## On New Message\n\nThe widget will only scroll when a completely new message is added, not during updates to existing messages. This is useful when streaming updates, as it won't constantly scroll during the streaming process.",
        user: _aiUser,
        createdAt: DateTime.now().add(const Duration(milliseconds: 200)),
        isMarkdown: true,
        customProperties: {
          'isUserMessage': false,
          'responseId': responseId, // Same response chain ID
        },
      ));
    });

    Future.delayed(const Duration(milliseconds: 2400), () {
      _controller.addMessage(ChatMessage(
        text:
            "## On User Message Only\n\nThe widget will only auto-scroll when the user sends a message, not for AI responses. This gives the user full control over scrolling when reading AI responses, which is especially helpful for long, detailed answers.",
        user: _aiUser,
        createdAt: DateTime.now().add(const Duration(milliseconds: 300)),
        isMarkdown: true,
        customProperties: {
          'isUserMessage': false,
          'responseId': responseId, // Same response chain ID
        },
      ));
    });

    Future.delayed(const Duration(milliseconds: 3200), () {
      _controller.addMessage(ChatMessage(
        text:
            "## Never\n\nThe widget will never auto-scroll. The user is fully responsible for manually scrolling through the conversation. This is the most conservative option that gives users complete control.",
        user: _aiUser,
        createdAt: DateTime.now().add(const Duration(milliseconds: 400)),
        isMarkdown: true,
        customProperties: {
          'isUserMessage': false,
          'responseId': responseId, // Same response chain ID
        },
      ));
    });
  }

  // Test the current scroll behavior
  void _testCurrentScrollBehavior() {
    // Check if widget is still mounted before showing SnackBar
    if (!mounted) return;
    
    // Show overlay to explain what's happening
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '🧪 TESTING SCROLL BEHAVIOR\n'
          '${_selectedScrollBehavior.name} • '
          '${_scrollToFirstMessage ? "Scroll to FIRST message" : "Scroll to LAST message"} • '
          '$_selectedAnimationStyle\n'
          '👀 Watch where the scroll position goes when the response finishes!'
        ),
        duration: const Duration(seconds: 4),
        backgroundColor: _getAnimationColor(),
        behavior: SnackBarBehavior.floating,
      ),
    );

    if (mounted) setState(() => _isLoading = true);

    // Clear any previous messages to ensure a clean test
    _controller.clearMessages();

    // Ensure controller has latest configuration
    _controller.scrollBehaviorConfig = _getCurrentScrollConfig();
    
    // Add explanatory message about what's being tested
    _controller.addMessage(ChatMessage(
      text: '# 🧪 STARTING SCROLL BEHAVIOR TEST\n\n'
          '**Configuration Being Tested:**\n'
          '• Auto-scroll behavior: `${_selectedScrollBehavior.name}`\n'
          '• Scroll to first message: ${_scrollToFirstMessage ? "✅ **ENABLED**" : "❌ **DISABLED**"}\n'
          '• Animation style: `$_selectedAnimationStyle`\n\n'
          '**What Should Happen:**\n'
          '${_scrollToFirstMessage ? "🔝 After all messages appear, you should see **MESSAGE #1** at the top" : "🔽 After all messages appear, you should see the **FINAL MESSAGE** at the bottom"}\n\n'
          '⏳ **Test starting...** Watch the scroll position!',
      user: _aiUser,
      createdAt: DateTime.now(),
      isMarkdown: true,
    ));

    // First add a user message
    _controller.addMessage(ChatMessage(
      text: "Show me $_selectedAnimationStyle animation scrolling behavior",
      user: _currentUser,
      createdAt: DateTime.now(),
      customProperties: {'isUserMessage': true, 'source': 'user'},
    ));

    // Generate a unique response ID for this response chain
    final responseId = 'response_${DateTime.now().millisecondsSinceEpoch}';

    // Wait for user message to render
    Future.delayed(const Duration(milliseconds: 500), () {
      // First message with very clear scroll behavior indication - MAKE IT LARGE
      _controller.addMessage(ChatMessage(
        text: "🎯 **SCROLL BEHAVIOR TEST** 🎯\n\n" +
            "## Current Configuration\n" +
            "• **Auto-scroll behavior:** `${_selectedScrollBehavior.name}`\n" +
            "• **Scroll to first message:** ${_scrollToFirstMessage ? '✅ **ENABLED**' : '❌ **DISABLED**'}\n" +
            "• **Animation style:** `$_selectedAnimationStyle`\n\n" +
            "## 📍 THIS IS MESSAGE #1 (FIRST)\n" +
            "**Expected behavior:** When the response finishes, you should ${_scrollToFirstMessage ? '**see THIS message at the top**' : '**scroll to the LAST message at the bottom**'}.\n\n" +
            "## Animation Details\n" +
            _getAnimationDescription(_selectedAnimationStyle) + "\n\n" +
            "⏳ **More messages coming...** Watch the scroll position!\n\n" +
            "🔥 **IMPORTANT**: This is the FIRST message of the response. " +
            "${_scrollToFirstMessage ? 'You should see this message at the TOP when the response is complete!' : 'You should scroll to the BOTTOM when the response is complete!'}\n\n" +
            "---\n\n" +
            "## 📏 Making This Message TALL for Better Testing\n\n" +
            "This message is intentionally made very long to exceed the screen height and properly demonstrate scroll behavior.\n\n" +
            "• Line 1 of extra content to make this message tall\n" +
            "• Line 2 of extra content to make this message tall\n" +
            "• Line 3 of extra content to make this message tall\n" +
            "• Line 4 of extra content to make this message tall\n" +
            "• Line 5 of extra content to make this message tall\n" +
            "• Line 6 of extra content to make this message tall\n" +
            "• Line 7 of extra content to make this message tall\n" +
            "• Line 8 of extra content to make this message tall\n" +
            "• Line 9 of extra content to make this message tall\n" +
            "• Line 10 of extra content to make this message tall\n\n" +
            "### More Content to Exceed Screen Height\n\n" +
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\n" +
            "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\n" +
            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.\n\n" +
            "**Scroll Test in Progress...** 📊\n\n" +
            "Remember: This is MESSAGE #1 and should be visible at the top when scroll-to-first is enabled!",
        user: _aiUser.copyWith(
            // Create and style the AI user to have a visibly styled name in dark mode
            firstName: Theme.of(context).brightness == Brightness.dark
                ? 'AI ASSISTANT' // All caps for better visibility
                : 'AI Assistant',
            customProperties: {
              'nameColor': Theme.of(context).brightness == Brightness.dark
                  ? Colors.teal[200] // Lighter teal for dark mode
                  : Colors.teal, // Normal teal for light mode
              'fontSize': 18.0, // Larger font size
              'fontWeight': FontWeight.bold, // Make it bold
            }),
        createdAt: DateTime.now(),
        isMarkdown: true,
        customProperties: {
          'isUserMessage': false,
          'isStartOfResponse': true,
          'responseId': responseId,
        },
      ));

      // Automatic scroll behavior handles this based on ScrollBehaviorConfig
      debugPrint(
          'First message automatic scroll with $_selectedAnimationStyle animation');
      

      // Add more long messages with longer delays to better show the scroll behavior
      Future.delayed(const Duration(milliseconds: 2000), () {
        _controller.addMessage(ChatMessage(
          text: "## 📱 MESSAGE #2 (MIDDLE)\n\n" +
              "This is the **second message** in this multi-part AI response. " +
              "You're currently seeing the $_selectedAnimationStyle animation in action.\n\n" +
              "### 🔍 Animation Styles Explained\n" +
              "- **Smooth:** Gradual acceleration and deceleration (natural feel)\n" +
              "- **Bouncy:** Elastic effect that overshoots then settles (playful)\n" +
              "- **Fast:** Quick, minimal animation (efficient)\n" +
              "- **Decelerate:** Starts fast, gradually slows down (gentle landing)\n" +
              "- **Accelerate:** Starts slow, gradually speeds up (building momentum)\n" +
              "- **Default:** Standard easeOut animation (balanced)\n\n" +
              "### 📏 Making This Message VERY TALL Too\n\n" +
              "This middle message is also made very long to ensure the total content height exceeds the screen.\n\n" +
              "🎨 **Extended Animation Analysis**\n\n" +
              "The $_selectedAnimationStyle animation style provides a specific user experience:\n\n" +
              "1. **Visual Impact**: How the animation feels to the user\n" +
              "2. **Performance**: How smooth the animation runs\n" +
              "3. **Accessibility**: How well it works for users with motion preferences\n" +
              "4. **Context**: When this animation style is most appropriate\n\n" +
              "### 📊 Technical Details\n\n" +
              "Animation curves in Flutter:\n" +
              "• `Curves.easeOut` - Default curve, gentle deceleration\n" +
              "• `Curves.easeInOutCubic` - Smooth curve with natural feel\n" +
              "• `Curves.elasticOut` - Bouncy curve with overshoot\n" +
              "• `Curves.easeOutQuart` - Fast curve with quick completion\n" +
              "• `Curves.decelerate` - Rapid start, gradual slowdown\n" +
              "• `Curves.easeIn` - Gradual start, building speed\n\n" +
              "### 🔧 Implementation Notes\n\n" +
              "The scroll animation system uses Flutter's built-in animation controller with customizable duration and curve parameters. This allows for precise control over how the scroll feels to users.\n\n" +
              "⏳ **One more message coming...** Continue watching the scroll behavior!",
          user: _aiUser,
          createdAt: DateTime.now().add(const Duration(milliseconds: 100)),
          isMarkdown: true,
          customProperties: {
            'isUserMessage': false,
            'responseId': responseId,
          },
        ));

        // Automatic scroll behavior handles this based on ScrollBehaviorConfig
        debugPrint(
            'Second message automatic scroll with $_selectedAnimationStyle animation');

        // Final message with even longer delay to make scroll behavior clear
        Future.delayed(const Duration(milliseconds: 3000), () {
          _controller.addMessage(ChatMessage(
            text: "## 🎬 MESSAGE #3 (FINAL/LAST)\n\n" +
                "✅ **This is the LAST message** in this response chain.\n\n" +
                "### 🎯 Scroll Behavior Results\n" +
                "Now that all messages have appeared, the scroll should:\n\n" +
                "${_scrollToFirstMessage ? '🔝 **Show MESSAGE #1 at the top** (scroll to first enabled)' : '🔽 **Show THIS message at the bottom** (scroll to last - default behavior)'}\n\n" +
                "### 🎨 Animation Complete\n" +
                "You just experienced the **$_selectedAnimationStyle** animation curve.\n\n" +
                "### ⚙️ Try Different Settings\n" +
                "Use the settings (⚙️) to experiment with:\n" +
                "- Different animation styles to see how they feel\n" +
                "- Toggle 'scroll to first message' ON/OFF\n" +
                "- Various auto-scroll behaviors\n\n" +
                "**Current Configuration:**\n" +
                "• Animation: `$_selectedAnimationStyle`\n" +
                "• Auto-scroll: `${_selectedScrollBehavior.name}`\n" +
                "• Scroll to first: ${_scrollToFirstMessage ? '✅ Enabled' : '❌ Disabled'}\n\n" +
                "---\n\n" +
                "### 📏 Making This FINAL Message EXTREMELY TALL\n\n" +
                "This is the final message and it's intentionally made very long to ensure the total content of all three messages significantly exceeds screen height.\n\n" +
                "#### 🔬 Deep Dive: Scroll Behavior Analysis\n\n" +
                "The scroll behavior configuration you just tested represents a sophisticated approach to user experience in AI chat interfaces. Here's what makes it powerful:\n\n" +
                "**1. User Context Preservation**\n" +
                "When AI responses are long, users often want to read from the beginning to understand the full context. Traditional chat apps that always scroll to the bottom can frustrate users by hiding the start of important responses.\n\n" +
                "**2. Animation Psychology**\n" +
                "Different animation curves create different emotional responses:\n" +
                "• **Smooth (easeInOutCubic)**: Feels natural and professional\n" +
                "• **Bouncy (elasticOut)**: Adds personality and playfulness\n" +
                "• **Fast (easeOutQuart)**: Emphasizes efficiency and speed\n" +
                "• **Decelerate**: Creates anticipation and gentle landing\n" +
                "• **Accelerate**: Builds momentum and energy\n\n" +
                "**3. Accessibility Considerations**\n" +
                "Users with vestibular disorders or motion sensitivity can benefit from:\n" +
                "- Reduced animation speeds\n" +
                "- More predictable scroll patterns\n" +
                "- User control over automatic scrolling\n\n" +
                "#### 🏗️ Technical Implementation Details\n\n" +
                "The scroll behavior system works through several layers:\n\n" +
                "**Message Chain Tracking:**\n" +
                "```dart\n" +
                "customProperties: {\n" +
                "  'responseId': 'response_123',\n" +
                "  'isStartOfResponse': true,\n" +
                "}\n" +
                "```\n\n" +
                "**Scroll Decision Logic:**\n" +
                "- First message in chain triggers scroll-to-first behavior\n" +
                "- Continuation messages preserve existing scroll position\n" +
                "- Animation timing is carefully calculated\n\n" +
                "**Performance Optimizations:**\n" +
                "- Debounced scroll events prevent excessive redraws\n" +
                "- Smart batching of scroll operations\n" +
                "- Efficient position calculations\n\n" +
                "#### 📱 Real-World Use Cases\n\n" +
                "1. **Code Generation**: When AI generates long code snippets, users want to see the beginning\n" +
                "2. **Educational Content**: Step-by-step explanations are more valuable when read from start\n" +
                "3. **Creative Writing**: Stories and articles should be read from the beginning\n" +
                "4. **Technical Documentation**: Complex explanations need context from the start\n\n" +
                "#### 🎮 Interactive Testing Guide\n\n" +
                "To fully test this system:\n\n" +
                "1. **Compare Behaviors**: Try both scroll-to-first ON and OFF\n" +
                "2. **Test Animation Styles**: Each style creates a different feel\n" +
                "3. **Vary Content Length**: Test with short and very long responses\n" +
                "4. **Check Edge Cases**: Test during streaming, interruptions, rapid messages\n\n" +
                "#### 🔮 Future Enhancements\n\n" +
                "Potential improvements to this system could include:\n" +
                "- Smart content analysis to determine optimal scroll position\n" +
                "- User preference learning and adaptation\n" +
                "- Context-aware animation selection\n" +
                "- Advanced accessibility features\n\n" +
                "#### 📊 Performance Metrics\n\n" +
                "Key metrics for scroll behavior effectiveness:\n" +
                "- **User Satisfaction**: How often users manually adjust scroll position\n" +
                "- **Reading Completion**: Do users read full responses?\n" +
                "- **Animation Smoothness**: Frame rate during scroll animations\n" +
                "- **Battery Impact**: Energy efficiency of different animation styles\n\n" +
                "### 🎯 Test Complete!\n\n" +
                "You've successfully tested the scroll behavior with the $_selectedAnimationStyle animation. The current configuration ${_scrollToFirstMessage ? 'should show MESSAGE #1 at the top' : 'should show this final message at the bottom'}.\n\n" +
                "**📏 Content Height Check**: With this final message being extremely long, the total height of all three messages should now significantly exceed the screen height, making the scroll behavior clearly visible.\n\n" +
                "**🔄 Next Steps**: Try different settings and run the test again to see how each configuration affects the user experience!",
            user: _aiUser,
            createdAt: DateTime.now().add(const Duration(milliseconds: 200)),
            isMarkdown: true,
            customProperties: {
              'isUserMessage': false,
              'responseId': responseId,
            },
          ));

          // Complete test
          if (mounted) setState(() => _isLoading = false);

          // Automatic scroll behavior handles this based on ScrollBehaviorConfig
          debugPrint(
              'Final message automatic scroll with $_selectedAnimationStyle animation');
        });
      });
    });
  }

  // Get a color associated with the current animation style
  Color _getAnimationColor() {
    switch (_selectedAnimationStyle) {
      case 'Smooth':
        return Colors.blue;
      case 'Bouncy':
        return Colors.purple;
      case 'Fast':
        return Colors.orange;
      case 'Decelerate':
        return Colors.green;
      case 'Accelerate':
        return Colors.red;
      case 'Default':
      default:
        return Colors.grey;
    }
  }

  // Get a detailed description of the animation style
  String _getAnimationDescription(String style) {
    switch (style) {
      case 'Smooth':
        return "Smooth animation provides a natural, fluid motion with gradual acceleration and deceleration (easeInOutCubic curve).";
      case 'Bouncy':
        return "Bouncy animation adds a playful elastic effect that overshoots the target position and then settles (elasticOut curve).";
      case 'Fast':
        return "Fast animation provides quick, direct movement with minimal delay (easeOutQuart with shorter duration).";
      case 'Decelerate':
        return "Decelerate animation starts quickly and gradually slows down as it approaches the destination (decelerate curve).";
      case 'Accelerate':
        return "Accelerate animation begins slowly and gradually picks up speed (easeIn curve).";
      case 'Default':
      default:
        return "Default animation uses a standard easeOut curve with moderate speed.";
    }
  }

  // Helper method to get the current scroll config based on animation selection
  ScrollBehaviorConfig _getCurrentScrollConfig() {
    switch (_selectedAnimationStyle) {
      case 'Smooth':
        return ScrollBehaviorConfig.smooth(
          autoScrollBehavior: _selectedScrollBehavior,
          scrollToFirstResponseMessage: _scrollToFirstMessage,
        );
      case 'Bouncy':
        return ScrollBehaviorConfig.bouncy(
          autoScrollBehavior: _selectedScrollBehavior,
          scrollToFirstResponseMessage: _scrollToFirstMessage,
        );
      case 'Fast':
        return ScrollBehaviorConfig.fast(
          autoScrollBehavior: _selectedScrollBehavior,
          scrollToFirstResponseMessage: _scrollToFirstMessage,
        );
      case 'Decelerate':
        return ScrollBehaviorConfig.decelerate(
          autoScrollBehavior: _selectedScrollBehavior,
          scrollToFirstResponseMessage: _scrollToFirstMessage,
        );
      case 'Accelerate':
        return ScrollBehaviorConfig.accelerate(
          autoScrollBehavior: _selectedScrollBehavior,
          scrollToFirstResponseMessage: _scrollToFirstMessage,
        );
      case 'Default':
      default:
        return ScrollBehaviorConfig(
          autoScrollBehavior: _selectedScrollBehavior,
          scrollToFirstResponseMessage: _scrollToFirstMessage,
        );
    }
  }

  /// Build futuristic app bar
  PreferredSizeWidget _buildFuturisticAppBar(
    BuildContext context,
    AppState appState,
    bool isDarkMode,
  ) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [
                    const Color(0xFF0A0A0F),
                    const Color(0xFF1A1B23).withOpacity(0.8),
                  ]
                : [
                    const Color(0xFFF8F9FF),
                    const Color(0xFFFFFFFF).withOpacity(0.9),
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border(
            bottom: BorderSide(
              color: isDarkMode 
                  ? const Color(0xFF1F2937).withOpacity(0.3)
                  : const Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
        ),
      ),
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDarkMode 
              ? const Color(0xFF1A1B23).withOpacity(0.6)
              : const Color(0xFFFFFFFF).withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode 
                ? const Color(0xFF374151).withOpacity(0.3)
                : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: isDarkMode 
                ? const Color(0xFF00D4FF)
                : const Color(0xFF6366F1),
            size: 18,
          ),
          onPressed: () => Navigator.of(context).pop(),
          padding: EdgeInsets.zero,
        ),
      ),
      title: Flexible(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [const Color(0xFF00D4FF), const Color(0xFF0EA5E9)]
                      : [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: (isDarkMode 
                        ? const Color(0xFF00D4FF) 
                        : const Color(0xFF6366F1)).withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.swipe_vertical_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Scroll Behavior',
                    style: TextStyle(
                      color: isDarkMode 
                          ? const Color(0xFFF3F4F6)
                          : const Color(0xFF1F2937),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Animation testing',
                    style: TextStyle(
                      color: isDarkMode 
                          ? const Color(0xFF6B7280)
                          : const Color(0xFF9CA3AF),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 6),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isDarkMode 
                ? const Color(0xFF1A1B23).withOpacity(0.6)
                : const Color(0xFFFFFFFF).withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDarkMode 
                  ? const Color(0xFF374151).withOpacity(0.3)
                  : const Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
          child: IconButton(
            icon: Icon(
              Icons.play_arrow_rounded,
              color: isDarkMode 
                  ? const Color(0xFF00D4FF)
                  : const Color(0xFF6366F1),
              size: 18,
            ),
            onPressed: _testCurrentScrollBehavior,
            tooltip: 'Test behavior',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 12),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isDarkMode 
                ? const Color(0xFF1A1B23).withOpacity(0.6)
                : const Color(0xFFFFFFFF).withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDarkMode 
                  ? const Color(0xFF374151).withOpacity(0.3)
                  : const Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
          child: IconButton(
            icon: Icon(
              Icons.settings_rounded,
              color: isDarkMode 
                  ? const Color(0xFF00D4FF)
                  : const Color(0xFF6366F1),
              size: 18,
            ),
            onPressed: _showSettingsDialog,
            tooltip: 'Settings',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 12),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isDarkMode 
                ? const Color(0xFF1A1B23).withOpacity(0.6)
                : const Color(0xFFFFFFFF).withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDarkMode 
                  ? const Color(0xFF374151).withOpacity(0.3)
                  : const Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
          child: IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                key: ValueKey(isDarkMode),
                color: isDarkMode 
                    ? const Color(0xFF00D4FF)
                    : const Color(0xFF6366F1),
                size: 18,
              ),
            ),
            onPressed: () => appState.toggleTheme(),
            tooltip: isDarkMode ? 'Light' : 'Dark',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
      ],
    );
  }

  /// Build futuristic loading indicator
  Widget _buildFuturisticLoadingIndicator() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return LoadingWidget(
      texts: [
        "Testing scroll behavior...",
        "Analyzing animation...",
        "Generating response...",
        "Ready to scroll...",
      ],
      shimmerBaseColor: isDarkMode 
          ? const Color(0xFF1F2937)
          : const Color(0xFFE5E7EB),
      shimmerHighlightColor: isDarkMode 
          ? const Color(0xFF00D4FF).withOpacity(0.3)
          : const Color(0xFF6366F1).withOpacity(0.2),
    );
  }
}
