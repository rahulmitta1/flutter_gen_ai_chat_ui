import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/ai_agent.dart';

/// Multi-agent orchestration system similar to CopilotKit's CoAgents framework
/// Manages agent coordination, routing, and collaborative problem-solving
class AgentOrchestrator extends ChangeNotifier {
  final Map<String, AIAgent> _agents = {};
  final Map<String, AgentCollaboration> _activeCollaborations = {};
  final StreamController<AgentResponse> _responseStreamController = StreamController<AgentResponse>.broadcast();
  final StreamController<AgentState> _stateStreamController = StreamController<AgentState>.broadcast();
  
  // Orchestrator configuration
  final int maxConcurrentRequests;
  final Duration requestTimeout;
  final bool enableCollaboration;
  
  AgentOrchestrator({
    this.maxConcurrentRequests = 10,
    this.requestTimeout = const Duration(seconds: 30),
    this.enableCollaboration = true,
  });

  // Getters
  List<AIAgent> get agents => _agents.values.toList();
  List<AgentCollaboration> get activeCollaborations => _activeCollaborations.values.toList();
  Stream<AgentResponse> get responseStream => _responseStreamController.stream;
  Stream<AgentState> get stateStream => _stateStreamController.stream;

  /// Register an agent with the orchestrator
  Future<void> registerAgent(AIAgent agent) async {
    _agents[agent.id] = agent;
    
    // Listen to agent state changes
    agent.streamState().listen((state) {
      _stateStreamController.add(state);
    });
    
    // Initialize agent
    await agent.initialize({
      'orchestrator_id': 'main',
      'collaboration_enabled': enableCollaboration,
    });
    
    notifyListeners();
  }

  /// Unregister an agent
  Future<void> unregisterAgent(String agentId) async {
    final agent = _agents[agentId];
    if (agent != null) {
      await agent.dispose();
      _agents.remove(agentId);
      notifyListeners();
    }
  }

  /// Process a request through intelligent agent routing
  Future<AgentResponse> processRequest(AgentRequest request) async {
    // Find the best agent for this request
    final routingDecision = await _routeRequest(request);
    final targetAgent = _agents[routingDecision.targetAgentId];
    
    if (targetAgent == null) {
      throw AgentException('Target agent ${routingDecision.targetAgentId} not found');
    }

    try {
      final response = await targetAgent.processRequest(request);
      _responseStreamController.add(response);
      
      // Handle delegation if needed
      if (response.type == AgentResponseType.delegation) {
        return await _handleDelegation(request, response);
      }
      
      // Handle collaboration requests
      if (response.type == AgentResponseType.collaborationRequest) {
        return await _handleCollaborationRequest(request, response);
      }
      
      return response;
    } catch (e) {
      final errorResponse = AgentResponse(
        id: 'error_${DateTime.now().millisecondsSinceEpoch}',
        requestId: request.id,
        agentId: targetAgent.id,
        content: 'Error processing request: $e',
        type: AgentResponseType.error,
        timestamp: DateTime.now(),
      );
      
      _responseStreamController.add(errorResponse);
      return errorResponse;
    }
  }

  /// Stream responses for real-time processing
  Stream<AgentResponse> streamResponse(AgentRequest request) async* {
    final routingDecision = await _routeRequest(request);
    final targetAgent = _agents[routingDecision.targetAgentId];
    
    if (targetAgent == null) {
      yield AgentResponse(
        id: 'error_${DateTime.now().millisecondsSinceEpoch}',
        requestId: request.id,
        agentId: 'orchestrator',
        content: 'Target agent ${routingDecision.targetAgentId} not found',
        type: AgentResponseType.error,
        timestamp: DateTime.now(),
      );
      return;
    }

    try {
      // For now, simulate streaming by yielding partial responses
      yield AgentResponse(
        id: 'partial_${DateTime.now().millisecondsSinceEpoch}',
        requestId: request.id,
        agentId: targetAgent.id,
        content: 'Processing request with ${targetAgent.name}...',
        type: AgentResponseType.partial,
        timestamp: DateTime.now(),
      );

      final finalResponse = await targetAgent.processRequest(request);
      _responseStreamController.add(finalResponse);
      yield finalResponse;
    } catch (e) {
      yield AgentResponse(
        id: 'error_${DateTime.now().millisecondsSinceEpoch}',
        requestId: request.id,
        agentId: targetAgent.id,
        content: 'Error processing request: $e',
        type: AgentResponseType.error,
        timestamp: DateTime.now(),
      );
    }
  }

  /// Start a collaboration between multiple agents
  Future<AgentCollaboration> startCollaboration({
    required List<String> participantAgentIds,
    required String coordinatorAgentId,
    required String topic,
  }) async {
    if (!enableCollaboration) {
      throw UnsupportedError('Collaboration is disabled');
    }

    final collaboration = AgentCollaboration(
      id: 'collab_${DateTime.now().millisecondsSinceEpoch}',
      participantAgentIds: participantAgentIds,
      coordinatorAgentId: coordinatorAgentId,
      topic: topic,
      startedAt: DateTime.now(),
    );

    _activeCollaborations[collaboration.id] = collaboration;
    notifyListeners();

    return collaboration;
  }

