import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

void main() {
  group('ActionController Tests', () {
    late ActionController controller;

    setUp(() {
      controller = ActionController();
    });

    tearDown(() {
      controller.dispose();
    });

    group('Action Registration', () {
      test('should register action successfully', () {
        final action = _createTestAction();
        
        controller.registerAction(action);
        
        expect(controller.actions, containsPair('test_action', action));
      });

      test('should unregister action successfully', () {
        final action = _createTestAction();
        controller.registerAction(action);
        
        final result = controller.unregisterAction('test_action');
        
        expect(result, isTrue);
        expect(controller.actions, isNot(contains('test_action')));
      });

      test('should return false when unregistering non-existent action', () {
        final result = controller.unregisterAction('non_existent');
        
        expect(result, isFalse);
      });

      test('should clear all actions', () {
        controller.registerAction(_createTestAction());
        controller.registerAction(_createTestAction(name: 'action2'));
        
        controller.clearActions();
        
        expect(controller.actions, isEmpty);
      });
    });

    group('Action Execution', () {
      test('should execute action successfully', () async {
        final action = _createTestAction();
        controller.registerAction(action);
        
        final result = await controller.executeAction('test_action', {'param': 'value'});
        
        expect(result.success, isTrue);
        expect(result.data, equals({'result': 'success', 'param': 'value'}));
      });

      test('should handle action execution failure', () async {
        final action = _createFailingAction();
        controller.registerAction(action);
        
        final result = await controller.executeAction('failing_action', {});
        
        expect(result.success, isFalse);
        expect(result.error, equals('Test error'));
      });

      test('should return error for non-existent action', () async {
        final result = await controller.executeAction('non_existent', {});
        
        expect(result.success, isFalse);
        expect(result.error, contains('Action not found'));
      });

      test('should validate required parameters', () async {
        final action = _createActionWithRequiredParams();
        controller.registerAction(action);
        
        final result = await controller.executeAction('param_action', {});
        
        expect(result.success, isFalse);
        expect(result.error, contains('required_param'));
      });

      test('should pass validation with all required parameters', () async {
        final action = _createActionWithRequiredParams();
        controller.registerAction(action);
        
        final result = await controller.executeAction('param_action', {
          'required_param': 'test_value'
        });
        
        expect(result.success, isTrue);
      });
    });

    group('Function Calling Format', () {
      test('should generate function calling format correctly', () {
        final action = _createTestAction();
        controller.registerAction(action);
        
        final functions = controller.getActionsForFunctionCalling();
        
        expect(functions, hasLength(1));
        expect(functions.first['name'], equals('test_action'));
        expect(functions.first['description'], equals('Test action'));
        expect(functions.first['parameters'], isA<Map>());
        expect(functions.first['parameters']['type'], equals('object'));
        expect(functions.first['parameters']['properties'], isA<Map>());
      });

      test('should handle function call correctly', () async {
        final action = _createTestAction();
        controller.registerAction(action);
        
        final result = await controller.handleFunctionCall(
          'test_action',
          {'param': 'value'}
        );
        
        expect(result.success, isTrue);
        expect(result.data, equals({'result': 'success', 'param': 'value'}));
      });
    });

    group('Event Streaming', () {
      test('should emit execution started event', () async {
        final action = _createTestAction();
        controller.registerAction(action);
        
        late ActionEvent receivedEvent;
        controller.events.listen((event) {
          receivedEvent = event;
        });
        
        await controller.executeAction('test_action', {});
        
        expect(receivedEvent.type, equals(ActionEventType.executionStarted));
        expect(receivedEvent.actionName, equals('test_action'));
      });

      test('should emit execution completed event', () async {
        final action = _createTestAction();
        controller.registerAction(action);
        
        ActionEvent? completedEvent;
        controller.events.listen((event) {
          if (event.type == ActionEventType.executionCompleted) {
            completedEvent = event;
          }
        });
        
        await controller.executeAction('test_action', {});
        
        expect(completedEvent, isNotNull);
        expect(completedEvent!.type, equals(ActionEventType.executionCompleted));
        expect(completedEvent!.result, isNotNull);
        expect(completedEvent!.result!.success, isTrue);
      });

      test('should emit execution failed event', () async {
        final action = _createFailingAction();
        controller.registerAction(action);
        
        ActionEvent? failedEvent;
        controller.events.listen((event) {
          if (event.type == ActionEventType.executionFailed) {
            failedEvent = event;
          }
        });
        
        await controller.executeAction('failing_action', {});
        
        expect(failedEvent, isNotNull);
        expect(failedEvent!.type, equals(ActionEventType.executionFailed));
        expect(failedEvent!.error, equals('Test error'));
      });
    });

    group('Context Integration', () {
      test('should integrate with context controller', () {
        final contextController = AiContextController();
        controller.contextController = contextController;
        
        expect(controller.contextController, equals(contextController));
        
        contextController.dispose();
      });

      test('should generate actions with context', () {
        final contextController = AiContextController();
        contextController.setContext(AiContextData.userProfile(
          id: 'test_user',
          name: 'Test User',
          profileData: {'role': 'admin'},
        ));
        
        controller.contextController = contextController;
        controller.registerAction(_createTestAction());
        
        final result = controller.getActionsWithContext();
        
        expect(result['actions'], isA<List>());
        expect(result['context'], isA<Map>());
        expect(result['context']['test_user'], isNotNull);
        
        contextController.dispose();
      });

      test('should enhance prompts with context', () {
        final contextController = AiContextController();
        contextController.setContext(AiContextData.userProfile(
          id: 'test_user',
          name: 'Test User',
          profileData: {'role': 'admin'},
        ));
        
        controller.contextController = contextController;
        
        final enhancedPrompt = controller.getEnhancedPrompt('Test prompt');
        
        expect(enhancedPrompt, contains('Test prompt'));
        expect(enhancedPrompt, contains('Context'));
        
        contextController.dispose();
      });
    });
  });
}

// Helper methods for creating test actions
AiAction _createTestAction({String name = 'test_action'}) {
  return AiAction(
    name: name,
    description: 'Test action',
    parameters: [
      ActionParameter.string(
        name: 'param',
        description: 'Test parameter',
        required: false,
      ),
    ],
    handler: (parameters) async {
      return ActionResult.createSuccess({
        'result': 'success',
        ...parameters,
      });
    },
  );
}

AiAction _createFailingAction() {
  return AiAction(
    name: 'failing_action',
    description: 'Action that fails',
    parameters: [],
    handler: (parameters) async {
      return ActionResult.createFailure('Test error');
    },
  );
}

AiAction _createActionWithRequiredParams() {
  return AiAction(
    name: 'param_action',
    description: 'Action with required parameters',
    parameters: [
      ActionParameter.string(
        name: 'required_param',
        description: 'Required parameter',
        required: true,
      ),
    ],
    handler: (parameters) async {
      return ActionResult.createSuccess({'executed': true});
    },
  );
}