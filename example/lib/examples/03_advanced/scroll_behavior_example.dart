import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

class ScrollBehaviorExample extends StatefulWidget {
  const ScrollBehaviorExample({Key? key}) : super(key: key);

  @override
  State<ScrollBehaviorExample> createState() => _ScrollBehaviorExampleState();
}

class _ScrollBehaviorExampleState extends State<ScrollBehaviorExample> {
  late final ChatMessagesController _controller;
  final _currentUser = const ChatUser(id: 'user', firstName: 'You');
  final _aiUser = const ChatUser(id: 'ai', firstName: 'AI Assistant');
  bool _isLoading = false;

  // Initialize with custom scroll behavior to solve the issue with long responses
  AutoScrollBehavior _selectedScrollBehavior =
      AutoScrollBehavior.onUserMessageOnly;
  bool _scrollToFirstMessage = true;

  @override
  void initState() {
    super.initState();
    _controller = ChatMessagesController(
      scrollBehaviorConfig: ScrollBehaviorConfig(
        autoScrollBehavior: _selectedScrollBehavior,
        scrollToFirstResponseMessage: _scrollToFirstMessage,
      ),
    );

    // Log the initial configuration
    debugPrint('Initial scroll behavior: $_selectedScrollBehavior, '
        'scrollToFirstMessage: $_scrollToFirstMessage');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scroll Behavior Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Mode: ${_selectedScrollBehavior.name}${_scrollToFirstMessage ? " (scroll to first message)" : ""}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _testCurrentScrollBehavior(),
                  child: const Text('Test Current Mode'),
                ),
              ],
            ),
          ),
          Expanded(
            child: AiChatWidget(
              currentUser: _currentUser,
              aiUser: _aiUser,
              controller: _controller,
              onSendMessage: _handleSendMessage,
              loadingConfig: LoadingConfig(isLoading: _isLoading),
              // Configure scroll behavior to solve the issue with long responses
              scrollBehaviorConfig: ScrollBehaviorConfig(
                autoScrollBehavior: _selectedScrollBehavior,
                scrollToFirstResponseMessage: _scrollToFirstMessage,
              ),
              // Add some example questions to try
              exampleQuestions: [
                ExampleQuestion(question: "Generate a long response"),
                ExampleQuestion(question: "Tell me about auto-scrolling"),
                ExampleQuestion(
                    question: "Generate a multi-paragraph response"),
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

        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Scroll Behavior Settings'),
            content: Column(
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
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedScrollBehavior = tempScrollBehavior;
                    _scrollToFirstMessage = tempScrollToFirst;

                    // Explicitly update the controller's scroll behavior configuration
                    _controller.scrollBehaviorConfig = ScrollBehaviorConfig(
                      autoScrollBehavior: _selectedScrollBehavior,
                      scrollToFirstResponseMessage: _scrollToFirstMessage,
                    );

                    debugPrint(
                        'Updated scroll behavior: ${_selectedScrollBehavior.name}, '
                        'scroll to first message: $_scrollToFirstMessage');
                  });
                  Navigator.pop(context);
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

  Future<void> _handleSendMessage(ChatMessage message) async {
    setState(() => _isLoading = true);

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
          customProperties: {
            'isUserMessage': false
          }, // Explicitly mark as AI message
        ));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _simulateLongResponse() {
    // First part of the response
    _controller.addMessage(ChatMessage(
      text:
          "# Long Response Example\n\nThis is a long response that demonstrates how the scrolling behavior works with multi-part responses. Notice how the different scroll behavior settings affect what happens when this message appears.",
      user: _aiUser,
      createdAt: DateTime.now(),
      isMarkdown: true,
      customProperties: {'isUserMessage': false},
    ));

    // Add the other parts with slight delays to simulate streaming
    Future.delayed(const Duration(milliseconds: 800), () {
      _controller.addMessage(ChatMessage(
        text:
            "## Section 1: Introduction\n\nWhen an AI gives a long response with multiple paragraphs or message bubbles, the default behavior in many chat UIs is to scroll to the bottom, showing the most recent part of the response.",
        user: _aiUser,
        createdAt: DateTime.now().add(const Duration(milliseconds: 100)),
        isMarkdown: true,
        customProperties: {'isUserMessage': false},
      ));
    });

    Future.delayed(const Duration(milliseconds: 1600), () {
      _controller.addMessage(ChatMessage(
        text:
            "## Section 2: The Problem\n\nHowever, this can be problematic for users because they might miss the beginning of the response, which often contains important context or the direct answer to their question.",
        user: _aiUser,
        createdAt: DateTime.now().add(const Duration(milliseconds: 200)),
        isMarkdown: true,
        customProperties: {'isUserMessage': false},
      ));
    });

    Future.delayed(const Duration(milliseconds: 2400), () {
      _controller.addMessage(ChatMessage(
        text:
            "## Section 3: The Solution\n\nThe new `scrollBehaviorConfig` allows you to control this behavior. You can:\n\n- Only auto-scroll for user messages (letting users control scrolling for AI responses)\n- Scroll to the first message of a response instead of the last\n- Disable auto-scrolling entirely\n\nTry changing the settings using the gear icon in the app bar!",
        user: _aiUser,
        createdAt: DateTime.now().add(const Duration(milliseconds: 300)),
        isMarkdown: true,
        customProperties: {'isUserMessage': false},
      ));
    });
  }

  void _simulateAutoScrollExplanation() {
    _controller.addMessage(ChatMessage(
      text:
          "# Auto-Scrolling Behavior Options\n\nThis chat widget now supports several scrolling behaviors to improve user experience with long responses:",
      user: _aiUser,
      createdAt: DateTime.now(),
      isMarkdown: true,
      customProperties: {'isUserMessage': false},
    ));

    Future.delayed(const Duration(milliseconds: 800), () {
      _controller.addMessage(ChatMessage(
        text:
            "## Always\n\nThe widget will always scroll to the bottom whenever messages are added or updated. This ensures you always see the most recent content, but can be disruptive with long responses as it will keep scrolling as each part arrives.",
        user: _aiUser,
        createdAt: DateTime.now().add(const Duration(milliseconds: 100)),
        isMarkdown: true,
        customProperties: {'isUserMessage': false},
      ));
    });

    Future.delayed(const Duration(milliseconds: 1600), () {
      _controller.addMessage(ChatMessage(
        text:
            "## On New Message\n\nThe widget will only scroll when a completely new message is added, not during updates to existing messages. This is useful when streaming updates, as it won't constantly scroll during the streaming process.",
        user: _aiUser,
        createdAt: DateTime.now().add(const Duration(milliseconds: 200)),
        isMarkdown: true,
        customProperties: {'isUserMessage': false},
      ));
    });

    Future.delayed(const Duration(milliseconds: 2400), () {
      _controller.addMessage(ChatMessage(
        text:
            "## On User Message Only\n\nThe widget will only auto-scroll when the user sends a message, not for AI responses. This gives the user full control over scrolling when reading AI responses, which is especially helpful for long, detailed answers.",
        user: _aiUser,
        createdAt: DateTime.now().add(const Duration(milliseconds: 300)),
        isMarkdown: true,
        customProperties: {'isUserMessage': false},
      ));
    });

    Future.delayed(const Duration(milliseconds: 3200), () {
      _controller.addMessage(ChatMessage(
        text:
            "## Never\n\nThe widget will never auto-scroll. The user is fully responsible for manually scrolling through the conversation. This is the most conservative option that gives users complete control.",
        user: _aiUser,
        createdAt: DateTime.now().add(const Duration(milliseconds: 400)),
        isMarkdown: true,
        customProperties: {'isUserMessage': false},
      ));
    });
  }

  // Test the current scroll behavior
  void _testCurrentScrollBehavior() {
    setState(() => _isLoading = true);

    // First add a user message
    _controller.addMessage(ChatMessage(
      text:
          "Show me an example of a very long message that demonstrates scroll behavior",
      user: _currentUser,
      createdAt: DateTime.now(),
      customProperties: {'isUserMessage': true, 'source': 'user'},
    ));

    // Simulate API delay
    Future.delayed(const Duration(milliseconds: 500), () {
      // First part of response
      _controller.addMessage(ChatMessage(
        text:
            "# Very Long Message Example\n\nThis example demonstrates how our improved scroll behavior handles extremely long content. With the fixes to the scroll system, the UI will now correctly scroll to the first part of the message when configured to do so.",
        user: _aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
        customProperties: {'isUserMessage': false},
      ));

      // Add more content with a delay
      Future.delayed(const Duration(milliseconds: 600), () {
        _controller.addMessage(ChatMessage(
          text: """## Technical Details of the Scroll Fix

The scrolling system was improved in two key ways:

1. **Fixed Position Calculation**: The scrollToMessage method now uses a more accurate position calculation that correctly displays the start of long messages.

2. **Prevented Double Scrolling**: We eliminated an issue where the system would first scroll to the correct position but then immediately scroll to the bottom.

3. **Added Tracking**: A tracking variable now ensures only one scroll action happens per message event.

```dart
void _scrollAfterRender(bool isUserMessage, bool isStartOfResponse, ScrollBehaviorConfig config) {
  // Store current response ID
  final currentResponseId = _currentResponseFirstMessageId;
  
  // Add a tracking variable to prevent multiple scroll actions
  bool hasScrolled = false;
  
  // Ensures the message is rendered first
  Future.microtask(() {
    // Delayed to ensure layout is complete
    Future.delayed(const Duration(milliseconds: 200), () {
      // Scroll to first response if conditions are met
      if (!isUserMessage && 
          config.scrollToFirstResponseMessage && 
          currentResponseId != null) {
          
        scrollToMessage(currentResponseId);
        hasScrolled = true;
      } 
      // Only scroll to bottom if we haven't already scrolled
      else if (!hasScrolled) {
        scrollToBottom();
      }
    });
  });
}
```""",
          user: _aiUser,
          createdAt: DateTime.now().add(const Duration(milliseconds: 100)),
          isMarkdown: true,
          customProperties: {'isUserMessage': false},
        ));

        // Add even more content with additional delay
        Future.delayed(const Duration(milliseconds: 600), () {
          _controller.addMessage(ChatMessage(
            text: """## Why This Matters

Very long messages like this one pose a unique challenge for chat UIs:

1. **User Experience**: When a long message arrives, users typically want to read from the beginning
2. **Context Preservation**: Reading from the middle or end of a response can be confusing
3. **Information Hierarchy**: The most important information is often at the beginning

With the current scroll configuration settings:

${_selectedScrollBehavior.name == AutoScrollBehavior.onUserMessageOnly ? "✅ **User Messages Only**: The chat only auto-scrolls when you send a message, giving you full control when receiving long AI responses." : ""}

${_selectedScrollBehavior.name == AutoScrollBehavior.always ? "🔄 **Always**: The chat automatically scrolls for every message update." : ""}

${_selectedScrollBehavior.name == AutoScrollBehavior.onNewMessage ? "📨 **New Messages**: The chat only scrolls for new messages, not updates." : ""}

${_selectedScrollBehavior.name == AutoScrollBehavior.never ? "🛑 **Never**: Auto-scrolling is completely disabled, requiring manual scrolling." : ""}

${_scrollToFirstMessage ? "✅ **First Message Scrolling**: Enabled - when AI responds, view starts at the first message" : "❌ **First Message Scrolling**: Disabled - AI responses scroll to the most recent content"}""",
            user: _aiUser,
            createdAt: DateTime.now().add(const Duration(milliseconds: 200)),
            isMarkdown: true,
            customProperties: {'isUserMessage': false},
          ));

          // Final part with test instructions
          Future.delayed(const Duration(milliseconds: 600), () {
            _controller.addMessage(ChatMessage(
              text: """## Testing Instructions

To test the scroll behavior:

1. Try different auto-scroll modes in the settings ⚙️
2. Toggle 'Scroll to first message of response'
3. Send messages and observe how the chat scrolls
4. Pay attention to long responses like this one

The best configuration for most users with long content like this is:
- `AutoScrollBehavior.onUserMessageOnly` (only auto-scroll when the user sends a message)
- `scrollToFirstResponseMessage: true` (show the beginning of AI responses)

This provides a balance of automation and user control.

---

This very long message with multiple sections demonstrates our improved scrolling system, which now correctly handles large content while respecting user configuration preferences.""",
              user: _aiUser,
              createdAt: DateTime.now().add(const Duration(milliseconds: 300)),
              isMarkdown: true,
              customProperties: {'isUserMessage': false},
            ));

            setState(() => _isLoading = false);
          });
        });
      });
    });
  }
}
