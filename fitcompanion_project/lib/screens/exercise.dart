import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fitcompanion_project/model/Exercises.dart';
import 'package:fitcompanion_project/services/httpservice.dart';
import 'package:get/get.dart';
import 'chat.dart';
import 'exerciseDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'favourites.dart';

class ExerciseScreen extends StatefulWidget {
  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  List<Exercises> exercises = [];
  List<String> muscleGroups = [
    'abdominals',
    'abductors',
    'adductors',
    'biceps',
    'calves',
    'chest',
    'forearms',
    'glutes',
    'hamstrings',
    'lats',
    'lower_back',
    'middle_back',
    'neck',
    'quadriceps',
    'traps',
    'triceps'
  ];

  String selectedMuscle;

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

  Future<void> addFavoriteExercise(
      BuildContext context, Exercises exercise) async {
    try {
      User user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      var docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favourites')
          .doc();
      print('add docRef:' + docRef.id);

      String difficulty = exercise.difficulty.toString().split('.').last;

      await docRef.set({
        'name': exercise.name,
        'muscle': exercise.muscle,
        'equipment': exercise.equipment,
        'difficulty': difficulty,
        'instructions': exercise.instructions,
      });

      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Exercise added to favorites')),
      );
    } catch (e) {
      print('Error adding favorite exercise: $e');
    }
  }

  void _navigateToFavorites(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FavoriteExercisesScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchExercises();
  }

  Future<void> _fetchExercises() async {
    try {
      final service = ExerciseService();
      final fetchedExercises =
          await service.fetchExercises(muscle: selectedMuscle);
      setState(() {
        exercises = fetchedExercises;
      });
    } catch (e) {
      print('Error fetching exercises: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      appBar: AppBar(
        backgroundColor: Color(0xFFEBEBEB),
        title: Text(
          'Exercise List',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_border_outlined, color: Colors.black),
            onPressed: () => _navigateToFavorites(context),
          ),
        ],
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: 'Select Muscle Group',
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            value: selectedMuscle,
            onChanged: (newValue) {
              setState(() {
                selectedMuscle = newValue;
              });
              _fetchExercises();
            },
            items: muscleGroups.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          Expanded(
            child: exercises.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = exercises[index];
                      final cardColor = _randomColor(cardColors);
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Card(
                          color: cardColor,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              exercise.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              exercise.muscle,
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              Get.to(() =>
                                  ExerciseDetailScreen(exercise: exercise));
                            },
                            trailing: IconButton(
                              icon: Icon(
                                Icons.bookmark_border_outlined,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                addFavoriteExercise(context, exercise);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
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
