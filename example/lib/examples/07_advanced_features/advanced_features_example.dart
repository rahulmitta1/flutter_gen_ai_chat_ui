import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

/// Comprehensive example showcasing all advanced CopilotKit-inspired features:
/// 1. Enhanced Chat Interface (useCopilotChat equivalent)
/// 2. AI-Enhanced Text Input (useCopilotTextarea equivalent) 
/// 3. Multi-Agent Orchestration System
/// 4. AI Actions and Context-Aware State Management (from previous phases)
class AdvancedFeaturesExample extends StatefulWidget {
  const AdvancedFeaturesExample({super.key});

  @override
  State<AdvancedFeaturesExample> createState() => _AdvancedFeaturesExampleState();
}

class _AdvancedFeaturesExampleState extends State<AdvancedFeaturesExample>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controllers for different systems
  final HeadlessChatController _chatController = HeadlessChatController();
  final AiTextInputController _textInputController = AiTextInputController();
  final AgentOrchestrator _orchestrator = AgentOrchestrator();
  final ActionController _actionController = ActionController();
  final AiContextController _contextController = AiContextController();

  // Chat UI controller
  final ChatMessagesController _chatMessagesController = ChatMessagesController();

  // Demo users
  final ChatUser currentUser = const ChatUser(id: '1', name: 'You');
  final ChatUser aiUser = const ChatUser(id: '2', name: 'AI Assistant');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _initializeAdvancedFeatures();
  }

  Future<void> _initializeAdvancedFeatures() async {
    // Initialize agents
    await _setupAgentOrchestrator();
    
    // Setup AI actions
    _setupAiActions();
    
    // Setup context awareness
    _setupContextAwareness();
    
    // Create initial chat thread
    _chatController.createThread(title: 'Advanced Features Demo');
  }

  Future<void> _setupAgentOrchestrator() async {
    // Register specialist agents
    await _orchestrator.registerAgent(TextAnalysisAgent());
    await _orchestrator.registerAgent(CodeAnalysisAgent());
    await _orchestrator.registerAgent(GeneralAssistantAgent());
  }

  void _setupAiActions() {
    // Register agent query action
    _actionController.registerAction(AiAction(
      name: 'query_agent',
      description: 'Query the multi-agent system',
      parameters: [
        ActionParameter(
          name: 'query',
          type: ActionParameterType.string,
          description: 'The query to send to agents',
          required: true,
        ),
        ActionParameter(
          name: 'agent_type',
          type: ActionParameterType.string,
          description: 'Preferred agent type (text_analysis, code_analysis, general)',
          required: false,
        ),
      ],
      handler: _handleAgentQuery,
    ));

    // Register text enhancement action
    _actionController.registerAction(AiAction(
      name: 'enhance_text',
      description: 'Enhance text using AI suggestions',
      parameters: [
        ActionParameter(
          name: 'text',
          type: ActionParameterType.string,
          description: 'Text to enhance',
          required: true,
        ),
      ],
      handler: _handleTextEnhancement,
    ));
  }

  void _setupContextAwareness() {
    // Set demo context
    _contextController.setContext(AiContextData(
      id: 'user_session',
      name: 'User Session',
      description: 'Current user session information and preferences',
      type: AiContextType.userProfile,
      priority: AiContextPriority.high,
      data: {
        'name': 'Demo User',
        'preferences': ['technical', 'detailed_explanations'],
        'current_task': 'exploring_advanced_features',
      },
    ));

    _contextController.setContext(AiContextData(
      id: 'app_state',
      name: 'Application State',
      description: 'Current application state and active features',
      type: AiContextType.applicationState,
      priority: AiContextPriority.normal,
      data: {
        'active_features': ['chat', 'agents', 'actions', 'context'],
        'demo_mode': true,
      },
    ));
  }

  Future<ActionResult> _handleAgentQuery(Map<String, dynamic> parameters) async {
    final query = parameters['query'] as String;
    
    try {
      final request = AgentRequest(
        id: 'query_${DateTime.now().millisecondsSinceEpoch}',
        query: query,
        type: AgentRequestType.query,
        timestamp: DateTime.now(),
      );

      final response = await _orchestrator.processRequest(request);
      
      return ActionResult.createSuccess({
        'response': response.content,
        'agent': response.agentId,
        'confidence': response.confidence,
        'type': response.type.toString(),
      });
    } catch (e) {
      return ActionResult.createFailure('Failed to query agents: $e');
    }
  }

  Future<ActionResult> _handleTextEnhancement(Map<String, dynamic> parameters) async {
    final text = parameters['text'] as String;
    
    try {
      final enhancedText = await _textInputController.generateFirstDraft(
        'Enhance this text: $text'
      );
      
      return ActionResult.createSuccess({
        'original': text,
        'enhanced': enhancedText,
        'improvements': 'AI-enhanced with better clarity and structure',
      });
    } catch (e) {
      return ActionResult.createFailure('Failed to enhance text: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced AI Features Demo'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Multi-Chat', icon: Icon(Icons.chat_bubble_outline)),
            Tab(text: 'AI Text Input', icon: Icon(Icons.edit_outlined)),
            Tab(text: 'Agent System', icon: Icon(Icons.psychology_outlined)),
            Tab(text: 'AI Actions', icon: Icon(Icons.functions_outlined)),
            Tab(text: 'Live Demo', icon: Icon(Icons.play_arrow_outlined)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMultiChatDemo(),
          _buildAiTextInputDemo(),
          _buildAgentSystemDemo(),
          _buildAiActionsDemo(),
          _buildLiveDemo(),
        ],
      ),
    );
  }

  Widget _buildMultiChatDemo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enhanced Chat Interface',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Multiple isolated chat threads with state persistence (equivalent to CopilotKit\'s useCopilotChat)',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          
          // Thread management controls
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  final threadId = _chatController.createThread(
                    title: 'Chat ${DateTime.now().millisecondsSinceEpoch}',
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Created thread: $threadId')),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('New Thread'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  _chatController.resetThread();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Thread reset')),
                  );
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Thread state display
          Expanded(
            child: ListenableBuilder(
              listenable: _chatController,
              builder: (context, child) {
                final state = _chatController.state;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Active Threads: ${state.threads.length}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('Active Thread: ${state.activeThreadId ?? "None"}'),
                            Text('Messages in Active: ${state.activeThread?.messages.length ?? 0}'),
                            Text('Loading: ${state.isLoading}'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Messages display
                    Expanded(
                      child: state.activeThread != null && state.activeThread!.messages.isNotEmpty
                          ? ListView.builder(
                              itemCount: state.activeThread!.messages.length,
                              itemBuilder: (context, index) {
                                final message = state.activeThread!.messages[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                  child: ListTile(
                                    title: Text(message.user.name),
                                    subtitle: Text(message.text),
                                    trailing: Text(
                                      '${message.createdAt.hour}:${message.createdAt.minute.toString().padLeft(2, '0')}',
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text(
                                'No messages in active thread.\nSend a message to get started!',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                    ),
                    
                    // Message input
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Type a message...',
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: (text) {
                              if (text.isNotEmpty) {
                                final message = ChatMessage(
                                  text: text,
                                  user: currentUser,
                                  createdAt: DateTime.now(),
                                );
                                _chatController.appendMessage(message);
                                
                                // Simulate AI response
                                Future.delayed(const Duration(milliseconds: 500), () {
                                  final aiResponse = ChatMessage(
                                    text: 'AI Response to: "$text"',
                                    user: aiUser,
                                    createdAt: DateTime.now(),
                                  );
                                  _chatController.appendMessage(aiResponse);
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiTextInputDemo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AI-Enhanced Text Input',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Smart text suggestions and auto-drafts (equivalent to CopilotKit\'s useCopilotTextarea)',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AI Text Input Field
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Smart Text Field',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            maxLines: 4,
                            decoration: const InputDecoration(
                              hintText: 'Start typing and get AI suggestions...',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (text) {
                              _textInputController.updateText(text);
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          // Generate Draft Button
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () async {
                                  try {
                                    final draft = await _textInputController.generateFirstDraft(
                                      'Write a professional email about project updates'
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Draft generated: ${draft.substring(0, 50)}...')),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e')),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.auto_awesome),
                                label: const Text('Generate Draft'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                onPressed: () {
                                  _textInputController.clearSuggestions();
                                },
                                icon: const Icon(Icons.clear),
                                label: const Text('Clear'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // AI Suggestions Display
                  ListenableBuilder(
                    listenable: _textInputController,
                    builder: (context, child) {
                      final state = _textInputController.state;
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'AI Suggestions',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  if (state.isLoading) ...[
                                    const SizedBox(width: 8),
                                    const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (state.suggestions.isEmpty)
                                const Text(
                                  'Start typing to see AI suggestions...',
                                  style: TextStyle(color: Colors.grey),
                                )
                              else
                                ...state.suggestions.map((suggestion) => ListTile(
                                  leading: Icon(_getSuggestionIcon(suggestion.type)),
                                  title: Text(suggestion.replacementText),
                                  subtitle: Text('${suggestion.type.name} • ${(suggestion.confidence * 100).toInt()}% confidence'),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.check),
                                    onPressed: () {
                                      _textInputController.applySuggestion(suggestion);
                                    },
                                  ),
                                )),
                              
                              if (state.error != null)
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.error, color: Colors.red),
                                      const SizedBox(width: 8),
                                      Expanded(child: Text(state.error!)),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getSuggestionIcon(AiSuggestionType type) {
    switch (type) {
      case AiSuggestionType.completion:
        return Icons.auto_fix_high;
      case AiSuggestionType.enhancement:
        return Icons.trending_up;
      case AiSuggestionType.grammar:
        return Icons.spellcheck;
      case AiSuggestionType.style:
        return Icons.palette;
      case AiSuggestionType.draft:
        return Icons.description;
    }
  }

  Widget _buildAgentSystemDemo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Multi-Agent Orchestration',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Intelligent agent routing and collaboration (equivalent to CopilotKit\'s CoAgents)',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: Row(
              children: [
                // Agents list
                Expanded(
                  flex: 1,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Active Agents',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListenableBuilder(
                              listenable: _orchestrator,
                              builder: (context, child) {
                                return ListView.builder(
                                  itemCount: _orchestrator.agents.length,
                                  itemBuilder: (context, index) {
                                    final agent = _orchestrator.agents[index];
                                    return Card(
                                      margin: const EdgeInsets.symmetric(vertical: 4),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: _getAgentColor(agent.status),
                                          child: Icon(_getAgentIcon(agent.specialization)),
                                        ),
                                        title: Text(agent.name),
                                        subtitle: Text(agent.specialization),
                                        trailing: Chip(
                                          label: Text(agent.status.name),
                                          backgroundColor: _getAgentColor(agent.status).withOpacity(0.1),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Query interface
                Expanded(
                  flex: 2,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Query Agents',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          
                          TextField(
                            decoration: const InputDecoration(
                              hintText: 'Ask anything... (try "analyze sentiment of this text" or "review my code")',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                            onSubmitted: (query) async {
                              if (query.isNotEmpty) {
                                await _queryAgentSystem(query);
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () => _queryAgentSystem('Analyze the sentiment of this positive message'),
                                child: const Text('Demo: Sentiment Analysis'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () => _queryAgentSystem('Review this code for potential improvements'),
                                child: const Text('Demo: Code Review'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          const Text(
                            'Response:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SingleChildScrollView(
                                child: Text(
                                  _lastAgentResponse ?? 'No response yet. Try querying the agents above.',
                                  style: const TextStyle(fontFamily: 'monospace'),
                                ),
                              ),
                            ),
                          ),
                        ],
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

  String? _lastAgentResponse;

  Future<void> _queryAgentSystem(String query) async {
    try {
      final request = AgentRequest(
        id: 'demo_${DateTime.now().millisecondsSinceEpoch}',
        query: query,
        type: AgentRequestType.query,
        timestamp: DateTime.now(),
      );

      final response = await _orchestrator.processRequest(request);
      setState(() {
        _lastAgentResponse = '🤖 Agent: ${response.agentId}\n'
                           '📈 Confidence: ${(response.confidence * 100).toInt()}%\n'
                           '🕐 Time: ${response.timestamp.toLocal()}\n\n'
                           '💬 Response:\n${response.content}';
      });
    } catch (e) {
      setState(() {
        _lastAgentResponse = '❌ Error: $e';
      });
    }
  }

  Color _getAgentColor(AgentStatus status) {
    switch (status) {
      case AgentStatus.idle:
        return Colors.green;
      case AgentStatus.processing:
        return Colors.orange;
      case AgentStatus.streaming:
        return Colors.blue;
      case AgentStatus.delegating:
        return Colors.purple;
      case AgentStatus.error:
        return Colors.red;
      case AgentStatus.offline:
        return Colors.grey;
      case AgentStatus.initializing:
        return Colors.yellow;
    }
  }

  IconData _getAgentIcon(String specialization) {
    if (specialization.contains('text') || specialization.contains('language')) {
      return Icons.text_fields;
    } else if (specialization.contains('code')) {
      return Icons.code;
    } else {
      return Icons.psychology;
    }
  }

  Widget _buildAiActionsDemo() {
    return AiActionProvider(
      config: const AiActionConfig(),
      controller: _actionController,
      child: AiContextProvider(
        controller: _contextController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AI Actions Integration',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Execute AI actions with context awareness and agent integration',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              
              Expanded(
                child: Row(
                  children: [
                    // Available Actions
                    Expanded(
                      flex: 1,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Available Actions',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              
                              ListenableBuilder(
                                listenable: _actionController,
                                builder: (context, child) {
                                  final actions = _actionController.registeredActions;
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: actions.length,
                                    itemBuilder: (context, index) {
                                      final action = actions[index];
                                      return Card(
                                        margin: const EdgeInsets.symmetric(vertical: 4),
                                        child: ListTile(
                                          title: Text(action.name),
                                          subtitle: Text(action.description),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.play_arrow),
                                            onPressed: () => _executeAction(action),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Context & Execution Results
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          // Context Display
                          Expanded(
                            flex: 1,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Current Context',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    Expanded(
                                      child: ListenableBuilder(
                                        listenable: _contextController,
                                        builder: (context, child) {
                                          final summary = _contextController.getContextSummary();
                                          return SingleChildScrollView(
                                            child: Text(
                                              summary.isNotEmpty ? summary : 'No context available',
                                              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Action Results
                          Expanded(
                            flex: 1,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Action Results',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: SingleChildScrollView(
                                          child: Text(
                                            _lastActionResult ?? 'No action executed yet.',
                                            style: const TextStyle(fontFamily: 'monospace'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  String? _lastActionResult;

  Future<void> _executeAction(AiAction action) async {
    try {
      Map<String, dynamic> parameters = {};
      
      // Fill in demo parameters
      if (action.name == 'query_agent') {
        parameters = {
          'query': 'Analyze the sentiment of this positive and exciting message!',
          'agent_type': 'text_analysis',
        };
      } else if (action.name == 'enhance_text') {
        parameters = {
          'text': 'This is good text that could be better.',
        };
      }

      final result = await _actionController.executeAction(
        action.name,
        parameters,
        context: context,
      );

      setState(() {
        _lastActionResult = '✅ Action: ${action.name}\n'
                           '🎯 Success: ${result.success}\n'
                           '📊 Data: ${result.data}\n'
                           '⏰ Executed at: ${DateTime.now().toLocal()}\n\n'
                           'Result: ${result.data}';
      });
    } catch (e) {
      setState(() {
        _lastActionResult = '❌ Error executing ${action.name}: $e';
      });
    }
  }

  Widget _buildLiveDemo() {
    return AiActionProvider(
      config: const AiActionConfig(),
      controller: _actionController,
      child: AiContextProvider(
        controller: _contextController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Live Integration Demo',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'All systems working together in a real chat interface',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              
              // Full chat interface with all features
              Expanded(
                child: AiChatWidget(
                  currentUser: currentUser,
                  aiUser: aiUser,
                  controller: _chatMessagesController,
                  onSendMessage: _handleLiveDemoMessage,
                  welcomeMessageConfig: const WelcomeMessageConfig(
                    title: '🚀 Welcome to the Advanced Features Demo!\n\n'
                            'Try these commands:\n'
                            '• "Analyze: This is amazing text!"\n'
                            '• "Code review my function"\n'
                            '• "Enhance: good morning message"\n'
                            '• "Help" for more options',
                  ),
                  inputOptions: InputOptions.glassmorphic(
                    hintText: 'Ask me anything... I\'ll route to the best agent!',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLiveDemoMessage(ChatMessage message) async {
    try {
      // Route message through agent system
      final request = AgentRequest(
        id: 'live_${DateTime.now().millisecondsSinceEpoch}',
        query: message.text,
        type: AgentRequestType.query,
        timestamp: DateTime.now(),
        context: {}, // TODO: Add context data from controller
      );

      // Stream response
      await for (final response in _orchestrator.streamResponse(request)) {
        final aiMessage = ChatMessage(
          text: response.content,
          user: aiUser,
          createdAt: DateTime.now(),
          isMarkdown: true,
        );
        
        _chatMessagesController.addMessage(aiMessage);
        
        if (response.type == AgentResponseType.finalAnswer) break;
      }
    } catch (e) {
      final errorMessage = ChatMessage(
        text: '❌ Error: $e',
        user: aiUser,
        createdAt: DateTime.now(),
      );
      _chatMessagesController.addMessage(errorMessage);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _chatController.dispose();
    _textInputController.dispose();
    _orchestrator.dispose();
    _actionController.dispose();
    _contextController.dispose();
    _chatMessagesController.dispose();
    super.dispose();
  }
}