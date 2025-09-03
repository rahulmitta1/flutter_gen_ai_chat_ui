import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

/// Screen that reproduces the welcome message overlay bug from issue #22
/// https://github.com/hooshyar/flutter_gen_ai_chat_ui/issues/22
class WelcomeMessageBugScreen extends StatefulWidget {
  const WelcomeMessageBugScreen({super.key});

  @override
  State<WelcomeMessageBugScreen> createState() => _WelcomeMessageBugScreenState();
}

class _WelcomeMessageBugScreenState extends State<WelcomeMessageBugScreen> {
  final ChatMessagesController _controller = ChatMessagesController();
  final ChatUser _currentUser = ChatUser(id: '1', name: 'User');
  final ChatUser _aiUser = ChatUser(id: '2', name: 'AI Assistant');
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSendMessage(ChatMessage message) {
    setState(() {
      _isLoading = true;
    });

    // Add user message
    _controller.addMessage(message);

    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      final aiResponse = ChatMessage(
        text: 'I received your message: "${message.text}"',
        user: _aiUser,
        createdAt: DateTime.now(),
      );
      _controller.addMessage(aiResponse);
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome Message Bug Reproduction'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Info banner about the bug
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.red.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.bug_report, color: Colors.red.shade700),
                    const SizedBox(width: 8),
                    Text(
                      'Bug Reproduction: Issue #22',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Expected: Custom welcome message should scroll with chat and disappear when sending a message.\nActual: Welcome message stays fixed and overlaps chat messages.',
                  style: TextStyle(color: Colors.red.shade600),
                ),
              ],
            ),
          ),
          // Chat widget with exact configuration from issue #22
          Expanded(
            child: AiChatWidget(
              // Required parameters
              currentUser: _currentUser,
              aiUser: _aiUser,
              enableMarkdownStreaming: true,
              streamingDuration: const Duration(milliseconds: 100),
              controller: _controller,
              onSendMessage: _handleSendMessage,
              // Optional parameters
              loadingConfig: LoadingConfig(isLoading: _isLoading),
              enableAnimation: true,
              fileUploadOptions: const FileUploadOptions(
                enabled: true,
              ),
              inputOptions: InputOptions(
                sendOnEnter: true,
                containerBackgroundColor: Colors.transparent,
                decoration: const InputDecoration(
                  hintText: "Ask me anything...",
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  border: InputBorder.none,
                ),
                containerPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                containerDecoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                ),
              ),
              // This is the problematic welcome message from issue #22
              welcomeMessageConfig: WelcomeMessageConfig(
                builder: () {
                  return Card(
                    color: Colors.orange,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Placeholder for the image (since we don't have the asset)
                        Container(
                          height: 120,
                          width: double.infinity,
                          color: Colors.orange.shade200,
                          child: const Icon(
                            Icons.android,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(text: "How can we"),
                                  TextSpan(
                                    text: " assist ",
                                    style: TextStyle(color: Colors.orange),
                                  ),
                                  TextSpan(text: "you today?"),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text("FAQ:"),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () {
                                // Send chat confirmation
                                _controller.addMessage(ChatMessage(
                                  text: "Find a Room",
                                  user: _currentUser,
                                  createdAt: DateTime.now(),
                                ));
                              },
                              child: Card(
                                color: Colors.grey.shade300,
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Find me a room",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Icon(Icons.send),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}