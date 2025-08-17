import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

/// Simplified AI Actions example demonstrating clean integration patterns
class SimpleAiActionsExample extends StatefulWidget {
  const SimpleAiActionsExample({super.key});

  @override
  State<SimpleAiActionsExample> createState() => _SimpleAiActionsExampleState();
}

class _SimpleAiActionsExampleState extends State<SimpleAiActionsExample> {
  late ChatMessagesController _controller;
  late ChatUser _currentUser;
  late ChatUser _aiUser;
  StreamSubscription<ActionEvent>? _actionSubscription;

  @override
  void initState() {
    super.initState();
    _initializeChat();
    _addWelcomeMessage();
  }

  void _initializeChat() {
    _controller = ChatMessagesController();
    _currentUser = const ChatUser(id: '1', firstName: 'User');
    _aiUser = const ChatUser(id: '2', firstName: 'Assistant');
  }

  void _addWelcomeMessage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.addMessage(
        ChatMessage(
          text: 'Hello! I can help you with:\n\n'
              '• Mathematical calculations\n'
              '• Weather information\n'
              '• Unit conversions\n\n'
              'Try asking me something!',
          user: _aiUser,
          createdAt: DateTime.now(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _actionSubscription?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _handleSendMessage(ChatMessage message) {
    _controller.addMessage(message);
    _processUserMessage(message.text);
  }

  /// Process user message and determine appropriate action
  Future<void> _processUserMessage(String message) async {
    // Simple pattern matching for demo purposes
    // In production, this would be handled by an LLM
    final lowerMessage = message.toLowerCase();
    
    if (_containsAny(lowerMessage, ['calculate', 'math', '+', '-', '*', '/'])) {
      await _executeCalculation(message);
    } else if (_containsAny(lowerMessage, ['weather', 'temperature'])) {
      await _executeWeatherQuery(message);
    } else if (_containsAny(lowerMessage, ['convert', 'celsius', 'fahrenheit'])) {
      await _executeUnitConversion(message);
    } else {
      _addAiResponse('I can help with calculations, weather, and conversions. What would you like to know?');
    }
  }

  bool _containsAny(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword));
  }

  Future<void> _executeCalculation(String message) async {
    final actionHook = AiActionHook.of(context);
    
    // Extract numbers for demo - in production, LLM would parse this
    final numbers = RegExp(r'\d+').allMatches(message).map((m) => int.parse(m.group(0)!)).toList();
    if (numbers.length >= 2) {
      final result = await actionHook.executeAction('basic_math', {
        'a': numbers[0],
        'b': numbers[1],
        'operation': _detectOperation(message),
      });
      
      if (result.success) {
        _addAiResponse('The result is: ${result.data['result']}');
      } else {
        _addAiResponse('Sorry, I couldn\'t calculate that: ${result.error}');
      }
    } else {
      _addAiResponse('Please provide two numbers to calculate with.');
    }
  }

  String _detectOperation(String message) {
    if (message.contains('+')) return 'add';
    if (message.contains('-')) return 'subtract';
    if (message.contains('*')) return 'multiply';
    if (message.contains('/')) return 'divide';
    return 'add'; // Default
  }

  Future<void> _executeWeatherQuery(String message) async {
    final actionHook = AiActionHook.of(context);
    
    // Extract location - simplified for demo
    String location = 'London';
    if (message.contains('New York')) location = 'New York';
    if (message.contains('Paris')) location = 'Paris';
    if (message.contains('Tokyo')) location = 'Tokyo';
    
    final result = await actionHook.executeAction('get_weather', {
      'location': location,
    });
    
    if (result.success) {
      final weather = result.data;
      _addAiResponse('Weather in ${weather['location']}: ${weather['temperature']}°C, ${weather['condition']}');
    } else {
      _addAiResponse('Sorry, I couldn\'t get weather information: ${result.error}');
    }
  }

  Future<void> _executeUnitConversion(String message) async {
    final actionHook = AiActionHook.of(context);
    
    // Simple conversion example
    final result = await actionHook.executeAction('convert_temperature', {
      'value': 25.0,
      'from': 'celsius',
      'to': 'fahrenheit',
    });
    
    if (result.success) {
      _addAiResponse('25°C = ${result.data['result']}°F');
    } else {
      _addAiResponse('Sorry, I couldn\'t convert that: ${result.error}');
    }
  }

  void _addAiResponse(String text) {
    _controller.addMessage(
      ChatMessage(
        text: text,
        user: _aiUser,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AiActionProvider(
      config: AiActionConfig(
        actions: _createSimpleActions(),
        debug: true,
      ),
      child: Builder(
        builder: (context) {
          _setupActionListener();
          
          return Scaffold(
            appBar: AppBar(
              title: const Text('Simple AI Actions'),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            body: Column(
              children: [
                _buildQuickActionsBar(),
                Expanded(
                  child: AiChatWidget(
                    currentUser: _currentUser,
                    aiUser: _aiUser,
                    controller: _controller,
                    onSendMessage: _handleSendMessage,
                    inputOptions: const InputOptions(
                      decoration: InputDecoration(
                        hintText: 'Ask me anything...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActionsBar() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.calculate),
            label: const Text('Calculate 15 + 27'),
            onPressed: () => _handleSendMessage(
              ChatMessage(
                text: 'Calculate 15 + 27',
                user: _currentUser,
                createdAt: DateTime.now(),
              ),
            ),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.cloud),
            label: const Text('Weather in London'),
            onPressed: () => _handleSendMessage(
              ChatMessage(
                text: 'What\'s the weather in London?',
                user: _currentUser,
                createdAt: DateTime.now(),
              ),
            ),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.swap_horiz),
            label: const Text('Convert 25°C'),
            onPressed: () => _handleSendMessage(
              ChatMessage(
                text: 'Convert 25 celsius to fahrenheit',
                user: _currentUser,
                createdAt: DateTime.now(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _setupActionListener() {
    _actionSubscription?.cancel();
    final actionController = AiActionProvider.of(context);
    _actionSubscription = actionController.events.listen(_handleActionEvent);
  }

  void _handleActionEvent(ActionEvent event) {
    // Handle action events for logging or UI feedback
    debugPrint('Action ${event.actionName}: ${event.type}');
  }

  List<AiAction> _createSimpleActions() {
    return [
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
        handler: (params) async {
          await Future.delayed(const Duration(milliseconds: 500)); // Simulate processing
          
          final a = (params['a'] as num).toDouble();
          final b = (params['b'] as num).toDouble();
          final operation = params['operation'] as String;
          
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
        },
      ),
      
      AiAction(
        name: 'get_weather',
        description: 'Get current weather information',
        parameters: [
          ActionParameter.string(name: 'location', description: 'City name', required: true),
        ],
        handler: (params) async {
          await Future.delayed(const Duration(seconds: 1)); // Simulate API call
          
          final location = params['location'] as String;
          
          // Mock weather data
          final weatherData = {
            'London': {'temperature': 15, 'condition': 'Cloudy'},
            'New York': {'temperature': 22, 'condition': 'Sunny'},
            'Paris': {'temperature': 18, 'condition': 'Rainy'},
            'Tokyo': {'temperature': 25, 'condition': 'Clear'},
          };
          
          final weather = weatherData[location] ?? weatherData['London']!;
          
          return ActionResult.createSuccess({
            'location': location,
            'temperature': weather['temperature'],
            'condition': weather['condition'],
          });
        },
      ),
      
      AiAction(
        name: 'convert_temperature',
        description: 'Convert temperature between units',
        parameters: [
          ActionParameter.number(name: 'value', description: 'Temperature value', required: true),
          ActionParameter.string(name: 'from', description: 'From unit', required: true, enumValues: ['celsius', 'fahrenheit']),
          ActionParameter.string(name: 'to', description: 'To unit', required: true, enumValues: ['celsius', 'fahrenheit']),
        ],
        handler: (params) async {
          await Future.delayed(const Duration(milliseconds: 300));
          
          final value = params['value'] as num;
          final from = params['from'] as String;
          final to = params['to'] as String;
          
          if (from == to) {
            return ActionResult.createSuccess({'result': value});
          }
          
          double result;
          if (from == 'celsius' && to == 'fahrenheit') {
            result = (value * 9 / 5) + 32;
          } else if (from == 'fahrenheit' && to == 'celsius') {
            result = (value - 32) * 5 / 9;
          } else {
            return ActionResult.createFailure('Unsupported conversion');
          }
          
          return ActionResult.createSuccess({
            'result': result.round(),
            'conversion': '$value°${from[0].toUpperCase()} = ${result.round()}°${to[0].toUpperCase()}',
          });
        },
      ),
    ];
  }
}