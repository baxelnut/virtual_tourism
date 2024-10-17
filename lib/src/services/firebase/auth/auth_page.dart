import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:virtual_tourism/src/app.dart';

import 'auth.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  List<bool> isSelected = [true, false];
  List<String> selectionOps = ['Login', 'Register'];
  bool obscurial = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final Color _absoluteBlack = const Color(0xff121212);
  final Color _absoluteWhite = const Color(0xffEFFFFB);

  final Auth _auth = Auth();

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
              child: const Text("OK"),
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        surfaceTintColor: _absoluteBlack,
        shadowColor: _absoluteBlack,
        backgroundColor: _absoluteBlack,
        foregroundColor: _absoluteWhite,
      ),
      backgroundColor: _absoluteWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _headerSection(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _inputSection(
                        controller: _emailController,
                        hintText: 'Email',
                        icon: Icons.email_rounded),
                    _inputSection(
                        controller: _passwordController,
                        hintText: 'Password',
                        icon: Icons.lock_rounded),
                    Visibility(
                      visible: isSelected[1],
                      child: _inputSection(
                          controller: _confirmPasswordController,
                          hintText: 'Confirm password',
                          icon: Icons.lock_rounded),
                    ),
                    _additionalAction(),
                    const SizedBox(height: 20),
                    _authButton(),
                    const SizedBox(height: 20),
                    _alternativeMethods(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerSection() {
    final ThemeData theme = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      color: _absoluteBlack,
      width: screenSize.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Go ahead and set up your account',
              style: theme.textTheme.headlineMedium
                  ?.copyWith(color: _absoluteWhite),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Sign in-up to experience your epic odyssey!',
              style:
                  theme.textTheme.bodyMedium?.copyWith(color: _absoluteWhite),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: screenSize.width,
            height: 100,
            decoration: BoxDecoration(
                color: _absoluteWhite,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            child: Center(child: _toggleButton(isSelected: isSelected)),
          ),
        ],
      ),
    );
  }

  Widget _toggleButton({required List<bool> isSelected}) {
    final ThemeData theme = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ToggleButtons(
        isSelected: isSelected,
        borderWidth: 0,
        borderColor: Colors.transparent,
        selectedBorderColor: Colors.transparent,
        disabledBorderColor: Colors.transparent,
        color: Colors.transparent,
        fillColor: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        onPressed: (int index) => switchSelected(index),
        children: [
          for (int i = 0; i < selectionOps.length; i++)
            Container(
              color: _absoluteBlack.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  width: screenSize.width / 2.5,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected[i] ? _absoluteWhite : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      selectionOps[i],
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: _absoluteBlack,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _inputSection({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
  }) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ListTile(
        dense: true,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: _absoluteBlack.withOpacity(0.5), width: 1),
            borderRadius: BorderRadius.circular(15)),
        leading: Icon(
          icon,
          color: _absoluteBlack,
          size: 20,
        ),
        title: TextField(
          controller: controller,
          obscureText:
              hintText.toLowerCase().contains('password') ? obscurial : false,
          style: theme.textTheme.bodyLarge
              ?.copyWith(color: _absoluteBlack, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              color: _absoluteBlack,
            ),
          ),
        ),
        trailing: Visibility(
          visible: hintText.toLowerCase().contains('password'),
          child: GestureDetector(
            onTap: () {
              setState(() {
                obscurial = !obscurial;
              });
            },
            child: Icon(
              obscurial
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
              color: _absoluteBlack,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _additionalAction() {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              int index = isSelected[0] ? 1 : 0;
              switchSelected(index);
            },
            child: Text(
              isSelected[0]
                  ? "Don't have an account?"
                  : "Already have an account?",
              style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold, color: _absoluteBlack),
            ),
          ),
          Text(
            isSelected[0] ? 'Forgot Password?' : '',
            style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: _absoluteBlack,
                decoration: TextDecoration.underline),
          )
        ],
      ),
    );
  }

  Widget _authButton() {
    final ThemeData theme = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            fixedSize: Size(screenSize.width, 50),
            backgroundColor: theme.colorScheme.primary),
        onPressed: () => handleAuthentication(context),
        child: Text(
          isSelected[0] ? selectionOps[0] : selectionOps[1],
          style: theme.textTheme.bodyLarge
              ?.copyWith(fontWeight: FontWeight.bold, color: _absoluteWhite),
        ));
  }

  Widget _alternativeMethods() {
    final ThemeData theme = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                height: 1, width: screenSize.width / 5, color: _absoluteBlack),
            Text(
              'OR',
              style:
                  theme.textTheme.bodyMedium?.copyWith(color: _absoluteBlack),
            ),
            Container(
                height: 1, width: screenSize.width / 5, color: _absoluteBlack),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 20,
          runSpacing: 5,
          alignment: WrapAlignment.spaceEvenly,
          children: [
            _methodButton(methodName: 'Google'),
            _methodButton(methodName: 'Facebook'),
            _methodButton(methodName: 'Apple'),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _methodButton({
    required String methodName,
  }) {
    final ThemeData theme = Theme.of(context);

    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            backgroundColor: _absoluteWhite,
            side: BorderSide(
              width: 1,
              color: _absoluteBlack.withOpacity(0.5),
            )),
        onPressed: () {},
        icon: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: SvgPicture.asset(
            'assets/icons/${methodName.toLowerCase()}.svg',
            width: 25,
            height: 25,
          ),
        ),
        label: Text(
          methodName,
          style: theme.textTheme.bodyLarge
              ?.copyWith(color: _absoluteBlack, fontWeight: FontWeight.bold),
        ));
  }
}
