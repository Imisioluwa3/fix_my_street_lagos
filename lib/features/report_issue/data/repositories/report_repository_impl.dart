// import 'package:dartz/dartz.dart';
// import 'dart:io';

// import '../../../../core/error/failures.dart';
// import '../../../../core/error/exceptions.dart';
// import '../../../../core/services/firebase_storage_service.dart';
// import '../../../../shared/models/issue_report.dart';
// import '../../domain/repositories/report_repository.dart';
// import '../datasources/report_remote_datasource.dart';

// class ReportRepositoryImpl implements ReportRepository {
//   final ReportRemoteDataSource remoteDataSource;

//   ReportRepositoryImpl({required this.remoteDataSource});

//   @override
//   Future<Either<Failure, void>> submitReport(
//     IssueReport report,
//     List<File> images,
//     List<File> videos,
//   ) async {
//     try {
//       // Upload media files to Firebase Storage
//       final mediaUrls = await FirebaseStorageService.uploadReportMedia(
//         reportId: report.id,
//         images: images,
//         videos: videos,
//         onProgress: (type, current, total) {
//           print('Uploading $type: $current/$total');
//         },
//       );

//       // Update report with uploaded URLs
//       final updatedReport = report.copyWith(
//         imageUrls: mediaUrls['images'] ?? [],
//         videoUrls: mediaUrls['videos'] ?? [],
//       );

//       // Submit report to Firestore
//       await remoteDataSource.submitReport(updatedReport);
      
//       return const Right(null);
//     } on ServerException catch (e) {
//       return Left(ServerFailure(e.message));
//     } catch (e) {
//       return Left(ServerFailure('Failed to submit report: $e'));
//     }
//   }

//   @override
//   Future<Either<Failure, List<IssueReport>>> getUserReports(String userId) async {
//     try {
//       final reports = await remoteDataSource.getUserReports(userId);
//       return Right(reports);
//     } on ServerException catch (e) {
//       return Left(ServerFailure(e.message));
//     }
//   }

//   @override
//   Future<Either<Failure, List<IssueReport>>> getAllReports() async {
//     try {
//       final reports = await remoteDataSource.getAllReports();
//       return Right(reports);
//     } on ServerException catch (e) {
//       return Left(ServerFailure(e.message));
//     }
//   }

//   @override
//   Future<Either<Failure, IssueReport>> getReportById(String reportId) async {
//     try {
//       final report = await remoteDataSource.getReportById(reportId);
//       return Right(report);
//     } on ServerException catch (e) {
//       return Left(ServerFailure(e.message));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> updateReport(IssueReport report) async {
//     try {
//       await remoteDataSource.updateReport(report);
//       return const Right(null);
//     } on ServerException catch (e) {
//       return Left(ServerFailure(e.message));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> deleteReport(String reportId) async {
//     try {
//       // Get report to access media URLs
//       final report = await remoteDataSource.getReportById(reportId);
      
//       // Delete media files from storage
//       final allUrls = [...report.imageUrls, ...report.videoUrls];
//       if (allUrls.isNotEmpty) {
//         await FirebaseStorageService.deleteFiles(allUrls);
//       }

//       // Delete report from Firestore
//       await remoteDataSource.deleteReport(reportId);
      
//       return const Right(null);
//     } on ServerException catch (e) {
//       return Left(ServerFailure(e.message));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> upvoteReport(String reportId, String userId) async {
//     try {
//       await remoteDataSource.upvoteReport(reportId, userId);
//       return const Right(null);
//     } on ServerException catch (e) {
//       return Left(ServerFailure(e.message));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> addComment(String reportId, Comment comment) async {
//     try {
//       await remoteDataSource.addComment(reportId, comment);
//       return const Right(null);
//     } on ServerException catch (e) {
//       return Left(ServerFailure(e.message));
//     }
//   }
// }
