import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  final String username;
  final String imagePath;
  final String email;
  const UserProfile(
      {super.key,
      required this.username,
      required this.imagePath,
      required this.email});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: AspectRatio(
                                aspectRatio: 1.0,
                                child: Image.asset(
                                  imagePath,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              content: const Text(
                                  'This is your profile picture',
                                  textAlign: TextAlign.center),
                            );
                          },
                        );
                      },
                      child: CircleAvatar(
                          radius: 50, backgroundImage: AssetImage(imagePath)),
                    ),
                  ),
                  Text(
                    username,
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    email,
                    style: theme.textTheme.labelMedium,
                  ),
                  const Divider(thickness: 0.5),
                  _inputSection(label: 'Username', theme: theme),
                  _inputSection(label: 'Email', theme: theme),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SizedBox(
                            child:
                                _inputSection(label: 'Gender', theme: theme)),
                      ),
                      Expanded(
                          child:
                              _inputSection(label: 'Birthday', theme: theme)),
                    ],
                  ),
                  _inputSection(label: 'Phone number', theme: theme),
                  const Spacer(),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(screenSize.width, 60),
                          backgroundColor: theme.colorScheme.primary),
                      onPressed: () {},
                      child: Text('Save',
                          style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onPrimary))),
                 
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _inputSection({
    required String label,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        // controller: controller,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(width: 0.5)),
          label: Text(label, style: theme.textTheme.bodyLarge),
        ),
      ),
    );
  }
}
