import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

import '../../action_examples/calculator_action.dart';
import '../../action_examples/weather_action.dart';

class AiActionsExample extends StatefulWidget {
  const AiActionsExample({super.key});

  @override
  State<AiActionsExample> createState() => _AiActionsExampleState();
}

class _AiActionsExampleState extends State<AiActionsExample> {
  late ChatMessagesController _controller;
  late ChatUser _currentUser;
  late ChatUser _aiUser;
  late StreamSubscription<ActionEvent> _actionSubscription;
  
  @override
  void initState() {
    super.initState();
    
    _controller = ChatMessagesController();
    _currentUser = ChatUser(id: '1', firstName: 'John Doe');
    _aiUser = ChatUser(id: '2', firstName: 'AI Assistant');
    
    // Add welcome message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.addMessage(ChatMessage(
        text: 'Hello! I can help you with calculations, weather information, and unit conversions. Try asking me things like:\n\n'
              '• "Calculate 15 + 27"\n'
              '• "What\'s the weather in New York?"\n'
              '• "Convert 100 meters to feet"\n'
              '• "Calculate the square root of 144"\n\n'
              'I can perform actions automatically based on your requests!',
        user: _aiUser,
        createdAt: DateTime.now(),
      ));
    });
  }

  @override
  void dispose() {
    _actionSubscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _handleSendMessage(ChatMessage message) {
    _controller.addMessage(message);
    
    // Simulate AI processing and function calling
    _processAIResponse(message.text);
  }

  /// Simulates AI processing that might call functions
  void _processAIResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    
    // Simple pattern matching to determine what action to call
    if (_shouldCalculate(lowerMessage)) {
      _handleCalculationRequest(userMessage, lowerMessage);
    } else if (_shouldGetWeather(lowerMessage)) {
      _handleWeatherRequest(userMessage, lowerMessage);
    } else if (_shouldConvert(lowerMessage)) {
      _handleConversionRequest(userMessage, lowerMessage);
    } else {
      // Regular AI response without function calling
      Timer(const Duration(milliseconds: 800), () {
        _controller.addMessage(ChatMessage(
          text: 'I can help you with calculations, weather information, and unit conversions. '
                'Try asking me to calculate something, get weather info, or convert units!',
          user: _aiUser,
          createdAt: DateTime.now(),
        ));
      });
    }
  }

  bool _shouldCalculate(String message) {
    return message.contains('calculate') || 
           message.contains('math') ||
           message.contains('add') ||
           message.contains('subtract') ||
           message.contains('multiply') ||
           message.contains('divide') ||
           message.contains('sin') ||
           message.contains('cos') ||
           message.contains('sqrt') ||
           message.contains('log') ||
           RegExp(r'\d+\s*[\+\-\*\/]\s*\d+').hasMatch(message);
  }

  bool _shouldGetWeather(String message) {
    return message.contains('weather') || 
           message.contains('temperature') ||
           message.contains('forecast');
  }

  bool _shouldConvert(String message) {
    return message.contains('convert') ||
           message.contains('celsius') ||
           message.contains('fahrenheit') ||
           message.contains('meters') ||
           message.contains('feet');
  }

  void _handleCalculationRequest(String originalMessage, String lowerMessage) {
    Timer(const Duration(milliseconds: 500), () async {
      final actionHook = AiActionHook.of(context);
      
      // Try to extract calculation from message
      Map<String, dynamic>? params;
      
      if (lowerMessage.contains('sqrt') || lowerMessage.contains('square root')) {
        final match = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(originalMessage);
        if (match != null) {
          final value = double.parse(match.group(1)!);
          params = {'value': value, 'function': 'sqrt'};
        }
      } else if (lowerMessage.contains('sin')) {
        final match = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(originalMessage);
        if (match != null) {
          final value = double.parse(match.group(1)!);
          params = {'value': value, 'function': 'sin'};
        }
      } else if (lowerMessage.contains('cos')) {
        final match = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(originalMessage);
        if (match != null) {
          final value = double.parse(match.group(1)!);
          params = {'value': value, 'function': 'cos'};
        }
      } else {
        // Try to parse basic arithmetic
        final match = RegExp(r'(\d+(?:\.\d+)?)\s*([\+\-\*\/])\s*(\d+(?:\.\d+)?)').firstMatch(originalMessage);
        if (match != null) {
          final a = double.parse(match.group(1)!);
          final operator = match.group(2)!;
          final b = double.parse(match.group(3)!);
          
          String operation;
          switch (operator) {
            case '+':
              operation = 'add';
              break;
            case '-':
              operation = 'subtract';
              break;
            case '*':
              operation = 'multiply';
              break;
            case '/':
              operation = 'divide';
              break;
            default:
              operation = 'add';
          }
          
          params = {'a': a, 'b': b, 'operation': operation};
        } else {
          // Fallback example
          params = {'a': 10, 'b': 5, 'operation': 'add'};
        }
      }
      
      if (params != null) {
        String actionName = params.containsKey('function') ? 'advanced_math' : 'calculate';
        
        // Add AI message saying it's performing the calculation
        final messageId = 'calc_${DateTime.now().millisecondsSinceEpoch}';
        final aiMessage = ChatMessage(
          text: 'I\'ll calculate that for you...',
          user: _aiUser,
          createdAt: DateTime.now(),
          customProperties: {'id': messageId},
        );
        _controller.addMessage(aiMessage);
        
        try {
          final result = await actionHook.executeAction(actionName, params);
          
          // Update AI message with result
          String responseText;
          if (result.success) {
            if (actionName == 'calculate') {
              responseText = 'Here\'s the calculation result:\n\n${result.data['equation']}\n\nThe answer is **${result.data['result']}**.';
            } else {
              responseText = 'Here\'s the calculation result:\n\n${result.data['expression']} = **${result.data['result']}**';
            }
          } else {
            responseText = 'Sorry, I encountered an error while calculating: ${result.error}';
          }
          
          _controller.updateMessage(ChatMessage(
            text: responseText,
            user: _aiUser,
            createdAt: aiMessage.createdAt,
            customProperties: {'id': messageId},
          ));
        } catch (e) {
          _controller.updateMessage(ChatMessage(
            text: 'Sorry, I encountered an unexpected error while calculating.',
            user: _aiUser,
            createdAt: aiMessage.createdAt,
            customProperties: {'id': messageId},
          ));
        }
      }
    });
  }

  void _handleWeatherRequest(String originalMessage, String lowerMessage) {
    Timer(const Duration(milliseconds: 500), () async {
      final actionHook = AiActionHook.of(context);
      
      // Try to extract location from message
      String location = 'New York, NY'; // Default
      
      // Simple location extraction
      if (lowerMessage.contains(' in ')) {
        final parts = lowerMessage.split(' in ');
        if (parts.length > 1) {
          location = parts[1].trim().split(' ').take(2).join(' ');
          location = location.replaceAll(RegExp(r'[^\w\s,]'), '');
        }
      }
      
      // Add AI message saying it's getting weather
      final messageId = 'weather_${DateTime.now().millisecondsSinceEpoch}';
      final aiMessage = ChatMessage(
        text: 'I\'ll get the current weather information for $location...',
        user: _aiUser,
        createdAt: DateTime.now(),
        customProperties: {'id': messageId},
      );
      _controller.addMessage(aiMessage);
      
      try {
        final result = await actionHook.executeAction('get_current_weather', {
          'location': location,
          'units': 'celsius',
        });
        
        // Update AI message with result
        String responseText;
        if (result.success) {
          final data = result.data as Map<String, dynamic>;
          responseText = 'Here\'s the current weather for ${data['location']}:\n\n'
                        '🌡️ **${data['temperature']}°${data['units'] == 'celsius' ? 'C' : 'F'}**\n'
                        '☁️ ${data['condition']}\n'
                        '💧 Humidity: ${data['humidity']}%\n'
                        '💨 Wind: ${data['windSpeed']} km/h';
        } else {
          responseText = 'Sorry, I couldn\'t get the weather information: ${result.error}';
        }
        
        _controller.updateMessage(ChatMessage(
          text: responseText,
          user: _aiUser,
          createdAt: aiMessage.createdAt,
          customProperties: {'id': messageId},
        ));
      } catch (e) {
        _controller.updateMessage(ChatMessage(
          text: 'Sorry, I encountered an error while getting weather information.',
          user: _aiUser,
          createdAt: aiMessage.createdAt,
          customProperties: {'id': messageId},
        ));
      }
    });
  }

  void _handleConversionRequest(String originalMessage, String lowerMessage) {
    Timer(const Duration(milliseconds: 500), () async {
      final actionHook = AiActionHook.of(context);
      
      // Try to extract conversion parameters
      double value = 100; // Default
      String fromUnit = 'celsius';
      String toUnit = 'fahrenheit';
      
      // Simple conversion extraction
      final valueMatch = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(originalMessage);
      if (valueMatch != null) {
        value = double.parse(valueMatch.group(1)!);
      }
      
      if (lowerMessage.contains('celsius') && lowerMessage.contains('fahrenheit')) {
        fromUnit = 'celsius';
        toUnit = 'fahrenheit';
      } else if (lowerMessage.contains('fahrenheit') && lowerMessage.contains('celsius')) {
        fromUnit = 'fahrenheit';
        toUnit = 'celsius';
      } else if (lowerMessage.contains('meters') && lowerMessage.contains('feet')) {
        fromUnit = 'meters';
        toUnit = 'feet';
      } else if (lowerMessage.contains('feet') && lowerMessage.contains('meters')) {
        fromUnit = 'feet';
        toUnit = 'meters';
      }
      
      // Add AI message saying it's converting
      final messageId = 'convert_${DateTime.now().millisecondsSinceEpoch}';
      final aiMessage = ChatMessage(
        text: 'I\'ll convert $value $fromUnit to $toUnit...',
        user: _aiUser,
        createdAt: DateTime.now(),
        customProperties: {'id': messageId},
      );
      _controller.addMessage(aiMessage);
      
      try {
        final result = await actionHook.executeAction('convert_units', {
          'value': value,
          'from_unit': fromUnit,
          'to_unit': toUnit,
        });
        
        // Update AI message with result
        String responseText;
        if (result.success) {
          responseText = 'Here\'s the conversion result:\n\n**${result.data['conversion']}**';
        } else {
          responseText = 'Sorry, I couldn\'t convert those units: ${result.error}';
        }
        
        _controller.updateMessage(ChatMessage(
          text: responseText,
          user: _aiUser,
          createdAt: aiMessage.createdAt,
          customProperties: {'id': messageId},
        ));
      } catch (e) {
        _controller.updateMessage(ChatMessage(
          text: 'Sorry, I encountered an error while converting units.',
          user: _aiUser,
          createdAt: aiMessage.createdAt,
          customProperties: {'id': messageId},
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AiActionProvider(
      config: AiActionConfig(
        actions: [
          // Calculator actions
          CalculatorActions.basicCalculator(),
          CalculatorActions.advancedMath(),
          CalculatorActions.unitConverter(),
          
          // Weather actions
          WeatherActions.getCurrentWeather(),
          WeatherActions.setWeatherAlert(),
        ],
        debug: true,
      ),
      child: Builder(
        builder: (context) {
          // Set up action event listener
          final actionController = AiActionProvider.of(context);
          _actionSubscription = actionController.events.listen((event) {
            dev.log('Action Event: ${event.type} - ${event.actionName}');
            
            // You could add action result messages to chat here
            // This is where you'd integrate with your AI's function calling
          });
          
          return Scaffold(
            appBar: AppBar(
              title: const Text('AI Actions Example'),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              actions: [
                AiActionBuilder(
                  builder: (context, hook) {
                    return PopupMenuButton<String>(
                      icon: const Icon(Icons.functions),
                      tooltip: 'Available Actions',
                      onSelected: (action) {
                        // Show action info
                        _showActionInfo(context, hook.actions[action]!);
                      },
                      itemBuilder: (context) {
                        return hook.actions.keys.map((actionName) {
                          final action = hook.actions[actionName]!;
                          return PopupMenuItem<String>(
                            value: actionName,
                            child: ListTile(
                              leading: const Icon(Icons.bolt),
                              title: Text(action.name),
                              subtitle: Text(
                                action.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        }).toList();
                      },
                    );
                  },
                ),
              ],
            ),
            body: AiChatWidget(
              currentUser: _currentUser,
              aiUser: _aiUser,
              controller: _controller,
              onSendMessage: _handleSendMessage,
              welcomeMessageConfig: WelcomeMessageConfig(
                title: 'AI Actions Demo',
                questionsSectionTitle: 'Try these examples:',
              ),
              exampleQuestions: const [
                ExampleQuestion(question: 'Calculate 25 * 8'),
                ExampleQuestion(question: 'What\'s the square root of 144?'),
                ExampleQuestion(question: 'Get weather for London'),
                ExampleQuestion(question: 'Convert 100 meters to feet'),
              ],
              inputOptions: const InputOptions(
                decoration: InputDecoration(
                  hintText: 'Ask me to calculate, get weather, or convert units...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showActionInfo(BuildContext context, AiAction action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(action.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(action.description),
              const SizedBox(height: 16),
              
              Text(
                'Parameters',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              ...action.parameters.map((param) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            param.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              param.type.toString().split('.').last,
                              style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          if (param.required) ...[
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'required',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        param.description,
                        style: const TextStyle(fontSize: 12),
                      ),
                      if (param.defaultValue != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Default: ${param.defaultValue}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              )),
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