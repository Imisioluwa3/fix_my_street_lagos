# Flutter Firebase App

A comprehensive Flutter application demonstrating Firebase integration with authentication and real-time data storage.

## Features

### 🔐 Authentication
- **Email/Password Authentication**: Secure sign-up and login with email validation
- **Phone Authentication**: SMS-based verification with international phone number support
- **Password Reset**: Email-based password recovery
- **Profile Management**: Update user profile information
- **Account Linking**: Link phone numbers to existing email accounts

### 📱 Real-time Data Management
- **CRUD Operations**: Create, read, update, and delete notes
- **Real-time Sync**: Instant updates across all devices
- **Search Functionality**: Search notes by title, content, or tags
- **Tagging System**: Organize notes with custom tags
- **Important Notes**: Mark notes as important for quick access
- **Batch Operations**: Delete multiple notes at once

### 🎨 User Interface
- **Material Design 3**: Modern, clean interface following Material Design guidelines
- **Dark/Light Theme**: Automatic theme switching based on system preferences
- **Responsive Design**: Optimized for different screen sizes
- **Loading States**: Smooth loading animations and progress indicators
- **Error Handling**: User-friendly error messages and validation

### 🔒 Security
- **Row Level Security**: Firestore security rules ensure users can only access their own data
- **Input Validation**: Comprehensive form validation for all user inputs
- **Secure Authentication**: Firebase Authentication with industry-standard security
- **Data Encryption**: All data encrypted in transit and at rest

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── models/                   # Data models
│   ├── user_model.dart
│   └── note_model.dart
├── services/                 # Business logic services
│   ├── auth_service.dart
│   └── firestore_service.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   └── data_provider.dart
├── screens/                  # UI screens
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── signup_screen.dart
│   │   ├── phone_auth_screen.dart
│   │   ├── otp_verification_screen.dart
│   │   └── forgot_password_screen.dart
│   └── home/
│       ├── home_screen.dart
│       ├── add_edit_note_screen.dart
│       ├── profile_screen.dart
│       └── search_screen.dart
├── widgets/                  # Reusable UI components
│   ├── loading_overlay.dart
│   ├── note_card.dart
│   └── empty_state.dart
└── utils/                    # Utilities and helpers
    ├── app_theme.dart
    └── validators.dart
```

## Dependencies

### Core Dependencies
- `firebase_core`: Firebase SDK core functionality
- `firebase_auth`: Authentication services
- `cloud_firestore`: NoSQL database
- `provider`: State management solution

### UI Dependencies
- `google_fonts`: Custom fonts from Google Fonts
- `loading_animation_widget`: Loading animations
- `fluttertoast`: Toast notifications

### Utility Dependencies
- `email_validator`: Email validation
- `connectivity_plus`: Network connectivity checking

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio or VS Code with Flutter extensions
- Firebase account

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd flutter_firebase_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   
   Follow the detailed [Firebase Setup Guide](FIREBASE_SETUP.md) to:
   - Create a Firebase project
   - Configure authentication (email/password and phone)
   - Set up Firestore database
   - Configure platform-specific settings

4. **Run the app**
   ```bash
   flutter run
   ```

## Firebase Configuration

### Authentication Methods
- **Email/Password**: Standard email-based authentication
- **Phone**: SMS verification with international support
- **Password Reset**: Email-based password recovery

### Firestore Database Structure
```
users/
├── {userId}/
│   ├── uid: string
│   ├── email: string
│   ├── displayName: string?
│   ├── phoneNumber: string?
│   ├── photoURL: string?
│   ├── createdAt: timestamp
│   └── lastLoginAt: timestamp

notes/
├── {noteId}/
│   ├── title: string
│   ├── content: string
│   ├── userId: string
│   ├── createdAt: timestamp
│   ├── updatedAt: timestamp
│   ├── tags: array<string>
│   └── isImportant: boolean
```

### Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own user document
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Users can only access their own notes
    match /notes/{noteId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
      allow create: if request.auth != null && 
        request.auth.uid == request.resource.data.userId;
    }
  }
}
```

