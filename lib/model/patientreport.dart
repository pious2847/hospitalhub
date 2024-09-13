class PatientReport {
  final int totalPatients;
  final List<GroupedData> groupedData;
  final List<TopDiagnosis> topDiagnoses;
  final OverallStatistics overallStatistics;

  PatientReport({
    required this.totalPatients,
    required this.groupedData,
    required this.topDiagnoses,
    required this.overallStatistics,
  });

  factory PatientReport.fromJson(Map<String, dynamic> json) {
    return PatientReport(
      totalPatients: json['totalPatients'],
      groupedData: (json['groupedData'] as List)
          .map((group) => GroupedData.fromJson(group))
          .toList(),
      topDiagnoses: (json['topDiagnoses'] as List)
          .map((diagnosis) => TopDiagnosis.fromJson(diagnosis))
          .toList(),
      overallStatistics: OverallStatistics.fromJson(json['overallStatistics']),
    );
  }
}

class GroupedData {
  final String diagnosis;
  final String ageRange;
  final int count;
  final double totalExpenses;
  final int admittedCount;
  final int dischargedCount;
  final double averageExpenses;

  GroupedData({
    required this.diagnosis,
    required this.ageRange,
    required this.count,
    required this.totalExpenses,
    required this.admittedCount,
    required this.dischargedCount,
    required this.averageExpenses,
  });

  factory GroupedData.fromJson(Map<String, dynamic> json) {
    return GroupedData(
      diagnosis: json['diagnosis'],
      ageRange: json['ageRange'],
      count: json['count'],
      totalExpenses: json['totalExpenses'].toDouble(),
      admittedCount: json['admittedCount'],
      dischargedCount: json['dischargedCount'],
      averageExpenses: json['averageExpenses'].toDouble(),
    );
  }
}

class TopDiagnosis {
  final String diagnosis;
  final int count;

  TopDiagnosis({
    required this.diagnosis,
    required this.count,
  });

  factory TopDiagnosis.fromJson(Map<String, dynamic> json) {
    return TopDiagnosis(
      diagnosis: json['diagnosis'],
      count: json['count'],
    );
  }
}

class OverallStatistics {
  final double totalExpenses;
  final double averageExpenses;
  final int admittedCount;
  final int dischargedCount;

  OverallStatistics({
    required this.totalExpenses,
    required this.averageExpenses,
    required this.admittedCount,
    required this.dischargedCount,
  });

  factory OverallStatistics.fromJson(Map<String, dynamic> json) {
    return OverallStatistics(
      totalExpenses: json['totalExpenses'].toDouble(),
      averageExpenses: json['averageExpenses'].toDouble(),
      admittedCount: json['admittedCount'],
      dischargedCount: json['dischargedCount'],
    );
  }
}