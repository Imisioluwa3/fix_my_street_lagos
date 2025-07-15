import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;
import 'package:video_compress/video_compress.dart';

class FirebaseStorageService {
  static final firebase_storage.FirebaseStorage _storage = firebase_storage.FirebaseStorage.instance;

  /// Upload report media files (images and videos)
  static Future<Map<String, List<String>>> uploadReportMedia({
    required String reportId,
    required List<File> images,
    required List<File> videos,
    Function(String type, int current, int total)? onProgress,
  }) async {
    final Map<String, List<String>> uploadedUrls = {
      'images': <String>[],
      'videos': <String>[],
    };

    try {
      // Upload images
      if (images.isNotEmpty) {
        onProgress?.call('images', 0, images.length);
        
        for (int i = 0; i < images.length; i++) {
          final imageUrl = await _uploadImage(
            file: images[i],
            filePath: 'reports/$reportId/images/image_$i.jpg',
          );
          uploadedUrls['images']!.add(imageUrl);
          onProgress?.call('images', i + 1, images.length);
        }
      }

      // Upload videos
      if (videos.isNotEmpty) {
        onProgress?.call('videos', 0, videos.length);
        
        for (int i = 0; i < videos.length; i++) {
          final videoUrl = await _uploadVideo(
            file: videos[i],
            filePath: 'reports/$reportId/videos/video_$i.mp4',
          );
          uploadedUrls['videos']!.add(videoUrl);
          onProgress?.call('videos', i + 1, videos.length);
        }
      }

      return uploadedUrls;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading media: $e');
      }
      rethrow;
    }
  }

  /// Upload user profile image
  static Future<String> uploadProfileImage({
    required String userId,
    required File imageFile,
  }) async {
    try {
      return await _uploadImage(
        file: imageFile,
        filePath: 'users/$userId/profile.jpg',
        maxWidth: 400,
        maxHeight: 400,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading profile image: $e');
      }
      rethrow;
    }
  }

  /// Upload and compress image
  static Future<String> _uploadImage({
    required File file,
    required String filePath,
    int maxWidth = 1024,
    int maxHeight = 1024,
    int quality = 85,
  }) async {
    try {
      // Read and decode image
      final bytes = await file.readAsBytes();
      img.Image? image = img.decodeImage(bytes);
      
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Resize image if needed
      if (image.width > maxWidth || image.height > maxHeight) {
        image = img.copyResize(
          image,
          width: image.width > maxWidth ? maxWidth : null,
          height: image.height > maxHeight ? maxHeight : null,
        );
      }

      // Compress image
      final compressedBytes = img.encodeJpg(image, quality: quality);

      // Upload to Firebase Storage
      final ref = _storage.ref().child(filePath);
      final uploadTask = ref.putData(
        Uint8List.fromList(compressedBytes),
        firebase_storage.SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'originalName': path.basename(file.path),
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
      rethrow;
    }
  }

  /// Upload and compress video
  static Future<String> _uploadVideo({
    required File file,
    required String filePath,
  }) async {
    try {
      // Compress video
      final compressedVideo = await VideoCompress.compressVideo(
        file.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
      );

      if (compressedVideo == null) {
        throw Exception('Failed to compress video');
      }

      // Upload compressed video
      final ref = _storage.ref().child(filePath);
      final uploadTask = ref.putFile(
        compressedVideo.file!,
        firebase_storage.SettableMetadata(
          contentType: 'video/mp4',
          customMetadata: {
            'originalName': path.basename(file.path),
            'originalSize': file.lengthSync().toString(),
            'compressedSize': compressedVideo.file!.lengthSync().toString(),
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading video: $e');
      }
      rethrow;
    }
  }

  /// Delete files from Firebase Storage
  static Future<void> deleteFiles(List<String> urls) async {
    try {
      for (final url in urls) {
        await deleteFile(url);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting files: $e');
      }
      rethrow;
    }
  }

  /// Delete single file from Firebase Storage
  static Future<void> deleteFile(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting file: $e');
      }
      // Don't rethrow for individual file deletion failures
    }
  }

  /// Get file metadata
  static Future<firebase_storage.FullMetadata> getFileMetadata(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      return await ref.getMetadata();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting file metadata: $e');
      }
      rethrow;
    }
  }

  /// Check if file exists
  static Future<bool> fileExists(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.getMetadata();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get download URL for a file path
  static Future<String> getDownloadURL(String filePath) async {
    try {
      final ref = _storage.ref().child(filePath);
      return await ref.getDownloadURL();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting download URL: $e');
      }
      rethrow;
    }
  }
}