import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

/// Code review specialist agent
class CodeReviewAgent extends AIAgent {
  CodeReviewAgent()
      : super(
          id: 'code_review_001',
          name: 'Code Review Specialist',
          specialization: 'Code quality analysis and review',
          capabilities: [
            'code_review',
            'bug_detection',
            'performance_analysis',
            'security_review',
            'best_practices',
          ],
          priority: AgentPriority.high,
        );

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    // Initialize agent
  }

  @override
  bool canHandle(AgentRequest request) {
    final query = request.query.toLowerCase();
    return query.contains('review') || 
           query.contains('code') || 
           query.contains('quality');
  }

  @override
  Future<AgentResponse> processRequest(AgentRequest request) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    return AgentResponse(
      id: 'code_review_${DateTime.now().millisecondsSinceEpoch}',
      requestId: request.id,
      agentId: id,
      content: 'Code review analysis completed. Found potential improvements in error handling and performance optimization.',
      type: AgentResponseType.finalAnswer,
      confidence: 0.9,
      timestamp: DateTime.now(),
    );
  }

  @override
  Stream<AgentState> streamState() => Stream.empty();

  @override
  AgentStatus get status => AgentStatus.idle;

  @override
  Future<void> dispose() async {}
}

/// Project planning specialist agent
class ProjectPlanningAgent extends AIAgent {
  ProjectPlanningAgent()
      : super(
          id: 'project_planning_001',
          name: 'Project Planning Specialist',
          specialization: 'Project management and planning',
          capabilities: [
            'project_planning',
            'task_breakdown',
            'timeline_estimation',
            'resource_allocation',
            'milestone_tracking',
          ],
          priority: AgentPriority.normal,
        );

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    // Initialize agent
  }

  @override
  bool canHandle(AgentRequest request) {
    final query = request.query.toLowerCase();
    return query.contains('project') || 
           query.contains('plan') || 
           query.contains('schedule') ||
           query.contains('milestone');
  }

  @override
  Future<AgentResponse> processRequest(AgentRequest request) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    return AgentResponse(
      id: 'project_planning_${DateTime.now().millisecondsSinceEpoch}',
      requestId: request.id,
      agentId: id,
      content: 'Project plan created with 5 phases, estimated completion in 3 months. Key milestones identified and resource allocation optimized.',
      type: AgentResponseType.finalAnswer,
      confidence: 0.85,
      timestamp: DateTime.now(),
    );
  }

  @override
  Stream<AgentState> streamState() => Stream.empty();

  @override
  AgentStatus get status => AgentStatus.idle;

  @override
  Future<void> dispose() async {}
}