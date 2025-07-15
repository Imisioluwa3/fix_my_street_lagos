import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_statistics.dart';
import '../../../../core/error/exceptions.dart';

abstract class StatisticsRemoteDataSource {
  Future<UserStatistics> getUserStatistics(String userId);
  Future<Map<String, dynamic>> getCommunityStatistics();
  Future<List<Map<String, dynamic>>> getMonthlyReportStats(String userId);
  Future<Map<String, int>> getCategoryBreakdown(String userId);
}

class StatisticsRemoteDataSourceImpl implements StatisticsRemoteDataSource {
  final FirebaseFirestore _firestore;

  StatisticsRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserStatistics> getUserStatistics(String userId) async {
    try {
      // Get user's reports
      final reportsQuery = await _firestore
          .collection('reports')
          .where('reporterId', isEqualTo: userId)
          .get();

      final reports = reportsQuery.docs;
      final totalReports = reports.length;

      // Count by status
      int resolvedReports = 0;
      int pendingReports = 0;
      int inProgressReports = 0;
      int rejectedReports = 0;
      
      double totalResponseTime = 0;
      int resolvedCount = 0;
      
      Map<String, int> categoryBreakdown = {};
      Map<String, int> monthlyStats = {};

      for (final doc in reports) {
        final data = doc.data();
        final status = data['status'] as String;
        final category = data['category'] as String;
        final createdAt = (data['createdAt'] as Timestamp).toDate();
        final updatedAt = data['updatedAt'] != null 
            ? (data['updatedAt'] as Timestamp).toDate()
            : null;

        // Count by status
        switch (status) {
          case 'resolved':
            resolvedReports++;
            if (updatedAt != null) {
              totalResponseTime += updatedAt.difference(createdAt).inHours;
              resolvedCount++;
            }
            break;
          case 'pending':
            pendingReports++;
            break;
          case 'in_progress':
            inProgressReports++;
            break;
          case 'rejected':
            rejectedReports++;
            break;
        }

        // Category breakdown
        categoryBreakdown[category] = (categoryBreakdown[category] ?? 0) + 1;

        // Monthly stats
        final monthKey = '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}';
        monthlyStats[monthKey] = (monthlyStats[monthKey] ?? 0) + 1;
      }

      // Calculate average response time
      final averageResponseTime = resolvedCount > 0 
          ? totalResponseTime / resolvedCount 
          : 0.0;

      // Get user rating (from reviews/feedback)
      double userRating = 0.0;
      try {
        final ratingsQuery = await _firestore
            .collection('user_ratings')
            .where('userId', isEqualTo: userId)
            .get();
        
        if (ratingsQuery.docs.isNotEmpty) {
          double totalRating = 0;
          for (final doc in ratingsQuery.docs) {
            totalRating += (doc.data()['rating'] as num).toDouble();
          }
          userRating = totalRating / ratingsQuery.docs.length;
        }
      } catch (e) {
        // Rating collection might not exist
        userRating = 0.0;
      }

      return UserStatistics(
        userId: userId,
        totalReports: totalReports,
        resolvedReports: resolvedReports,
        pendingReports: pendingReports,
        inProgressReports: inProgressReports,
        rejectedReports: rejectedReports,
        averageResponseTime: averageResponseTime,
        userRating: userRating,
        categoryBreakdown: categoryBreakdown,
        monthlyStats: monthlyStats,
        lastUpdated: DateTime.now(),
      );
    } on FirebaseException catch (e) {
      throw ServerException('Failed to get user statistics: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> getCommunityStatistics() async {
    try {
      final reportsQuery = await _firestore.collection('reports').get();
      final reports = reportsQuery.docs;

      int totalCommunityReports = reports.length;
      int resolvedCommunityReports = 0;
      Map<String, int> communityCategories = {};

      for (final doc in reports) {
        final data = doc.data();
        final status = data['status'] as String;
        final category = data['category'] as String;

        if (status == 'resolved') {
          resolvedCommunityReports++;
        }

        communityCategories[category] = (communityCategories[category] ?? 0) + 1;
      }

      return {
        'totalReports': totalCommunityReports,
        'resolvedReports': resolvedCommunityReports,
        'categoryBreakdown': communityCategories,
        'resolutionRate': totalCommunityReports > 0 
            ? (resolvedCommunityReports / totalCommunityReports * 100).round()
            : 0,
      };
    } on FirebaseException catch (e) {
      throw ServerException('Failed to get community statistics: ${e.message}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getMonthlyReportStats(String userId) async {
    try {
      final now = DateTime.now();
      final sixMonthsAgo = DateTime(now.year, now.month - 6, 1);

      final reportsQuery = await _firestore
          .collection('reports')
          .where('reporterId', isEqualTo: userId)
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(sixMonthsAgo))
          .orderBy('createdAt')
          .get();

      Map<String, Map<String, int>> monthlyData = {};

      for (final doc in reportsQuery.docs) {
        final data = doc.data();
        final createdAt = (data['createdAt'] as Timestamp).toDate();
        final status = data['status'] as String;
        
        final monthKey = '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}';
        
        if (!monthlyData.containsKey(monthKey)) {
          monthlyData[monthKey] = {
            'total': 0,
            'resolved': 0,
            'pending': 0,
            'in_progress': 0,
            'rejected': 0,
          };
        }

        monthlyData[monthKey]!['total'] = monthlyData[monthKey]!['total']! + 1;
        monthlyData[monthKey]![status] = (monthlyData[monthKey]![status] ?? 0) + 1;
      }

      return monthlyData.entries.map((entry) => {
        'month': entry.key,
        ...entry.value,
      }).toList();
    } on FirebaseException catch (e) {
      throw ServerException('Failed to get monthly statistics: ${e.message}');
    }
  }

  @override
  Future<Map<String, int>> getCategoryBreakdown(String userId) async {
    try {
      final reportsQuery = await _firestore
          .collection('reports')
          .where('reporterId', isEqualTo: userId)
          .get();

      Map<String, int> categoryBreakdown = {};

      for (final doc in reportsQuery.docs) {
        final data = doc.data();
        final category = data['category'] as String;
        categoryBreakdown[category] = (categoryBreakdown[category] ?? 0) + 1;
      }

      return categoryBreakdown;
    } on FirebaseException catch (e) {
      throw ServerException('Failed to get category breakdown: ${e.message}');
    }
  }
}
