import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MenuTab extends StatefulWidget {
  const MenuTab({super.key});

  @override
  State<MenuTab> createState() => _MenuTabState();
}

class _MenuTabState extends State<MenuTab> {
  bool _isExpanded = false;
  String _selectedMode = 'None';

  void _toggleMenu() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (!_isExpanded) _selectedMode = 'None';
    });
  }

  Widget _buildCleaningUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Data Cleaning', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ActionChip(label: const Text('fillna'), onPressed: () {}),
            ActionChip(label: const Text('dropna'), onPressed: () {}),
            ActionChip(label: const Text('Delete Column/Row'), onPressed: () {}),
            ActionChip(label: const Text('Fill w/ Most Occurring'), onPressed: () {}),
            ActionChip(label: const Text('Remove Duplicates'), onPressed: () {}),
          ],
        ),
      ],
    ).animate().fadeIn().slideY();
  }

  Widget _buildMLUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Machine Learning Analysis', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        const Text('Select Models (Multiple Selection):'),
        CheckboxListTile(value: true, onChanged: (v) {}, title: const Text('Linear Regression')),
        CheckboxListTile(value: false, onChanged: (v) {}, title: const Text('Random Forest')),
        CheckboxListTile(value: true, onChanged: (v) {}, title: const Text('K-Means Clustering')),
        const SizedBox(height: 10),
        const Text('Integrations:'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.code), label: const Text('Python Script')),
            ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.data_object), label: const Text('R Script')),
          ],
        )
      ],
    ).animate().fadeIn().slideY();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Menu'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background content changes based on selection
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (_selectedMode == 'None')
                    Center(
                      child: const Text('Tap the central node to expand options')
                          .animate(onPlay: (controller) => controller.repeat())
                          .fade(duration: 1.seconds)
                          .then()
                          .fade(duration: 1.seconds, begin: 1.0, end: 0.3),
                    ),
                  if (_selectedMode == 'Cleaning') _buildCleaningUI(),
                  if (_selectedMode == 'ML') _buildMLUI(),
                ],
              ),
            ),
          ),

          // Central Circular Animated Node
          Align(
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Top Node (Cleaning)
                if (_isExpanded)
                  Transform.translate(
                    offset: const Offset(0, -100),
                    child: FloatingActionButton(
                      heroTag: 'cleaning',
                      backgroundColor: Colors.teal,
                      onPressed: () => setState(() => _selectedMode = 'Cleaning'),
                      child: const Icon(Icons.cleaning_services),
                    ).animate().scale().fade(),
                  ),
                // Left Node (ML)
                if (_isExpanded)
                  Transform.translate(
                    offset: const Offset(-100, 0),
                    child: FloatingActionButton(
                      heroTag: 'ml',
                      backgroundColor: Colors.deepPurple,
                      onPressed: () => setState(() => _selectedMode = 'ML'),
                      child: const Icon(Icons.model_training),
                    ).animate().scale().fade(),
                  ),
                // Right Node (Reports)
                if (_isExpanded)
                  Transform.translate(
                    offset: const Offset(100, 0),
                    child: FloatingActionButton(
                      heroTag: 'reports',
                      backgroundColor: Colors.orange,
                      onPressed: () => setState(() => _selectedMode = 'Reports'),
                      child: const Icon(Icons.picture_as_pdf),
                    ).animate().scale().fade(),
                  ),

                // Center Node
                GestureDetector(
                  onTap: _toggleMenu,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _isExpanded ? 60 : 80,
                    height: _isExpanded ? 60 : 80,
                    decoration: BoxDecoration(
                      color: _isExpanded ? Colors.grey : Colors.blueAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        if (!_isExpanded)
                          BoxShadow(color: Colors.blueAccent.withOpacity(0.5), blurRadius: 20, spreadRadius: 5)
                      ],
                    ),
                    child: Icon(
                      _isExpanded ? Icons.close : Icons.hub,
                      color: Colors.white,
                      size: _isExpanded ? 30 : 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
