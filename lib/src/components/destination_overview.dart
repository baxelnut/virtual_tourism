import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DestinationOverview extends StatelessWidget {
  final Map<String, dynamic> destinationData;

  const DestinationOverview({
    super.key,
    required this.destinationData,
  });

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        print('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    const placeholderPath =
        'https://hellenic.org/wp-content/plugins/elementor/assets/images/placeholder.png';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(destinationData['destinationName'] ?? 'Unknown'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: screenSize.width,
                  height: screenSize.width / 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      destinationData["imagePath"] ?? placeholderPath,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: theme.colorScheme.onSurface,
                    ),
                    child: Text(
                      'View',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.surface,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                destinationData['description'] ?? 'No description available',
                textAlign: TextAlign.left,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 30),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 16.0,
                  columns: const <DataColumn>[
                    DataColumn(label: Text("Release Date")),
                    DataColumn(label: Text("Size")),
                    DataColumn(label: Text("Field of View")),
                    DataColumn(label: Text("Source")),
                  ],
                  rows: [
                    DataRow(
                      cells: <DataCell>[
                        DataCell(
                            Text(destinationData["releaseDate"] ?? "No data")),
                        DataCell(Text(destinationData["size"] ?? "No data")),
                        DataCell(
                            Text(destinationData["fieldOfView"] ?? "No data")),
                        DataCell(
                          GestureDetector(
                            onTap: () =>
                                _launchURL(destinationData["sourcePath"] ?? ""),
                            child: Text(
                              destinationData["sourcePath"] ?? "No data",
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
              SizedBox(height: screenSize.width / 3)
            ],
          ),
        ),
      ),
    );
  }
}
