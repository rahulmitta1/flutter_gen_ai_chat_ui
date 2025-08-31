import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:provider/provider.dart';

import '../../models/app_state.dart';
import '../../services/ai_service.dart' as example_ai;
import '../03_complete/complete_showcase.dart';

/// Hero Demo: 30-second showcase of unique features that makes users say "Wow!"
/// This example auto-demonstrates every impressive feature to solve the first impression problem
class HeroDemoScreen extends StatefulWidget {
  const HeroDemoScreen({super.key});

  @override
  State<HeroDemoScreen> createState() => _HeroDemoScreenState();
}

class _HeroDemoScreenState extends State<HeroDemoScreen>
    with TickerProviderStateMixin {
  
  late ChatMessagesController _chatController;
  late AnimationController _demoController;
  late example_ai.AiService _aiService;
  
  // Demo state
  int _currentDemoPhase = 0;
  bool _isAutoDemoMode = true;
  Timer? _autoAdvanceTimer;
  Timer? _autoRestartTimer;
  
  // Chat users
  final _currentUser = const ChatUser(id: 'user123', firstName: 'You');
  final _aiUser = const ChatUser(
    id: 'hero_ai', 
    firstName: 'Flutter AI',
    avatar: 'https://ui-avatars.com/api/?name=AI&background=6366f1&color=fff'
  );

  // Theme management
  int _currentThemeIndex = 0;
  final List<BubbleTheme> _themes = [
    BubbleTheme.gradient(),
    BubbleTheme.neon(), 
    BubbleTheme.glassmorphic(),
    BubbleTheme.elegant(),
    BubbleTheme.minimal(),
  ];

  // Animation styles for streaming text
  final List<StreamingStyle> _animationStyles = [
    StreamingStyle.typewriter,
    StreamingStyle.fadeIn,
    StreamingStyle.slideIn,
    StreamingStyle.bounce,
    StreamingStyle.glow,
  ];
  int _currentAnimationStyle = 0;

  // Demo phases with impressive content
  late final List<DemoPhase> _demoPhases;

  @override
  void initState() {
    super.initState();
    _initializeComponents();
    _setupDemoPhases();
    _startAutoDemo();
  }

  void _initializeComponents() {
    _chatController = ChatMessagesController();
    _aiService = example_ai.AiService();
    
    _demoController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    );
    
    _featureCalloutController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // Add welcome message
    _chatController.addMessage(
      ChatMessage(
        text: '# Welcome to Flutter Gen AI Chat UI! 🚀\n\n'
              'Watch this **30-second demo** showing features that make us **different**:\n\n'
              '✨ **Unique streaming animations**\n'
              '🎨 **5 professional themes**\n'
              '📁 **Advanced file handling**\n'
              '⚡ **Enterprise performance**\n\n'
              'Sit back and watch the magic! ✨',
        user: _aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
      ),
    );
  }

  void _setupDemoPhases() {
    _demoPhases = [
      DemoPhase(
        title: "🎯 Streaming Text Animation",
        description: "Watch text appear word-by-word with different styles",
        duration: const Duration(seconds: 8),
        action: _demonstrateStreamingAnimations,
        callout: "👀 This is what makes us unique - smooth streaming like ChatGPT!",
      ),
      DemoPhase(
        title: "🎨 Live Theme Switching", 
        description: "5 professional themes with smooth transitions",
        duration: const Duration(seconds: 6),
        action: _demonstrateThemeSwitch,
        callout: "🎨 50+ theme properties - most comprehensive in Flutter!",
      ),
      DemoPhase(
        title: "📁 File Attachments",
        description: "Complete file handling with previews",
        duration: const Duration(seconds: 5),
        action: _demonstrateFileSupport,
        callout: "📱 Real device integration - camera, gallery, documents!",
      ),
      DemoPhase(
        title: "⚡ Performance Excellence",
        description: "Smooth scrolling and efficient rendering", 
        duration: const Duration(seconds: 6),
        action: _demonstratePerformance,
        callout: "⚡ Enterprise-grade performance optimization!",
      ),
      DemoPhase(
        title: "🤖 AI Actions System",
        description: "Function calling with dynamic UI generation",
        duration: const Duration(seconds: 5),
        action: _demonstrateAiActions,
        callout: "🤖 Advanced AI integration with function calling!",
      ),
    ];
  }

  void _startAutoDemo() {
    if (!_isAutoDemoMode) return;
    
    _featureCalloutController.repeat(reverse: true);
    _demoController.forward();
    
    _runCurrentDemoPhase();
  }

  void _runCurrentDemoPhase() {
    if (_currentDemoPhase >= _demoPhases.length) {
      _restartDemo();
      return;
    }

    final phase = _demoPhases[_currentDemoPhase];
    
    // Execute phase action
    phase.action();
    
    // Auto advance to next phase
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = Timer(phase.duration, () {
      if (mounted && _isAutoDemoMode) {
        setState(() => _currentDemoPhase++);
        _runCurrentDemoPhase();
      }
    });
  }

  void _restartDemo() {
    _autoRestartTimer?.cancel();
    _autoRestartTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isAutoDemoMode) {
        setState(() {
          _currentDemoPhase = 0;
          _currentThemeIndex = 0;
          _currentAnimationStyle = 0;
        });
        _chatController.clearMessages();
        _initializeComponents();
        _demoController.reset();
        _startAutoDemo();
      }
    });
  }

  // Demo phase implementations
  void _demonstrateStreamingAnimations() {
    HapticFeedback.lightImpact();
    
    final messages = [
      "🎯 **Typewriter Effect**: This text appears character by character with a natural typing rhythm, just like watching someone type in real-time.",
      "✨ **Fade-In Animation**: Each word gently fades into view with a smooth opacity transition that feels elegant and professional.",
      "🎭 **Slide-In Effect**: Words slide smoothly from the right with a subtle bounce, creating engaging micro-interactions.",
      "⚡ **Bounce Animation**: Text bounces in with playful spring physics that adds personality without being distracting.",
      "🌟 **Glow Effect**: Words appear with a subtle glow animation that highlights the streaming progress beautifully.",
    ];

    _addStreamingMessage(messages[_currentAnimationStyle % messages.length]);
    
    // Cycle through animation styles
    setState(() {
      _currentAnimationStyle = (_currentAnimationStyle + 1) % _animationStyles.length;
    });
  }

  void _demonstrateThemeSwitch() {
    HapticFeedback.mediumImpact();
    
    setState(() {
      _currentThemeIndex = (_currentThemeIndex + 1) % _themes.length;
    });
    
    final themeName = _themes[_currentThemeIndex].name;
    _addStreamingMessage(
      "🎨 **${themeName} Theme Activated!**\n\n"
      "Notice how the entire interface smoothly transitions with:\n"
      "• Custom bubble designs\n"
      "• Professional color schemes\n" 
      "• Gradient backgrounds\n"
      "• Consistent styling throughout\n\n"
      "**50+ customizable properties** make this the most comprehensive theming system in Flutter!"
    );
  }

  void _demonstrateFileSupport() {
    // Add mock file attachments
    _chatController.addMessage(
      ChatMessage(
        text: "📁 **File Handling Demo**: Multiple file types with rich previews",
        user: _currentUser,
        createdAt: DateTime.now(),
        media: [
          ChatMedia(
            url: 'https://picsum.photos/400/300',
            type: ChatMediaType.image,
            fileName: 'demo_image.jpg',
            size: 1024 * 256,
            metadata: {'width': '400', 'height': '300'},
          ),
          ChatMedia(
            url: 'https://example.com/document.pdf',
            type: ChatMediaType.document,
            fileName: 'presentation.pdf',
            extension: 'pdf',
            size: 1024 * 1024 * 2,
          ),
        ],
      ),
    );

    _addStreamingMessage(
      "📱 **Complete File Integration:**\n\n"
      "• **Camera capture** with real-time preview\n"
      "• **Gallery selection** with multiple files\n"
      "• **Document picker** for PDFs, Office files\n"
      "• **Drag & drop** support on web/desktop\n"
      "• **File type detection** with custom icons\n"
      "• **Progress indicators** for uploads\n\n"
      "All with **professional UI components** you can ship immediately!"
    );
  }

  void _demonstratePerformance() {
    // Add multiple messages quickly to show smooth scrolling
    final performanceMessages = [
      "⚡ **Performance Optimizations:**",
      "📊 **ListView.builder** for efficient rendering",
      "🎯 **Message caching** prevents memory leaks", 
      "🔄 **Smart pagination** handles thousands of messages",
      "🎬 **Smooth animations** at 60fps consistently",
      "📱 **Responsive design** adapts to all screen sizes",
      "🚀 **Production-ready** with enterprise optimization",
    ];

    for (int i = 0; i < performanceMessages.length; i++) {
      Timer(Duration(milliseconds: i * 400), () {
        if (mounted) {
          _addStreamingMessage(performanceMessages[i], fastAnimation: true);
        }
      });
    }
  }

  void _demonstrateAiActions() {
    _addStreamingMessage(
      "🤖 **AI Actions System:**\n\n"
      "```json\n"
      "{\n"
      "  \"name\": \"create_task\",\n"
      "  \"parameters\": {\n"
      "    \"title\": \"Demo Task\",\n"
      "    \"priority\": \"high\",\n"
      "    \"due_date\": \"2024-12-31\"\n"
      "  }\n"
      "}\n"
      "```\n\n"
      "**Features:**\n"
      "• Function calling with parameter validation\n"
      "• Dynamic UI generation for results\n"
      "• CopilotKit compatibility\n"
      "• Human-in-the-loop confirmations\n\n"
      "**Perfect for AI agents and tool use!**"
    );
  }

  void _addStreamingMessage(String text, {bool fastAnimation = false}) {
    final messageId = 'demo_${DateTime.now().millisecondsSinceEpoch}';
    final duration = fastAnimation 
        ? const Duration(milliseconds: 20)
        : const Duration(milliseconds: 35);

    _chatController.addMessage(
      ChatMessage(
        text: text,
        user: _aiUser,
        createdAt: DateTime.now(),
        isMarkdown: true,
        customProperties: {
          'id': messageId,
          'isStreaming': true,
          'animationStyle': _animationStyles[_currentAnimationStyle % _animationStyles.length],
        },
      ),
    );

    // Mark as complete after streaming duration
    Timer(Duration(milliseconds: text.length * duration.inMilliseconds), () {
      if (mounted) {
        _chatController.updateMessage(
          ChatMessage(
            text: text,
            user: _aiUser,
            createdAt: DateTime.now(),
            isMarkdown: true,
            customProperties: {
              'id': messageId,
              'isStreaming': false,
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentTheme = _themes[_currentThemeIndex];
    final currentPhase = _currentDemoPhase < _demoPhases.length 
        ? _demoPhases[_currentDemoPhase] 
        : _demoPhases.last;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF0F0F23), const Color(0xFF1A1B23)]
                : [const Color(0xFFF8F9FF), const Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildCompactHeader(isDark, currentPhase),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: _buildChatContent(appState, isDark, currentTheme),
                ),
              ),
              _buildDemoControls(isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactHeader(bool isDark, DemoPhase currentPhase) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark 
            ? const Color(0xFF1F2937).withOpacity(0.8)
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF6366F1).withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Demo badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'HERO DEMO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Flutter Gen AI Chat UI',
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Phase ${_currentDemoPhase + 1} of ${_demoPhases.length}: ${currentPhase.title}',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : const Color(0xFF6B7280),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Controls
          IconButton(
            onPressed: () {
              setState(() => _isAutoDemoMode = !_isAutoDemoMode);
              if (_isAutoDemoMode) {
                _startAutoDemo();
              } else {
                _autoAdvanceTimer?.cancel();
              }
            },
            icon: Icon(
              _isAutoDemoMode ? Icons.pause : Icons.play_arrow,
              size: 18,
            ),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1).withOpacity(0.1),
              foregroundColor: const Color(0xFF6366F1),
              minimumSize: const Size(32, 32),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, size: 18),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey.withOpacity(0.1),
              foregroundColor: Colors.grey.shade600,
              minimumSize: const Size(32, 32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(bool isDark) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Phase ${_currentDemoPhase + 1} of ${_demoPhases.length}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              _currentDemoPhase < _demoPhases.length 
                  ? _demoPhases[_currentDemoPhase].title
                  : 'Complete',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (_currentDemoPhase + 1) / _demoPhases.length,
          backgroundColor: Colors.white.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          minHeight: 4,
        ),
      ],
    );
  }


  Widget _buildChatContent(AppState appState, bool isDark, BubbleTheme currentTheme) {
    return AiChatWidget(
      key: ValueKey('${_currentThemeIndex}_${_currentAnimationStyle}'),
      currentUser: _currentUser,
      aiUser: _aiUser,
      controller: _chatController,
      onSendMessage: (message) {
        // Allow manual interaction during demo
        _chatController.addMessage(message);
        _addStreamingMessage("Thanks for trying the demo! 🎉\n\nReady to build amazing AI chat interfaces?");
      },
      maxWidth: 800,
      
      // Apply current theme
      messageOptions: MessageOptions(
        decoration: currentTheme.messageDecoration,
        containerDecoration: currentTheme.userMessageDecoration,
        textStyle: currentTheme.messageTextStyle,
        aiTextColor: currentTheme.messageTextStyle?.color,
        userTextColor: currentTheme.userMessageTextStyle?.color,
        padding: currentTheme.messagePadding,
        showUserName: false,
        showTime: false,
        showCopyButton: true,
      ),
      
      // Input styling
      inputOptions: InputOptions(
        decoration: currentTheme.inputDecoration.copyWith(
          hintText: '💬 Try typing during the demo...',
        ),
        textStyle: currentTheme.inputTextStyle,
      ),
      
      // Enhanced streaming with current animation style
      enableMarkdownStreaming: true,
      streamingDuration: _animationStyles[_currentAnimationStyle % _animationStyles.length].duration,
      
      // File upload for demonstration
      fileUploadOptions: const FileUploadOptions(
        enabled: true,
        uploadTooltip: 'Try uploading a file!',
      ),
    );
  }

  Widget _buildDemoControls(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark 
            ? Colors.black.withOpacity(0.3)
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark 
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            'Restart Demo',
            Icons.replay_rounded,
            () {
              setState(() {
                _currentDemoPhase = 0;
                _currentThemeIndex = 0;
                _isAutoDemoMode = true;
              });
              _chatController.clearMessages();
              _initializeComponents();
              _startAutoDemo();
            },
            isDark,
          ),
          _buildControlButton(
            'Try Interactive',
            Icons.touch_app_rounded,
            () {
              setState(() => _isAutoDemoMode = false);
              _autoAdvanceTimer?.cancel();
            },
            isDark,
          ),
          _buildControlButton(
            'View Examples',
            Icons.apps_rounded,
            () => Navigator.pushReplacementNamed(context, '/'),
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(String label, IconData icon, VoidCallback onPressed, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          HapticFeedback.lightImpact();
          onPressed();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isDark ? Colors.white : const Color(0xFF1F2937),
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1F2937),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _autoRestartTimer?.cancel();
    _demoController.dispose();
    _featureCalloutController.dispose();
    _chatController.dispose();
    super.dispose();
  }
}

