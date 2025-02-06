import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ButtonDonate extends StatefulWidget {
  final Map<String, dynamic> destinationData;
  const ButtonDonate({
    super.key,
    required this.destinationData,
  });

  @override
  State<ButtonDonate> createState() => _ButtonDonateState();
}

class _ButtonDonateState extends State<ButtonDonate> {
  final User? user = FirebaseAuth.instance.currentUser;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "Donate to ${widget.destinationData['destinationName'] ?? 'Unknown'}",
                        style: theme.textTheme.titleLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Divider(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: _getImageProvider(),
                        ),
                        title: Text(
                          user?.displayName ?? 'username',
                          style: theme.textTheme.bodyLarge,
                        ),
                        subtitle: Text(
                          'Rp. 20.000',
                          style: theme.textTheme.headlineMedium,
                        ),
                      ),
                      SizedBox(
                        width: screenSize.width,
                        child: ElevatedButton(
                          onPressed: () {
                            print('DONATED');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                          ),
                          child: Text(
                            'Donate',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(
            Icons.attach_money_outlined,
            size: 20,
            color: theme.colorScheme.onPrimary,
          ),
          const SizedBox(width: 5),
          Text(
            'Donate',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
