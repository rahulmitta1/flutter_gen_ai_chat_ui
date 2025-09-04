import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'dart:ui';

class IntermediateChatScreen extends StatefulWidget {
  const IntermediateChatScreen({super.key});

  @override
  State<IntermediateChatScreen> createState() => _IntermediateChatScreenState();
}

class _IntermediateChatScreenState extends State<IntermediateChatScreen>
    with TickerProviderStateMixin {
  late final ChatMessagesController _chatController;
  late final TextEditingController _textController;
  late final ChatUser _currentUser;
  late final ChatUser _aiUser;
  bool _isGenerating = false;
  bool _useStreaming = true;

  // Liquid glass animation controllers
  AnimationController? _liquidController;

  // Liquid glass animations
  Animation<double>? _liquidBlurAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _chatController = ChatMessagesController();
    _textController = TextEditingController();
    _currentUser = const ChatUser(
      id: 'user-1',
      name: 'You',
      avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=user&size=128',
    );
    _aiUser = const ChatUser(
      id: 'ai-1',
      name: 'Assistant',
      avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=ai&size=128',
    );

    // Initialize liquid glass animations
    _liquidController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Apple-style liquid blur animation - subtle blur values for authentic look
    _liquidBlurAnimation = Tween<double>(begin: 1.5, end: 3.0).animate(
      CurvedAnimation(parent: _liquidController!, curve: Curves.easeInOut),
    );

    // Start liquid glass animation
    _liquidController?.repeat();

    // Add welcome message
    _chatController.addMessage(
      ChatMessage(
        text:
            'Hello! 👋 I\'m your AI assistant. I can help you with questions, provide information, assist with tasks, and have conversations on a wide variety of topics.\n\nFeel free to ask me anything - I\'m here to help! ✨',
        user: _aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
      ),
    );

    // Show welcome message with liquid glass example questions
    _chatController.showWelcomeMessage = true;
  }

  @override
  void dispose() {
    _liquidController?.dispose();
    _chatController.dispose();
    _textController.dispose();
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
            'isStreaming':
                true, // Mark as streaming so the package handles the animation
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
      // Non-streaming mode - show loading then add complete response
      await Future.delayed(const Duration(milliseconds: 800));

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

    // Clear loading state
    if (mounted) {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  /// Generate AI response based on user input
  String _generateResponse(String userInput) {
    final input = userInput.toLowerCase();

    if (input.contains('help') || input.contains('what can you')) {
      return '''I can assist you with a wide variety of tasks! Here's what I can help with:

## 💬 **Conversations & Questions**
- Answer questions on virtually any topic
- Provide explanations and clarifications
- Have discussions about ideas and concepts

## 💻 **Development & Technical**
- Help with programming problems
- Explain coding concepts
- Review and debug code
- Suggest best practices

## 📚 **Learning & Education**
- Break down complex topics
- Provide step-by-step tutorials
- Help with research and analysis

## ✍️ **Writing & Communication**
- Help with writing and editing
- Brainstorm ideas
- Improve clarity and structure

Feel free to ask me anything - I'm here to help make your tasks easier!''';
    } else if (input.contains('flutter') ||
        input.contains('mobile') ||
        input.contains('app')) {
      return '''**Flutter** is Google's UI toolkit for building beautiful, natively compiled applications! Here's what makes it great:

## 🚀 **Why Flutter?**
- **Cross-Platform**: Write once, run everywhere (iOS, Android, Web, Desktop)
- **Fast Development**: Hot reload for instant updates
- **Beautiful UI**: Rich set of customizable widgets
- **High Performance**: Compiled to native ARM code

## 📱 **Getting Started**
1. **Install Flutter SDK** from flutter.dev
2. **Set up your IDE** (VS Code, Android Studio)
3. **Create a new project**: `flutter create my_app`
4. **Run your app**: `flutter run`

## 🎨 **Key Concepts**
- **Widgets**: Everything is a widget in Flutter
- **State Management**: Provider, Riverpod, Bloc, etc.
- **Navigation**: Navigator and routing
- **Responsive Design**: MediaQuery and layout builders

## 💡 **Pro Tips**
- Use `flutter doctor` to check your setup
- Explore pub.dev for amazing packages
- Follow Flutter's official documentation
- Join the Flutter community for help!

Would you like me to help you with any specific Flutter topic?''';
    } else if (input.contains('code') || input.contains('example')) {
      return '''Here are some **Flutter code examples** to get you started:

## 🏗️ **Basic Flutter App Structure**

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You have pushed the button this many times:'),
            Text('\$_counter', style: Theme.of(context).textTheme.headline4),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
```

This is the classic Flutter counter app - a great starting point for learning Flutter development!''';
    } else if (input.contains('design') ||
        input.contains('ui') ||
        input.contains('interface')) {
      return '''Modern **UI/UX design** focuses on creating intuitive and delightful user experiences:

## 🎨 **Design Principles**

**User-Centered Design**: Always prioritize user needs and behaviors
**Consistency**: Maintain visual and interaction patterns throughout
**Accessibility**: Design for users of all abilities
**Simplicity**: Remove unnecessary complexity

## 🎯 **Key Elements**

1. **Visual Hierarchy**: Guide users through content with typography, color, and spacing
2. **Responsive Design**: Adapt to different screen sizes and devices
3. **Interactive Feedback**: Provide clear responses to user actions
4. **Color Psychology**: Use colors strategically to evoke emotions

## 🛠️ **Design Tools**

- **Figma**: Collaborative design and prototyping
- **Adobe XD**: User experience design and prototyping  
- **Sketch**: Digital design toolkit (Mac only)
- **Framer**: Advanced prototyping and animation

## 💡 **Best Practices**

- **User Testing**: Validate designs with real users
- **Iteration**: Continuously improve based on feedback
- **Performance**: Ensure fast loading and smooth interactions
- **Mobile-First**: Design for mobile devices first

## 🔍 **Current Trends**

- **Minimalism**: Clean, focused designs
- **Dark Mode**: Reduce eye strain and save battery
- **Micro-interactions**: Small animations that enhance UX
- **Voice Interfaces**: Designing for voice commands

Would you like to explore any specific aspect of UI/UX design?''';
    } else {
      return '''I'm here to help you with any questions or tasks you might have!

## 💡 **Try asking about:**
- **Development** - Programming, coding, and technical questions
- **Learning** - Explanations and tutorials on any topic
- **Problem Solving** - Help with challenges you're facing
- **Creative Projects** - Ideas and brainstorming

## 🚀 **Popular topics:**
- Flutter and mobile app development
- Web development and programming
- UI/UX design principles
- Career advice and learning paths
- Technology trends and best practices

Feel free to ask me anything - I'm designed to be helpful, informative, and engaging in our conversations!''';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF0A0A0A),
                    const Color(0xFF1A1A1A),
                    const Color(0xFF0F0F0F),
                  ]
                : [
                    const Color(0xFFF8FAFC),
                    const Color(0xFFF1F5F9),
                    const Color(0xFFE2E8F0),
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildLiquidGlassAppBar(isDark),
              Expanded(
                child: Stack(
                  children: [
                    // Main chat widget with hidden input
                    Column(
                      children: [
                        Expanded(
                          child: AnimatedBuilder(
                            animation: _liquidController!,
                            builder: (context, child) {
                              return AiChatWidget(
                                controller: _chatController,
                                currentUser: _currentUser,
                                aiUser: _aiUser,
                                onSendMessage: _handleSendMessage,
                                inputOptions: _buildLiquidGlassInputOptions(
                                  isDark,
                                ),
                                messageOptions: _buildLiquidGlassMessageOptions(
                                  isDark,
                                ),
                                loadingConfig: LoadingConfig(
                                  isLoading: _isGenerating,
                                  loadingIndicator: LoadingWidget(
                                    // Loading texts that cycle
                                    texts: const [
                                      'Thinking...',
                                      'Processing your request...',
                                      'Generating response...',
                                    ],
                                    interval: const Duration(
                                      milliseconds: 2500,
                                    ),

                                    // Enable built-in glassmorphic effect
                                    // isGlassmorphic: true,
                                    // blurStrength: _liquidBlurAnimation?.value ?? 2.5,
                                    // glassmorphicOpacity: 0.15,

                                    // Liquid glass styling
                                    backgroundColor: Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    // border: Border.all(
                                    //   color: isDark
                                    //       ? Colors.white.withOpacity(0.8)
                                    //       : Colors.black.withOpacity(0.8),
                                    //   width: 1,
                                    // ),

                                    // Apple-style gradient
                                    gradientColors: [
                                      isDark
                                          ? Colors.white.withOpacity(0.15)
                                          : Colors.white.withOpacity(0.25),
                                      isDark
                                          ? Colors.white.withOpacity(0.05)
                                          : Colors.white.withOpacity(0.1),
                                    ],
                                    gradientType: GradientType.linear,
                                    gradientAngle: 135,

                                    // Shimmer effect
                                    shimmerBaseColor: isDark
                                        ? Colors.white.withOpacity(0.1)
                                        : Colors.black.withOpacity(0.05),
                                    shimmerHighlightColor: isDark
                                        ? Colors.white.withOpacity(0.3)
                                        : Colors.white.withOpacity(0.8),

                                    // Layout
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 8,
                                    ),
                                    alignment: Alignment.centerLeft,

                                    // Typography
                                    textStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                ),
                                welcomeMessageConfig: WelcomeMessageConfig(
                                  title: 'AI Assistant',
                                  titleStyle: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        isDark ? Colors.white : Colors.black87,
                                  ),
                                  containerPadding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 32,
                                  ),
                                  questionsSectionPadding: const EdgeInsets.all(
                                    20,
                                  ),
                                ),
                                exampleQuestions:
                                    _buildExampleQuestions(isDark),
                              );
                            },
                          ),
                        ),
                        // No need for custom input area - using package's built-in input
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Liquid glass app bar with flowing animations
  Widget _buildLiquidGlassAppBar(bool isDark) {
    if (_liquidController == null) {
      return _buildFallbackAppBar(isDark);
    }

    return AnimatedBuilder(
      animation: _liquidController!,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          constraints: const BoxConstraints(minHeight: 60, maxHeight: 80),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.15)
                : Colors.black.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.8)
                  : Colors.black.withOpacity(0.8),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    isDark ? const Color(0x201F2687) : const Color(0x20000000),
                blurRadius: 32,
                offset: const Offset(0, 8),
              ),
              // Apple-style specular highlight
              BoxShadow(
                color: isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.white.withOpacity(0.3),
                blurRadius: 1,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: _liquidBlurAnimation?.value ?? 2.0,
                sigmaY: _liquidBlurAnimation?.value ?? 2.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            Colors.white.withOpacity(0.15),
                            Colors.white.withOpacity(0.05),
                          ]
                        : [
                            Colors.white.withOpacity(0.25),
                            Colors.white.withOpacity(0.1),
                          ],
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 18,
                ),
                child: Row(
                  children: [
                    // Apple-style back button with liquid glass treatment
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withOpacity(0.3)
                              : Colors.black.withOpacity(0.2),
                          width: 0.5,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: isDark ? Colors.white70 : Colors.black87,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Title with icon - Optimized to prevent overflow
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  isDark
                                      ? Colors.blue.withOpacity(0.3)
                                      : Colors.blue.withOpacity(0.2),
                                  isDark
                                      ? Colors.blue.withOpacity(0.1)
                                      : Colors.blue.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.auto_awesome,
                              color:
                                  isDark ? Colors.blue[300] : Colors.blue[600],
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'AI Assistant',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        isDark ? Colors.white : Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'AI Assistant',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: isDark
                                        ? Colors.white60
                                        : Colors.black54,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Single refresh button to save space
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.08)
                            : Colors.black.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withOpacity(0.2)
                              : Colors.black.withOpacity(0.1),
                          width: 0.5,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            _chatController.clearMessages();
                            _chatController.addMessage(
                              ChatMessage(
                                text:
                                    'Hello! 👋 I\'m your AI assistant. I can help you with questions, provide information, assist with tasks, and have conversations on a wide variety of topics.\n\nFeel free to ask me anything - I\'m here to help! ✨',
                                user: _aiUser,
                                createdAt: DateTime.now(),
                                isMarkdown: true,
                              ),
                            );
                            _chatController.showWelcomeMessage = true;
                          },
                          child: Icon(
                            Icons.refresh_rounded,
                            color: isDark ? Colors.white70 : Colors.black54,
                            size: 16,
                          ),
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

  /// Fallback app bar when animations aren't ready
  Widget _buildFallbackAppBar(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      constraints: const BoxConstraints(minHeight: 60, maxHeight: 80),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.15)
              : Colors.black.withOpacity(0.08),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Icon(
            Icons.water_drop,
            color: isDark ? Colors.blue[300] : Colors.blue[600],
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            'AI Chat',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () {
              _chatController.clearMessages();
              _chatController.addMessage(
                ChatMessage(
                  text:
                      'Hello! 👋 I\'m your AI assistant. I can help you with questions, provide information, assist with tasks, and have conversations on a wide variety of topics.\n\nFeel free to ask me anything - I\'m here to help! ✨',
                  user: _aiUser,
                  createdAt: DateTime.now(),
                  isMarkdown: true,
                ),
              );
              _chatController.showWelcomeMessage = true;
            },
            tooltip: 'New conversation',
          ),
        ],
      ),
    );
  }

  /// Liquid glass input options using the package's built-in glassmorphic system
  InputOptions _buildLiquidGlassInputOptions(bool isDark) {
    // Use the package's built-in glassmorphic factory with liquid glass enhancements
    return InputOptions.glassmorphic(
      colors: [
        isDark
            ? Colors.white.withOpacity(0.15)
            : Colors.white.withOpacity(0.25),
        isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.1),
      ],
      borderRadius: 28.0,
      blurStrength: _liquidBlurAnimation?.value ?? 2.0,
      hintText: 'Type your message...',
      textColor: isDark ? Colors.white : Colors.black87,
      hintColor: isDark ? Colors.white60 : Colors.black54,
      textController: _textController,
    ).copyWith(
      // Enhanced customization for Apple-style liquid glass
      clipBehavior: true, // Enable BackdropFilter
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      containerDecoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isDark
                ? Colors.white.withOpacity(0.15)
                : Colors.white.withOpacity(0.25),
            isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(28.0),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.8)
              : Colors.black.withOpacity(0.8),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? const Color(0x201F2687) : const Color(0x20000000),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
          // Apple-style specular highlight
          BoxShadow(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.white.withOpacity(0.3),
            blurRadius: 1,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      sendButtonBuilder: _buildLiquidGlassSendButton,
    );
  }

  /// Custom send button with liquid glass styling
  Widget _buildLiquidGlassSendButton(VoidCallback onSend) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(right: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: isDark
              ? Colors.blue.withOpacity(0.4)
              : Colors.blue.withOpacity(0.6),
          width: 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  isDark
                      ? Colors.blue.withOpacity(0.25)
                      : Colors.blue.withOpacity(0.2),
                  isDark
                      ? Colors.blue.withOpacity(0.15)
                      : Colors.blue.withOpacity(0.05),
                ],
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24.0),
                onTap: onSend,
                child: Container(
                  width: 44,
                  height: 44,
                  child: Icon(
                    Icons.arrow_upward,
                    color: isDark ? Colors.blue[300] : Colors.blue[600],
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Apple-style liquid glass message options with enhanced depth and saturation
  MessageOptions _buildLiquidGlassMessageOptions(bool isDark) {
    return MessageOptions(
      showTime: true,
      showUserName: true,
      bubbleStyle: BubbleStyle(
        userBubbleColor: isDark
            ? Colors.blue.withOpacity(0.2)
            : Colors.blue.withOpacity(0.15),
        aiBubbleColor: isDark
            ? Colors.white.withOpacity(0.15)
            : Colors.white.withOpacity(0.25),
        userNameColor: isDark ? Colors.blue[300] : Colors.blue[600],
        aiNameColor: isDark ? Colors.white70 : Colors.black54,
        bottomLeftRadius: 22,
        bottomRightRadius: 22,
        enableShadow: true,
      ),
    );
  }

  /// Example questions for the welcome message
  List<ExampleQuestion> _buildExampleQuestions(bool isDark) {
    return [
      const ExampleQuestion(
        question: 'What can you help me with?',
      ),
      const ExampleQuestion(question: 'Tell me about Flutter development'),
      const ExampleQuestion(
        question: 'How do I build mobile apps?',
      ),
    ];
  }
}