## Key Features Implementation

### State Management
The app uses Provider for state management with two main providers:
- **AuthProvider**: Manages authentication state and user data
- **DataProvider**: Handles note data and Firestore operations

### Real-time Updates
Firestore streams provide real-time updates:
```dart
Stream<List<NoteModel>> getUserNotes(String userId) {
  return _notesCollection
      .where('userId', isEqualTo: userId)
      .orderBy('updatedAt', descending: true)
      .snapshots()
      .map((snapshot) => /* convert to NoteModel list */);
}
```

### Form Validation
Comprehensive validation for all user inputs:
- Email format validation
- Strong password requirements
- Phone number format checking
- Required field validation

### Error Handling
- Network connectivity checking
- Firebase error code translation
- User-friendly error messages
- Graceful fallbacks for offline scenarios

## Testing

### Unit Tests
Run unit tests for business logic:
```bash
flutter test
```

### Integration Tests
Test complete user flows:
```bash
flutter test integration_test/
```

### Manual Testing Checklist
- [ ] Email sign-up and login
- [ ] Phone number verification
- [ ] Password reset functionality
- [ ] Note creation, editing, and deletion
- [ ] Real-time synchronization
- [ ] Search functionality
- [ ] Offline behavior
- [ ] Error handling scenarios

## Deployment

### Android
1. Generate a signed APK:
   ```bash
   flutter build apk --release
   ```

2. Or build an App Bundle:
   ```bash
   flutter build appbundle --release
   ```

### iOS
1. Build for iOS:
   ```bash
   flutter build ios --release
   ```

2. Archive and upload via Xcode

### Web
1. Build for web:
   ```bash
   flutter build web --release
   ```

2. Deploy to Firebase Hosting:
   ```bash
   firebase deploy --only hosting
   ```

## Performance Optimization

### Implemented Optimizations
- **Lazy Loading**: Notes loaded on-demand
- **Image Optimization**: Efficient image loading and caching
- **State Management**: Minimal rebuilds with Provider
- **Database Indexing**: Optimized Firestore queries
- **Code Splitting**: Modular architecture for better performance

### Best Practices
- Use `const` constructors where possible
- Implement proper disposal of controllers and streams
- Optimize Firestore queries with proper indexing
- Use pagination for large datasets
- Implement offline caching strategies

## Security Considerations

### Data Protection
- All user data encrypted in transit and at rest
- Firestore security rules prevent unauthorized access
- Input validation prevents injection attacks
- Secure authentication with Firebase Auth

### Privacy
- Minimal data collection
- User consent for data processing
- Secure data transmission
- Regular security audits

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style
- Follow Dart/Flutter style guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Maintain consistent formatting

## Troubleshooting

### Common Issues

1. **Firebase not initialized**
   - Ensure `Firebase.initializeApp()` is called in `main()`
   - Check `firebase_options.dart` configuration

2. **Phone authentication fails**
   - Verify SHA fingerprints in Firebase Console
   - Check Android minimum SDK version (21+)
   - Ensure proper iOS configuration

3. **Firestore permission denied**
   - Check security rules
   - Verify user authentication
   - Ensure proper user ID matching

### Debug Commands
```bash
# Clean build
flutter clean && flutter pub get

# Verbose logging
flutter run --verbose

# Check dependencies
flutter doctor

# Analyze code
flutter analyze
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support and questions:
- Check the [Firebase Setup Guide](FIREBASE_SETUP.md)
- Review [Flutter documentation](https://flutter.dev/docs)
- Visit [Firebase documentation](https://firebase.google.com/docs)

## Acknowledgments

- Flutter team for the amazing framework
- Firebase team for the backend services
- Material Design team for the design system
- Open source community for the packages used