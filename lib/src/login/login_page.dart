import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List<bool> isSelected = [true, false];
  List<String> selectionOps = ['Login', 'Register'];
  bool obscurial = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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

  void handleAuthentication(BuildContext context) {
    bool isEmailFilled = emailController.text.trim().isNotEmpty;
    bool isPasswordFilled = passwordController.text.trim().isNotEmpty;
    bool isRegistering = isSelected[1];

    if (isEmailFilled && isPasswordFilled) {
      if (isRegistering) {
        bool isConfirmPasswordFilled =
            confirmPasswordController.text.trim().isNotEmpty;
        bool passwordsMatch = passwordController.text.trim() ==
            confirmPasswordController.text.trim();

        if (isConfirmPasswordFilled && passwordsMatch) {
          showAlertDialog(context, 'Successfully registered');
        } else {
          showAlertDialog(
            context,
            'Failed to register: \n${!isConfirmPasswordFilled ? 'Fill all fields' : 'Passwords do not match'}',
          );
        }
      } else {
        showAlertDialog(context, 'Successfully logged in');
      }
    } else {
      showAlertDialog(context,
          'Failed to ${isRegistering ? 'register' : 'login'}: \nFill all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    const Color absoluteBlack = Color(0xff121212);
    final Color absoluteWhite = theme.colorScheme.onPrimary;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        surfaceTintColor: absoluteBlack,
        shadowColor: absoluteBlack,
        backgroundColor: absoluteBlack,
        foregroundColor: absoluteWhite,
      ),
      backgroundColor: absoluteWhite,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  _headerSection(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _inputSection(
                              controller: emailController,
                              hintText: 'Email',
                              icon: Icons.email_rounded),
                          _inputSection(
                              controller: passwordController,
                              hintText: 'Password',
                              icon: Icons.lock_rounded),
                          Visibility(
                            visible: isSelected[1],
                            child: _inputSection(
                                controller: confirmPasswordController,
                                hintText: 'Confirm password',
                                icon: Icons.lock_rounded),
                          ),
                          _additionalAction(),
                          const Spacer(),
                          _authButton(),
                          const Spacer(),
                          _alternativeMethods(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _headerSection() {
    final ThemeData theme = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;
    const Color absoluteBlack = Color(0xff121212);
    final Color absoluteWhite = theme.colorScheme.onPrimary;

    return Container(
      color: absoluteBlack,
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
                  ?.copyWith(color: absoluteWhite),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Sign in-up to experience your odyssey!',
              style: theme.textTheme.bodyMedium?.copyWith(color: absoluteWhite),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: screenSize.width,
            height: 100,
            decoration: BoxDecoration(
                color: absoluteWhite,
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
    const Color absoluteBlack = Color(0xff121212);
    final Color absoluteWhite = theme.colorScheme.onPrimary;

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
              color: absoluteBlack.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  width: screenSize.width / 2.5,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected[i] ? absoluteWhite : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      selectionOps[i],
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: absoluteBlack,
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
    const Color absoluteBlack = Color(0xff121212);

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ListTile(
        dense: true,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: absoluteBlack.withOpacity(0.5), width: 1),
            borderRadius: BorderRadius.circular(15)),
        leading: Icon(
          icon,
          color: absoluteBlack,
          size: 20,
        ),
        title: TextField(
          controller: controller,
          obscureText:
              hintText.toLowerCase().contains('password') ? obscurial : false,
          style: theme.textTheme.bodyLarge
              ?.copyWith(color: absoluteBlack, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              color: absoluteBlack,
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
              color: absoluteBlack,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _additionalAction() {
    final ThemeData theme = Theme.of(context);
    const Color absoluteBlack = Color(0xff121212);
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
              style: theme.textTheme.labelMedium
                  ?.copyWith(fontWeight: FontWeight.bold, color: absoluteBlack),
            ),
          ),
          Text(
            isSelected[0] ? 'Forgot Password?' : '',
            style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: absoluteBlack,
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
          style:
              theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ));
  }

  Widget _alternativeMethods() {
    final ThemeData theme = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;
    const Color absoluteBlack = Color(0xff121212);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                height: 1, width: screenSize.width / 5, color: absoluteBlack),
            Text(
              'OR',
              style: theme.textTheme.bodyMedium?.copyWith(color: absoluteBlack),
            ),
            Container(
                height: 1, width: screenSize.width / 5, color: absoluteBlack),
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
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _methodButton({
    required String methodName,
  }) {
    final ThemeData theme = Theme.of(context);
    const Color absoluteBlack = Color(0xff121212);
    final Color absoluteWhite = theme.colorScheme.onPrimary;
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            backgroundColor: absoluteWhite,
            side: BorderSide(
              width: 1,
              color: absoluteBlack.withOpacity(0.5),
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
              ?.copyWith(color: absoluteBlack, fontWeight: FontWeight.bold),
        ));
  }
}
