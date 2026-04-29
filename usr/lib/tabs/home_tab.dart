import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ).animate().fade().slideY(begin: 0.5, end: 0, duration: 500.ms),
              const SizedBox(height: 20),
              // Simulated summary cards
              Row(
                children: [
                  Expanded(child: _buildSummaryCard(context, 'Total Datasets', '12', Icons.data_usage, Colors.blue)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildSummaryCard(context, 'Models Trained', '5', Icons.model_training, Colors.purple)),
                ],
              ).animate().fade(delay: 200.ms).slideY(begin: 0.5, end: 0, duration: 500.ms),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildSummaryCard(context, 'Visualizations', '24', Icons.insert_chart, Colors.orange)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildSummaryCard(context, 'Alerts', '2', Icons.warning, Colors.red)),
                ],
              ).animate().fade(delay: 400.ms).slideY(begin: 0.5, end: 0, duration: 500.ms),
              const SizedBox(height: 30),
              Text(
                'Recent Activity',
                style: Theme.of(context).textTheme.titleLarge,
              ).animate().fade(delay: 600.ms),
              const SizedBox(height: 10),
              ...List.generate(5, (index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: Theme.of(context).cardColor.withOpacity(0.5),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.history, color: Colors.white),
                    ),
                    title: Text('Report generated - ${DateTime.now().subtract(Duration(days: index)).toString().substring(0, 10)}'),
                    subtitle: const Text('K-Means clustering on sales data'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ).animate().fade(delay: Duration(milliseconds: 800 + (index * 100))).slideX();
              }),
              const SizedBox(height: 80), // padding for bottom nav
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 30, color: color),
          const SizedBox(height: 10),
          Text(count, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
