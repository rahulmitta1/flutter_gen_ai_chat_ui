import 'package:flutter/material.dart';

enum VoiceSendMode { pushToTalk, toggle }
enum VoiceState { idle, listening, detecting, recording, sending, error, disabled }

class VoiceSendButton extends StatelessWidget {
  final VoiceSendMode mode;
  final VoiceState state;
  final VoidCallback? onHoldStart;
  final VoidCallback? onHoldEnd;
  final ValueChanged<bool>? onToggle;
  final String? semanticsLabel;

  const VoiceSendButton({
    super.key,
    required this.mode,
    required this.state,
    this.onHoldStart,
    this.onHoldEnd,
    this.onToggle,
    this.semanticsLabel,
  });

  bool get _isDisabled => state == VoiceState.disabled;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final icon = _iconFor(state);

    final button = Semantics(
      button: true,
      enabled: !_isDisabled,
      label: semanticsLabel ?? 'Voice button: ${_stateLabel(state)}',
      child: _buildGestureWrapper(
        context,
        Container(
          decoration: BoxDecoration(
            color:
                _isDisabled ? color.surfaceContainerHighest : color.primaryContainer,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(12),
          child: Icon(icon,
              color:
                  _isDisabled ? color.onSurfaceVariant : color.onPrimaryContainer),
        ),
      ),
    );

    return button;
  }

  Widget _buildGestureWrapper(BuildContext context, Widget child) {
    if (_isDisabled) return child;
    switch (mode) {
      case VoiceSendMode.pushToTalk:
        return GestureDetector(
          onTapDown: (_) => onHoldStart?.call(),
          onTapCancel: () => onHoldEnd?.call(),
          onTapUp: (_) => onHoldEnd?.call(),
          child: child,
        );
      case VoiceSendMode.toggle:
        return InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: () => onToggle?.call(state != VoiceState.listening && state != VoiceState.recording),
          child: child,
        );
    }
  }

  IconData _iconFor(VoiceState s) {
    switch (s) {
      case VoiceState.idle:
        return Icons.mic_none;
      case VoiceState.listening:
        return Icons.hearing;
      case VoiceState.detecting:
        return Icons.graphic_eq;
      case VoiceState.recording:
        return Icons.mic;
      case VoiceState.sending:
        return Icons.cloud_upload_outlined;
      case VoiceState.error:
        return Icons.error_outline;
      case VoiceState.disabled:
        return Icons.mic_off;
    }
  }

  String _stateLabel(VoiceState s) {
    switch (s) {
      case VoiceState.idle:
        return 'idle';
      case VoiceState.listening:
        return 'listening';
      case VoiceState.detecting:
        return 'detecting';
      case VoiceState.recording:
        return 'recording';
      case VoiceState.sending:
        return 'sending';
      case VoiceState.error:
        return 'error';
      case VoiceState.disabled:
        return 'disabled';
    }
  }
}


