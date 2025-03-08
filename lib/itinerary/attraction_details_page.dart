import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/attraction_data.dart';
import '../model/attraction.dart';

class AttractionDetailsPage extends StatelessWidget {
  final Attraction attraction;

  const AttractionDetailsPage({Key? key, required this.attraction}) : super(key: key);

  Future<void> _launchURL(BuildContext context, String url) async {
    final String encodedUrl = Uri.encodeFull(url);
    final Uri uri = Uri.parse(encodedUrl.trim());
    print('Attempting to launch URL: $url (Encoded: $encodedUrl)');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('Cannot launch URL: $url');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Could not open link"),
            content: Text("There was a problem opening the official website. Please try again later."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final attractionDetails = attractionDetailsMap[attraction.name];

    if (attractionDetails == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Details not found", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.redAccent,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: Text("No details available for this attraction.", style: TextStyle(fontSize: 16)),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                attraction.name,
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
              ),
              centerTitle: true,
              background: Stack(
                fit: StackFit.expand,
                children: [

                  FadeInImage.assetNetwork(
                    placeholder: 'assets/placeholder.png',
                    image: attraction.imageUrl,
                    fit: BoxFit.cover,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/image_error.png', fit: BoxFit.cover);
                    },
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, 0.7),
                        end: Alignment.center,
                        colors: <Color>[
                          Color(0x80000000),
                          Color(0x00000000),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: Icon(Icons.location_on, color: Colors.blueAccent, size: 30),
                            title: Text(
                              "Country",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                            ),
                            subtitle: Text(
                              attraction.country,
                              style: TextStyle(fontSize: 18, color: Colors.black87),
                            ),
                          ),
                          Divider(), // Add divider
                          ListTile(
                            leading: Icon(Icons.access_time, color: Colors.green, size: 30),
                            title: Text(
                              "Opening Hours",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                            ),
                            subtitle: Text(
                              attractionDetails!.openingHours,
                              style: TextStyle(fontSize: 18, color: Colors.black87),
                            ),
                          ),
                          Divider(), // Add divider
                          ListTile(
                            leading: Icon(Icons.timer_off, color: Colors.redAccent, size: 30),
                            title: Text(
                              "Closing Time",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                            ),
                            subtitle: Text(
                              attractionDetails.closingTime,
                              style: TextStyle(fontSize: 18, color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  Center(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.travel_explore, color: Colors.white),
                      label: Text("Visit Official Website", style: TextStyle(color: Colors.white, fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                      onPressed: () => _launchURL(context, attractionDetails.officialWebsite),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
