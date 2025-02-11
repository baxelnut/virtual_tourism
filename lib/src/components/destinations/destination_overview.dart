// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../content/image_screen.dart';
import '../content/load_image.dart';
import 'review_section.dart';

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

      if (!userDoc.exists) {
        print("User not found.");
        return;
      }

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
    final ThemeData theme = Theme.of(context);
    final Size screenSize = MediaQuery.of(context).size;
    const String placeholderPath =
        'https://hellenic.org/wp-content/plugins/elementor/assets/images/placeholder.png';

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
                  descriptionView(
                    theme: theme,
                  ),
                  buildTheTable(
                    theme: theme,
                    screenSize: screenSize,
                  ),
                  ReviewSection(
                    destinationData: widget.destinationData,
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
            imagePath: widget.destinationData["thumbnailPath"] == null ||
                    widget.destinationData["thumbnailPath"] == ''
                ? placeholderPath
                : widget.destinationData["thumbnailPath"],
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
            print(
                widget.destinationData["hotspotData"]["hotspot0"]["imagePath"]);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ImageScreen(
                  image: Image(
                    image: NetworkImage(
                      widget.destinationData["type"] == 'Tour'
                          ? (widget.destinationData["hotspotData"]["hotspot0"]
                                  ["imagePath"] ??
                              placeholderPath)
                          : widget.destinationData["imagePath"].isEmpty ??
                              placeholderPath,
                    ),
                  ),
                ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var entry in {
            widget.destinationData["type"] == 'Tour' ? 'Hotspots' : 'Size':
                widget.destinationData["type"] == 'Tour'
                    ? widget.destinationData["hotspotData"]["hotspotQty"]
                        .toString()
                    : widget.destinationData["imageSize"].toString(),
            "Released": formatDate(
              widget.destinationData["created"],
              "E, d MMM y, h:mm a",
            ),
            "Source": widget.destinationData["source"]
          }.entries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: screenSize.width * 0.3,
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: screenSize.width / 2,
                    child: entry.key == "Source"
                        ? GestureDetector(
                            onTap: () => _launchURL(entry.value),
                            child: Text(
                              entry.value.isNotEmpty ? entry.value : "-",
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : Text(
                            entry.value,
                            maxLines: 1,
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
}
