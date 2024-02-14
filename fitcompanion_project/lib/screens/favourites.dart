import 'package:fitcompanion_project/screens/exerciseDetails.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitcompanion_project/model/Exercises.dart';
import 'package:get/get.dart';
import 'dart:math';

class FavoriteExercisesScreen extends StatefulWidget {
  @override
  _FavoriteExercisesScreenState createState() =>
      _FavoriteExercisesScreenState();
}

class _FavoriteExercisesScreenState extends State<FavoriteExercisesScreen> {
  List<Exercises> favoriteExercises = [];

  final List<Color> cardColors = [
    Color(0xFF99C24D),
    Color(0xFF048BA8),
    Color(0xFF2E4057),
    Color(0xFF2F2D2E),
    Color(0xFFF18F01),
  ];

  final List<Color> fontColors = [
    Colors.white,
  ];

  Random random = Random();

  Color _randomColor(List<Color> colors) {
    return colors[Random().nextInt(colors.length)];
  }

  @override
  void initState() {
    super.initState();
    _fetchFavoriteExercises();
  }

  Future<void> _fetchFavoriteExercises() async {
    try {
      User user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favourites')
          .get();

      setState(() {
        favoriteExercises = querySnapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return Exercises.fromJson(data);
        }).toList();
      });
    } catch (e) {
      print('Error fetching favorite exercises: $e');
    }
  }

  Future<void> _deleteExercise(String exerciseName) async {
    try {
      User user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favourites')
          .where('name', isEqualTo: exerciseName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.delete();
      } else {
        throw Exception('Exercise not found');
      }
      await _fetchFavoriteExercises();
    } catch (e, stackTrace) {
      print('Error deleting exercise: $e');
      print(stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      appBar: AppBar(
        backgroundColor:
            Color(0xFFEBEBEB),
        title: Text(
          'Favourites',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: favoriteExercises.isEmpty
          ? Center(
              child: Text('No favorite exercises'),
            )
          : ListView.builder(
              itemCount: favoriteExercises.length,
              itemBuilder: (context, index) {
                final exercise = favoriteExercises[index];
                final cardColor = _randomColor(cardColors);
                final fontColor = _randomColor(fontColors);
                return Card(
                  color: cardColor,
                  child: Dismissible(
                    key: Key(exercise.name),
                    onDismissed: (direction) {
                      _deleteExercise(
                          exercise.name);
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    child: ListTile(
                      title: Text(
                        exercise.name,
                        style: TextStyle(color: fontColor),
                      ),
                      subtitle: Text(
                        '${exercise.muscle}',
                        style: TextStyle(color: fontColor),
                      ),
                      onTap: () {
                        Get.to(() => ExerciseDetailScreen(exercise: exercise));
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
