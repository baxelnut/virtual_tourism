import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DestinationOverview extends StatelessWidget {
  const DestinationOverview({super.key});

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    final List<Map<String, String>> destinationData = [
      {
        "releaseDate": "18 May 2013, 15:21",
        "size": "33580 x 5502 px",
        "fieldOfView": "360° x 59°",
        "sourcePath": "https://www.eso.org/public/images/res-vlt-sunset-pan/",
        "description":
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
      },
    ];

    final description = destinationData.first["description"] ?? "";

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('destinationName'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
                    child: Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                        'https://cdn.eso.org/images/wallpaper1/res-vlt-sunset-pan.jpg',
                      ),
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
                description,
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
                  rows: destinationData.map((destination) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(Text(destination["releaseDate"] ?? "")),
                        DataCell(Text(destination["size"] ?? "")),
                        DataCell(Text(destination["fieldOfView"] ?? "")),
                        DataCell(
                          GestureDetector(
                            onTap: () =>
                                _launchURL(destination["sourcePath"] ?? ""),
                            child: Text(
                              destination["sourcePath"] ?? "",
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
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
