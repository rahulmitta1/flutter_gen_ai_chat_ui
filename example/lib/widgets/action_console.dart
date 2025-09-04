import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

/// Simple console that shows currently running and recently completed actions.
class ActionConsole extends StatelessWidget {
  const ActionConsole({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AiActionProvider.of(context);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final executions = controller.executions.values.toList()
          ..sort((a, b) => b.startTime.compareTo(a.startTime));
        final hasExecutions = executions.isNotEmpty;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.terminal, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Action Console',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    Tooltip(
                      message:
                          'Shows live action executions (auto-clears after a few seconds)',
                      child: Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (!hasExecutions)
                  Text(
                    'No actions running.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final e = executions[index];
                      return ActionResultWidget(executionId: e.id);
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemCount: executions.length,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
