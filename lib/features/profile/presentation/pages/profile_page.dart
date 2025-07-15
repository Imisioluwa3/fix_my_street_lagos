// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// import '../../../../core/constants/app_constants.dart';
// import '../../../../shared/widgets/loading_overlay.dart';
// import '../../../../shared/widgets/custom_text_field.dart';
// import '../../../../core/services/firebase_storage_service.dart';
// import '../bloc/profile_bloc.dart';
// import '../widgets/profile_image_picker.dart';
// import '../widgets/profile_info_card.dart';
// import 'settings_page.dart';

// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _locationController = TextEditingController();
//   final _bioController = TextEditingController();
//   final _occupationController = TextEditingController();

//   DateTime? _selectedDateOfBirth;
//   String? _selectedGender;
//   File? _selectedImage;
//   bool _isEditing = false;

//   @override
//   void initState() {
//     super.initState();
//     context.read<ProfileBloc>().add(LoadProfileEvent());
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _locationController.dispose();
//     _bioController.dispose();
//     _occupationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//         actions: [
//           if (!_isEditing)
//             IconButton(
//               onPressed: () => setState(() => _isEditing = true),
//               icon: Icon(Icons.edit),
//             ),
//           IconButton(
//             onPressed: () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => SettingsPage()),
//             ),
//             icon: Icon(Icons.settings),
//           ),
//         ],
//       ),
//       body: BlocListener<ProfileBloc, ProfileState>(
//         listener: (context, state) {
//           if (state is ProfileUpdatedState) {
//             setState(() => _isEditing = false);
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('Profile updated successfully'),
//                 backgroundColor: AppConstants.successGreen,
//               ),
//             );
//           } else if (state is ProfileErrorState) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: AppConstants.errorRed,
//               ),
//             );
//           }
//         },
//         child: BlocBuilder<ProfileBloc, ProfileState>(
//           builder: (context, state) {
//             if (state is ProfileLoadingState) {
//               return Center(child: CircularProgressIndicator());
//             } else if (state is ProfileLoadedState) {
//               _populateFields(state.profile);
              
