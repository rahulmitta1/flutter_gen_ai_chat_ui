import 'package:flutter/material.dart';

import '../controllers/action_controller.dart';
import '../controllers/ai_context_controller.dart';
import '../models/ai_action.dart';
import '../models/ai_context.dart';
import 'ai_context_provider.dart';

/// Configuration for the AiActionProvider
class AiActionConfig {
  /// List of actions to register
  final List<AiAction> actions;
  
  /// Custom confirmation dialog builder
  final Future<bool> Function(BuildContext context, AiAction action, Map<String, dynamic> parameters)? confirmationBuilder;
  
  /// Whether to show debug information
  final bool debug;

  const AiActionConfig({
    this.actions = const [],
    this.confirmationBuilder,
    this.debug = false,
  });
}

/// Inherited widget that provides AiAction functionality to the widget tree
class AiActionProvider extends StatefulWidget {
  /// Configuration for the provider
  final AiActionConfig config;
  
  /// Child widget
  final Widget child;
  
  /// Optional external action controller
  final ActionController? controller;

  const AiActionProvider({
    super.key,
    required this.config,
    required this.child,
    this.controller,
  });

  @override
  State<AiActionProvider> createState() => _AiActionProviderState();

  /// Get the ActionController from the current context
  static ActionController of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<_AiActionInheritedWidget>();
    if (provider == null) {
      throw FlutterError(
        'AiActionProvider.of() called with a context that does not contain a AiActionProvider.\n'
        'No AiActionProvider ancestor could be found starting from the context that was passed to AiActionProvider.of().',
      );
    }
    return provider.controller;
  }

  /// Get the ActionController from the current context, or null if not found
  static ActionController? maybeOf(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<_AiActionInheritedWidget>();
    return provider?.controller;
  }
}

class _AiActionProviderState extends State<AiActionProvider> {
  late ActionController _controller;
  bool _isExternalController = false;

  @override
  void initState() {
    super.initState();
    
    // Use external controller or create new one
    if (widget.controller != null) {
      _controller = widget.controller!;
      _isExternalController = true;
    } else {
      _controller = ActionController();
      _isExternalController = false;
    }

    // Set up confirmation handler if provided
    if (widget.config.confirmationBuilder != null) {
      _controller.onConfirmationRequired = widget.config.confirmationBuilder;
    } else {
      _controller.onConfirmationRequired = _defaultConfirmationHandler;
    }

    // Register initial actions
    _registerActions();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Try to connect to context controller if available
    final contextController = AiContextProvider.maybeOf(context);
    if (contextController != null) {
      _controller.contextController = contextController;
    }
  }

  void _registerActions() {
    for (final action in widget.config.actions) {
      _controller.registerAction(action);
    }
  }

  @override
  void didUpdateWidget(AiActionProvider oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Update confirmation handler
    if (widget.config.confirmationBuilder != null) {
      _controller.onConfirmationRequired = widget.config.confirmationBuilder;
    } else {
      _controller.onConfirmationRequired = _defaultConfirmationHandler;
    }
    
    // Handle action changes
    if (widget.config.actions != oldWidget.config.actions) {
      // Unregister old actions that are no longer present
      for (final oldAction in oldWidget.config.actions) {
        if (!widget.config.actions.any((a) => a.name == oldAction.name)) {
          _controller.unregisterAction(oldAction.name);
        }
      }
      
      // Register new actions
      for (final newAction in widget.config.actions) {
        if (!oldWidget.config.actions.any((a) => a.name == newAction.name)) {
          _controller.registerAction(newAction);
        }
      }
    }
  }

  /// Default confirmation dialog implementation
  Future<bool> _defaultConfirmationHandler(
    BuildContext context,
    AiAction action,
    Map<String, dynamic> parameters,
  ) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final config = action.confirmationConfig!;
        
        // Use custom builder if provided
        if (config.builder != null) {
          return Dialog(
            child: config.builder!(context, parameters),
          );
        }

