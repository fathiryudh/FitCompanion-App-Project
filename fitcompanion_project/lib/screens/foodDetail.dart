import 'package:flutter/material.dart';

class FoodDetailsPage extends StatelessWidget {
  final String foodId;

  FoodDetailsPage({this.foodId});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> foodDetails = {
      'foodName': 'Example Food',
      'calories': 200,
      'mealType': 'Breakfast',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Food Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Food Name: ${foodDetails['foodName']}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Calories: ${foodDetails['calories']}',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Meal Type: ${foodDetails['mealType']}',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
