import 'package:flutter/material.dart';
import '../model/destination.dart';

class AttractionsPage extends StatelessWidget {
  final Destination destination;

  const AttractionsPage({Key? key, required this.destination}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(destination.name)),
      body: destination.attractions.isEmpty
          ? Center(child: Text("No attractions available for ${destination.name}"))
          : ListView.builder(
        itemCount: destination.attractions.length,
        itemBuilder: (context, index) {
          final attraction = destination.attractions[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  attraction.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.image_not_supported),
                ),
              ),
              title: Text(attraction.name, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(attraction.country),
            ),
          );
        },
      ),
    );
  }
}
