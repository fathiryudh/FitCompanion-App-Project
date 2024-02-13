import 'package:fitcompanion_project/screens/login.dart';
import 'package:fitcompanion_project/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Launch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'FitCompanion',
                style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 50),
              RaisedButton(
                color: Colors.orangeAccent,
                onPressed: () {
                  Get.to(() => LoginPage());
                },
                child: Text(
                  'Let\'s Go',
                  style: TextStyle(
                    fontSize: 25,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  Get.to(() => SignUpPage());
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 25,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightGreen,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
