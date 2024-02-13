import 'package:flutter/material.dart';
import 'package:fitcompanion_project/services/firebaseauth_service.dart';
import 'package:fitcompanion_project/screens/index.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Sign In',
          style: TextStyle(
            color: Colors.lightGreen,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        width: 300, 
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(color: Colors.orangeAccent),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3, color: Colors.orangeAccent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3, color: Colors.orangeAccent),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        width: 300, 
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.orangeAccent),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3, color: Colors.orangeAccent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3, color: Colors.orangeAccent),
                            ),
                          ),
                        ),
                      ),
                    ),
                    RaisedButton(
                      color: Colors.orangeAccent,
                      onPressed: () async {
                        var reguser = await FirebaseAuthService().signIn(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                        if (reguser != null) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => MainMenu()),
                          );
                        }
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'FitCompanion',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
