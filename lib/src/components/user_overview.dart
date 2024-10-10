import 'package:flutter/material.dart';

class UserOverview extends StatefulWidget {
  final String username;
  final String imagePath;
  final bool isFull;
  final String email;
  const UserOverview(
      {super.key,
      required this.username,
      required this.imagePath,
      required this.isFull,
      required this.email});

  @override
  State<UserOverview> createState() => _UserOverviewState();
}

class _UserOverviewState extends State<UserOverview> {
  showProfilePict() {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: AspectRatio(
            aspectRatio: 1.0,
            child: Image.asset(
              widget.imagePath,
              fit: BoxFit.cover,
            ),
          ),
          content: const Text('This is your profile picture',
              textAlign: TextAlign.center),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final screenSize = MediaQuery.of(context).size;
    return widget.isFull
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: GestureDetector(
                    onTap: () {
                      showProfilePict();
                    },
                    child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(widget.imagePath)),
                  ),
                ),
                Text(
                  widget.username,
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.email,
                  style: theme.textTheme.labelMedium,
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.secondary),
                      onPressed: () {
                        print('edit profile bro');
                      },
                      child: Text(
                        'Edit Profile',
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: theme.colorScheme.onSecondary),
                      )),
                )
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              children: [
                Expanded(
                    child: Text.rich(
                  TextSpan(
                    text: 'Hi, ',
                    style: theme.textTheme.bodyLarge,
                    children: [
                      TextSpan(
                        text: widget.username,
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Icon(Icons.bookmarks_rounded),
                ),
                GestureDetector(
                  onTap: () {
                    showProfilePict();
                  },
                  child: CircleAvatar(
                      backgroundImage: AssetImage(widget.imagePath)),
                ),
              ],
            ),
          );
  }
}
