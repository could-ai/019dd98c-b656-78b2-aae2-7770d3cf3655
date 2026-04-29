import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:carousel_slider/carousel_slider.dart';

class VisualizationTab extends StatefulWidget {
  const VisualizationTab({super.key});

  @override
  State<VisualizationTab> createState() => _VisualizationTabState();
}

class _VisualizationTabState extends State<VisualizationTab> {
  String _selectedSheet = 'Sheet 1';
  String _chartType = 'Bar Chart';
  Color _chartColor = Colors.blueAccent;
  double _chartSize = 1.0;
  bool _showLabels = true;
  String _detailLevel = 'High';

  final List<String> _sheets = ['Sheet 1', 'Sheet 2', 'Sheet 3'];
  final List<String> _chartTypes = ['Bar Chart', 'Line Chart', 'Pie Chart', '3D Plot Simulation'];

  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Chart Color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _chartColor,
            onColorChanged: (color) {
              setState(() {
                _chartColor = color;
              });
            },
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Done'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    Widget chart;
    switch (_chartType) {
      case 'Line Chart':
        chart = LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: const [FlSpot(0, 1), FlSpot(1, 3), FlSpot(2, 2), FlSpot(3, 5)],
                color: _chartColor,
                barWidth: 4 * _chartSize,
                isCurved: true,
                dotData: FlDotData(show: _showLabels),
              ),
            ],
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: _showLabels)),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: _showLabels)),
            ),
          ),
        );
        break;
      case 'Pie Chart':
        chart = PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(value: 40, color: _chartColor, title: _showLabels ? 'A' : '', radius: 50 * _chartSize),
              PieChartSectionData(value: 30, color: _chartColor.withOpacity(0.7), title: _showLabels ? 'B' : '', radius: 50 * _chartSize),
              PieChartSectionData(value: 30, color: _chartColor.withOpacity(0.4), title: _showLabels ? 'C' : '', radius: 50 * _chartSize),
            ],
          ),
        );
        break;
      case '3D Plot Simulation':
        chart = Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(0.5)
            ..rotateY(0.3),
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A), // Dark blue/black background
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _chartColor.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Stack(
                children: [
                  Icon(Icons.scatter_plot, color: _chartColor, size: 80 * _chartSize),
                  Positioned(
                    top: 10,
                    left: 20,
                    child: Icon(Icons.circle, color: Colors.white70, size: 20 * _chartSize),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 20,
                    child: Icon(Icons.square, color: Colors.redAccent, size: 30 * _chartSize),
                  )
                ],
              ),
            ),
          ),
        );
        break;
      case 'Bar Chart':
      default:
        chart = BarChart(
          BarChartData(
            barGroups: [
              BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 10, color: _chartColor, width: 16 * _chartSize)]),
              BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 14, color: _chartColor, width: 16 * _chartSize)]),
              BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 8, color: _chartColor, width: 16 * _chartSize)]),
            ],
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: _showLabels)),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: _showLabels)),
            ),
          ),
        );
        break;
    }

    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: chart,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizations'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sheet Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Select Sheet:'),
                DropdownButton<String>(
                  value: _selectedSheet,
                  items: _sheets.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedSheet = val);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Chart Type Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Chart Type:'),
                DropdownButton<String>(
                  value: _chartType,
                  items: _chartTypes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _chartType = val);
                  },
                ),
              ],
            ),
            const Divider(height: 30),
            // Modifications
            Text('Modifications', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickColor,
                  icon: const Icon(Icons.color_lens),
                  label: const Text('Color Panel'),
                  style: ElevatedButton.styleFrom(backgroundColor: _chartColor),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: SwitchListTile(
                    title: const Text('Labels'),
                    value: _showLabels,
                    onChanged: (val) => setState(() => _showLabels = val),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Size: '),
                Expanded(
                  child: Slider(
                    value: _chartSize,
                    min: 0.5,
                    max: 2.0,
                    onChanged: (val) => setState(() => _chartSize = val),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Detail Level:'),
                DropdownButton<String>(
                  value: _detailLevel,
                  items: ['Low', 'Medium', 'High'].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _detailLevel = val);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Chart Preview
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: _buildChart(),
            ),
            const SizedBox(height: 30),
            // Saved Visualizations Slider
            Text('Saved Visualizations', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            CarouselSlider(
              options: CarouselOptions(
                height: 200,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                initialPage: 0,
              ),
              items: [1, 2, 3].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          'Saved Chart \$i',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
