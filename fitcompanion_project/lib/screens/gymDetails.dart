import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitcompanion_project/screens/map.dart';

class GymDetailsPage extends StatelessWidget {
  final String gymId;
  final GeoPoint coordinates;
  final String name;
  final String openHours;

  GymDetailsPage({
    this.gymId,
    this.coordinates,
    this.name,
    this.openHours,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      appBar: AppBar(
        backgroundColor:
            Color(0xFFEBEBEB),
        title: Text(
          'Gym Detail',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4.0,
              margin: EdgeInsets.only(bottom: 16.0),
              child: Container(
                width: screenWidth,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gym Name',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(name),
                      SizedBox(height: 8.0),
                      Text(
                        'Opening Hours',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(openHours),
                      SizedBox(height: 16.0),
                      if (coordinates != null) ...[
                        Text('Latitude: ${coordinates.latitude}'),
                        Text('Longitude: ${coordinates.longitude}'),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(
                              () => MapPage(
                                latitude: coordinates.latitude,
                                longitude: coordinates.longitude,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.limeAccent,
                            onPrimary: Colors.black,
                          ),
                          child: Text('View on Map'),
                        )
                      ] else
                        Text('Coordinates not available'),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              elevation: 4.0,
              child: Container(
                width: screenWidth,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Specialities',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      FutureBuilder<List<String>>(
                        future: fetchEquipments(gymId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text(
                                'Error fetching equipments: ${snapshot.error}');
                          } else {
                            List<String> equipmentsList = snapshot.data ?? [];
                            return Wrap(
                              spacing: 8.0,
                              children: equipmentsList.map<Widget>(
                                (equipment) {
                                  final randomColor = cardColors[
                                      Random().nextInt(cardColors.length)];
                                  return Chip(
                                    label: Text(equipment),
                                    backgroundColor: randomColor,
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ).toList(),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              elevation: 4.0,
              child: Container(
                width: screenWidth,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Facilities',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      FutureBuilder<List<String>>(
                        future: fetchFacilities(gymId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text(
                                'Error fetching facilities: ${snapshot.error}');
                          } else {
                            List<String> facilitiesList = snapshot.data ?? [];
                            return Wrap(
                              spacing: 8.0,
                              children: facilitiesList.map<Widget>(
                                (facility) {
                                  final randomColor = cardColors[
                                      Random().nextInt(cardColors.length)];
                                  return Chip(
                                    label: Text(facility),
                                    backgroundColor: randomColor,
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ).toList(),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<String>> fetchEquipments(String gymId) async {
    List<String> equipmentsList = [];
    try {
      QuerySnapshot specialitiesSnapshot = await FirebaseFirestore.instance
          .collection('gym')
          .doc(gymId)
          .collection('Specialities')
          .get();

      specialitiesSnapshot.docs.forEach((doc) {
        String equipments = doc.data()['equipment'];
        equipmentsList.add(equipments);
      });

      return equipmentsList;
    } catch (e) {
      print('Error fetching equipments: $e');
      return [];
    }
  }

  Future<List<String>> fetchFacilities(String gymId) async {
    List<String> facilitiesList = [];
    try {
      QuerySnapshot facilitiesSnapshot = await FirebaseFirestore.instance
          .collection('gym')
          .doc(gymId)
          .collection('Facilities')
          .get();

      facilitiesSnapshot.docs.forEach((doc) {
        String facility = doc.data()['facility'];
        facilitiesList.add(facility);
      });

      return facilitiesList;
    } catch (e) {
      print('Error fetching facilities: $e');
      return [];
    }
  }

  final List<Color> cardColors = [
    Color(0xFF99C24D),
    Color(0xFF048BA8),
    Color(0xFF2E4057),
    Color(0xFF2F2D2E),
    Color(0xFFF18F01),
  ];
}
