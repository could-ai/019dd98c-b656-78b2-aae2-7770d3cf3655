import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class QueryTab extends StatefulWidget {
  const QueryTab({super.key});

  @override
  State<QueryTab> createState() => _QueryTabState();
}

class _QueryTabState extends State<QueryTab> {
  final TextEditingController _queryController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'isAi': true,
      'text': 'Hello! I am your AI Data Assistant. Ask me anything about your connected data sources. For example:\n"Show me total sales by region"\n"Are there any anomalies in Q1 revenue?"',
      'hasChart': false,
    }
  ];

  bool _isTyping = false;

  void _submitQuery() {
    if (_queryController.text.trim().isEmpty) return;

    final query = _queryController.text.trim();
    _queryController.clear();

    setState(() {
      _messages.add({
        'isAi': false,
        'text': query,
        'hasChart': false,
      });
      _isTyping = true;
    });

    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add({
            'isAi': true,
            'text': 'Based on the "Sales_Q1_2026.csv" dataset, here is the breakdown you requested. The data shows a 15% increase in the North region compared to the previous quarter.',
            'hasChart': true, // simulate a chart response
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Query Engine'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                final msg = _messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),
          _buildQueryInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    final isAi = msg['isAi'] as bool;
    return Align(
      alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
          color: isAi ? Theme.of(context).cardColor : Colors.blueAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomLeft: isAi ? const Radius.circular(0) : const Radius.circular(16),
            bottomRight: !isAi ? const Radius.circular(0) : const Radius.circular(16),
          ),
          border: isAi ? Border.all(color: Colors.white10) : Border.all(color: Colors.blueAccent.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(isAi ? Icons.auto_awesome : Icons.person, size: 16, color: isAi ? Colors.orangeAccent : Colors.blueAccent),
                const SizedBox(width: 8),
                Text(isAi ? 'AI Assistant' : 'You', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            Text(msg['text']),
            if (msg['hasChart'] == true) ...[
              const SizedBox(height: 12),
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bar_chart, size: 40, color: Colors.blueAccent),
                      SizedBox(height: 8),
                      Text('Interactive Chart Generated', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add_to_photos, size: 16),
                    label: const Text('Add to Dashboard'),
                  )
                ],
              )
            ]
          ],
        ),
      ),
    ).animate().fade().slideY(begin: 0.2, end: 0);
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16).copyWith(bottomLeft: const Radius.circular(0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome, size: 16, color: Colors.orangeAccent),
            const SizedBox(width: 8),
            const Text('Analyzing data').animate(onPlay: (controller) => controller.repeat()).shimmer(duration: 1.seconds),
          ],
        ),
      ),
    );
  }

  Widget _buildQueryInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0).copyWith(
        bottom: 80.0, // extra padding for bottom nav bar
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: const Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {
              // Show filter/sorting options
            },
            tooltip: 'Query Options',
          ),
          Expanded(
            child: TextField(
              controller: _queryController,
              decoration: InputDecoration(
                hintText: 'Ask a question about your data...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
              onSubmitted: (_) => _submitQuery(),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _submitQuery,
            ),
          )
        ],
      ),
    );
  }
}
