import 'dart:async';
import 'dart:math';

/// Response from the AI, including text and formatting information
class AiResponse {
  /// The text content of the response
  final String text;

  /// Whether the text should be rendered as markdown
  final bool isMarkdown;

  AiResponse(this.text, {this.isMarkdown = false});
}

/// Service that simulates AI responses for example apps
class AiService {
  final Random _random = Random();

  /// Generate a response with a realistic delay
  Future<AiResponse> generateResponse(
    String query, {
    bool includeCodeBlock = true,
  }) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500 + _random.nextInt(1000)));

    final lowerQuery = query.toLowerCase();

    // Introduction/greeting
    if (lowerQuery.contains('hello') ||
        lowerQuery.contains('hi') ||
        query.length < 10) {
      return AiResponse(
        "Hello! I'm your AI assistant. How can I help you today?",
      );
    }

    // About the assistant
    if (lowerQuery.contains('who are you') ||
        lowerQuery.contains('about you') ||
        lowerQuery.contains('your name')) {
      return AiResponse('''
# About Me

I'm a simulated AI assistant designed to demonstrate the Flutter Gen AI Chat UI package.

My capabilities include:
- Answering questions
- Providing information
- Demonstrating UI features
- Showing how markdown works

Feel free to ask me anything!
      ''', isMarkdown: true);
    }

    // Help options
    if (lowerQuery.contains('help') ||
        lowerQuery.contains('can you do') ||
        lowerQuery.contains('what can you')) {
      return AiResponse('''
# How I Can Help You

I can demonstrate various features of this chat UI:

1. **Basic Messaging** - Simple text conversations
2. **Markdown Support** - Formatted text with headings, lists, etc.
3. **Code Examples** - Syntax highlighted code blocks
4. **UI Elements** - Chat bubbles, typing indicators, etc.

Try asking me to show you an example of any of these!
      ''', isMarkdown: true);
    }

    // Flutter information
    if (lowerQuery.contains('flutter') || lowerQuery.contains('dart')) {
      return AiResponse('''
# Flutter

Flutter is Google's UI toolkit for building beautiful, natively compiled applications for mobile, web, desktop, and embedded devices from a single codebase.

## Key Features

- **Fast Development**: Hot reload helps you quickly experiment and build UIs
- **Expressive UI**: Create beautiful apps with widgets
- **Native Performance**: Flutter compiles to native code

## Popular Packages

- **flutter_gen_ai_chat_ui**: Create chat UIs like this one!
- **provider**: State management solution
- **flutter_markdown**: Render markdown content
      ''', isMarkdown: true);
    }

    // Code example (conditionally included based on parameter)
    if ((lowerQuery.contains('code') ||
            lowerQuery.contains('example') ||
            lowerQuery.contains('sample')) &&
        includeCodeBlock) {
      return AiResponse('''
# Flutter Code Examples

Here are some useful Flutter code examples:

## 1. Custom Button Widget

```dart
class StyledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  
  const StyledButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = Colors.blue,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(
          horizontal: 24, 
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
```

## 2. Usage Example

```dart
StyledButton(
  text: 'Press Me',
  onPressed: () => print('Button pressed!'),
  color: Colors.purple,
)
```

## 3. Theme-Aware Container

```dart
Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[800]
        : Colors.grey[100],
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: Theme.of(context).dividerColor.withOpacity(0.3),
    ),
  ),
  child: Text('Theme-aware content'),
)
```

These examples show Flutter's flexibility and how to create reusable, theme-aware components!
      ''', isMarkdown: true);
    }

    // UI features
    if (lowerQuery.contains('ui') ||
        lowerQuery.contains('features') ||
        lowerQuery.contains('this chat')) {
      return AiResponse('''
# Chat UI Features

This example demonstrates these features:

## Core Features
- 🎨 Light & dark mode themes with smooth transitions
- 💬 Message bubbles with user avatars and timestamps
- ⏳ Typing indicators with animated text
- 📝 Markdown formatting support for rich content
- 📱 Responsive design that works on all screen sizes

## UI Elements
- Welcome messages with interactive example questions
- Modern, Material 3 design with ChatGPT-inspired styling
- Clean, minimal interface with proper spacing
- Copy buttons for easy text selection
- Smooth animations and transitions

## Enhanced UX
- Error handling with user-friendly messages
- Success notifications for actions
- Theme toggle and conversation reset
- Enter key support for quick messaging

Try exploring the various examples to see more advanced features!
      ''', isMarkdown: true);
    }

    // Examples information
    if (lowerQuery.contains('examples') ||
        lowerQuery.contains('showcase') ||
        lowerQuery.contains('demo')) {
      return AiResponse('''
# Available Examples

This app includes several examples of the Flutter Gen AI Chat UI:

1. **Basic Example**: Simple implementation with core features
2. **Intermediate Example**: Adds streaming responses and more customization
3. **Advanced Example**: Full-featured with custom themes and all capabilities
4. **Specialized Examples**: Industry-specific implementations

Navigate back to the home screen to explore them all!
      ''', isMarkdown: true);
    }

    // Default response
    return AiResponse(
      "Thanks for your message. I'm a demo assistant built to showcase the Flutter Gen AI Chat UI package. Try asking me about 'features', 'examples', or 'Flutter' to see what I can do!",
    );
  }

  /// Stream a response word by word for examples that support streaming
  Stream<String> streamResponse(
    String query, {
    bool includeCodeBlock = true,
  }) async* {
    final response = await generateResponse(
      query,
      includeCodeBlock: includeCodeBlock,
    );
    final words = response.text.split(' ');

    String accumulated = '';

    for (final word in words) {
      accumulated += (accumulated.isEmpty ? '' : ' ') + word;
      yield accumulated;

      // Random delay between words for natural typing feel
      await Future.delayed(Duration(milliseconds: 20 + _random.nextInt(80)));
    }
  }
}
