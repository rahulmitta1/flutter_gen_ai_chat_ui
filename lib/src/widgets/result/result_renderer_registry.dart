import 'package:flutter/material.dart';

typedef ResultBuilder = Widget Function(
    BuildContext context, Map<String, dynamic> data);

/// UI-only registry mapping a string `kind` to a result widget builder.
class ResultRendererRegistry extends InheritedWidget {
  final Map<String, ResultBuilder> builders;

  const ResultRendererRegistry({
    super.key,
    required super.child,
    this.builders = const {},
  });

  static ResultRendererRegistry of(BuildContext context) {
    final registry =
        context.dependOnInheritedWidgetOfExactType<ResultRendererRegistry>();
    assert(registry != null, 'ResultRendererRegistry not found in context');
    return registry!;
  }

  static ResultRendererRegistry? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ResultRendererRegistry>();
  }

  /// Returns a widget for the given kind, or null if not registered.
  Widget? buildResult(
      BuildContext context, String kind, Map<String, dynamic> data) {
    final builder = builders[kind];
    if (builder == null) return null;
    return builder(context, data);
  }

  /// Returns a new registry with additional/overridden builders.
  ResultRendererRegistry extend(Map<String, ResultBuilder> additions) {
    return ResultRendererRegistry(
      builders: {...builders, ...additions},
      child: child,
    );
  }

  @override
  bool updateShouldNotify(covariant ResultRendererRegistry oldWidget) {
    // Rebuild dependents when builder map identity changes
    return !identical(oldWidget.builders, builders);
  }
}
