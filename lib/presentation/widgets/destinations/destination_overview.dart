// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:virtual_tourism/app.dart';

import '../../../core/global_values.dart';
import '../content/load_image.dart';
import '../content/photographic_screen.dart';
import '../content/tour_screen.dart';
import 'ratings/review_section.dart';

class DestinationOverview extends StatefulWidget {
  final Map<String, dynamic> destinationData;
  const DestinationOverview({
    super.key,
    required this.destinationData,
  });

  @override
  DestinationOverviewState createState() => DestinationOverviewState();
}

class DestinationOverviewState extends State<DestinationOverview> {
  bool _isLoading = false;
  late String publisherImageUrl = '';

  int? selectedAnswerIndex;
  bool isAnswered = false;

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    setState(() {
      _isLoading = true;
    });

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        print('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchUserInfo(
    String uid,
    Function(Map<String, Object>) onUserFetched,
  ) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      String userName = userDoc['username'] ?? 'No Name';
      String userImageUrl = (userDoc['imageUrl'] as String?) ?? '';

      onUserFetched({
        'imageUrl': userImageUrl,
        'username': userName,
        'isAdmin': userDoc['admin'],
      });
    } catch (e) {
      print("Error fetching user: $e");
    }
  }

  String formatDate(dynamic dateTime, String dateTimeFormat) {
    if (dateTime == null) return "-";

    DateTime parsedDate;
    if (dateTime is Timestamp) {
      parsedDate = dateTime.toDate();
    } else if (dateTime is String) {
      try {
        parsedDate = DateTime.parse(dateTime);
      } catch (e) {
        return "-";
      }
    } else {
      return "-";
    }

    return DateFormat(dateTimeFormat).format(parsedDate);
  }

  String getImagePath(
      Map<String, dynamic> destinationData, String placeholderPath) {
    final thumbnailPath = destinationData["thumbnailPath"] ?? '';
    final hotspotImagePath =
        destinationData["hotspotData"]?["hotspot0"]?["imagePath"] ?? '';

    if (thumbnailPath.isNotEmpty) return thumbnailPath;
    if (hotspotImagePath.isNotEmpty) return hotspotImagePath;

    return placeholderPath;
  }

  @override
  void initState() {
    super.initState();
    String publisherUid = widget.destinationData['userId'] ?? 'Unknown';
    if (publisherUid != "" ||
        publisherUid != 'Unknown' ||
        widget.destinationData['userId'] != null) {
      fetchUserInfo(publisherUid, (userInfo) {
        setState(() {
          publisherImageUrl = userInfo['imageUrl'] != null
              ? (userInfo['imageUrl'] as String)
              : '';
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = GlobalValues.theme(context);
    final Size screenSize = GlobalValues.screenSize(context);
    const String placeholderPath = GlobalValues.placeholderPath;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            title: Text(
              widget.destinationData['destinationName'] ?? 'Unknown',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            backgroundColor: theme.colorScheme.primary,
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  imagePreview(
                    screenSize: screenSize,
                    placeholderPath: placeholderPath,
                    theme: theme,
                  ),
                  viewButton(
                    theme: theme,
                    placeholderPath: placeholderPath,
                    screenSize: screenSize,
                  ),
                  Visibility(
                    visible: widget.destinationData['userId'] != null &&
                        widget.destinationData['userId'] != '' &&
                        widget.destinationData['userId'] != 'Unknown',
                    child: publisherInfo(
                      placeholderPath: placeholderPath,
                      theme: theme,
                    ),
                  ),
                  if (widget.destinationData['description'].isNotEmpty)
                    descriptionView(theme: theme),
                  if (widget.destinationData['trivia'] != null)
                    answerTrivia(
                      question: widget.destinationData['trivia']['question'] ??
                          'No question.',
                      answers: List<String>.from(
                          widget.destinationData['trivia']['answers'] ?? []),
                      correctIndex: widget.destinationData['trivia']
                          ['correctIndex'],
                      screenSize: screenSize,
                      theme: theme,
                    ),
                  Visibility(
                    visible: widget.destinationData['infosPath'] != null &&
                        (widget.destinationData['infosPath'] as List)
                            .isNotEmpty,
                    child: additionalInfos(
                      theme: theme,
                      screenSize: screenSize,
                      infosPath: widget.destinationData['infosPath'] != null
                          ? List<String>.from(
                              widget.destinationData['infosPath'])
                          : [GlobalValues.placeholderPath],
                      infos: widget.destinationData['infos'] != null
                          ? List<String>.from(widget.destinationData['infos'])
                          : [""],
                    ),
                  ),
                  SizedBox(height: 60),
                  buildTheTable(theme: theme, screenSize: screenSize),
                  if (widget.destinationData
                      .toString()
                      .contains("verified_user_uploads"))
                    ReviewSection(
                      destinationData: widget.destinationData,
                      theId: widget.destinationData['docId'] ??
                          widget.destinationData['destinationId'] ??
                          "something's wrong with the id thing",
                    ),
                  SizedBox(height: screenSize.width / 3),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget answerTrivia({
    required String question,
    required List<String> answers,
    required int correctIndex,
    required Size screenSize,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SizedBox(
        width: screenSize.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text('Trivia 🏅', style: theme.textTheme.titleLarge)),
            SizedBox(height: 5),
            Center(
              child: SizedBox(
                width: screenSize.width / 1.5,
                child: Text(
                  'Answer this and prove your trivia skills – medal awaits!',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Divider(),
            SizedBox(height: 5),
            Text(
              question,
              style: theme.textTheme.bodyLarge,
            ),
            SizedBox(height: 15),
            ...answers.asMap().entries.map((entry) {
              final index = entry.key;
              final answer = entry.value;
              final isCorrect = correctIndex == index;

              Color buttonColor = theme.colorScheme.onSurface.withOpacity(0.1);

              if (selectedAnswerIndex == index) {
                if (isCorrect) {
                  buttonColor = Colors.green;
                } else {
                  buttonColor = theme.colorScheme.error;
                }
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: ElevatedButton(
                  onPressed: () {
                    if (!isAnswered) {
                      setState(() {
                        selectedAnswerIndex = index;
                        isAnswered = true;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      answer,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight:
                            isAnswered && isCorrect ? FontWeight.bold : null,
                      ),
                    ),
                  ),
                ),
              );
            }),
            if (isAnswered)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: ElevatedButton(
                    onPressed: () {
                      if (correctIndex == selectedAnswerIndex) {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return MyApp(pageIndex: 3);
                            },
                          ),
                        );
                      } else {
                        setState(() {
                          isAnswered = false;
                          selectedAnswerIndex = null;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                    ),
                    child: Text(
                      correctIndex == selectedAnswerIndex
                          ? "Congrats! You got a medal!"
                          : 'Wrong! Try again?',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget imagePreview({
    required Size screenSize,
    required String placeholderPath,
    required ThemeData theme,
  }) {
    return SizedBox(
      width: screenSize.width,
      height: screenSize.width / 1.5,
      child: Stack(
        children: [
          LoadImage(
            imagePath: getImagePath(
              widget.destinationData,
              placeholderPath,
            ),
            width: screenSize.width,
            height: screenSize.width / 1.5,
          ),
          Container(
            width: screenSize.width,
            height: screenSize.width / 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xff151515).withOpacity(0.9),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: const [0.0, 0.9],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Text(
                  formatDate(
                    widget.destinationData["created"],
                    "d MMM y",
                  ),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    widget.destinationData['destinationName'] ?? 'Unknown',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget viewButton({
    required ThemeData theme,
    required String placeholderPath,
    required Size screenSize,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30, right: 20, left: 20, top: 10),
      child: SizedBox(
        width: screenSize.width,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  String? type = widget.destinationData["type"];

                  if (type == "Tour") {
                    return TourScreen(
                      destinationData: widget.destinationData,
                    );
                  } else {
                    return PhotographicScreen(
                      destinationData: widget.destinationData,
                    );
                  }
                },
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: theme.colorScheme.secondary,
          ),
          child: Text(
            'View',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSecondary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }

  Widget publisherInfo({
    required ThemeData theme,
    required String placeholderPath,
  }) {
    return Row(
      children: [
        const SizedBox(width: 20),
        CircleAvatar(
          radius: 16,
          backgroundImage: NetworkImage(
            publisherImageUrl.isNotEmpty ? publisherImageUrl : placeholderPath,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          widget.destinationData['userName'] ?? 'Unknown',
          style: theme.textTheme.titleLarge,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(width: 10),
        const Icon(
          Icons.verified_rounded,
          size: 20,
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget additionalInfos({
    required ThemeData theme,
    required Size screenSize,
    required List<String>? infosPath,
    required List<String>? infos,
  }) {
    final safeInfosPath = infosPath?.isNotEmpty == true
        ? infosPath!
        : [GlobalValues.placeholderPath];

    final safeInfos = infos?.isNotEmpty == true
        ? infos!
        : List.generate(safeInfosPath.length, (index) => "");

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(safeInfosPath.length, (index) {
          return Column(
            children: [
              LoadImage(
                imagePath: safeInfosPath[index],
                width: screenSize.width,
                height: screenSize.width / 2,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: screenSize.width,
                child: Text(
                  safeInfos.length > index ? safeInfos[index] : "",
                  textAlign: TextAlign.left,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              SizedBox(height: 40),
            ],
          );
        }),
      ),
    );
  }

  Widget descriptionView({
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Text(
        widget.destinationData['description'] ?? 'No description available',
        textAlign: TextAlign.left,
        style: theme.textTheme.bodyLarge,
      ),
    );
  }

  Widget buildTheTable({
    required ThemeData theme,
    required Size screenSize,
  }) {
    final dataMap = {
      "Address": widget.destinationData["address"],
      "Released": widget.destinationData["releaseDate"] ??
          formatDate(
            widget.destinationData["created"] ?? "",
            "E, d MMM y, h:mm a",
          ),
      "Link": widget.destinationData["source"] == " " ||
              widget.destinationData["source"] == null
          ? widget.destinationData['sourcePath'] ?? 'No link'
          : widget.destinationData["source"],
      widget.destinationData["type"] == 'Tour' ? 'Hotspots' : 'Size':
          (widget.destinationData["type"] == 'Tour'
              ? widget.destinationData["hotspotData"].length ?? "-"
              : widget.destinationData["imageSize"] ?? "-"),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: dataMap.entries.map((entry) {
          final isLink = entry.key == "Link";
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: screenSize.width * 0.3,
                  child: Text(
                    entry.key,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: screenSize.width / 2,
                  child: isLink
                      ? GestureDetector(
                          onTap: () => _launchURL(entry.value),
                          child: Text(
                            entry.value.toString(),
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      : Text(
                          entry.value.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
