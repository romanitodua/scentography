import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scentography/data/providers.dart';

class ScentBarChart extends ConsumerStatefulWidget {
  final String fragranceId;

  ScentBarChart(this.fragranceId, {Key? key}) : super(key: key);

  @override
  _ScentBarChartState createState() => _ScentBarChartState();
}

class _ScentBarChartState extends ConsumerState<ScentBarChart>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Color barColor = Colors.blue;
  final Color backgroundColor = Colors.grey[900]!;
  final Color textColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(fireStoreRepoProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'SCENT'),
              Tab(text: 'DURABILITY'),
              Tab(text: 'SILLAGE'),
              Tab(text: 'BOTTLE'),
            ],
          ),
          SizedBox(height: 20,),
          FutureBuilder(
              future: repo.getFragranceRating(widget.fragranceId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.ratings.isEmpty) {
                  return const Center(
                    child: Text("No ratings yet, be the first!"),
                  );
                } else {
                  var data = snapshot.data!;
                  return SizedBox(
                    height: 300,
                    child: TabBarView(controller: _tabController, children: [
                      _buildTabContent(data.scentAverage.toString(),
                          data.count.toString(), data.ratings["SCENT"]!),
                      _buildTabContent(data.sillageAverage.toString(),
                          data.count.toString(), data.ratings["SILLAGE"]!),
                      _buildTabContent(data.durabilityAverage.toString(),
                          data.count.toString(), data.ratings["DURABILITY"]!),
                      _buildTabContent(data.bottleAverage.toString(),
                          data.count.toString(), data.ratings["BOTTLE"]!)
                    ]),
                  );
                }
              }),
        ],
      ),
    );
  }

  Widget buildTabBarView(
      String rating, String ratingCount, Map<String, int> distribution) {
    return SizedBox(
      height: 300,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildTabContent(rating, ratingCount, distribution!),
          _buildTabContent(rating, ratingCount, distribution),
          _buildTabContent(rating, ratingCount, distribution),
          _buildTabContent(rating, ratingCount, distribution),
        ],
      ),
    );
  }

  Widget _buildTabContent(
      String rating, String ratingCount, Map<String, int> distribution) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Text(
              rating,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              ' / 10',
              style: TextStyle(color: textColor, fontSize: 20),
            ),
            Spacer(),
            Icon(Icons.people, color: textColor),
            SizedBox(width: 5),
            Text(
              ratingCount,
              style: TextStyle(color: textColor),
            ),
          ],
        ),
        Text(
          "Average",
          style: TextStyle(color: textColor, fontSize: 18),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: _buildChart(distribution),
        ),
      ],
    );
  }

  Widget _buildChart(Map<String, int> ratingMap) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 5,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: TextStyle(color: textColor, fontSize: 12),
              ),
              reservedSize: 30,
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: ratingMap.entries.map((entry) {
          return BarChartGroupData(
            x: int.parse(entry.key),
            barRods: [
              BarChartRodData(
                toY: entry.value.toDouble(),
                color: barColor,
                width: 15,
              ),
            ],
          );
        }).toList(),
        gridData: const FlGridData(show: false),
      ),
    );
  }
}
