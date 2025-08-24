import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

class UiGalleryScreen extends StatefulWidget {
  const UiGalleryScreen({super.key});
  @override
  State<UiGalleryScreen> createState() => _UiGalleryScreenState();
}

class _UiGalleryScreenState extends State<UiGalleryScreen> {
  String _ghost = ' with AI';
  final _controller = TextEditingController(text: 'Chat');
  String _selectedSuggestion = '';
  DuplexState _duplex = DuplexState.idle;
  int _latency = 120;
  double _packetLoss = 0.02;
  String _transcript = 'Listening…';
  bool _isFinal = false;
  String _resultKind = 'card';

  @override
  Widget build(BuildContext context) {
    final registry = ResultRendererRegistry(
      builders: {
        'card': (ctx, data) => ResultCard.fromData(data),
        'kv': (ctx, data) =>
            const KeyValueList(items: {'Status': 'OK', 'Count': '42'}),
        'table': (ctx, data) => const DataTableLite(
          columns: ['Name', 'Age'],
          rows: [
            ['Alice', '30'],
            ['Bob', '25'],
          ],
        ),
        'callout': (ctx, data) =>
            const Callout(title: 'Heads up', message: 'Demo callout message'),
      },
      child: const SizedBox.shrink(),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('UI Gallery')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Suggestions + Autocomplete
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Suggestions & Autocomplete',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  AiSuggestionsBar(
                    suggestions: const ['Summarize', 'Explain', 'Create tests'],
                    onSelect: (s) => setState(() => _selectedSuggestion = s),
                  ),
                  const SizedBox(height: 8),
                  InlineAutocompleteTextField(
                    controller: _controller,
                    ghostText: _ghost,
                    onChanged: (_) => setState(() {}),
                  ),
                  if (_selectedSuggestion.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text('Selected: $_selectedSuggestion'),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Result rendering
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Result Rendering',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('Card'),
                        selected: _resultKind == 'card',
                        onSelected: (_) => setState(() => _resultKind = 'card'),
                      ),
                      ChoiceChip(
                        label: const Text('Key/Value'),
                        selected: _resultKind == 'kv',
                        onSelected: (_) => setState(() => _resultKind = 'kv'),
                      ),
                      ChoiceChip(
                        label: const Text('Table'),
                        selected: _resultKind == 'table',
                        onSelected: (_) =>
                            setState(() => _resultKind = 'table'),
                      ),
                      ChoiceChip(
                        label: const Text('Callout'),
                        selected: _resultKind == 'callout',
                        onSelected: (_) =>
                            setState(() => _resultKind = 'callout'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Builder(
                    builder: (context) {
                      final built = registry.buildResult(context, _resultKind, {
                        'title': 'Analysis',
                        'subtitle': 'Quick summary',
                        'body': 'Everything looks good.',
                      });
                      return built ?? const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Voice UI
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Voice UI',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      VoiceSendButton(
                        mode: VoiceSendMode.pushToTalk,
                        state: VoiceState.idle,
                        onHoldStart: () =>
                            setState(() => _transcript = 'Recording…'),
                        onHoldEnd: () => setState(() => _transcript = 'Done'),
                      ),
                      const SizedBox(width: 12),
                      VoiceSendButton(
                        mode: VoiceSendMode.toggle,
                        state: VoiceState.listening,
                        onToggle: (v) => setState(
                          () => _duplex = v
                              ? DuplexState.listening
                              : DuplexState.idle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  VoiceStatusBar(
                    duplexState: _duplex,
                    latencyMs: _latency,
                    packetLoss: _packetLoss,
                    onInterrupt: () =>
                        setState(() => _duplex = DuplexState.idle),
                    onReconnect: () =>
                        setState(() => _duplex = DuplexState.connecting),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Latency'),
                            Slider(
                              value: _latency.toDouble(),
                              min: 20,
                              max: 400,
                              onChanged: (v) =>
                                  setState(() => _latency = v.round()),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Packet loss'),
                            Slider(
                              value: _packetLoss,
                              min: 0,
                              max: 0.2,
                              onChanged: (v) => setState(() => _packetLoss = v),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TranscriptChip(
                    text: _transcript,
                    isFinal: _isFinal,
                    onPromote: !_isFinal
                        ? () => setState(() => _isFinal = true)
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
