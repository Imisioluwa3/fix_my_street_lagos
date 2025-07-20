import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:flutter/foundation.dart';  // for kIsWeb
// import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

// Firebase Options - Replace with your project config
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'AIzaSyD8-tonJqJa0On6yXU_hYZRMEpRQtp707I',
      appId: '1:527633615990:web:be667d61ecad8e5f5ba357',
      messagingSenderId: '527633615990',
      projectId: 'fixmystreet-lagos',
      storageBucket: 'fixmystreet-lagos.firebasestorage.app',
      authDomain: 'fixmystreet-lagos.firebaseapp.com', // Added missing authDomain
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(FixMyStreetApp());
}

class FixMyStreetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FixMyStreet Lagos',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Color(0xFF008751),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF008751),
          foregroundColor: Colors.white,
        ),
      ),
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomePage();
        }
        return LoginPage();
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  String _verificationId = '';
  bool _codeSent = false;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF008751),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_city, size: 100, color: Colors.white),
              SizedBox(height: 20),
              Text(
                'FixMyStreet Lagos',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Text(
                'Report infrastructure issues in Lagos',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              SizedBox(height: 40),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    if (!_codeSent) ...[
                      TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          hintText: '+234xxxxxxxxxx',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loading ? null : _verifyPhone,
                        child: _loading ? CircularProgressIndicator() : Text('Send Code'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                    ] else ...[
                      TextField(
                        controller: _smsController,
                        decoration: InputDecoration(
                          labelText: 'Verification Code',
                          prefixIcon: Icon(Icons.sms),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loading ? null : _verifyCode,
                        child: _loading ? CircularProgressIndicator() : Text('Verify'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() {
                          _codeSent = false;
                          _phoneController.clear();
                          _smsController.clear();
                        }),
                        child: Text('Change Phone Number'),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Updated authentication methods in _LoginPageState

void _verifyPhone() async {
  if (_phoneController.text.trim().isEmpty) {
    _showError('Please enter a phone number');
    return;
  }

  // Format phone number for Nigeria
  String phoneNumber = _formatPhoneNumber(_phoneController.text.trim());
  
  setState(() => _loading = true);

  try {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          await FirebaseAuth.instance.signInWithCredential(credential);
          setState(() => _loading = false);
        } catch (e) {
          setState(() => _loading = false);
          _showError('Auto sign-in failed: ${e.toString()}');
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() => _loading = false);
        _handleVerificationError(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _codeSent = true;
          _loading = false;
        });
        _showSuccess('Verification code sent to $phoneNumber');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
        if (mounted) setState(() => _loading = false);
      },
    );
  } catch (e) {
    setState(() => _loading = false);
    _showError('Phone verification setup failed. Please try again.');
    print('Phone verification error: $e');
  }
}

String _formatPhoneNumber(String phoneNumber) {
  // Remove all non-digit characters except +
  String cleaned = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
  
  if (cleaned.startsWith('+234')) {
    return cleaned;
  } else if (cleaned.startsWith('234')) {
    return '+$cleaned';
  } else if (cleaned.startsWith('0')) {
    return '+234${cleaned.substring(1)}';
  } else if (cleaned.length == 10) {
    return '+234$cleaned';
  } else {
    return '+234$cleaned';
  }
}

void _handleVerificationError(FirebaseAuthException e) {
  String errorMessage;
  switch (e.code) {
    case 'invalid-phone-number':
      errorMessage = 'Please enter a valid Nigerian phone number';
      break;
    case 'too-many-requests':
      errorMessage = 'Too many attempts. Please try again in a few minutes';
      break;
    case 'quota-exceeded':
      errorMessage = 'SMS quota exceeded. Please try again later';
      break;
    case 'captcha-check-failed':
      errorMessage = 'reCAPTCHA verification failed. Please refresh and try again';
      break;
    case 'missing-phone-number':
      errorMessage = 'Phone number is required';
      break;
    default:
      errorMessage = 'Verification failed: ${e.message ?? 'Unknown error'}';
      print('Firebase Auth Error Code: ${e.code}');
      print('Firebase Auth Error Message: ${e.message}');
  }
  _showError(errorMessage);
}

void _verifyCode() async {
    String code = _smsController.text.trim();
    if (code.isEmpty) {
      _showError('Please enter the 6-digit verification code');
      return;
    }
    
    if (code.length != 6) {
      _showError('Verification code must be 6 digits');
      return;
    }

    setState(() => _loading = true);
    
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: code,
      );
      
      UserCredential result = await FirebaseAuth.instance.signInWithCredential(credential);
      
      if (result.user != null) {
        // Successfully signed in
        setState(() => _loading = false);
      }
    } catch (e) {
      setState(() => _loading = false);
      
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-verification-code':
            _showError('Invalid verification code. Please check and try again');
            break;
          case 'session-expired':
          case 'code-expired':
            _showError('Code expired. Please request a new verification code');
            _resetToPhoneInput();
            break;
          default:
            _showError('Verification failed: ${e.message ?? 'Unknown error'}');
        }
      } else {
        _showError('Verification failed. Please try again');
      }
      print('Code verification error: $e');
    }
}

  void _resetToPhoneInput() {
    setState(() {
      _codeSent = false;
      _smsController.clear();
    });
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showSuccess(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FixMyStreet Lagos'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: [
          DashboardScreen(),
          ReportIssueScreen(),
          MyReportsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'My Reports'),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to FixMyStreet Lagos',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Report infrastructure issues in your community and help build a better Lagos.',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Recent Reports',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('reports')
                  .orderBy('createdAt', descending: true)
                  .limit(10)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No reports yet. Be the first to report an issue!'),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var report = snapshot.data!.docs[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: _getCategoryIcon(report['category']),
                        title: Text(report['title']),
                        subtitle: Text(report['description']),
                        trailing: _getStatusChip(report['status']),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCategoryIcon(String category) {
    IconData icon;
    Color color;
    switch (category.toLowerCase()) {
      case 'roads':
        icon = Icons.construction;
        color = Colors.orange;
        break;
      case 'waste':
        icon = Icons.delete;
        color = Colors.green;
        break;
      case 'utilities':
        icon = Icons.electrical_services;
        color = Colors.blue;
        break;
      default:
        icon = Icons.report;
        color = Colors.grey;
    }
    return CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.white));
  }

  Widget _getStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'submitted':
        color = Colors.blue;
        break;
      case 'in progress':
        color = Colors.orange;
        break;
      case 'resolved':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }
    return Chip(
      label: Text(status, style: TextStyle(color: Colors.white, fontSize: 12)),
      backgroundColor: color,
    );
  }
}

