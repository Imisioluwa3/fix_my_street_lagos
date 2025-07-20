# Firebase Setup Guide for Flutter App

This guide will walk you through setting up Firebase for your Flutter application with authentication and Firestore database.

## Prerequisites

- Flutter SDK installed
- Android Studio or VS Code with Flutter extensions
- Google account for Firebase Console

## Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter your project name (e.g., "flutter-firebase-app")
4. Choose whether to enable Google Analytics (recommended)
5. Select or create a Google Analytics account
6. Click "Create project"

## Step 2: Install FlutterFire CLI

The FlutterFire CLI is the easiest way to configure Firebase for Flutter.

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Verify installation
flutterfire --version
```

## Step 3: Configure Firebase for Your Flutter App

1. Navigate to your Flutter project directory
2. Run the FlutterFire configuration command:

```bash
flutterfire configure
```

3. Select your Firebase project from the list
4. Choose the platforms you want to support (iOS, Android, Web)
5. The CLI will automatically:
   - Create platform-specific configuration files
   - Generate `firebase_options.dart`
   - Update your `pubspec.yaml` with required dependencies

## Step 4: Enable Authentication

### Email/Password Authentication

1. In Firebase Console, go to **Authentication** > **Sign-in method**
2. Click on **Email/Password**
3. Enable **Email/Password** authentication
4. Optionally enable **Email link (passwordless sign-in)**
5. Click **Save**

### Phone Authentication

1. In the same **Sign-in method** tab, click on **Phone**
2. Enable **Phone** authentication
3. Add your phone number for testing (optional)
4. Click **Save**

**Important for Phone Authentication:**
- For Android: Add SHA-1 and SHA-256 fingerprints to your app
- For iOS: Enable push notifications in your app

### Get SHA Fingerprints (Android)

```bash
# Debug SHA-1
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# For release builds, use your release keystore
keytool -list -v -keystore /path/to/your/release-keystore.jks -alias your-alias
```

Add these fingerprints in Firebase Console:
1. Go to **Project Settings** > **Your apps**
2. Select your Android app
3. Scroll down to **SHA certificate fingerprints**
4. Click **Add fingerprint** and paste your SHA-1 and SHA-256

## Step 5: Configure Firestore Database

1. In Firebase Console, go to **Firestore Database**
2. Click **Create database**
3. Choose **Start in test mode** (for development)
4. Select a location for your database (choose closest to your users)
5. Click **Done**

### Set Up Security Rules

Replace the default rules with these production-ready rules:

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

## Step 6: Configure Phone Authentication (Additional Setup)

### Android Configuration

1. **Add SHA fingerprints** (as shown in Step 4)

2. **Update `android/app/build.gradle`:**
```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        minSdkVersion 21  // Required for phone auth
        targetSdkVersion 34
        multiDexEnabled true
    }
}

dependencies {
    implementation 'androidx.multidex:multidex:2.0.1'
}
```

3. **Update `android/app/src/main/AndroidManifest.xml`:**
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Add internet permission -->
    <uses-permission android:name="android.permission.INTERNET" />
    
    <application
        android:name="${applicationName}"
        android:exported="true"
        android:icon="@mipmap/ic_launcher"
        android:label="flutter_firebase_app">
        
        <!-- Add this activity for phone auth -->
        <activity
            android:name="com.google.firebase.auth.internal.RecaptchaActivity"
            android:exported="true"
            android:theme="@android:style/Theme.Translucent.NoTitleBar" />
            
        <!-- Your main activity -->
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme">
            <!-- ... -->
        </activity>
    </application>
</manifest>
```

### iOS Configuration

1. **Update `ios/Runner/Info.plist`:**
```xml
<dict>
    <!-- Add URL scheme for Firebase Auth -->
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleURLName</key>
            <string>REVERSED_CLIENT_ID</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>YOUR_REVERSED_CLIENT_ID</string>
            </array>
        </dict>
    </array>
    
    <!-- Enable push notifications -->
    <key>UIBackgroundModes</key>
    <array>
        <string>remote-notification</string>
    </array>
</dict>
```