//               return Stack(
//                 children: [
//                   SingleChildScrollView(
//                     padding: EdgeInsets.all(AppConstants.paddingMedium),
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         children: [
//                           _buildProfileHeader(state.profile),
//                           SizedBox(height: AppConstants.paddingLarge),
//                           _buildPersonalInfoSection(),
//                           SizedBox(height: AppConstants.paddingLarge),
//                           _buildContactInfoSection(),
//                           SizedBox(height: AppConstants.paddingLarge),
//                           _buildAdditionalInfoSection(),
//                           if (_isEditing) ...[
//                             SizedBox(height: AppConstants.paddingLarge),
//                             _buildActionButtons(),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ),
//                   if (state is ProfileUpdatingState)
//                     LoadingOverlay(message: 'Updating profile...'),
//                 ],
//               );
//             } else if (state is ProfileErrorState) {
//               return _buildErrorState(state.message);
//             }
            
//             return Container();
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileHeader(profile) {
//     return Column(
//       children: [
//         ProfileImagePicker(
//           imageUrl: profile.profileImageUrl,
//           selectedImage: _selectedImage,
//           isEditing: _isEditing,
//           onImageSelected: (image) {
//             setState(() {
//               _selectedImage = image;
//             });
//           },
//         ),
//         SizedBox(height: AppConstants.paddingMedium),
//         Text(
//           profile.name,
//           style: Theme.of(context).textTheme.headlineMedium,
//         ),
//         if (profile.bio != null && profile.bio!.isNotEmpty) ...[
//           SizedBox(height: AppConstants.paddingSmall),
//           Text(
//             profile.bio!,
//             textAlign: TextAlign.center,
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//               color: AppConstants.textSecondary,
//             ),
//           ),
//         ],
//         SizedBox(height: AppConstants.paddingSmall),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               profile.isVerified ? Icons.verified : Icons.pending,
//               color: profile.isVerified 
//                   ? AppConstants.successGreen 
//                   : AppConstants.warningAmber,
//               size: 16,
//             ),
//             SizedBox(width: 4),
//             Text(
//               profile.isVerified ? 'Verified' : 'Pending Verification',
//               style: TextStyle(
//                 color: profile.isVerified 
//                     ? AppConstants.successGreen 
//                     : AppConstants.warningAmber,
//                 fontSize: 12,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildPersonalInfoSection() {
//     return ProfileInfoCard(
//       title: 'Personal Information',
//       children: [
//         CustomTextField(
//           controller: _nameController,
//           label: 'Full Name',
//           enabled: _isEditing,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please enter your name';
//             }
//             return null;
//           },
//         ),
//         SizedBox(height: AppConstants.paddingMedium),
//         CustomTextField(
//           controller: _bioController,
//           label: 'Bio',
//           hint: 'Tell us about yourself...',
//           maxLines: 3,
//           enabled: _isEditing,
//         ),
//         SizedBox(height: AppConstants.paddingMedium),
//         _buildDateOfBirthField(),
//         SizedBox(height: AppConstants.paddingMedium),
//         _buildGenderField(),
//         SizedBox(height: AppConstants.paddingMedium),
//         CustomTextField(
//           controller: _occupationController,
//           label: 'Occupation',
//           enabled: _isEditing,
//         ),
//       ],
//     );
//   }

//   Widget _buildContactInfoSection() {
//     return ProfileInfoCard(
//       title: 'Contact Information',
//       children: [
//         CustomTextField(
//           controller: _emailController,
//           label: 'Email',
//           keyboardType: TextInputType.emailAddress,
//           enabled: _isEditing,
//           validator: (value) {
//             if (value != null && value.isNotEmpty) {
//               if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                 return 'Please enter a valid email';
//               }
//             }
//             return null;
//           },
//         ),
//         SizedBox(height: AppConstants.paddingMedium),
//         CustomTextField(
//           controller: _phoneController,
//           label: 'Phone Number',
//           keyboardType: TextInputType.phone,
//           enabled: false, // Phone number should not be editable
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Phone number is required';
//             }
//             return null;
//           },
//         ),
//         SizedBox(height: AppConstants.paddingMedium),
//         CustomTextField(
//           controller: _locationController,
//           label: 'Location',
//           enabled: _isEditing,
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please enter your location';
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildAdditionalInfoSection() {
//     return ProfileInfoCard(
//       title: 'Account Information',
//       children: [
//         ListTile(
//           leading: Icon(Icons.calendar_today, color: AppConstants.primaryGreen),
//           title: Text('Member Since'),
//           subtitle: Text(_formatDate(DateTime.now())), // This should be profile.createdAt
//           contentPadding: EdgeInsets.zero,
//         ),
//         ListTile(
//           leading: Icon(Icons.report, color: AppConstants.primaryGreen),
//           title: Text('Total Reports'),
//           subtitle: Text('0 reports submitted'), // This should come from user stats
//           contentPadding: EdgeInsets.zero,
//         ),
//       ],
//     );
//   }

//   Widget _buildDateOfBirthField() {
//     return InkWell(
//       onTap: _isEditing ? _selectDateOfBirth : null,
//       child: InputDecorator(
//         decoration: InputDecoration(
//           labelText: 'Date of Birth',
//           border: OutlineInputBorder(),
//           suffixIcon: Icon(Icons.calendar_today),
//         ),
//         child: Text(
//           _selectedDateOfBirth != null 
//               ? _formatDate(_selectedDateOfBirth!)
//               : 'Select date of birth',
//           style: TextStyle(
//             color: _selectedDateOfBirth != null 
//                 ? Theme.of(context).textTheme.bodyLarge?.color
//                 : Theme.of(context).hintColor,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildGenderField() {
//     return DropdownButtonFormField<String>(
//       value: _selectedGender,
//       decoration: InputDecoration(
//         labelText: 'Gender',
//         border: OutlineInputBorder(),
//       ),
//       items: ['Male', 'Female', 'Other', 'Prefer not to say']
//           .map((gender) => DropdownMenuItem(
//                 value: gender,
//                 child: Text(gender),
//               ))
//           .toList(),
//       onChanged: _isEditing ? (value) {
//         setState(() {
//           _selectedGender = value;
//         });
//       } : null,
//     );
//   }

//   Widget _buildActionButtons() {
//     return Row(
//       children: [
//         Expanded(
//           child: OutlinedButton(
//             onPressed: () {
//               setState(() {
//                 _isEditing = false;
//                 // Reset form to original values
//                 context.read<ProfileBloc>().add(LoadProfileEvent());
//               });
//             },
//             child: Text('Cancel'),
//           ),
//         ),
//         SizedBox(width: AppConstants.paddingMedium),
//         Expanded(
//           child: ElevatedButton(
//             onPressed: _saveProfile,
//             child: Text('Save Changes'),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildErrorState(String message) {
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
//             'Error Loading Profile',
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
//               context.read<ProfileBloc>().add(LoadProfileEvent());
//             },
//             child: Text('Retry'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _populateFields(profile) {
//     _nameController.text = profile.name;
//     _emailController.text = profile.email;
//     _phoneController.text = profile.phone;
//     _locationController.text = profile.location;
//     _bioController.text = profile.bio ?? '';
//     _occupationController.text = profile.occupation ?? '';
//     _selectedDateOfBirth = profile.dateOfBirth;
//     _selectedGender = profile.gender;
//   }

//   Future<void> _selectDateOfBirth() async {
//     final date = await showDatePicker(
//       context: context,
//       initialDate: _selectedDateOfBirth ?? DateTime.now().subtract(Duration(days: 365 * 18)),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );

//     if (date != null) {
//       setState(() {
//         _selectedDateOfBirth = date;
//       });
//     }
//   }

//   void _saveProfile() {
//     if (_formKey.currentState?.validate() ?? false) {
//       context.read<ProfileBloc>().add(
//         UpdateProfileEvent(
//           name: _nameController.text,
//           email: _emailController.text,
//           location: _locationController.text,
//           bio: _bioController.text,
//           occupation: _occupationController.text,
//           dateOfBirth: _selectedDateOfBirth,
//           gender: _selectedGender,
//           profileImage: _selectedImage,
//         ),
//       );
//     }
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year}';
//   }
// }
