import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get.dart';
import 'chat.dart';
import 'gymDetails.dart';
import 'profile.dart';

class Locator extends StatefulWidget {
  @override
  _LocatorState createState() => _LocatorState();
}

class _LocatorState extends State<Locator> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot> gymDocs;

  @override
  void initState() {
    super.initState();
    _fetchGymsData();
  }

  final List<Color> cardColors = [
    Color(0xFF99C24D),
    Color(0xFF048BA8),
    Color(0xFF2E4057),
    Color(0xFF2F2D2E),
    Color(0xFFF18F01),
  ];

  final List<Color> fontColors = [
    Colors.white,
    Colors.black,
  ];

  Random random = Random();

  Future<void> _fetchGymsData() async {
    QuerySnapshot querySnapshot = await _firestore.collection('gym').get();
    gymDocs = querySnapshot.docs;
    setState(() {});
  }

  Future<List<String>> fetchEquipments(String gymId) async {
    List<String> equipmentsList = [];
    try {
      QuerySnapshot specialitiesSnapshot = await _firestore
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      appBar: AppBar(
        backgroundColor:
            Color(0xFFEBEBEB),
        leading: IconButton(
          padding: const EdgeInsets.all(8.0),
          icon: Icon(Icons.person,
              color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
        ),
        title: Text(
          'Gym Locator',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
      ),
      body: gymDocs == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: gymDocs.length,
              itemBuilder: (context, index) {
                var gymData = gymDocs[index].data();
                var gymId = gymDocs[index].id;
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GymDetailsPage(
                            gymId: gymId,
                            coordinates: gymData['coordinates'],
                            name: gymData['name'],
                            openHours: gymData['open'],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  gymData['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text('${gymData['open']}'),
                                SizedBox(height: 8.0),
                                FutureBuilder<List<String>>(
                                  future: fetchEquipments(gymId),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text(
                                          'Error fetching equipments: ${snapshot.error}');
                                    } else {
                                      List<String> equipmentsList =
                                          snapshot.data ?? [];
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 4.0),
                                          Wrap(
                                            spacing: 8.0,
                                            children: equipmentsList
                                                .map<Widget>((equipment) {
                                              final randomColor = cardColors[
                                                  Random().nextInt(
                                                      cardColors.length)];
                                              return Chip(
                                                label: Text(equipment),
                                                backgroundColor: randomColor,
                                                labelStyle: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.chat_bubble_outline_rounded, color: Colors.black),
        backgroundColor: Colors.limeAccent,
        tooltip: 'Chat with FitCompanion',
        onPressed: () async {
          Get.to(() => FitCompanionChat());
        },
      ),
    );
  }
}
