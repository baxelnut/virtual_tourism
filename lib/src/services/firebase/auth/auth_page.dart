import 'package:flutter/material.dart';

import '../../../app.dart';
import 'auth.dart';
import 'components/additional_action.dart';
import 'components/alternative_methods.dart';
import 'components/auth_button.dart';
import 'components/header_section.dart';
import 'components/input_section.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  List<bool> isSelected = [true, false];
  List<String> selectionOps = ['Login', 'Register'];

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final Auth _auth = Auth();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void switchSelected(int index) {
    setState(() {
      isSelected[0] = index == 0;
      isSelected[1] = index == 1;
    });
  }

  void showAlertDialog(BuildContext context, String message) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Notification"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "OK",
                style: theme.textTheme.titleMedium,
              ),
            ),
          ],
        );
      },
    );
  }

  void handleAuthentication(BuildContext context) async {
    bool isEmailFilled = _emailController.text.trim().isNotEmpty;
    bool isPasswordFilled = _passwordController.text.trim().isNotEmpty;
    bool isRegistering = isSelected[1];

    if (isEmailFilled && isPasswordFilled) {
      if (isRegistering) {
        bool isConfirmPasswordFilled =
            _confirmPasswordController.text.trim().isNotEmpty;
        bool passwordsMatch = _passwordController.text.trim() ==
            _confirmPasswordController.text.trim();

        if (isConfirmPasswordFilled && passwordsMatch) {
          try {
            await _auth.register(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

            if (context.mounted) {
              showAlertDialog(context, 'Successfully registered');
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const MyApp()),
              );
            }
          } catch (e) {
            if (context.mounted) {
              showAlertDialog(context, 'Failed to register: \n${e.toString()}');
            }
          }
        } else {
          if (context.mounted) {
            showAlertDialog(
              context,
              'Failed to register: \n${!isConfirmPasswordFilled ? 'Fill all fields' : 'Passwords do not match'}',
            );
          }
        }
      } else {
        try {
          await _auth.login(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

          if (context.mounted) {
            showAlertDialog(context, 'Successfully logged in');
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MyApp()),
            );
          }
        } catch (e) {
          if (context.mounted) {
            showAlertDialog(context, 'Failed to login: \n${e.toString()}');
          }
        }
      }
    } else {
      if (context.mounted) {
        showAlertDialog(context,
            'Failed to ${isRegistering ? 'register' : 'login'}: \nFill all fields');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.colorScheme.onPrimary,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  HeaderSection(
                    isSelected: isSelected,
                    selectionOps: selectionOps,
                    switchSelected: switchSelected,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        InputSection(
                          controller: _emailController,
                          hintText: 'Email',
                          icon: Icons.email_rounded,
                        ),
                        InputSection(
                          controller: _passwordController,
                          hintText: 'Password',
                          icon: Icons.lock_rounded,
                        ),
                        Visibility(
                          visible: isSelected[1],
                          child: InputSection(
                            controller: _confirmPasswordController,
                            hintText: 'Confirm password',
                            icon: Icons.lock_rounded,
                          ),
                        ),
                        AdditionalAction(
                          isSelected: isSelected,
                          switchSelected: switchSelected,
                        ),
                        const SizedBox(height: 20),
                        AuthButton(
                          isSelected: isSelected,
                          selectionOps: selectionOps,
                          handleAuthentication: handleAuthentication,
                        ),
                        const SizedBox(height: 20),
                        AlternativeMethods(
                          isLoading: _isLoading,
                          setLoading: (bool value) {
                            setState(() {
                              _isLoading = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: theme.colorScheme.onPrimary.withOpacity(0.5),
              child: Center(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    strokeWidth: 5,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
