import 'package:flutter/material.dart';
import 'package:fitcompanion_project/model/Exercises.dart';
import 'package:get/get.dart';
import 'chat.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Exercises exercise;

  ExerciseDetailScreen({Key key, @required this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      appBar: AppBar(
        backgroundColor:
            Color(0xFFEBEBEB),
        title: Text(
          'Exercise Detail',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                exercise.name,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Type: ${exercise.type}'),
                      SizedBox(height: 8.0),
                      Text('Muscle: ${exercise.muscle}'),
                      SizedBox(height: 8.0),
                      Text('Equipment: ${exercise.equipment}'),
                      SizedBox(height: 8.0),
                      Text('Difficulty: ${exercise.difficulty}'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Instructions',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        exercise.instructions,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
