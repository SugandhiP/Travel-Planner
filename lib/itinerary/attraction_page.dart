import 'package:flutter/material.dart';
import '../model/destination.dart';
import 'attraction_details_page.dart';

class AttractionsPage extends StatefulWidget {
  final Destination destination;

  const AttractionsPage({Key? key, required this.destination}) : super(key: key);

  @override
  _AttractionsPageState createState() => _AttractionsPageState();
}

class _AttractionsPageState extends State<AttractionsPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredAttractions = widget.destination.attractions
        .where((attraction) =>
        attraction.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text(
          widget.destination.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Search Attractions",
                hintText: "Type to search...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),
          ),
          Expanded(
            child: Scrollbar(
              thickness: 6,
              radius: Radius.circular(10),
              child: filteredAttractions.isEmpty
                  ? Center(
                child: Text(
                  "No attractions match your search.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              )
                  : ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 10),
                itemCount: filteredAttractions.length,
                itemBuilder: (context, index) {
                  final attraction = filteredAttractions[index];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 6,
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(15),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          attraction.imageUrl,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.image_not_supported, color: Colors.grey),
                        ),
                      ),
                      title: Text(
                        attraction.name,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Text(
                        attraction.country,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
                      onTap: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AttractionDetailsPage(attraction: attraction),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
