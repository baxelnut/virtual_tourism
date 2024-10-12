import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List<bool> isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xffEFFFFB),
      ),
      backgroundColor: const Color(0xff121212),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Go ahead and set up your account',
              style: theme.textTheme.headlineMedium
                  ?.copyWith(color: const Color(0xffEFFFFB)),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Sign in-up to experience your odyssey!',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: const Color(0xffEFFFFB)),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: screenSize.width,
              decoration: const BoxDecoration(
                  color: Color(0xffEFFFFB),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    toggleButton(isSelected: isSelected),
                    const SizedBox(height: 20),
                    Container(
                      width: 100,
                      height: 100,
                      color: isSelected[0] ? Colors.red : Colors.green,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget toggleButton({required List<bool> isSelected}) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    List<String> ops = ['Login', 'Register'];
    return ToggleButtons(
      isSelected: isSelected,
      fillColor: const Color(0xff121212).withOpacity(0.3),
      borderColor: const Color(0xff121212).withOpacity(0.3),
      borderWidth: 1.5,
      borderRadius: BorderRadius.circular(30),
      onPressed: (index) {
        setState(() {
          isSelected[0] = index == 0;
          isSelected[1] = index == 1;
        });
      },
      children: [
        for (int i = 0; i < ops.length; i++)
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: 12, horizontal: screenSize.width / 8),
            child: Text(ops[i],
                style: theme.textTheme.bodyLarge?.copyWith(
                    color: const Color(0xff121212),
                    fontWeight: FontWeight.bold)),
          ),
      ],
    );
  }
}
