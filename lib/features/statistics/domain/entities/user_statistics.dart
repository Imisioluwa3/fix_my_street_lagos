import 'package:equatable/equatable.dart';

class UserStatistics extends Equatable {
  final String userId;
  final int totalReports;
  final int resolvedReports;
  final int pendingReports;
  final int inProgressReports;
  final int rejectedReports;
  final double averageResponseTime; // in hours
  final double userRating; // 0-5 scale
  final Map<String, int> categoryBreakdown;
  final Map<String, int> monthlyStats;
  final DateTime lastUpdated;

  const UserStatistics({
    required this.userId,
    required this.totalReports,
    required this.resolvedReports,
    required this.pendingReports,
    required this.inProgressReports,
    required this.rejectedReports,
    required this.averageResponseTime,
    required this.userRating,
    required this.categoryBreakdown,
    required this.monthlyStats,
    required this.lastUpdated,
  });

  double get resolutionRate {
    if (totalReports == 0) return 0.0;
    return (resolvedReports / totalReports) * 100;
  }

  int get activeReports => pendingReports + inProgressReports;

  String get mostReportedCategory {
    if (categoryBreakdown.isEmpty) return 'None';
    
    String topCategory = categoryBreakdown.keys.first;
    int maxCount = categoryBreakdown[topCategory]!;
    
    for (final entry in categoryBreakdown.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        topCategory = entry.key;
      }
    }
    
    return topCategory;
  }

  @override
  List<Object?> get props => [
    userId,
    totalReports,
    resolvedReports,
    pendingReports,
    inProgressReports,
    rejectedReports,
    averageResponseTime,
    userRating,
    categoryBreakdown,
    monthlyStats,
    lastUpdated,
  ];
}
