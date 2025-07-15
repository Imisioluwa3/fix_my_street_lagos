import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_profile.dart';
import '../../../../core/error/exceptions.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfile> getUserProfile(String userId);
  Future<void> updateUserProfile(UserProfile profile);
  Future<void> updateProfileImage(String userId, String imageUrl);
  Future<void> updateNotificationSettings(String userId, Map<String, bool> settings);
  Future<Map<String, bool>> getNotificationSettings(String userId);
  Future<void> deleteUserAccount(String userId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ProfileRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  @override
  Future<UserProfile> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      
      if (!doc.exists) {
        throw const ServerException('User profile not found');
      }

      final data = doc.data()!;
      return UserProfile.fromMap(data, userId);
    } on FirebaseException catch (e) {
      throw ServerException('Failed to get user profile: ${e.message}');
    }
  }

  @override
  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      await _firestore.collection('users').doc(profile.id).update({
        'name': profile.name,
        'email': profile.email,
        'phone': profile.phone,
        'location': profile.location,
        'bio': profile.bio,
        'dateOfBirth': profile.dateOfBirth != null 
            ? Timestamp.fromDate(profile.dateOfBirth!) 
            : null,
        'gender': profile.gender,
        'occupation': profile.occupation,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } on FirebaseException catch (e) {
      throw ServerException('Failed to update profile: ${e.message}');
    }
  }

  @override
  Future<void> updateProfileImage(String userId, String imageUrl) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'profileImageUrl': imageUrl,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } on FirebaseException catch (e) {
      throw ServerException('Failed to update profile image: ${e.message}');
    }
  }

  @override
  Future<void> updateNotificationSettings(String userId, Map<String, bool> settings) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'notificationSettings': settings,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } on FirebaseException catch (e) {
      throw ServerException('Failed to update notification settings: ${e.message}');
    }
  }

  @override
  Future<Map<String, bool>> getNotificationSettings(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      
      if (!doc.exists) {
        throw const ServerException('User not found');
      }

      final data = doc.data()!;
      final settings = data['notificationSettings'] as Map<String, dynamic>?;
      
      return {
        'statusUpdates': settings?['statusUpdates'] ?? true,
        'communityAlerts': settings?['communityAlerts'] ?? true,
        'governmentResponse': settings?['governmentResponse'] ?? true,
        'nearbyReports': settings?['nearbyReports'] ?? false,
        'emailNotifications': settings?['emailNotifications'] ?? false,
      };
    } on FirebaseException catch (e) {
      throw ServerException('Failed to get notification settings: ${e.message}');
    }
  }

  @override
  Future<void> deleteUserAccount(String userId) async {
    try {
      // Delete user document
      await _firestore.collection('users').doc(userId).delete();
      
      // Delete user's reports
      final reportsQuery = await _firestore
          .collection('reports')
          .where('reporterId', isEqualTo: userId)
          .get();
      
      final batch = _firestore.batch();
      for (final doc in reportsQuery.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      // Delete Firebase Auth account
      final user = _auth.currentUser;
      if (user != null && user.uid == userId) {
        await user.delete();
      }
    } on FirebaseException catch (e) {
      throw ServerException('Failed to delete account: ${e.message}');
    }
  }
}