  /// Get agent by ID
  AIAgent? getAgent(String agentId) => _agents[agentId];

  /// Get agents by capability
  List<AIAgent> getAgentsByCapability(String capability) {
    return _agents.values
        .where((agent) => agent.capabilities.contains(capability))
        .toList();
  }

  /// Get available agents (not busy)
  List<AIAgent> getAvailableAgents() {
    return _agents.values
        .where((agent) => agent.status == AgentStatus.idle)
        .toList();
  }

  // Private methods

  /// Route a request to the most appropriate agent
  Future<RoutingDecision> _routeRequest(AgentRequest request) async {
    if (_agents.isEmpty) {
      throw AgentException('No agents available');
    }

    // Simple routing algorithm - can be enhanced with ML models
    double bestScore = 0.0;
    String? bestAgentId;
    String reasoning = 'Default routing';

    for (final agent in _agents.values) {
      if (!agent.canHandle(request)) continue;

      double score = _calculateRoutingScore(agent, request);
      if (score > bestScore) {
        bestScore = score;
        bestAgentId = agent.id;
        reasoning = 'Best match: ${agent.specialization} (score: ${score.toStringAsFixed(2)})';
      }
    }

    if (bestAgentId == null) {
      // Fallback to first available agent
      final availableAgents = getAvailableAgents();
      if (availableAgents.isNotEmpty) {
        bestAgentId = availableAgents.first.id;
        reasoning = 'Fallback to available agent';
      } else {
        throw AgentException('No suitable agent found for request');
      }
    }

    return RoutingDecision(
      targetAgentId: bestAgentId,
      confidence: bestScore,
      reasoning: reasoning,
    );
  }

  /// Calculate routing score for an agent
  double _calculateRoutingScore(AIAgent agent, AgentRequest request) {
    double score = 0.0;

    // Check if agent can handle the request
    if (!agent.canHandle(request)) return 0.0;

    // Capability match score
    final queryLower = request.query.toLowerCase();
    for (final capability in agent.capabilities) {
      if (queryLower.contains(capability.toLowerCase())) {
        score += 0.3;
      }
    }

    // Agent availability score
    switch (agent.status) {
      case AgentStatus.idle:
        score += 0.5;
        break;
      case AgentStatus.processing:
        score += 0.1;
        break;
      case AgentStatus.streaming:
        score += 0.2;
        break;
      default:
        score -= 0.2;
    }

    // Priority bonus
    switch (agent.priority) {
      case AgentPriority.high:
        score += 0.2;
        break;
      case AgentPriority.critical:
        score += 0.3;
        break;
      default:
        break;
    }

    // Random factor to prevent always selecting the same agent
    score += Random().nextDouble() * 0.1;

    return score;
  }

  /// Handle delegation to another agent
  Future<AgentResponse> _handleDelegation(AgentRequest originalRequest, AgentResponse delegationResponse) async {
    // Extract delegation information from response metadata
    final targetAgentId = delegationResponse.metadata['delegate_to'] as String?;
    final delegatedQuery = delegationResponse.metadata['delegated_query'] as String? ?? originalRequest.query;

    if (targetAgentId == null) {
      throw AgentException('Delegation target not specified');
    }

    final targetAgent = _agents[targetAgentId];
    if (targetAgent == null) {
      throw AgentException('Delegation target agent not found: $targetAgentId');
    }

    // Create delegated request
    final delegatedRequest = originalRequest.copyWith(
      id: 'delegated_${DateTime.now().millisecondsSinceEpoch}',
      query: delegatedQuery,
      type: AgentRequestType.delegation,
      parentRequestId: originalRequest.id,
    );

    return await targetAgent.processRequest(delegatedRequest);
  }

  /// Handle collaboration request
  Future<AgentResponse> _handleCollaborationRequest(AgentRequest originalRequest, AgentResponse collaborationResponse) async {
    final participantIds = collaborationResponse.metadata['participants'] as List<String>?;
    final coordinatorId = collaborationResponse.metadata['coordinator'] as String?;
    final topic = collaborationResponse.metadata['topic'] as String? ?? originalRequest.query;

    if (participantIds == null || coordinatorId == null) {
      throw AgentException('Collaboration parameters not specified');
    }

    final collaboration = await startCollaboration(
      participantAgentIds: participantIds,
      coordinatorAgentId: coordinatorId,
      topic: topic,
    );

    return AgentResponse(
      id: 'collab_response_${DateTime.now().millisecondsSinceEpoch}',
      requestId: originalRequest.id,
      agentId: 'orchestrator',
      content: 'Started collaboration ${collaboration.id} with ${participantIds.length} agents',
      type: AgentResponseType.finalAnswer,
      metadata: {'collaboration_id': collaboration.id},
      timestamp: DateTime.now(),
    );
  }

  @override
  void dispose() {
    _responseStreamController.close();
    _stateStreamController.close();
    
    // Dispose all agents
    for (final agent in _agents.values) {
      agent.dispose();
    }
    _agents.clear();
    
    super.dispose();
  }
}

/// Exception thrown by the agent system
class AgentException implements Exception {
  final String message;
  const AgentException(this.message);
  
  @override
  String toString() => 'AgentException: $message';
}