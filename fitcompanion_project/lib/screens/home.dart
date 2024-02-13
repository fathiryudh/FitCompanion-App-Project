import 'package:fitcompanion_project/screens/chat.dart';
import 'package:fitcompanion_project/screens/exercise.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitcompanion_project/screens/shop.dart';
import 'package:fitcompanion_project/screens/profile.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int totalCalories = 0;
  int foodIntake = 0;

  @override
  void initState() {
    super.initState();
    _fetchTotalCalories();
    _fetchTotalFoodCount();
  }

  Future<void> _fetchTotalCalories() async {
    User user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;
      DateTime now = DateTime.now();
      String formattedDate = '${now.year}-${now.month}-${now.day}';

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('foodIntake')
          .doc(userId)
          .collection(formattedDate)
          .get();

      int calories = 0;
      querySnapshot.docs.forEach((doc) {
        calories += doc['calories'];
      });

      setState(() {
        totalCalories = calories;
      });

      print('Fetching total calories...');
      print('Total calories: $totalCalories');
    }
  }

  Future<int> _fetchTotalFoodCount() async {
    User user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;
      DateTime now = DateTime.now();
      String formattedDate = '${now.year}-${now.month}-${now.day}';

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('foodIntake')
          .doc(userId)
          .collection(formattedDate)
          .get();

      setState(() {
        foodIntake = querySnapshot.size;
      });
    }
    return 0;
  }

  Future<List<Map<String, dynamic>>> _fetchFoodIntakeHistory() async {
    List<Map<String, dynamic>> foodHistory = [];
    User user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;
      DateTime now = DateTime.now();
      String formattedDate = '${now.year}-${now.month}-${now.day}';

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('foodIntake')
          .doc(userId)
          .collection(formattedDate)
          .orderBy('timestamp', descending: true)
          .get();

      foodHistory = querySnapshot.docs.map((doc) => doc.data()).toList();
    }
    return foodHistory;
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
          'Home',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Color(0xFF99C24D),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Calories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Total: $totalCalories',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Meals ate today: $foodIntake',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 200,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Color(0xFF048BA8),
                    child: TextButton(
                      onPressed: () {
                        Get.to(() => ExerciseScreen());
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Workouts',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 200,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Color(0xFF2E4057),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Recent Intake',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: FutureBuilder<List<Map<String, dynamic>>>(
                            future: _fetchFoodIntakeHistory(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                List<Map<String, dynamic>> foodHistory =
                                    snapshot.data ?? [];
                                return ListView.builder(
                                  itemCount: foodHistory.length,
                                  itemBuilder: (context, index) {
                                    var food = foodHistory[index];
                                    return ListTile(
                                      title: Text(
                                        food['foodName'],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        '${food['calories']} calories - ${food['mealType']}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 150,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Color(0xFFF18F01),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.to(() => ShopPage());
                    },
                    child: Text(
                      'Shop',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
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
