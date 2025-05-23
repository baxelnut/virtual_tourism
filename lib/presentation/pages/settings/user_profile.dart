import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/global_values.dart';
import '../../../services/firebase/api/users_service.dart';

class UserProfile extends StatefulWidget {
  final bool isAdmin;
  const UserProfile({
    super.key,
    required this.isAdmin,
  });

  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  final User? user = GlobalValues.user;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  final UsersService _usersService = UsersService();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool isUploading = false;
  String _selectedGender = 'Prefer not to say';
  DateTime? _selectedBirthday;

  @override
  void initState() {
    super.initState();
    _initializeProfile();
  }

  Future<void> _initializeProfile() async {
    _emailController.text = user?.email ?? '';
    _usernameController.text = user?.displayName ?? '';
    _phoneNumberController.text = user?.phoneNumber ?? '';
    _selectedGender = 'Prefer not to say';

    final profileData = await _usersService.getUserData(user!.uid);
    if (profileData != null) {
      setState(() {
        _usernameController.text = profileData['username'] ?? '';
        _phoneNumberController.text = profileData['phoneNumber'] ?? '';
        _selectedGender = profileData['gender'] ?? 'Prefer not to say';
        _selectedBirthday = DateTime.tryParse(profileData['birthday'] ?? '');
        _birthdayController.text = _selectedBirthday != null
            ? "${_selectedBirthday!.toLocal()}".split(' ')[0]
            : '';
      });
    }
  }

  Future<void> handleProfileClick(
    BuildContext context,
    ThemeData theme,
  ) async {
    if (!mounted) return;

    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    Widget changePhoto() {
      return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.onSurface,
        ),
        onPressed: () async {
          navigator.pop();

          if (mounted) {
            setState(() {
              isUploading = true;
            });
          }

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );

          String? updatedUrl = await _usersService.updateProfilePicture(
            userUid: user!.uid,
          );

          navigator.pop();

          if (mounted) {
            setState(() {
              isUploading = false;
            });

            if (updatedUrl != null) {
              setState(() {
                user?.updatePhotoURL(updatedUrl);
              });
            } else {
              scaffoldMessenger.showSnackBar(
                const SnackBar(
                  content: Text('Failed to update profile picture'),
                ),
              );
            }
          }
        },
        icon: Icon(
          Icons.edit_rounded,
          color: theme.colorScheme.surface,
        ),
        label: Text(
          'Change',
          style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.surface, fontWeight: FontWeight.bold),
        ),
      );
    }

    Widget deletePhoto() {
      return IconButton(
        onPressed: () async {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          await user!.updatePhotoURL('not provided');
          await user?.reload();
        },
        icon: const Icon(
          Icons.delete_rounded,
          color: Colors.red,
          size: 30,
        ),
      );
    }

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: AspectRatio(
            aspectRatio: 1.0,
            child: Image(
              image: _getImageProvider(),
              fit: BoxFit.cover,
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              deletePhoto(),
              changePhoto(),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectBirthday(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime lastDate = now.subtract(const Duration(days: 365 * 9));
    final DateTime firstDate = now.subtract(const Duration(days: 365 * 100));

    final DateTime initialDate = _selectedBirthday != null &&
            (_selectedBirthday!.isBefore(lastDate) &&
                _selectedBirthday!.isAfter(firstDate))
        ? _selectedBirthday!
        : lastDate;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != _selectedBirthday) {
      setState(() {
        _selectedBirthday = picked;
        _birthdayController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    final RegExp phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  Future<void> _saveProfile() async {
    final phoneNumber = _phoneNumberController.text.trim();

    if (phoneNumber.isNotEmpty && !_isValidPhoneNumber(phoneNumber)) {
      showAlertDialog(context, 'Invalid phone number');
      return;
    }

    try {
      await _usersService.editUserProfile(
        userUid: user!.uid,
        username: _usernameController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        gender: _selectedGender,
        birthday: _selectedBirthday?.toIso8601String(),
      );
    } catch (e) {
      if (mounted) {
        showAlertDialog(context, e.toString());
      }
    }
  }

  _getImageProvider() {
    const invalidPhotoURLs = {
      'assets/profile.png',
      'not provided',
      'gs://virtual-tourism-7625f.appspot.com/users/.default/profile.png',
      'users/.default/profile.png',
    };

    if (user?.photoURL != null && !invalidPhotoURLs.contains(user?.photoURL)) {
      return NetworkImage(user!.photoURL!);
    } else {
      return const AssetImage('assets/profile.png');
    }
  }

  void showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Notification"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);
    final Size screenSize = GlobalValues.screenSize(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: GestureDetector(
                        onTap: () => handleProfileClick(context, theme),
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 69,
                              backgroundImage: _getImageProvider(),
                            ),
                            if (widget.isAdmin)
                              const Positioned(
                                bottom: 0,
                                right: 15,
                                child: Icon(
                                  Icons.verified_rounded,
                                  size: 26,
                                  color: Colors.blue,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    _inputSection(
                      label: 'Username',
                      controller: _usernameController,
                      theme: theme,
                    ),
                    _inputSection(
                      label: 'Email',
                      controller: _emailController,
                      theme: theme,
                      readOnly: true,
                    ),
                    _genderInputSection(theme),
                    GestureDetector(
                      onTap: () => _selectBirthday(context),
                      child: AbsorbPointer(
                        child: _inputSection(
                          label: 'Birthday',
                          controller: _birthdayController,
                          theme: theme,
                        ),
                      ),
                    ),
                    _inputSection(
                      label: 'Phone number',
                      controller: _phoneNumberController,
                      theme: theme,
                      keyboardType: TextInputType.phone,
                    ),
                    const Spacer(),
                    saveChanges(
                      theme: theme,
                      screenSize: screenSize,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _genderInputSection(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: DropdownButtonFormField<String>(
        value: _selectedGender.isNotEmpty &&
                ['Male', 'Female', 'Prefer not to say']
                    .contains(_selectedGender)
            ? _selectedGender
            : 'Prefer not to say',
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 0.5),
          ),
          labelText: 'Gender',
          labelStyle: theme.textTheme.bodyLarge,
        ),
        items: const [
          DropdownMenuItem(
            value: 'Male',
            child: Text('Male'),
          ),
          DropdownMenuItem(
            value: 'Female',
            child: Text('Female'),
          ),
          DropdownMenuItem(
            value: 'Prefer not to say',
            child: Text('Prefer not to say'),
          ),
        ],
        onChanged: (value) {
          setState(() {
            _selectedGender = value ?? 'Prefer not to say';
          });
        },
      ),
    );
  }

  Widget _inputSection({
    required String label,
    required ThemeData theme,
    TextEditingController? controller,
    bool readOnly = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 0.5),
          ),
          label: Text(
            label,
            style: theme.textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }

  Widget saveChanges({
    required ThemeData theme,
    required Size screenSize,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(screenSize.width, 50),
        backgroundColor: theme.colorScheme.primary,
      ),
      onPressed: () {
        _saveProfile();
        Navigator.pop(context);
      },
      child: Text(
        'Save',
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
