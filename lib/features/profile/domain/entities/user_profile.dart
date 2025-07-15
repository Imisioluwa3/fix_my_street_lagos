import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String location;
  final String? profileImageUrl;
  final String? bio;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? occupation;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, bool> notificationSettings;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    this.profileImageUrl,
    this.bio,
    this.dateOfBirth,
    this.gender,
    this.occupation,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
    required this.notificationSettings,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map, String id) {
    return UserProfile(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      location: map['location'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      bio: map['bio'],
      dateOfBirth: map['dateOfBirth'] != null 
          ? (map['dateOfBirth'] as Timestamp).toDate() 
          : null,
      gender: map['gender'],
      occupation: map['occupation'],
      isVerified: map['isVerified'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      notificationSettings: Map<String, bool>.from(
        map['notificationSettings'] ?? {
          'statusUpdates': true,
          'communityAlerts': true,
          'governmentResponse': true,
          'nearbyReports': false,
          'emailNotifications': false,
        },
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'dateOfBirth': dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
      'gender': gender,
      'occupation': occupation,
      'isVerified': isVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'notificationSettings': notificationSettings,
    };
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? location,
    String? profileImageUrl,
    String? bio,
    DateTime? dateOfBirth,
    String? gender,
    String? occupation,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, bool>? notificationSettings,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      occupation: occupation ?? this.occupation,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notificationSettings: notificationSettings ?? this.notificationSettings,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    location,
    profileImageUrl,
    bio,
    dateOfBirth,
    gender,
    occupation,
    isVerified,
    createdAt,
    updatedAt,
    notificationSettings,
  ];
}