        // Default confirmation dialog
        return AlertDialog(
          title: Text(config.title ?? 'Confirm Action'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(config.message ?? 'Do you want to execute "${action.name}"?'),
              const SizedBox(height: 16),
              if (parameters.isNotEmpty) ...[
                const Text(
                  'Parameters:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    parameters.entries
                        .map((e) => '${e.key}: ${e.value}')
                        .join('\n'),
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(config.cancelText),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(config.confirmText),
            ),
          ],
        );
      },
    ) ?? false;
  }

  @override
  void dispose() {
    // Only dispose if we created the controller
    if (!_isExternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AiActionInheritedWidget(
      controller: _controller,
      config: widget.config,
      child: widget.child,
    );
  }
}

/// Inherited widget that exposes the ActionController
class _AiActionInheritedWidget extends InheritedWidget {
  final ActionController controller;
  final AiActionConfig config;

  const _AiActionInheritedWidget({
    required this.controller,
    required this.config,
    required super.child,
  });

  @override
  bool updateShouldNotify(_AiActionInheritedWidget oldWidget) {
    return controller != oldWidget.controller || config != oldWidget.config;
  }
}

/// Hook-like function to access AiActions in a widget
/// Hook-like pattern for accessing AI actions in a widget
class AiActionHook {
  final BuildContext _context;
  final ActionController _controller;

  AiActionHook._(this._context, this._controller);

  /// Factory constructor to create from context
  factory AiActionHook.of(BuildContext context) {
    final controller = AiActionProvider.of(context);
    return AiActionHook._(context, controller);
  }

  /// Register a new action (similar to useAiAction)
  void registerAction(AiAction action) {
    _controller.registerAction(action);
  }

  /// Execute an action by name
  Future<ActionResult> executeAction(
    String actionName,
    Map<String, dynamic> parameters,
  ) {
    return _controller.executeAction(actionName, parameters, context: _context);
  }

  /// Get all registered actions
  Map<String, AiAction> get actions => _controller.actions;

  /// Get current executions
  Map<String, ActionExecution> get executions => _controller.executions;

  /// Stream of action events
  Stream<ActionEvent> get events => _controller.events;

  /// Get actions formatted for AI function calling
  List<Map<String, dynamic>> getActionsForFunctionCalling() {
    return _controller.getActionsForFunctionCalling();
  }

  /// Get actions with current context for enhanced AI prompts
  Map<String, dynamic> getActionsWithContext({
    List<AiContextType>? contextTypes,
    List<AiContextPriority>? contextPriorities,
    List<String>? contextCategories,
  }) {
    return _controller.getActionsWithContext(
      contextTypes: contextTypes,
      contextPriorities: contextPriorities,
      contextCategories: contextCategories,
    );
  }

  /// Handle function call from AI with context awareness
  Future<ActionResult> handleFunctionCall(
    String functionName,
    Map<String, dynamic> arguments, {
    bool includeContext = true,
  }) {
    return _controller.handleFunctionCall(
      functionName,
      arguments,
      context: _context,
      includeContext: includeContext,
    );
  }

  /// Get enhanced prompt with context for AI interactions
  String getEnhancedPrompt(
    String basePrompt, {
    List<AiContextType>? contextTypes,
    List<AiContextPriority>? contextPriorities,
    List<String>? contextCategories,
    bool includeActions = true,
  }) {
    return _controller.getEnhancedPrompt(
      basePrompt,
      contextTypes: contextTypes,
      contextPriorities: contextPriorities,
      contextCategories: contextCategories,
      includeActions: includeActions,
    );
  }

  /// Get context controller if available
  AiContextController? get contextController => _controller.contextController;
}

/// Widget builder that provides access to AiActionHook
class AiActionBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, AiActionHook hook) builder;

  const AiActionBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final hook = AiActionHook.of(context);
    return builder(context, hook);
  }
}