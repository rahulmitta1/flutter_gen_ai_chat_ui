import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

/// Essential CopilotKit Features Demo
/// Showcases the most important features that every CopilotKit app uses:
/// 1. Readable Context (useCopilotReadable equivalent)  
/// 2. Action System (useCopilotAction equivalent)
/// 3. AI-Enhanced Text Input (CopilotTextarea equivalent)
/// 4. Context-Aware Chat Integration
class EssentialCopilotExample extends StatefulWidget {
  const EssentialCopilotExample({super.key});

  @override
  State<EssentialCopilotExample> createState() => _EssentialCopilotExampleState();
}

class _EssentialCopilotExampleState extends State<EssentialCopilotExample> 
    with ContextAwareChatMixin {
  
  // App state that we'll share with AI
  final List<String> _tasks = ['Buy groceries', 'Call dentist', 'Fix broken door'];
  int _currentUserId = 1;
  String _currentUserName = 'John Doe';
  double _appRating = 4.5;
  
  // Controllers for text input
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _setupCopilotFeatures();
  }
  
  /// Setup essential CopilotKit features
  void _setupCopilotFeatures() {
    // 1. Setup Readable Context (useCopilotReadable equivalent)
    _updateContextFromAppState();
    
    // 2. Setup Actions (useCopilotAction equivalent)  
    _setupActions();
  }
  
  /// Update readable context with current app state
  void _updateContextFromAppState() {
    // Share user info with AI
    addReadableContext(
      'user_profile',
      'Current user information and preferences',
      {
        'id': _currentUserId,
        'name': _currentUserName,
        'preferences': ['productivity', 'simple_ui'],
        'timezone': 'UTC-8',
      },
    );
    
    // Share tasks list with AI
    addReadableContext(
      'tasks_list',
      'User\'s current task list and to-do items',
      {
        'tasks': _tasks,
        'total_count': _tasks.length,
        'last_updated': DateTime.now().toIso8601String(),
      },
    );
    
    // Share app metrics with AI
    addReadableContext(
      'app_metrics',
      'Current app performance and user engagement metrics',
      {
        'user_rating': _appRating,
        'active_users': 1247,
        'app_version': '2.3.6',
        'last_sync': DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
      },
    );
  }
  
  /// Setup AI actions that can be triggered
  void _setupActions() {
    // Action to add tasks
    registerAction(AiAction(
      name: 'add_task',
      description: 'Add a new task to the user\'s task list',
      parameters: [
        ActionParameter.string(
          name: 'task_name',
          description: 'The task description or title',
          required: true,
        ),
        ActionParameter.string(
          name: 'priority',
          description: 'Task priority level',
          enumValues: ['low', 'medium', 'high'],
        ),
      ],
      handler: (params) async {
        final taskName = params['task_name'] as String;
        final priority = params['priority'] as String? ?? 'medium';
        
        setState(() {
          _tasks.add('[$priority] $taskName');
        });
        
        // Update context after state changes
        _updateContextFromAppState();
        
        return ActionResult.createSuccess({
          'message': 'Task "$taskName" added successfully',
          'task_count': _tasks.length,
          'priority': priority,
        });
      },
    ));
    
    // Action to remove tasks
    registerAction(AiAction(
      name: 'remove_task',
      description: 'Remove a task from the user\'s task list',
      parameters: [
        ActionParameter.string(
          name: 'task_name',
          description: 'The task name or partial text to remove',
          required: true,
        ),
      ],
      handler: (params) async {
        final taskName = params['task_name'] as String;
        final initialCount = _tasks.length;
        
        setState(() {
          _tasks.removeWhere((task) => 
            task.toLowerCase().contains(taskName.toLowerCase()));
        });
        
        final removedCount = initialCount - _tasks.length;
        _updateContextFromAppState();
        
        if (removedCount > 0) {
          return ActionResult.createSuccess({
            'message': 'Removed $removedCount task(s) matching "$taskName"',
            'remaining_tasks': _tasks.length,
          });
        } else {
          return ActionResult.createFailure('No tasks found matching "$taskName"');
        }
      },
    ));
    
    // Action to update user info
    registerAction(AiAction(
      name: 'update_user_name',
      description: 'Update the current user\'s display name',
      parameters: [
        ActionParameter.string(
          name: 'new_name',
          description: 'The new name for the user',
          required: true,
        ),
      ],
      handler: (params) async {
        final newName = params['new_name'] as String;
        final oldName = _currentUserName;
        
        setState(() {
          _currentUserName = newName;
        });
        
        _updateContextFromAppState();
        
        return ActionResult.createSuccess({
          'message': 'User name updated from "$oldName" to "$newName"',
          'old_name': oldName,
          'new_name': newName,
        });
      },
    ));
  }
  
  /// Handle AI responses for the chat
  Future<String> _handleAiResponse(String enhancedPrompt, List<AiAction> availableActions) async {
    // Simulate AI processing with context and actions
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Simple response logic that acknowledges context and suggests actions
    final lowerPrompt = enhancedPrompt.toLowerCase();
    
    if (lowerPrompt.contains('task') || lowerPrompt.contains('todo')) {
      return '''I can see you currently have ${_tasks.length} tasks in your list:

${_tasks.map((t) => '• $t').join('\n')}

I can help you manage your tasks! I can:
- Add new tasks (just say "add a task to...")  
- Remove completed tasks (say "remove the task about...")
- Organize your tasks by priority

What would you like to do with your tasks?''';
    }
    
    if (lowerPrompt.contains('name') || lowerPrompt.contains('profile')) {
      return '''Hi $_currentUserName! I can see your profile information. Your app has a $_appRating star rating and you seem to prefer productivity tools with simple UIs.

I can help update your profile information if needed. Just let me know what you'd like to change!''';
    }
    
    if (lowerPrompt.contains('help') || lowerPrompt.contains('what can you do')) {
      return '''I'm your AI assistant with access to your app data! Here's what I can help with:

**Your Current Context:**
- Tasks: ${_tasks.length} items in your todo list
- User: $_currentUserName (ID: $_currentUserId)  
- App Rating: $_appRating/5.0

**Actions I Can Take:**
- **add_task**: Add new items to your task list
- **remove_task**: Remove completed or unwanted tasks  
- **update_user_name**: Change your display name

Just tell me what you want to do naturally - I'll understand and take the right action!''';
    }
    
    return '''Hi $_currentUserName! I can see your app context and I'm ready to help. You have ${_tasks.length} tasks pending. 

Try asking me to:
- "Add a task to clean the garage"  
- "Remove the task about groceries"
- "Change my name to Jane Smith"
- "Show me my tasks"

I have full access to your app state and can take actions on your behalf!''';
  }
  
  @override
  Widget build(BuildContext context) {
    return ContextAwareChatProvider(
      controller: contextAwareChat,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Essential CopilotKit Features'),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        body: Column(
          children: [
            // Context Display Panel
            _buildContextPanel(),
            
            const Divider(height: 1),
            
            // Main chat interface
            Expanded(
              flex: 3,
              child: _buildChatInterface(),
            ),
            
            const Divider(height: 1),
            
            // AI-Enhanced Input Section  
            _buildAiInputSection(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildContextPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.visibility,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Readable Context (useCopilotReadable)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // User info
          _buildContextItem(
            'User: $_currentUserName (ID: $_currentUserId)',
            Icons.person,
          ),
          
          // Tasks
          _buildContextItem(
            'Tasks: ${_tasks.length} items - ${_tasks.take(2).join(", ")}${_tasks.length > 2 ? "..." : ""}',
            Icons.check_box,
          ),
          
          // App metrics  
          _buildContextItem(
            'App Rating: $_appRating/5.0 • 1,247 active users',
            Icons.analytics,
          ),
          
          const SizedBox(height: 8),
          Text(
            '💡 This context is automatically shared with the AI assistant',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContextItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildChatInterface() {
    return ListenableBuilder(
      listenable: contextAwareChat.chatController,
      builder: (context, child) {
        final messages = contextAwareChat.messages;
        
        return Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.chat,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Context-Aware AI Chat',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${messages.length} messages',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            
            // Messages
            Expanded(
              child: messages.isEmpty 
                ? _buildWelcomeMessage()
                : ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return _buildMessageBubble(message);
                    },
                  ),
            ),
            
            // Input
            _buildChatInput(),
          ],
        );
      },
    );
  }
  
  Widget _buildWelcomeMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.waving_hand,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Hi $_currentUserName! 👋',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'I can see your app context and take actions on your behalf.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Try asking me to:\n• "Add a task to clean the house"\n• "Remove the groceries task"\n• "Show me my current tasks"',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.user.id != 'ai';
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.smart_toy,
                size: 18,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(width: 8),
          ],
          
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser 
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isUser 
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Text(
                _currentUserName[0].toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Ask me anything... I know your app context!',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              onSubmitted: _sendChatMessage,
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _sendChatMessage(String text) async {
    if (text.trim().isEmpty) return;
    
    final message = ChatMessage(
      text: text,
      user: ChatUser(id: 'user', name: _currentUserName),
      createdAt: DateTime.now(),
    );
    
    await contextAwareChat.sendMessage(
      message,
      onAiResponse: _handleAiResponse,
    );
  }
  
  Widget _buildAiInputSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'AI-Enhanced Text Input (CopilotTextarea)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: CopilotTextarea(
                  controller: _taskController,
                  placeholder: 'Type a new task... (AI will suggest improvements)',
                  aiInstructions: 'Help improve this task description to be more specific and actionable',
                  minLines: 1,
                  maxLines: 3,
                  onAiComplete: (text, instructions) async {
                    await Future.delayed(const Duration(milliseconds: 600));
                    return 'Complete this task: $text by tomorrow at 2 PM with high priority';
                  },
                  onAiSuggest: (text, instructions) async {
                    await Future.delayed(const Duration(milliseconds: 400));
                    if (text.toLowerCase().contains('clean')) {
                      return ['Clean the house thoroughly', 'Clean the kitchen and bathroom', 'Clean and organize the garage'];
                    } else if (text.toLowerCase().contains('call')) {
                      return ['Call and schedule appointment', 'Call to confirm details', 'Call during business hours'];  
                    }
                    return ['$text with specific deadline', '$text and set reminder', '$text with priority level'];
                  },
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () {
                  if (_taskController.text.isNotEmpty) {
                    setState(() {
                      _tasks.add(_taskController.text);
                      _taskController.clear();
                    });
                    _updateContextFromAppState();
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          CopilotTextarea(
            controller: _noteController,
            placeholder: 'Write a note... (AI will enhance your writing)',
            aiInstructions: 'Help improve the clarity and professionalism of this note',
            minLines: 2,
            maxLines: 4,
            onAiComplete: (text, instructions) async {
              await Future.delayed(const Duration(milliseconds: 700));
              return 'Enhanced note: $text\n\nThis note has been improved for clarity and includes relevant action items based on your current context.';
            },
          ),
          
          const SizedBox(height: 8),
          Text(
            '💡 Use Ctrl+Space (or Cmd+Space) for AI completion, Tab to accept suggestions',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _taskController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}