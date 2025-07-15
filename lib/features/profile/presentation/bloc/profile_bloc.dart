// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';

import '../../domain/entities/user_profile.dart';
// import '../../domain/usecases/get_user_profile.dart';
// import '../../domain/usecases/update_user_profile.dart';
// import '../../domain/usecases/delete_user_account.dart';
// import '../../../../core/services/firebase_storage_service.dart';

// Events
abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final String name;
  final String email;
  final String location;
  final String? bio;
  final String? occupation;
  final DateTime? dateOfBirth;
  final String? gender;
  final File? profileImage;

  UpdateProfileEvent({
    required this.name,
    required this.email,
    required this.location,
    this.bio,
    this.occupation,
    this.dateOfBirth,
    this.gender,
    this.profileImage,
  });

  @override
  List<Object?> get props => [
    name, email, location, bio, occupation, 
    dateOfBirth, gender, profileImage
  ];
}

class DeleteAccountEvent extends ProfileEvent {}

// States
abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final UserProfile profile;

  ProfileLoadedState({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class ProfileUpdatingState extends ProfileState {}

class ProfileUpdatedState extends ProfileState {
  final UserProfile profile;

  ProfileUpdatedState({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class ProfileErrorState extends ProfileState {
  final String message;

  ProfileErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class AccountDeletedState extends ProfileState {}

// BLoC
// class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
//   final GetUserProfile getUserProfile;
//   final UpdateUserProfile updateUserProfile;
//   final DeleteUserAccount deleteUserAccount;

//   ProfileBloc({
//     required this.getUserProfile,
//     required this.updateUserProfile,
//     required this.deleteUserAccount,
//   }) : super(ProfileInitialState()) {
//     on<LoadProfileEvent>(_onLoadProfile);
//     on<UpdateProfileEvent>(_onUpdateProfile);
//     on<DeleteAccountEvent>(_onDeleteAccount);
//   }

//   Future<void> _onLoadProfile(
//     LoadProfileEvent event,
//     Emitter<ProfileState> emit,
//   ) async {
//     emit(ProfileLoadingState());

//     final result = await getUserProfile();
//     result.fold(
//       (failure) => emit(ProfileErrorState(message: failure.message)),
//       (profile) => emit(ProfileLoadedState(profile: profile)),
//     );
//   }

//   Future<void> _onUpdateProfile(
//     UpdateProfileEvent event,
//     Emitter<ProfileState> emit,
//   ) async {
//     if (state is ProfileLoadedState) {
//       emit(ProfileUpdatingState());

//       try {
//         final currentProfile = (state as ProfileLoadedState).profile;
//         String? profileImageUrl = currentProfile.profileImageUrl;

//         // Upload new profile image if provided
//         if (event.profileImage != null) {
//           profileImageUrl = await FirebaseStorageService.uploadProfileImage(
//             userId: currentProfile.id,
//             imageFile: event.profileImage!,
//           );
//         }

//         // Create updated profile
//         final updatedProfile = currentProfile.copyWith(
//           name: event.name,
//           email: event.email,
//           location: event.location,
//           bio: event.bio,
//           occupation: event.occupation,
//           dateOfBirth: event.dateOfBirth,
//           gender: event.gender,
//           profileImageUrl: profileImageUrl,
//           updatedAt: DateTime.now(),
//         );

//         final result = await updateUserProfile(updatedProfile);
//         result.fold(
//           (failure) => emit(ProfileErrorState(message: failure.message)),
//           (_) => emit(ProfileUpdatedState(profile: updatedProfile)),
//         );
//       } catch (e) {
//         emit(ProfileErrorState(message: 'Failed to update profile: $e'));
//       }
//     }
//   }

//   Future<void> _onDeleteAccount(
//     DeleteAccountEvent event,
//     Emitter<ProfileState> emit,
//   ) async {
//     if (state is ProfileLoadedState) {
//       emit(ProfileLoadingState());

//       final currentProfile = (state as ProfileLoadedState).profile;
//       final result = await deleteUserAccount(currentProfile.id);
      
//       result.fold(
//         (failure) => emit(ProfileErrorState(message: failure.message)),
//         (_) => emit(AccountDeletedState()),
//       );
//     }
//   }
// }
