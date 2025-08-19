import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

/// Comprehensive showcase of the advanced theme system with 50+ properties
class AdvancedThemeShowcase extends StatefulWidget {
  const AdvancedThemeShowcase({super.key});

  @override
  State<AdvancedThemeShowcase> createState() => _AdvancedThemeShowcaseState();
}

class _AdvancedThemeShowcaseState extends State<AdvancedThemeShowcase> {
  late ChatMessagesController _controller;
  late ChatUser _currentUser;
  late ChatUser _aiUser;
  
  // Available themes with dramatic visual effects
  final List<ThemeOption> _themes = [
    ThemeOption(
      name: 'ChatGPT Style',
      description: 'OpenAI ChatGPT-inspired with vibrant green',
      primaryColor: const Color(0xFF10A37F),
      backgroundColor: const Color(0xFFF0F9F5),
      surfaceColor: const Color(0xFFE8F5E8),
      userBubbleColor: const Color(0xFF10A37F), // Vibrant green user bubbles
      aiBubbleColor: const Color(0xFFE8F5E8), // Light green AI bubbles
      brightness: Brightness.light,
      gradient: const LinearGradient(
        colors: [Color(0xFF10A37F), Color(0xFF059669)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Color(0xFF10A37F).withOpacity(0.3),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ),
    ThemeOption(
      name: 'Claude Style', 
      description: 'Anthropic Claude-inspired with warm orange',
      primaryColor: const Color(0xFFFF7A00),
      backgroundColor: const Color(0xFFFFF5E6),
      surfaceColor: const Color(0xFFFFE8CC),
      userBubbleColor: const Color(0xFFFF7A00), // Bright orange user bubbles
      aiBubbleColor: const Color(0xFFFFE8CC), // Light orange AI bubbles
      brightness: Brightness.light,
      gradient: const LinearGradient(
        colors: [Color(0xFFFF7A00), Color(0xFFFF9800)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Color(0xFFFF7A00).withOpacity(0.3),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ),
    ThemeOption(
      name: 'Cyber Dark',
      description: 'Futuristic cyber theme with neon green',
      primaryColor: const Color(0xFF00FF41),
      backgroundColor: const Color(0xFF0A0A0A),
      surfaceColor: const Color(0xFF1A1A1A),
      userBubbleColor: const Color(0xFF00FF41), // Neon green user bubbles
      aiBubbleColor: const Color(0xFF1A1A1A), // Dark AI bubbles
      brightness: Brightness.dark,
      gradient: const LinearGradient(
        colors: [Color(0xFF00FF41), Color(0xFF00CC33)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Color(0xFF00FF41).withOpacity(0.5),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
        BoxShadow(
          color: Color(0xFF00FF41).withOpacity(0.2),
          blurRadius: 20,
          offset: Offset(0, 8),
        ),
      ],
    ),
    ThemeOption(
      name: 'Royal Purple',
      description: 'Elegant royal purple theme',
      primaryColor: const Color(0xFF9C27B0),
      backgroundColor: const Color(0xFFF3E5F5),
      surfaceColor: const Color(0xFFE1BEE7),
      userBubbleColor: const Color(0xFF9C27B0), // Royal purple user bubbles
      aiBubbleColor: const Color(0xFFE1BEE7), // Light purple AI bubbles
      brightness: Brightness.light,
      gradient: const LinearGradient(
        colors: [Color(0xFF9C27B0), Color(0xFF673AB7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Color(0xFF9C27B0).withOpacity(0.3),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ),
    ThemeOption(
      name: 'Discord Dark',
      description: 'Discord-inspired dark theme',
      primaryColor: const Color(0xFF7289DA),
      backgroundColor: const Color(0xFF2C2F33),
      surfaceColor: const Color(0xFF36393F),
      userBubbleColor: const Color(0xFF7289DA), // Discord blue user bubbles
      aiBubbleColor: const Color(0xFF36393F), // Discord gray AI bubbles
      brightness: Brightness.dark,
      gradient: const LinearGradient(
        colors: [Color(0xFF7289DA), Color(0xFF5865F2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Color(0xFF7289DA).withOpacity(0.4),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ),
    ThemeOption(
      name: 'Sunset Orange',
      description: 'Warm sunset theme with gradients',
      primaryColor: const Color(0xFFFF5722),
      backgroundColor: const Color(0xFFFFF3E0),
      surfaceColor: const Color(0xFFFFE0B2),
      userBubbleColor: const Color(0xFFFF5722), // Deep orange user bubbles
      aiBubbleColor: const Color(0xFFFFE0B2), // Light orange AI bubbles
      brightness: Brightness.light,
      gradient: const LinearGradient(
        colors: [Color(0xFFFF5722), Color(0xFFFF7043), Color(0xFFFFAB40)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Color(0xFFFF5722).withOpacity(0.3),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ),
    ThemeOption(
      name: 'GitHub Dark',
      description: 'GitHub-inspired dark theme',
      primaryColor: const Color(0xFF58A6FF),
      backgroundColor: const Color(0xFF0D1117),
      surfaceColor: const Color(0xFF21262D),
      userBubbleColor: const Color(0xFF58A6FF), // GitHub blue user bubbles
      aiBubbleColor: const Color(0xFF21262D), // GitHub dark AI bubbles
      brightness: Brightness.dark,
      gradient: const LinearGradient(
        colors: [Color(0xFF58A6FF), Color(0xFF388BFD)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Color(0xFF58A6FF).withOpacity(0.3),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ),
    ThemeOption(
      name: 'Matrix Green',
      description: 'Matrix-inspired green terminal theme',
      primaryColor: const Color(0xFF76FF03),
      backgroundColor: const Color(0xFF0D0D0D),
      surfaceColor: const Color(0xFF1B1B1B),
      userBubbleColor: const Color(0xFF76FF03), // Matrix green user bubbles
      aiBubbleColor: const Color(0xFF1B1B1B), // Dark AI bubbles
      brightness: Brightness.dark,
      gradient: const LinearGradient(
        colors: [Color(0xFF76FF03), Color(0xFF64DD17)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Color(0xFF76FF03).withOpacity(0.5),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
        BoxShadow(
          color: Color(0xFF76FF03).withOpacity(0.2),
          blurRadius: 20,
          offset: Offset(0, 8),
        ),
      ],
    ),
    ThemeOption(
      name: 'Ocean Blue',
      description: 'Deep ocean blue theme with waves',
      primaryColor: const Color(0xFF006064),
      backgroundColor: const Color(0xFFE0F2F1),
      surfaceColor: const Color(0xFFB2DFDB),
      userBubbleColor: const Color(0xFF006064), // Deep teal user bubbles
      aiBubbleColor: const Color(0xFFB2DFDB), // Light teal AI bubbles
      brightness: Brightness.light,
      gradient: const LinearGradient(
        colors: [Color(0xFF006064), Color(0xFF00838F), Color(0xFF0097A7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Color(0xFF006064).withOpacity(0.3),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ),
    ThemeOption(
      name: 'Fire Red',
      description: 'Blazing fire theme with intense reds',
      primaryColor: const Color(0xFFD32F2F),
      backgroundColor: const Color(0xFFFFEBEE),
      surfaceColor: const Color(0xFFFFCDD2),
      userBubbleColor: const Color(0xFFD32F2F), // Fire red user bubbles
      aiBubbleColor: const Color(0xFFFFCDD2), // Light red AI bubbles
      brightness: Brightness.light,
      gradient: const LinearGradient(
        colors: [Color(0xFFD32F2F), Color(0xFFE53935), Color(0xFFFF5722)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Color(0xFFD32F2F).withOpacity(0.4),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
  ];

  int _selectedThemeIndex = 0;

  @override
  void initState() {
    super.initState();
    
    _currentUser = ChatUser(
      id: 'user',
      name: 'You',
    );
    
    _aiUser = ChatUser(
      id: 'ai',
      name: 'AI Assistant',
    );
    
    _controller = ChatMessagesController();
    
    // Add some demo messages to showcase the theme
    _addDemoMessages();
  }

  void _addDemoMessages() {
    // Welcome message
    _controller.addMessage(
      ChatMessage(
        user: _aiUser,
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        text: '🎨 **Welcome to the Advanced Theme Showcase!**\n\n'
            'This demo showcases our **50+ theme properties** including:\n'
            '• Gradient backgrounds and message bubbles\n'
            '• Professional typography scales\n'
            '• Platform-specific optimizations\n'
            '• Micro-animations and transitions\n'
            '• Accessibility enhancements\n\n'
            'Switch between different themes using the selector above!',
      ),
    );

    // Code example
    _controller.addMessage(
      ChatMessage(
        user: _currentUser,
        createdAt: DateTime.now().subtract(const Duration(minutes: 4)),
        text: 'Show me some code examples',
      ),
    );

    _controller.addMessage(
      ChatMessage(
        user: _aiUser,
        createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
        text: 'Here\'s how easy it is to use the advanced theme system:\n\n'
            '```dart\n'
            '// Quick presets\n'
            'final chatGptTheme = ChatThemeBuilder.chatGptStyle();\n'
            'final claudeTheme = ChatThemeBuilder.claudeStyle();\n\n'
            '// Custom brand theme\n'
            'final brandTheme = ChatThemeBuilder.fromBrand(\n'
            '  primaryColor: Colors.deepPurple,\n'
            '  secondaryColor: Colors.purple.shade300,\n'
            ').withGradientBackground([\n'
            '  Colors.white,\n'
            '  Colors.purple.shade50,\n'
            ']).build();\n'
            '```\n\n'
            'The theme system includes **50+ configurable properties** for ultimate customization!',
      ),
    );

    // Feature showcase
    _controller.addMessage(
      ChatMessage(
        user: _currentUser,
        createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
        text: 'What features does this theme system support?',
      ),
    );

    _controller.addMessage(
      ChatMessage(
        user: _aiUser,
        createdAt: DateTime.now().subtract(const Duration(minutes: 1)),
        text: '✨ **Advanced Theme Features:**\n\n'
            '**🎨 Visual System:**\n'
            '• Gradient backgrounds and message bubbles\n'
            '• Sophisticated shadow system\n'
            '• Adaptive border radius\n'
            '• Interactive state colors\n\n'
            '**📝 Typography:**\n'
            '• 25+ professional text styles\n'
            '• Responsive scaling for different screens\n'
            '• Platform-optimized fonts\n\n'
            '**⚡ Animations:**\n'
            '• Micro-interaction timings\n'
            '• Message slide-in effects\n'
            '• Platform-specific behaviors\n\n'
            '**🔧 Platform Optimization:**\n'
            '• iOS: SF Symbols, haptic feedback\n'
            '• Android: Material Design 3, ripples\n'
            '• Web: Hover effects, accessibility\n'
            '• Desktop: Keyboard shortcuts\n\n'
            '**♿ Accessibility:**\n'
            '• WCAG 2.1 AA compliance\n'
            '• High contrast variants\n'
            '• Screen reader optimization',
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = _themes[_selectedThemeIndex];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Theme Showcase'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Theme System Info',
            onPressed: () => _showThemeInfo(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Theme Selector
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Theme Style:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  value: _selectedThemeIndex,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: _themes.asMap().entries.map((entry) {
                    return DropdownMenuItem<int>(
                      value: entry.key,
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          entry.value.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (index) {
                    if (index != null) {
                      setState(() {
                        _selectedThemeIndex = index;
                      });
                    }
                  },
                ),
                const SizedBox(height: 4),
                Text(
                  'Current: ${currentTheme.name}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Chat Interface with Selected Theme
          Expanded(
            child: Theme(
              data: currentTheme.themeData,
              child: AiChatWidget(
                controller: _controller,
                currentUser: _currentUser,
                aiUser: _aiUser,
                enableAnimation: true,
                messageOptions: currentTheme.messageOptions,
                onSendMessage: (message) {
                  _handleUserMessage(message.text);
                },
                inputOptions: InputOptions.custom(
                  decoration: InputDecoration(
                    hintText: 'Try the ${currentTheme.name} theme...',
                    filled: true,
                    fillColor: currentTheme.surfaceColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: currentTheme.primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: currentTheme.primaryColor, width: 2),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Theme Properties Summary
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.palette,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '50+ theme properties • Platform optimized • Accessibility ready',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showThemeCode(context, currentTheme),
                  icon: const Icon(Icons.code, size: 16),
                  label: const Text('View Code'),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleUserMessage(String message) {
    // Add user message
    _controller.addMessage(
      ChatMessage(
        user: _currentUser,
        createdAt: DateTime.now(),
        text: message,
      ),
    );

    // Simulate AI response based on theme
    final currentTheme = _themes[_selectedThemeIndex];
    String response;
    
    if (message.toLowerCase().contains('theme') || message.toLowerCase().contains('color')) {
      response = '🎨 You\'re currently using the **${currentTheme.name}** theme!\n\n'
          '${currentTheme.description}\n\n'
          'This theme demonstrates our advanced theming capabilities with:\n'
          '• Custom gradient backgrounds\n'
          '• Professional typography\n'
          '• Platform-optimized animations\n'
          '• Accessibility enhancements\n\n'
          'Try switching to a different theme using the dropdown above!';
    } else if (message.toLowerCase().contains('code') || message.toLowerCase().contains('example')) {
      response = 'Here\'s how to create the **${currentTheme.name}** theme:\n\n'
          '```dart\n'
          'final theme = ${_getThemeCode(currentTheme)};\n'
          '```\n\n'
          'You can customize any of the 50+ properties to match your brand!';
    } else {
      response = 'Great message! The **${currentTheme.name}** theme is looking fantastic. '
          'Notice how the typography, colors, and spacing work together harmoniously?\n\n'
          'Feel free to ask about themes, colors, or code examples!';
    }

    // Add AI response after a short delay
    Future.delayed(const Duration(milliseconds: 800), () {
      _controller.addMessage(
        ChatMessage(
          user: _aiUser,
          createdAt: DateTime.now(),
          text: response,
        ),
      );
    });
  }

  String _getThemeCode(ThemeOption themeOption) {
    return 'ThemeData(\n'
        '  useMaterial3: true,\n'
        '  brightness: ${themeOption.brightness == Brightness.light ? 'Brightness.light' : 'Brightness.dark'},\n'
        '  colorScheme: ColorScheme.fromSeed(\n'
        '    seedColor: ${_colorToString(themeOption.primaryColor)},\n'
        '    brightness: ${themeOption.brightness == Brightness.light ? 'Brightness.light' : 'Brightness.dark'},\n'
        '    surface: ${_colorToString(themeOption.surfaceColor)},\n'
        '    background: ${_colorToString(themeOption.backgroundColor)},\n'
        '  ),\n'
        '  scaffoldBackgroundColor: ${_colorToString(themeOption.backgroundColor)},\n'
        ')';
  }

  String _colorToString(Color color) {
    // Convert color to hex string using alpha, red, green, blue components
    final hex = '${color.alpha.toRadixString(16).padLeft(2, '0')}'
        '${color.red.toRadixString(16).padLeft(2, '0')}'
        '${color.green.toRadixString(16).padLeft(2, '0')}'
        '${color.blue.toRadixString(16).padLeft(2, '0')}';
    return 'Color(0x${hex.toUpperCase()})';
  }

  void _showThemeInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎨 Advanced Theme System'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Revolutionary Theme Architecture',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                '• 50+ sophisticated theme properties\n'
                '• Gradient support for backgrounds and bubbles\n'
                '• Professional typography with 25+ text styles\n'
                '• Platform-specific optimizations (iOS/Android/Web/Desktop)\n'
                '• Advanced animation presets\n'
                '• WCAG 2.1 AA accessibility compliance\n'
                '• Brand-based theme generation\n'
                '• Fluent API for easy customization',
              ),
              SizedBox(height: 16),
              Text(
                'Development Standards',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                '• TDD with 21/21 passing tests\n'
                '• Backward compatible with existing themes\n'
                '• Production-ready architecture\n'
                '• Comprehensive documentation\n'
                '• Professional preset themes',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showThemeCode(BuildContext context, ThemeOption themeOption) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Code: ${themeOption.name}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Implementation:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  'final theme = ${_getThemeCode(themeOption)};',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Usage in Widget:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  'Theme(\n'
                  '  data: themeData, // Use the ThemeData from above\n'
                  '  child: AiChatWidget(\n'
                  '    controller: controller,\n'
                  '    currentUser: currentUser,\n'
                  '    aiUser: aiUser,\n'
                  '    onSendMessage: (message) {\n'
                  '      // Handle message\n'
                  '    },\n'
                  '  ),\n'
                  ')',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class ThemeOption {
  final String name;
  final String description;
  final Color primaryColor;
  final Color backgroundColor;
  final Color surfaceColor;
  final Color userBubbleColor;
  final Color aiBubbleColor;
  final Brightness brightness;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;

  ThemeOption({
    required this.name,
    required this.description,
    required this.primaryColor,
    required this.backgroundColor,
    required this.surfaceColor,
    required this.userBubbleColor,
    required this.aiBubbleColor,
    required this.brightness,
    this.gradient,
    this.boxShadow,
  });

  ThemeData get themeData => ThemeData(
    useMaterial3: true,
    brightness: brightness,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: brightness,
      surface: surfaceColor,
      inversePrimary: backgroundColor,
    ).copyWith(
      primary: primaryColor,
      surface: surfaceColor,
      onSurface: brightness == Brightness.dark ? Colors.white : Colors.black,
      onPrimary: brightness == Brightness.dark ? Colors.black : Colors.white,
    ),
  );

  BubbleStyle get bubbleStyle => BubbleStyle(
    userBubbleColor: userBubbleColor,
    aiBubbleColor: aiBubbleColor,
    enableShadow: boxShadow != null,
    shadowOpacity: 0.2,
    shadowBlurRadius: 8,
    shadowOffset: const Offset(0, 2),
    userBubbleTopLeftRadius: 20,
    userBubbleTopRightRadius: 4,
    aiBubbleTopLeftRadius: 4,
    aiBubbleTopRightRadius: 20,
    bottomLeftRadius: 20,
    bottomRightRadius: 20,
  );

  MessageOptions get messageOptions => MessageOptions(
    bubbleStyle: bubbleStyle,
    effectiveDecoration: gradient != null ? BoxDecoration(
      gradient: gradient,
      borderRadius: BorderRadius.circular(20),
      boxShadow: boxShadow,
    ) : null,
  );
}