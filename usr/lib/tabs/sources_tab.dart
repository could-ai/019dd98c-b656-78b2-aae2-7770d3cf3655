import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SourcesTab extends StatefulWidget {
  const SourcesTab({super.key});

  @override
  State<SourcesTab> createState() => _SourcesTabState();
}

class _SourcesTabState extends State<SourcesTab> {
  final List<Map<String, dynamic>> _sources = [
    {'name': 'Sales_Q1_2026.csv', 'type': 'CSV', 'status': 'Connected', 'rows': '15.2K'},
    {'name': 'UserAnalytics_Prod', 'type': 'PostgreSQL', 'status': 'Live', 'rows': '2.1M'},
    {'name': 'Marketing_Campaigns.json', 'type': 'JSON', 'status': 'Connected', 'rows': '450'},
    {'name': 'CRM_API', 'type': 'REST', 'status': 'Live', 'rows': 'N/A'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Sources & Workbook'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Active Connections', style: Theme.of(context).textTheme.titleLarge),
                ElevatedButton.icon(
                  onPressed: () {
                    _showAddSourceDialog(context);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Source'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ).animate().fade().slideY(),
            const SizedBox(height: 16),
            ..._sources.map((source) => _buildSourceCard(source)).toList(),
            const SizedBox(height: 32),
            Text('Workbook & Sheets', style: Theme.of(context).textTheme.titleLarge).animate().fade(delay: 300.ms),
            const SizedBox(height: 16),
            _buildWorkbookSection(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceCard(Map<String, dynamic> source) {
    IconData icon;
    Color color;
    switch (source['type']) {
      case 'CSV':
        icon = Icons.grid_on;
        color = Colors.green;
        break;
      case 'PostgreSQL':
      case 'SQL':
        icon = Icons.storage;
        color = Colors.blue;
        break;
      case 'JSON':
        icon = Icons.data_object;
        color = Colors.orange;
        break;
      case 'REST':
        icon = Icons.api;
        color = Colors.purple;
        break;
      default:
        icon = Icons.insert_drive_file;
        color = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Theme.of(context).cardColor.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(source['name']),
        subtitle: Text('${source['type']} • ${source['rows']} rows'),
        trailing: Chip(
          label: Text(source['status'], style: const TextStyle(fontSize: 12)),
          backgroundColor: source['status'] == 'Live' ? Colors.green.withOpacity(0.2) : Colors.blue.withOpacity(0.2),
          side: BorderSide.none,
        ),
      ),
    ).animate().fade().slideX();
  }

  Widget _buildWorkbookSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.book, color: Colors.blueAccent),
              const SizedBox(width: 8),
              Text('Default Analysis Workbook', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSheetChip('Raw Data', true),
              _buildSheetChip('Cleaned Dataset', false),
              _buildSheetChip('Aggregated Metrics', false),
              _buildSheetChip('Predictions', false),
              ActionChip(
                avatar: const Icon(Icons.add, size: 16),
                label: const Text('New Sheet'),
                onPressed: () {},
                backgroundColor: Colors.transparent,
                side: const BorderSide(color: Colors.blueAccent),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.cleaning_services, size: 18),
                label: const Text('Clean Data'),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.merge_type, size: 18),
                label: const Text('Merge Sheets'),
              ),
            ],
          )
        ],
      ),
    ).animate().fade(delay: 400.ms).slideY();
  }

  Widget _buildSheetChip(String label, bool isSelected) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {},
      selectedColor: Colors.blueAccent.withOpacity(0.3),
      backgroundColor: Colors.grey.withOpacity(0.1),
    );
  }

  void _showAddSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connect New Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('Upload File'),
              subtitle: const Text('CSV, JSON, Excel'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text('Database'),
              subtitle: const Text('PostgreSQL, MySQL, MongoDB'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.api),
              title: const Text('REST API'),
              subtitle: const Text('Connect to external services'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
