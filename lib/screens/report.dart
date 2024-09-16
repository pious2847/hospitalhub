import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hospitalhub/model/patientreport.dart';
import 'package:hospitalhub/widgets/colors.dart';

class ReportSummary extends StatelessWidget {
  final PatientReport report;

  const ReportSummary({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Patient Report Summary',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primcolor,
                ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 200,
            child: TopDiagnosesChart(topDiagnoses: report.topDiagnoses),
          ),
          const SizedBox(height: 50),
          SizedBox(
            height: 200,
            child: PatientStatusChart(overallStatistics: report.overallStatistics),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

class TopDiagnosesChart extends StatelessWidget {
  final List<TopDiagnosis> topDiagnoses;

  const TopDiagnosesChart({Key? key, required this.topDiagnoses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: topDiagnoses.map((d) => d.count).reduce((a, b) => a > b ? a : b)?.toDouble(),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                int index = value.toInt();
                return index < topDiagnoses.length
                    ? Text(
                        topDiagnoses[index].diagnosis.substring(0, 3),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      )
                    : const Text('');
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(
          topDiagnoses.length,
          (index) => BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: topDiagnoses[index].count.toDouble(),
                color: primcolor,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PatientStatusChart extends StatelessWidget {
  final OverallStatistics overallStatistics;

  const PatientStatusChart({Key? key, required this.overallStatistics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            color: Colors.green,
            value: overallStatistics.admittedCount.toDouble(),
            title: 'Admitted',
            radius: 100,
            titleStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            color: Colors.red,
            value: overallStatistics.dischargedCount.toDouble(),
            title: 'Discharged',
            radius: 100,
            titleStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
        sectionsSpace: 0,
        centerSpaceRadius: 40,
      ),
    );
  }
}