// Supporting classes for the Hero Demo

class DemoPhase {
  final String title;
  final String description;
  final Duration duration;
  final VoidCallback action;
  final String callout;

  DemoPhase({
    required this.title,
    required this.description,
    required this.duration,
    required this.action,
    required this.callout,
  });
}

enum StreamingStyle {
  typewriter,
  fadeIn,
  slideIn,
  bounce,
  glow,
}

extension StreamingStyleExtension on StreamingStyle {
  Duration get duration {
    switch (this) {
      case StreamingStyle.typewriter:
        return const Duration(milliseconds: 50);
      case StreamingStyle.fadeIn:
        return const Duration(milliseconds: 35);
      case StreamingStyle.slideIn:
        return const Duration(milliseconds: 40);
      case StreamingStyle.bounce:
        return const Duration(milliseconds: 45);
      case StreamingStyle.glow:
        return const Duration(milliseconds: 60);
    }
  }

  String get name {
    switch (this) {
      case StreamingStyle.typewriter:
        return 'Typewriter';
      case StreamingStyle.fadeIn:
        return 'Fade In';
      case StreamingStyle.slideIn:
        return 'Slide In';
      case StreamingStyle.bounce:
        return 'Bounce';
      case StreamingStyle.glow:
        return 'Glow';
    }
  }
}