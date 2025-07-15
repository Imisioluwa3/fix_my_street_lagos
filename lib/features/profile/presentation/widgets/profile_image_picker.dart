// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// import '../../../../core/constants/app_constants.dart';

// class ProfileImagePicker extends StatelessWidget {
//   final String? imageUrl;
//   final File? selectedImage;
//   final bool isEditing;
//   final Function(File) onImageSelected;

//   const ProfileImagePicker({
//     Key? key,
//     this.imageUrl,
//     this.selectedImage,
//     required this.isEditing,
//     required this.onImageSelected,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         CircleAvatar(
//           radius: 60,
//           backgroundColor: AppConstants.primaryGreen.withOpacity(0.1),
//           child: _buildImage(),
//         ),
//         if (isEditing)
//           Positioned(
//             bottom: 0,
//             right: 0,
//             child: GestureDetector(
//               onTap: () => _showImageSourceDialog(context),
//               child: Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: AppConstants.primaryGreen,
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.white, width: 2),
//                 ),
//                 child: Icon(
//                   Icons.camera_alt,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildImage() {
//     if (selectedImage != null) {
//       return ClipOval(
//         child: Image.file(
//           selectedImage!,
//           width: 120,
//           height: 120,
//           fit: BoxFit.cover,
//         ),
//       );
//     } else if (imageUrl != null && imageUrl!.isNotEmpty) {
//       return ClipOval(
//         child: CachedNetworkImage(
//           imageUrl: imageUrl!,
//           width: 120,
//           height: 120,
//           fit: BoxFit.cover,
//           placeholder: (context, url) => CircularProgressIndicator(),
//           errorWidget: (context, url, error) => Icon(
//             Icons.person,
//             size: 60,
//             color: AppConstants.primaryGreen,
//           ),
//         ),
//       );
//     } else {
//       return Icon(
//         Icons.person,
//         size: 60,
//         color: AppConstants.primaryGreen,
//       );
//     }
//   }

//   void _showImageSourceDialog(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: Icon(Icons.photo_camera),
//               title: Text('Camera'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _pickImage(ImageSource.camera);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.photo_library),
//               title: Text('Gallery'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _pickImage(ImageSource.gallery);
//               },
//             ),
//             if (imageUrl != null || selectedImage != null)
//               ListTile(
//                 leading: Icon(Icons.delete, color: AppConstants.errorRed),
//                 title: Text('Remove Photo', style: TextStyle(color: AppConstants.errorRed)),
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Handle remove photo
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(
//       source: source,
//       maxWidth: 800,
//       maxHeight: 800,
//       imageQuality: 85,
//     );

//     if (pickedFile != null) {
//       onImageSelected(File(pickedFile.path));
//     }
//   }
// }
