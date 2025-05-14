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

  // Initialize with custom scroll behavior to solve the issue with long responses
  AutoScrollBehavior _selectedScrollBehavior =
      AutoScrollBehavior.onUserMessageOnly;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scroll Behavior Example'),
        actions: [
          // Test current mode button
          TextButton.icon(
            icon: const Icon(Icons.play_arrow),
            label: const Text('Test'),
            onPressed: _testCurrentScrollBehavior,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Small indicator of current mode
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color:
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Mode: ${_selectedScrollBehavior.name}${_scrollToFirstMessage ? " (scroll to first message)" : ""} • Style: $_selectedAnimationStyle',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
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
              // Add message styling with proper dark theme support
              messageOptions: MessageOptions(
                showUserName: true,
                userNameStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.lightBlue[300] // Brighter blue for dark theme
                      : Colors.blue[700], // Dark blue for light theme
                ),
                textStyle: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white // White text for dark theme
                      : Colors.black87, // Dark text for light theme
                ),
                bubbleStyle: BubbleStyle(
                  userBubbleColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.blue
                              .withOpacity(0.3) // Darker blue for dark theme
                          : Colors.blue
                              .withOpacity(0.1), // Light blue for light theme
                  aiBubbleColor: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF2D2D2D) // Dark gray for dark theme
                      : Colors.white, // White for light theme
                  userNameColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.lightBlue[300] // Brighter blue for dark theme
                      : Colors.blue[700], // Dark blue for light theme
                  aiNameColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.purple[200] // Light purple for dark theme
                      : Colors.purple[700], // Dark purple for light theme
                ),
              ),
              // Add professional-looking input styling
              inputOptions: InputOptions(
                // Dark mode adapted input design
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[400] // Lighter gray for dark theme
                        : Colors.grey[600], // Darker gray for light theme
                  ),
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? const Color(
                          0xFF1E1E1E) // Slightly lighter than background
                      : Colors.grey[100], // Light gray for light theme
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[800]! // Dark border for dark theme
                          : Colors.grey[300]!, // Light border for light theme
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[800]! // Dark border for dark theme
                          : Colors.grey[300]!, // Light border for light theme
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                sendButtonColor: Theme.of(context).primaryColor,
              ),
              // Add some example questions to try
              exampleQuestions: [
                ExampleQuestion(
                  question: "Generate a long response",
                  config: ExampleQuestionConfig(
                    // Add light text for dark theme
                    textStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white // White text for dark theme
                          : Colors.black87, // Dark text for light theme
                      fontSize: 16, // Slightly larger font
                    ),
                    // Add light icon for dark theme
                    iconData: Icons.chat_bubble_outline,
                    iconColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors
                            .lightBlue[300] // Light blue icon for dark theme
                        : Colors.blue, // Blue icon for light theme
                    containerDecoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[800] // Lighter background in dark mode
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[700]! // Visible border in dark mode
                            : Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                ExampleQuestion(
                  question: "Tell me about auto-scrolling",
                  config: ExampleQuestionConfig(
                    // Add light text for dark theme
                    textStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white // White text for dark theme
                          : Colors.black87, // Dark text for light theme
                      fontSize: 16, // Slightly larger font
                    ),
                    // Add light icon for dark theme
                    iconData: Icons.swipe_vertical,
                    iconColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors
                            .lightBlue[300] // Light blue icon for dark theme
                        : Colors.blue, // Blue icon for light theme
                    containerDecoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[800] // Lighter background in dark mode
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[700]! // Visible border in dark mode
                            : Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                ExampleQuestion(
                  question: "Generate a multi-paragraph response",
                  config: ExampleQuestionConfig(
                    // Add light text for dark theme
                    textStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white // White text for dark theme
                          : Colors.black87, // Dark text for light theme
                      fontSize: 16, // Slightly larger font
                    ),
                    // Add light icon for dark theme
                    iconData: Icons.format_align_left,
                    iconColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors
                            .lightBlue[300] // Light blue icon for dark theme
                        : Colors.blue, // Blue icon for light theme
                    containerDecoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[800] // Lighter background in dark mode
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[700]! // Visible border in dark mode
                            : Colors.grey[300]!,
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
                  setState(() {
                    _selectedScrollBehavior = tempScrollBehavior;
                    _scrollToFirstMessage = tempScrollToFirst;
                    _selectedAnimationStyle = tempAnimationStyle;

                    // Explicitly update the controller's scroll behavior configuration
                    _controller.scrollBehaviorConfig =
                        _getCurrentScrollConfig();

                    debugPrint(
                        'Updated scroll behavior: ${_selectedScrollBehavior.name}, '
                        'scroll to first message: $_scrollToFirstMessage, '
                        'animation style: $_selectedAnimationStyle');
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
          customProperties: {'isUserMessage': false, 'isStartOfResponse': true},
        ));
      }
    } finally {
      setState(() => _isLoading = false);
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

    // If scrollToFirstMessage is enabled, force scroll to the first message
    if (_scrollToFirstMessage) {
      Future.delayed(const Duration(milliseconds: 200), () {
        debugPrint('FORCING scroll to first message in chain');
        _controller.forceScrollToFirstMessageInChain(responseId);
      });
    }

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

      // Reinforce the scroll position to the first message
      if (_scrollToFirstMessage) {
        Future.delayed(const Duration(milliseconds: 200), () {
          _controller.forceScrollToFirstMessageInChain(responseId);
        });
      }
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

    // Force scroll to first message if that option is enabled
    if (_scrollToFirstMessage) {
      Future.delayed(const Duration(milliseconds: 200), () {
        _controller.forceScrollToFirstMessageInChain(responseId);
      });
    }

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

      // Maintain scroll position if needed
      if (_scrollToFirstMessage) {
        Future.delayed(const Duration(milliseconds: 200), () {
          _controller.forceScrollToFirstMessageInChain(responseId);
        });
      }
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
    // Show overlay to explain what's happening
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Testing with animation style: $_selectedAnimationStyle\n' +
                'Watch how the scrolling behaves!'),
        duration: const Duration(milliseconds: 2000),
        backgroundColor: _getAnimationColor(),
      ),
    );

    setState(() => _isLoading = true);

    // Clear any previous messages to ensure a clean test
    _controller.clearMessages();

    // Ensure controller has latest configuration
    _controller.scrollBehaviorConfig = _getCurrentScrollConfig();

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
      // First message with very clear animation style indication
      _controller.addMessage(ChatMessage(
        text: "✨ $_selectedAnimationStyle Animation ✨\n\n" +
            "Demonstrating $_selectedAnimationStyle scrolling:\n" +
            _getAnimationDescription(_selectedAnimationStyle) +
            "\n\n" +
            "Watch how the messages scroll as more arrive...",
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

      // Force scroll using the selected animation style
      Future.delayed(const Duration(milliseconds: 200), () {
        _controller.forceScrollToFirstMessageInChain(responseId);
        debugPrint(
            'First message scroll with $_selectedAnimationStyle animation');
      });

      // Add more long messages with increasing delays to better show the animation
      Future.delayed(const Duration(milliseconds: 1500), () {
        _controller.addMessage(ChatMessage(
          text: "⏺️ SECOND MESSAGE - $_selectedAnimationStyle scrolling continues\n\n" +
              "This message is added after a longer delay to help you see the $_selectedAnimationStyle animation style more clearly.\n\n" +
              "Each animation style has different characteristics:\n" +
              "- Smooth: Gradual acceleration and deceleration (easeInOutCubic)\n" +
              "- Bouncy: Elastic effect that overshoots then settles (elasticOut)\n" +
              "- Fast: Quick, minimal animation (easeOutQuart)\n" +
              "- Decelerate: Starts fast, gradually slows down\n" +
              "- Accelerate: Starts slow, gradually speeds up\n" +
              "- Default: Standard easeOut animation",
          user: _aiUser,
          createdAt: DateTime.now().add(const Duration(milliseconds: 100)),
          isMarkdown: true,
          customProperties: {
            'isUserMessage': false,
            'responseId': responseId,
          },
        ));

        // Force scroll with the selected animation style again
        if (_scrollToFirstMessage) {
          Future.delayed(const Duration(milliseconds: 300), () {
            _controller.forceScrollToFirstMessageInChain(responseId);
            debugPrint(
                'Second message scroll with $_selectedAnimationStyle animation');
          });
        }

        // Final message with longer delay to make animation more visible
        Future.delayed(const Duration(milliseconds: 2000), () {
          _controller.addMessage(ChatMessage(
            text: "🎬 FINAL MESSAGE - $_selectedAnimationStyle animation complete\n\n" +
                "The scrolling behavior you just saw demonstrates the $_selectedAnimationStyle animation curve.\n\n" +
                "Try other animation styles from the settings (⚙️) to compare how they look and feel!\n\n" +
                "Current settings:\n" +
                "- Animation: **$_selectedAnimationStyle**\n" +
                "- Auto-scroll behavior: **${_selectedScrollBehavior.name}**\n" +
                "- Scroll to first message: **${_scrollToFirstMessage ? 'Yes' : 'No'}**",
            user: _aiUser,
            createdAt: DateTime.now().add(const Duration(milliseconds: 200)),
            isMarkdown: true,
            customProperties: {
              'isUserMessage': false,
              'responseId': responseId,
            },
          ));

          // Complete test
          setState(() => _isLoading = false);

          // Final force scroll
          if (_scrollToFirstMessage) {
            Future.delayed(const Duration(milliseconds: 300), () {
              _controller.forceScrollToFirstMessageInChain(responseId);
            });
          }
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
}
