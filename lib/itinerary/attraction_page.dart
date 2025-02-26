import 'package:flutter/material.dart';
import '../model/destination.dart';

class AttractionsPage extends StatelessWidget {
  final Destination destination;

  const AttractionsPage({Key? key, required this.destination}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text(destination.name, style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 5,
      ),
      body: destination.attractions.isEmpty
          ? Center(
        child: Text(
          "No attractions available for ${destination.name}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      )
          : Scrollbar(
        thickness: 6,
        radius: Radius.circular(10),
        child: ListView.builder(
          padding: EdgeInsets.only(top: 10, bottom: 20),
          itemCount: destination.attractions.length,
          itemBuilder: (context, index) {
            final attraction = destination.attractions[index];

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 6,
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: ListTile(
                contentPadding: EdgeInsets.all(12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                  attraction.country,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
              ),
            );
          },
        ),
      ),
    );
  }
}
