// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
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
                  descriptionView(theme: theme),
                  buildTheTable(),
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
            imagePath: widget.destinationData["imagePath"] ?? placeholderPath,
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
                  widget.destinationData["releaseDate"] ?? "No data",
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
                builder: (context) => ImageScreen(
                  image: Image(
                    image: NetworkImage(
                      widget.destinationData['imagePath'] ?? placeholderPath,
                    ),
                  ),
                ),
              ),
              // MaterialPageRoute(builder: (context) => const ExampleJump()),
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

  Widget descriptionView({
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        widget.destinationData['description'] ?? 'No description available',
        textAlign: TextAlign.left,
        style: theme.textTheme.bodyLarge,
      ),
    );
  }

  Widget buildTheTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: DataTable(
          columnSpacing: 16.0,
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                "Release Date",
              ),
            ),
            DataColumn(
              label: Text(
                "Size",
              ),
            ),
            DataColumn(
              label: Text(
                "Field of View",
              ),
            ),
            DataColumn(
              label: Text(
                "Source",
              ),
            ),
          ],
          rows: [
            DataRow(
              cells: <DataCell>[
                DataCell(
                  Text(
                    widget.destinationData["releaseDate"] ?? "No data",
                  ),
                ),
                DataCell(
                  Text(
                    widget.destinationData["size"] ?? "No data",
                  ),
                ),
                DataCell(
                  Text(
                    widget.destinationData["fieldOfView"] ?? "No data",
                  ),
                ),
                DataCell(
                  GestureDetector(
                    onTap: () {
                      _launchURL(
                        widget.destinationData["sourcePath"] ?? "",
                      );
                    },
                    child: Text(
                      widget.destinationData["sourcePath"] ?? "No data",
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
