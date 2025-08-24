import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

/// Example showing proper AI service integration with function calling
class AiIntegrationExample extends StatefulWidget {
  const AiIntegrationExample({super.key});

  @override
  State<AiIntegrationExample> createState() => _AiIntegrationExampleState();
}

class _AiIntegrationExampleState extends State<AiIntegrationExample> {
  late ChatMessagesController _controller;
  late ChatUser _currentUser;
  late ChatUser _aiUser;
  late AiServiceIntegration _aiIntegration;
  late ActionController _actionController;

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
    _initializeAiService();
  }

  void _initializeChat() {
    _controller = ChatMessagesController();
    _currentUser = const ChatUser(id: '1', firstName: 'You');
    _aiUser = const ChatUser(id: '2', firstName: 'Assistant');
    _actionController = ActionController();
  }

  void _initializeAiService() {
    // In a real app, you would use OpenAiService or AnthropicService here
    const aiService = MockAiService();
    _aiIntegration = AiServiceIntegration(aiService);

    // Register available actions
    _registerActions();
    
    _addWelcomeMessage();
  }

  void _registerActions() {
    _actionController.registerAction(
      AiAction(
        name: 'get_weather',
        description: 'Get current weather for a location',
        parameters: [
          ActionParameter.string(
            name: 'location',
            description: 'City name',
            required: true,
          ),
        ],
        handler: _handleWeatherAction,
      ),
    );

    _actionController.registerAction(
      AiAction(
        name: 'basic_math',
        description: 'Perform basic mathematical operations',
        parameters: [
          ActionParameter.number(name: 'a', description: 'First number', required: true),
          ActionParameter.number(name: 'b', description: 'Second number', required: true),
          ActionParameter.string(
            name: 'operation',
            description: 'Operation to perform',
            required: true,
            enumValues: ['add', 'subtract', 'multiply', 'divide'],
          ),
        ],
        handler: _handleMathAction,
      ),
    );
  }

  Future<ActionResult> _handleWeatherAction(Map<String, dynamic> params) async {
    final location = params['location'] as String;
    
    // Simulate weather API call
    await Future.delayed(const Duration(seconds: 1));
    
    final weatherData = {
      'location': location,
      'temperature': 22,
      'condition': 'Sunny',
      'humidity': 45,
    };
    
    return ActionResult.createSuccess(weatherData);
  }

  Future<ActionResult> _handleMathAction(Map<String, dynamic> params) async {
    final a = (params['a'] as num).toDouble();
    final b = (params['b'] as num).toDouble();
    final operation = params['operation'] as String;
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    double result;
    switch (operation) {
      case 'add':
        result = a + b;
        break;
      case 'subtract':
        result = a - b;
        break;
      case 'multiply':
        result = a * b;
        break;
      case 'divide':
        if (b == 0) return ActionResult.createFailure('Cannot divide by zero');
        result = a / b;
        break;
      default:
        return ActionResult.createFailure('Unknown operation: $operation');
    }
    
    return ActionResult.createSuccess({
      'result': result,
      'equation': '$a $operation $b = $result',
    });
  }

  void _addWelcomeMessage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.addMessage(
        ChatMessage(
          text: 'Hello! I\'m an AI assistant with function calling capabilities. '
                'I can help you with weather information, calculations, and more. '
                'Try asking me something like:\n\n'
                '• "What\'s the weather in Tokyo?"\n'
                '• "Calculate 25 * 8"\n'
                '• "What\'s 100 divided by 4?"',
          user: _aiUser,
          createdAt: DateTime.now(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _actionController.dispose();
    super.dispose();
  }

  void _handleSendMessage(ChatMessage message) {
    _controller.addMessage(message);
    _processAiMessage(message.text);
  }

  Future<void> _processAiMessage(String message) async {
    if (_isProcessing) return;
    
    setState(() {
      _isProcessing = true;
    });

    // Create a placeholder AI message for streaming
    final aiMessageId = 'ai_${DateTime.now().millisecondsSinceEpoch}';
    final aiMessage = ChatMessage(
      text: '',
      user: _aiUser,
      createdAt: DateTime.now(),
      customProperties: {'id': aiMessageId},
    );
    _controller.addMessage(aiMessage);

    try {
      // Use AI integration with streaming
      final responseStream = _aiIntegration.processMessageWithActionsStream(
        message,
        _actionController.actions.values.toList(),
        (actionName, parameters) => _actionController.executeAction(
          actionName,
          parameters,
          context: context,
        ),
      );

      String accumulatedResponse = '';
      await for (final chunk in responseStream) {
        accumulatedResponse += chunk;
        
        // Update the AI message with accumulated response
        _controller.updateMessage(
          ChatMessage(
            text: accumulatedResponse,
            user: _aiUser,
            createdAt: aiMessage.createdAt,
            customProperties: {'id': aiMessageId},
          ),
        );
      }
    } catch (e) {
      // Handle errors gracefully
      _controller.updateMessage(
        ChatMessage(
          text: 'Sorry, I encountered an error: $e',
          user: _aiUser,
          createdAt: aiMessage.createdAt,
          customProperties: {'id': aiMessageId},
        ),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AiActionProvider(
      config: AiActionConfig(
        actions: _actionController.actions.values.toList(),
        debug: true,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AI Integration Example'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            if (_isProcessing)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          ],
        ),
        body: Column(
          children: [
            // AI Service Status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Row(
                children: [
                  Icon(
                    Icons.smart_toy,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'AI Service: Mock (for demo)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Connected',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Quick Actions
            Container(
              padding: const EdgeInsets.all(8),
              child: Wrap(
                spacing: 8,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.cloud),
                    label: const Text('Weather in Paris'),
                    onPressed: _isProcessing ? null : () => _handleSendMessage(
                      ChatMessage(
                        text: 'What\'s the weather like in Paris?',
                        user: _currentUser,
                        createdAt: DateTime.now(),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.calculate),
                    label: const Text('Calculate 144 ÷ 12'),
                    onPressed: _isProcessing ? null : () => _handleSendMessage(
                      ChatMessage(
                        text: 'What is 144 divided by 12?',
                        user: _currentUser,
                        createdAt: DateTime.now(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Chat Interface
            Expanded(
              child: AiChatWidget(
                currentUser: _currentUser,
                aiUser: _aiUser,
                controller: _controller,
                onSendMessage: _isProcessing ? null : _handleSendMessage,
                inputOptions: InputOptions(
                  enabled: !_isProcessing,
                  decoration: InputDecoration(
                    hintText: _isProcessing 
                        ? 'AI is processing...' 
                        : 'Ask me anything...',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.chat),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example of how to implement a real OpenAI service
/// This is a template - you would need to add the actual HTTP implementation
class OpenAiService extends AiService {
  final String apiKey;
  final String model;

  const OpenAiService({
    required this.apiKey,
    this.model = 'gpt-3.5-turbo',
  });

  @override
  Future<String> sendMessage(String message) async {
    // TODO: Implement actual OpenAI API call
    throw UnimplementedError('Add HTTP client and OpenAI API integration');
  }

  @override
  Stream<String> sendMessageStream(String message) async* {
    // TODO: Implement streaming OpenAI API call
    throw UnimplementedError('Add HTTP client and OpenAI API integration');
  }

  @override
  Future<AiFunctionCallResult> sendMessageWithFunctions(
    String message,
    List<AiAction> availableActions,
  ) async {
    // TODO: Implement OpenAI function calling
    throw UnimplementedError('Add OpenAI function calling integration');
  }

  @override
  Stream<AiFunctionCallStreamResult> sendMessageWithFunctionsStream(
    String message,
    List<AiAction> availableActions,
  ) async* {
    // TODO: Implement streaming OpenAI function calling
    throw UnimplementedError('Add OpenAI streaming function calling');
  }
}

/// Example Anthropic Claude service implementation template
class AnthropicService extends AiService {
  final String apiKey;
  final String model;

  const AnthropicService({
    required this.apiKey,
    this.model = 'claude-3-sonnet-20240229',
  });

  @override
  Future<String> sendMessage(String message) async {
    // TODO: Implement actual Anthropic API call
    throw UnimplementedError('Add HTTP client and Anthropic API integration');
  }

  @override
  Stream<String> sendMessageStream(String message) async* {
    // TODO: Implement streaming Anthropic API call
    throw UnimplementedError('Add HTTP client and Anthropic API integration');
  }

  @override
  Future<AiFunctionCallResult> sendMessageWithFunctions(
    String message,
    List<AiAction> availableActions,
  ) async {
    // TODO: Implement Anthropic function calling
    throw UnimplementedError('Add Anthropic function calling integration');
  }

  @override
  Stream<AiFunctionCallStreamResult> sendMessageWithFunctionsStream(
    String message,
    List<AiAction> availableActions,
  ) async* {
    // TODO: Implement streaming Anthropic function calling
    throw UnimplementedError('Add Anthropic streaming function calling');
  }
}