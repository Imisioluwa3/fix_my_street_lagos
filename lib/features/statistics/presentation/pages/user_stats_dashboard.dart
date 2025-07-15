// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fl_chart/fl_chart.dart';

// import '../../../../core/constants/app_constants.dart';
// import '../../../../core/localization/app_localizations.dart';
// import '../bloc/statistics_bloc.dart';
// import '../widgets/stats_card.dart';
// import '../widgets/category_chart.dart';
// import '../widgets/monthly_chart.dart';
// import '../widgets/achievement_card.dart';

// class UserStatsDashboard extends StatefulWidget {
//   @override
//   _UserStatsDashboardState createState() => _UserStatsDashboardState();
// }

// class _UserStatsDashboardState extends State<UserStatsDashboard>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     context.read<StatisticsBloc>().add(LoadUserStatisticsEvent());
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User Statistics'),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: [
//             Tab(text: 'Overview'),
//             Tab(text: 'Charts'),
//             Tab(text: 'Achievements'),
//           ],
//         ),
//       ),
//       body: BlocBuilder<StatisticsBloc, StatisticsState>(
//         builder: (context, state) {
//           if (state is StatisticsLoadingState) {
//             return Center(child: CircularProgressIndicator());
//           } else if (state is StatisticsLoadedState) {
//             return TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildOverviewTab(context, state.statistics, l10n),
//                 _buildChartsTab(context, state.statistics, l10n),
//                 _buildAchievementsTab(context, state.statistics, l10n),
//               ],
//             );
//           } else if (state is StatisticsErrorState) {
//             return _buildErrorState(context, state.message, l10n);
//           }
          
//           return Container();
//         },
//       ),
//     );
//   }

//   Widget _buildOverviewTab(BuildContext context, statistics, AppLocalizations l10n) {
//     return RefreshIndicator(
//       onRefresh: () async {
//         context.read<StatisticsBloc>().add(LoadUserStatisticsEvent());
//       },
//       child: SingleChildScrollView(
//         padding: EdgeInsets.all(AppConstants.paddingMedium),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Your Impact',
//               style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                 color: AppConstants.primaryGreen,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: AppConstants.paddingMedium),
            
//             // Main Stats Grid
//             GridView.count(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               crossAxisCount: 2,
//               crossAxisSpacing: AppConstants.paddingMedium,
//               mainAxisSpacing: AppConstants.paddingMedium,
//               childAspectRatio: 1.2,
//               children: [
//                 StatsCard(
//                   title: l10n.totalReports,
//                   value: statistics.totalReports.toString(),
//                   icon: Icons.report,
//                   color: AppConstants.primaryGreen,
//                 ),
//                 StatsCard(
//                   title: l10n.resolvedReports,
//                   value: statistics.resolvedReports.toString(),
//                   icon: Icons.check_circle,
//                   color: AppConstants.successGreen,
//                 ),
//                 StatsCard(
//                   title: l10n.pendingReports,
//                   value: statistics.pendingReports.toString(),
//                   icon: Icons.pending,
//                   color: AppConstants.warningAmber,
//                 ),
//                 StatsCard(
//                   title: 'Resolution Rate',
//                   value: '${statistics.resolutionRate.toStringAsFixed(1)}%',
//                   icon: Icons.trending_up,
//                   color: AppConstants.lagosBlue,
//                 ),
//               ],
//             ),
            
//             SizedBox(height: AppConstants.paddingLarge),
            
//             // Performance Metrics
//             Text(
//               'Performance Metrics',
//               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                 color: AppConstants.primaryGreen,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             SizedBox(height: AppConstants.paddingMedium),
            
//             Card(
//               child: Padding(
//                 padding: EdgeInsets.all(AppConstants.paddingMedium),
//                 child: Column(
//                   children: [
//                     _buildMetricRow(
//                       context,
//                       l10n.responseTime,
//                       '${statistics.averageResponseTime.toStringAsFixed(1)} hours',
//                       Icons.access_time,
//                     ),
//                     Divider(),
//                     _buildMetricRow(
//                       context,
//                       l10n.userRating,
//                       '${statistics.userRating.toStringAsFixed(1)}/5.0',
//                       Icons.star,
//                     ),
//                     Divider(),
//                     _buildMetricRow(
//                       context,
//                       'Most Reported Category',
//                       statistics.mostReportedCategory,
//                       Icons.category,
//                     ),
//                     Divider(),
//                     _buildMetricRow(
//                       context,
//                       'Active Reports',
//                       statistics.activeReports.toString(),
//                       Icons.pending_actions,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
            
