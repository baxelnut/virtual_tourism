import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtual_tourism/src/pages/shop/shop_page.dart';

import '../../components/cards_header.dart';
// import '../../components/chips_component.dart';
// import '../../components/user_overview.dart';
import '../../services/firebase/api/firebase_api.dart';
import '../../services/firebase/auth/auth_page.dart';
// import '../../services/firebase/firebase_api.dart';
import 'image_storage_test.dart';
import 'upload_destinations.dart';
import 'upload_image.dart';

class TestExamplePages extends StatelessWidget {
  const TestExamplePages({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Component & Theme Testing'),
        // backgroundColor: theme.colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // page test
              // GestureDetector(
              //   onTap: () async {
              //     print('Adding user data');
              //     final user = FirebaseAuth.instance.currentUser;
              //     await FirebaseApi().addUserData(
              //       userUid: user!.uid,
              //       isVerified: user.emailVerified,
              //       email: user.email!,
              //     );
              //     print('User data added');
              //   },
              //   child: Container(
              //     color: Colors.red,
              //     height: 100,
              //     width: 200,
              //     child: Text('add user data'),
              //   ),
              // ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const UploadDestinations(),
                        ),
                      );
                    },
                    child: Container(
                      color: Colors.green,
                      height: 100,
                      width: 100,
                      child: const Center(
                        child: Text(
                          'Upload Destinations & Thumb',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const UploadImage(),
                        ),
                      );
                    },
                    child: Container(
                        color: Colors.red,
                        height: 100,
                        width: 100,
                        child: const Center(
                          child: Text(
                            'Upload Custom Image',
                            textAlign: TextAlign.center,
                          ),
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      // print('uploading profile picture');
                      final user = FirebaseAuth.instance.currentUser;
                      FirebaseApi firebaseApi = FirebaseApi();
                      await firebaseApi.updateProfilePicture(
                          userUid: user!.uid);
                      // print('profile picture uploaded');
                    },
                    child: Container(
                      color: Colors.green,
                      height: 100,
                      width: 100,
                      child: const Center(
                        child: Text(
                          'Upload Profile Picture',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AuthPage(),
                        ),
                      );
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.green,
                      child: const Center(
                        child: Text(
                          'Login Page',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ImageStorageTest(),
                        ),
                      );
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.amber,
                      child: const Center(
                        child: Text(
                          'Image Storage',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // component
              // const Text('UserOverview()'),
              // const Divider(),
              // const UserOverview(
              //   username: '_username_',
              //   imagePath: '',
              //   isFull: false,
              //   email: '',
              // ),
              // const UserOverview(
              //   username: 'bazelnut',
              //   imagePath: '',
              //   isFull: false,
              //   email: '',
              // ),
              // const UserOverview(
              //   username: 'Jeremiah',
              //   imagePath: '',
              //   isFull: true,
              //   email: 'jeremiah_jemeriah@gmail.com',
              // ),
              const Text('ChipsComponent()'),
              const Divider(),
              // const ChipsComponent(
              //   listOfThangz: ['Places', 'Conservation', 'News'],
              // ),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>  const ShopPage(),
                    ),
                  );
                },
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.blue,
                  child: const Center(
                    child: Text(
                      'shop_page test',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const Text('CardsHeader()'),
              const Divider(),
              const CardsHeader(
                cardsTitle: 'Top Picks',
              ),
              const CardsHeader(
                cardsTitle: 'Top Countries',
              ),
              const CardsHeader(
                cardsTitle: 'Popular',
              ),
              // theme
              Container(
                width: MediaQuery.of(context).size.width,
                color: theme.colorScheme.primary,
                child: Center(
                  child: Text(
                    'Primary (0xff1289B4)',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: theme.colorScheme.onPrimary),
                  ),
                ),
              ),
              Container(
                height: 30,
                width: MediaQuery.of(context).size.width,
                color: theme.colorScheme.secondary,
                child: Center(
                  child: Text(
                    'Secondary (0xffB43D12)',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: theme.colorScheme.onSecondary),
                  ),
                ),
              ),
              Container(
                height: 30,
                width: MediaQuery.of(context).size.width,
                color: theme.colorScheme.onPrimary,
                child: Center(
                  child: Text(
                    'On Primary (0xffEFFFFB)',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: theme.colorScheme.primary),
                  ),
                ),
              ),
              Container(
                height: 30,
                width: MediaQuery.of(context).size.width,
                color: theme.colorScheme.onSecondary,
                child: Center(
                  child: Text(
                    'On Secondary (0xffEFFFFB)',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: theme.colorScheme.secondary),
                  ),
                ),
              ),
              Container(
                height: 30,
                width: MediaQuery.of(context).size.width,
                color: theme.colorScheme.surface,
                child: Center(
                  child: Text(
                    'Surface (0xffEFFFFB)',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: theme.colorScheme.onSurface),
                  ),
                ),
              ),
              Container(
                height: 30,
                width: MediaQuery.of(context).size.width,
                color: theme.colorScheme.onSurface,
                child: Center(
                  child: Text(
                    'On Surface (0xff151515)',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: theme.colorScheme.surface),
                  ),
                ),
              ),
              const Divider(),
              Text(
                'displayLarge',
                style: theme.textTheme.displayLarge,
              ),
              Text(
                'displayMedium',
                style: theme.textTheme.displayMedium,
              ),
              Text(
                'displaySmall',
                style: theme.textTheme.displaySmall,
              ),
              Text(
                'headlineLarge',
                style: theme.textTheme.headlineLarge,
              ),
              Text(
                'headlineMedium',
                style: theme.textTheme.headlineMedium,
              ),
              Text(
                'headlineSmall',
                style: theme.textTheme.headlineSmall,
              ),
              Text(
                'titleLarge',
                style: theme.textTheme.titleLarge,
              ),
              Text(
                'titleMedium',
                style: theme.textTheme.titleMedium,
              ),
              Text(
                'titleSmall',
                style: theme.textTheme.titleSmall,
              ),
              Text(
                'bodyLarge',
                style: theme.textTheme.bodyLarge,
              ),
              Text(
                'bodyMedium',
                style: theme.textTheme.bodyMedium,
              ),
              Text(
                'bodySmall',
                style: theme.textTheme.bodySmall,
              ),
              Text(
                'labelLarge',
                style: theme.textTheme.labelLarge,
              ),
              Text(
                'labelMedium',
                style: theme.textTheme.labelMedium,
              ),
              Text(
                'labelSmall',
                style: theme.textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
