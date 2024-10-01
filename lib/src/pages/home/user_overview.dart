import 'package:flutter/material.dart';

class UserOverview extends StatefulWidget {
  final String username;
  const UserOverview({super.key, required this.username});

  @override
  State<UserOverview> createState() => _UserOverviewState();
}

class _UserOverviewState extends State<UserOverview> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
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
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Image.asset('assets/3d_avatar_21.png'),
                    );
                  });
            },
            child: CircleAvatar(
              child: Image.asset('assets/3d_avatar_21.png'),
            ),
          )
        ],
      ),
    );
  }
}