class ReportIssueScreen extends StatefulWidget {
  @override
  _ReportIssueScreenState createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = 'Roads';
  List<String> _categories = ['Roads', 'Waste', 'Utilities', 'Public Facilities'];
  File? _image;
  Position? _location;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Text(
              'Report an Issue',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) => setState(() => _selectedCategory = value!),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Issue Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty == true ? 'Please enter a title' : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              validator: (value) => value?.isEmpty == true ? 'Please enter a description' : null,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.camera_alt),
                    label: Text('Add Photo'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _getCurrentLocation,
                    icon: Icon(Icons.location_on),
                    label: Text('Get Location'),
                  ),
                ),
              ],
            ),
            if (_image != null) ...[
              SizedBox(height: 16),
              Image.file(_image!, height: 200, fit: BoxFit.cover),
            ],
            if (_location != null) ...[
              SizedBox(height: 16),
              Text('Location: ${_location!.latitude.toStringAsFixed(4)}, ${_location!.longitude.toStringAsFixed(4)}'),
            ],
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _submitReport,
              child: _loading ? CircularProgressIndicator() : Text('Submit Report'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  void _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location services are disabled')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permission denied')),
        );
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() => _location = position);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location')),
      );
    }
  }

  void _submitReport() async {
    if (!_formKey.currentState!.validate()) return;
    if (_location == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add location')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      String? imageUrl;
      if (_image != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('report_images')
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
        await storageRef.putFile(_image!);
        imageUrl = await storageRef.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection('reports').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'category': _selectedCategory,
        'imageUrl': imageUrl,
        'latitude': _location!.latitude,
        'longitude': _location!.longitude,
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'status': 'Submitted',
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Report submitted successfully!')),
      );

      // Clear form
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _image = null;
        _location = null;
        _selectedCategory = 'Roads';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit report: $e')),
      );
    }

    setState(() => _loading = false);
  }
}

class MyReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Reports',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('reports')
                  .where('userId', isEqualTo: userId)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No reports yet. Create your first report!'),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var report = snapshot.data!.docs[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  report['title'],
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                _getStatusChip(report['status']),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(report['description']),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.category, size: 16, color: Colors.grey),
                                SizedBox(width: 4),
                                Text(report['category'], style: TextStyle(color: Colors.grey)),
                                SizedBox(width: 16),
                                Icon(Icons.location_on, size: 16, color: Colors.grey),
                                SizedBox(width: 4),
                                Text(
                                  '${report['latitude'].toStringAsFixed(4)}, ${report['longitude'].toStringAsFixed(4)}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            if (report['imageUrl'] != null) ...[
                              SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  report['imageUrl'],
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'submitted':
        color = Colors.blue;
        break;
      case 'in progress':
        color = Colors.orange;
        break;
      case 'resolved':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }
    return Chip(
      label: Text(status, style: TextStyle(color: Colors.white, fontSize: 12)),
      backgroundColor: color,
    );
  }
}