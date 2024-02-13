import 'package:fitcompanion_project/screens/chat.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'profile.dart';

class AddFoodIntakeScreen extends StatefulWidget {
  @override
  _AddFoodIntakeScreenState createState() => _AddFoodIntakeScreenState();
}

class _AddFoodIntakeScreenState extends State<AddFoodIntakeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _foodNameController = TextEditingController();
  TextEditingController _caloriesController = TextEditingController();
  TextEditingController _mealTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFEBEBEB),
      appBar: AppBar(
        backgroundColor: Color(0xFFEBEBEB),
        leading: IconButton(
          padding: const EdgeInsets.all(8.0),
          icon: Icon(Icons.person, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
        ),
        title: Text(
          'Tracker',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              labelText: 'Food Name',
              controller: _foodNameController,
            ),
            SizedBox(height: 16.0),
            _buildTextField(
              labelText: 'Calories',
              controller: _caloriesController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            _buildTextField(
              labelText: 'Meal Type (e.g., Breakfast)',
              controller: _mealTypeController,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addFoodIntake,
              style: ElevatedButton.styleFrom(
                primary: Colors.limeAccent,
                onPrimary: Colors.black,
              ),
              child: Text('Add Food Intake'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.chat_bubble_outline_rounded,
          color: Colors.black,
        ),
        backgroundColor: Colors.limeAccent,
        onPressed: () async {
          Get.to(() => FitCompanionChat());
        },
      ),
    );
  }

  Widget _buildTextField({
    String labelText,
    TextEditingController controller,
    TextInputType keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  void _addFoodIntake() async {
    String foodName = _foodNameController.text.trim();
    int calories = int.tryParse(_caloriesController.text) ?? 0;
    String mealType = _mealTypeController.text.trim();

    if (foodName.isNotEmpty && calories > 0 && mealType.isNotEmpty) {
      try {
        User user = _auth.currentUser;
        if (user != null) {
          String userId = user.uid;
          String formattedDate = _getFormattedDate();
          await _firestore
              .collection('foodIntake')
              .doc(userId)
              .collection(formattedDate)
              .add({
            'foodName': foodName,
            'calories': calories,
            'mealType': mealType,
            'timestamp': Timestamp.now(),
          });
          _clearInputs();
          _showSnackBar('Food intake added!');
        } else {
          _showSnackBar('User not logged in!');
        }
      } catch (e) {
        print('Error adding food intake: $e');
        _showSnackBar('Failed to add food intake!');
      }
    } else {
      _showSnackBar('Please fill in all fields!');
    }
  }

  String _getFormattedDate() {
    DateTime now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  void _clearInputs() {
    _foodNameController.clear();
    _caloriesController.clear();
    _mealTypeController.clear();
  }

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}

