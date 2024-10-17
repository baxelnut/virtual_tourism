import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/firebase/auth/auth.dart';


class UserProfile extends StatelessWidget {
  UserProfile({super.key});

  final user = FirebaseAuth.instance.currentUser;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  void handleProfileClick(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: ClipOval(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Image.asset(
                user?.photoURL ?? 'assets/profile.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          content: const Text(
            'This is your profile picture',
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
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
                        onTap: () => handleProfileClick(context),
                        child: CircleAvatar(
                          radius: 69,
                          backgroundImage: AssetImage(
                            user?.photoURL ?? 'assets/profile.png',
                          ),
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
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SizedBox(
                            child: _inputSection(
                              label: 'Gender',
                              theme: theme,
                            ),
                          ),
                        ),
                        Expanded(
                          child: _inputSection(
                            label: 'Birthday',
                            theme: theme,
                          ),
                        ),
                      ],
                    ),
                    _inputSection(
                      label: 'Phone number',
                      controller: _phoneNumberController,
                      theme: theme,
                    ),
                    Text(Auth().currentUser!.emailVerified.toString()),
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

  Widget _inputSection(
      {required String label, required ThemeData theme, controller}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: controller,
        // onSubmitted: (value) {},
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 0.5),
          ),
          label: Text(label, style: theme.textTheme.bodyLarge),
        ),
      ),
    );
  }

  Widget saveChanges({required ThemeData theme, required Size screenSize}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          fixedSize: Size(screenSize.width, 60),
          backgroundColor: theme.colorScheme.primary),
      onPressed: () {},
      child: Text(
        'Save',
        style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold, color: theme.colorScheme.onPrimary),
      ),
    );
  }
}