Replace `YOUR_REVERSED_CLIENT_ID` with the value from `ios/Runner/GoogleService-Info.plist`.

2. **Enable Push Notifications:**
   - In Xcode, select your project
   - Go to **Signing & Capabilities**
   - Click **+ Capability**
   - Add **Push Notifications**

## Step 7: Test Phone Authentication

### Add Test Phone Numbers (Optional)

For development, you can add test phone numbers:

1. Go to **Authentication** > **Sign-in method**
2. Click on **Phone**
3. Scroll down to **Phone numbers for testing**
4. Add phone numbers with their verification codes
5. Click **Save**

Example:
- Phone: +1 555-555-5555
- Code: 123456

## Step 8: Environment Variables

Create a `.env` file in your project root (optional, for additional configuration):

```env
# Firebase Configuration (already handled by firebase_options.dart)
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_API_KEY=your-api-key

# Additional app configuration
APP_NAME=Flutter Firebase App
APP_VERSION=1.0.0
```

## Step 9: Initialize Firebase in Your App

The FlutterFire CLI should have already updated your `lib/main.dart`, but ensure it looks like this:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(MyApp());
}
```

## Step 10: Update Dependencies

Ensure your `pubspec.yaml` has all required dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  
  # Phone Auth (if using the phone_auth_handler package)
  firebase_phone_auth_handler: ^1.0.8
  
  # Other dependencies...
```

Run:
```bash
flutter pub get
```

## Step 11: Testing

### Test Email Authentication
1. Run your app
2. Try signing up with a new email
3. Check Firebase Console > Authentication > Users

### Test Phone Authentication
1. Use a real phone number or test number
2. Verify you receive SMS (for real numbers)
3. Enter the verification code
4. Check Firebase Console > Authentication > Users

### Test Firestore
1. Create a note in your app
2. Check Firebase Console > Firestore Database
3. Verify the note appears with correct user association

## Troubleshooting

### Common Issues

1. **"Default FirebaseApp is not initialized"**
   - Ensure `Firebase.initializeApp()` is called before `runApp()`
   - Check that `firebase_options.dart` exists and is imported

2. **Phone authentication not working on Android**
   - Verify SHA fingerprints are added to Firebase Console
   - Check that `minSdkVersion` is at least 21
   - Ensure internet permission is added to AndroidManifest.xml

3. **iOS build issues**
   - Run `cd ios && pod install`
   - Ensure `GoogleService-Info.plist` is added to the iOS project
   - Check that URL schemes are correctly configured

4. **Firestore permission denied**
   - Check your security rules
   - Ensure user is authenticated before accessing Firestore
   - Verify the user ID matches the document owner

### Debug Commands

```bash
# Clean and rebuild
flutter clean
flutter pub get

# For iOS
cd ios && pod install && cd ..

# Check Firebase configuration
flutterfire configure --reconfigure

# Run with verbose logging
flutter run --verbose
```

## Security Best Practices

1. **Never commit sensitive data:**
   - Add `google-services.json` and `GoogleService-Info.plist` to `.gitignore` if they contain sensitive data
   - Use environment variables for sensitive configuration

2. **Update Firestore rules for production:**
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
       
       match /notes/{noteId} {
         allow read, write: if request.auth != null && 
           request.auth.uid == resource.data.userId;
         allow create: if request.auth != null && 
           request.auth.uid == request.resource.data.userId;
       }
     }
   }
   ```

3. **Enable App Check** (for production):
   - Go to Firebase Console > App Check
   - Register your app
   - Enable enforcement for Firestore and Authentication

## Next Steps

1. **Add more authentication providers** (Google, Apple, etc.)
2. **Implement offline support** with Firestore offline persistence
3. **Add push notifications** using Firebase Cloud Messaging
4. **Set up Firebase Analytics** for user behavior tracking
5. **Configure Firebase Crashlytics** for crash reporting

## Support

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)
- [Flutter Firebase Samples](https://github.com/firebase/flutterfire/tree/master/packages)

Your Firebase setup is now complete! The app should be able to authenticate users via email/password and phone number, and store data securely in Firestore.