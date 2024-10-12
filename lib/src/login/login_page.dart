import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    const Color absoluteBlack = Color(0xff121212);
    final Color absoluteWhite = theme.colorScheme.onPrimary;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: absoluteBlack,
        shadowColor: absoluteBlack,
        backgroundColor: absoluteBlack,
        foregroundColor: absoluteWhite,
      ),
      backgroundColor: absoluteWhite,
      body: Column(
        children: [
          Container(
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
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: absoluteWhite),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: screenSize.width,
                  height: 80,
                  decoration: BoxDecoration(
                      color: absoluteWhite,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: Center(
                      child: toggleButton(
                          isSelected: isSelected,
                          absoluteBlack: absoluteBlack)),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  ListTile(
                    dense: true,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: absoluteBlack.withOpacity(0.5), width: 1),
                        borderRadius: BorderRadius.circular(15)),
                    leading: const Icon(
                      Icons.add_ic_call,
                      size: 25,
                      color: absoluteBlack,
                    ),
                    title: Text('Email Address',
                        style: theme.textTheme.labelMedium
                            ?.copyWith(color: absoluteBlack)),
                    subtitle: Text('input anjay',
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: absoluteBlack)),
                    trailing: Text('data',
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: absoluteBlack)),
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold, color: absoluteBlack),
                      ),
                      Text(
                        'Forgot Password?',
                        style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.secondary),
                      )
                    ],
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(screenSize.width, 50),
                          backgroundColor: theme.colorScheme.primary),
                      onPressed: () {},
                      child: Text(
                        'Login',
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      )),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          height: 1,
                          width: screenSize.width / 4,
                          color: absoluteBlack),
                      Text(
                        'OR',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: absoluteBlack),
                      ),
                      Container(
                          height: 1,
                          width: screenSize.width / 4,
                          color: absoluteBlack),
                    ],
                  ),
                  const Spacer(),
                  Wrap(
                    spacing: 20,
                    runSpacing: 5,
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                      methodButton(methodName: 'Google'),
                      methodButton(methodName: 'Facebook'),
                      methodButton(methodName: 'Apple'),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Container(
                    width: 100,
                    height: 100,
                    color: isSelected[0] ? Colors.red : Colors.green,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget toggleButton(
      {required List<bool> isSelected, required Color absoluteBlack}) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    List<String> ops = ['Login', 'Register'];
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ToggleButtons(
        isSelected: isSelected,
        fillColor: absoluteBlack.withOpacity(0.3),
        borderColor: absoluteBlack,
        selectedBorderColor: absoluteBlack,
        borderWidth: 1,
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
                      color: absoluteBlack, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  Widget methodButton({
    required String methodName,
  }) {
    final theme = Theme.of(context);
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