//             SizedBox(height: AppConstants.paddingLarge),
            
//             // Quick Actions
//             Text(
//               'Quick Actions',
//               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                 color: AppConstants.primaryGreen,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             SizedBox(height: AppConstants.paddingMedium),
            
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       // Navigate to report issue
//                     },
//                     icon: Icon(Icons.add_circle),
//                     label: Text('New Report'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppConstants.primaryGreen,
//                       foregroundColor: Colors.white,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: AppConstants.paddingMedium),
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     onPressed: () {
//                       // Navigate to my reports
//                     },
//                     icon: Icon(Icons.list),
//                     label: Text('My Reports'),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildChartsTab(BuildContext context, statistics, AppLocalizations l10n) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(AppConstants.paddingMedium),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Category Breakdown',
//             style: Theme.of(context).textTheme.titleLarge?.copyWith(
//               color: AppConstants.primaryGreen,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           SizedBox(height: AppConstants.paddingMedium),
          
//           CategoryChart(categoryData: statistics.categoryBreakdown),
          
//           SizedBox(height: AppConstants.paddingLarge),
          
//           Text(
//             'Monthly Trends',
//             style: Theme.of(context).textTheme.titleLarge?.copyWith(
//               color: AppConstants.primaryGreen,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           SizedBox(height: AppConstants.paddingMedium),
          
//           MonthlyChart(monthlyData: statistics.monthlyStats),
          
//           SizedBox(height: AppConstants.paddingLarge),
          
//           // Status Distribution
//           Text(
//             'Status Distribution',
//             style: Theme.of(context).textTheme.titleLarge?.copyWith(
//               color: AppConstants.primaryGreen,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           SizedBox(height: AppConstants.paddingMedium),
          
//           Card(
//             child: Padding(
//               padding: EdgeInsets.all(AppConstants.paddingMedium),
//               child: Column(
//                 children: [
//                   _buildStatusBar(
//                     context,
//                     'Resolved',
//                     statistics.resolvedReports,
//                     statistics.totalReports,
//                     AppConstants.successGreen,
//                   ),
//                   SizedBox(height: AppConstants.paddingSmall),
//                   _buildStatusBar(
//                     context,
//                     'Pending',
//                     statistics.pendingReports,
//                     statistics.totalReports,
//                     AppConstants.warningAmber,
//                   ),
//                   SizedBox(height: AppConstants.paddingSmall),
//                   _buildStatusBar(
//                     context,
//                     'In Progress',
//                     statistics.inProgressReports,
//                     statistics.totalReports,
//                     AppConstants.lagosBlue,
//                   ),
//                   SizedBox(height: AppConstants.paddingSmall),
//                   _buildStatusBar(
//                     context,
//                     'Rejected',
//                     statistics.rejectedReports,
//                     statistics.totalReports,
//                     AppConstants.errorRed,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAchievementsTab(BuildContext context, statistics, AppLocalizations l10n) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(AppConstants.paddingMedium),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Your Achievements',
//             style: Theme.of(context).textTheme.titleLarge?.copyWith(
//               color: AppConstants.primaryGreen,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           SizedBox(height: AppConstants.paddingMedium),
          
//           // Achievement Cards
//           AchievementCard(
//             title: 'First Reporter',
//             description: 'Submitted your first report',
//             icon: Icons.flag,
//             isUnlocked: statistics.totalReports >= 1,
//             progress: statistics.totalReports >= 1 ? 1.0 : 0.0,
//           ),
          
//           AchievementCard(
//             title: 'Community Helper',
//             description: 'Submitted 10 reports',
//             icon: Icons.people,
//             isUnlocked: statistics.totalReports >= 10,
//             progress: (statistics.totalReports / 10).clamp(0.0, 1.0),
//           ),
          
//           AchievementCard(
//             title: 'Problem Solver',
//             description: 'Had 5 reports resolved',
//             icon: Icons.build,
//             isUnlocked: statistics.resolvedReports >= 5,
//             progress: (statistics.resolvedReports / 5).clamp(0.0, 1.0),
//           ),
          
//           AchievementCard(
//             title: 'Consistency Champion',
//             description: 'Submitted reports for 3 consecutive months',
//             icon: Icons.calendar_today,
//             isUnlocked: _checkConsistencyAchievement(statistics.monthlyStats),
//             progress: _getConsistencyProgress(statistics.monthlyStats),
//           ),
          
//           AchievementCard(
//             title: 'Category Expert',
//             description: 'Submitted 20 reports in a single category',
//             icon: Icons.star,
//             isUnlocked: _checkCategoryExpertAchievement(statistics.categoryBreakdown),
//             progress: _getCategoryExpertProgress(statistics.categoryBreakdown),
//           ),
          
//           AchievementCard(
//             title: 'Lagos Champion',
//             description: 'Submitted 50 reports total',
//             icon: Icons.emoji_events,
//             isUnlocked: statistics.totalReports >= 50,
//             progress: (statistics.totalReports / 50).clamp(0.0, 1.0),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMetricRow(BuildContext context, String label, String value, IconData icon) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
//       child: Row(
//         children: [
//           Icon(icon, color: AppConstants.primaryGreen, size: 20),
//           SizedBox(width: AppConstants.paddingSmall),
//           Expanded(
//             child: Text(
//               label,
//               style: Theme.of(context).textTheme.bodyMedium,
//             ),
//           ),
//           Text(
//             value,
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//               fontWeight: FontWeight.w600,
//               color: AppConstants.primaryGreen,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatusBar(BuildContext context, String label, int count, int total, Color color) {
//     final percentage = total > 0 ? count / total : 0.0;
    
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(label),
//             Text('$count (${(percentage * 100).toStringAsFixed(1)}%)'),
//           ],
//         ),
//         SizedBox(height: 4),
//         LinearProgressIndicator(
//           value: percentage,
//           backgroundColor: color.withOpacity(0.2),
//           valueColor: AlwaysStoppedAnimation<Color>(color),
//         ),
//       ],
//     );
//   }

//   Widget _buildErrorState(BuildContext context, String message, AppLocalizations l10n) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.error_outline,
//             size: 64,
//             color: AppConstants.errorRed,
//           ),
//           SizedBox(height: AppConstants.paddingMedium),
//           Text(
//             'Error Loading Statistics',
//             style: Theme.of(context).textTheme.headlineSmall,
//           ),
//           SizedBox(height: AppConstants.paddingSmall),
//           Text(
//             message,
//             textAlign: TextAlign.center,
//             style: TextStyle(color: AppConstants.textSecondary),
//           ),
//           SizedBox(height: AppConstants.paddingLarge),
//           ElevatedButton(
//             onPressed: () {
//               context.read<StatisticsBloc>().add(LoadUserStatisticsEvent());
//             },
//             child: Text(l10n.retry),
//           ),
//         ],
//       ),
//     );
//   }

//   bool _checkConsistencyAchievement(Map<String, int> monthlyStats) {
//     if (monthlyStats.length < 3) return false;
    
//     final sortedMonths = monthlyStats.keys.toList()..sort();
//     int consecutiveMonths = 1;
//     int maxConsecutive = 1;
    
//     for (int i = 1; i < sortedMonths.length; i++) {
//       final current = DateTime.parse('${sortedMonths[i]}-01');
//       final previous = DateTime.parse('${sortedMonths[i-1]}-01');
      
//       if (current.difference(previous).inDays <= 31) {
//         consecutiveMonths++;
//         maxConsecutive = maxConsecutive > consecutiveMonths ? maxConsecutive : consecutiveMonths;
//       } else {
//         consecutiveMonths = 1;
//       }
//     }
    
//     return maxConsecutive >= 3;
//   }

//   double _getConsistencyProgress(Map<String, int> monthlyStats) {
//     if (monthlyStats.length < 3) return monthlyStats.length / 3.0;
//     return _checkConsistencyAchievement(monthlyStats) ? 1.0 : 0.8;
//   }

//   bool _checkCategoryExpertAchievement(Map<String, int> categoryBreakdown) {
//     return categoryBreakdown.values.any((count) => count >= 20);
//   }

//   double _getCategoryExpertProgress(Map<String, int> categoryBreakdown) {
//     if (categoryBreakdown.isEmpty) return 0.0;
//     final maxCount = categoryBreakdown.values.reduce((a, b) => a > b ? a : b);
//     return (maxCount / 20).clamp(0.0, 1.0);
//   }
// }
