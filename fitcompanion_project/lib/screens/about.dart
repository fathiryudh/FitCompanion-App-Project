import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'profile.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('about')
          .doc('OJXkq6k9hJ05DIdDTIuO')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          final data = snapshot.data.data();
          final phoneNumber = data['number'] ?? '';
          final email = data['email'] ?? '';

          return Scaffold(
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
                'Home',
                style: TextStyle(color: Colors.black),
              ),
              elevation: 0.0,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompanyInfoPage()),
                      );
                    },
                    child: Text(
                      'Company Info',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF2E4057)),
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DeveloperInfoPage()),
                      );
                    },
                    child: Text(
                      'Developer Info',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF99C24D),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      final url = 'tel:$phoneNumber';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Text(
                      'Call Us',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFFF18F01),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      final emailUrl = 'mailto:$email';
                      if (await canLaunch(emailUrl)) {
                        await launch(emailUrl);
                      } else {
                        throw 'Could not launch $emailUrl';
                      }
                    },
                    child: Text(
                      'Email Us',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF048BA8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class CompanyInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      appBar: AppBar(
        backgroundColor: Color(0xFFEBEBEB),
        title: Text(
          'Company Info',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About FitCompanion',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'FitCompanion stems from a deep passion for promoting a healthy lifestyle accessible to everyone. The initiative aims to harness technology to improve overall health outcomes and create a more health-conscious society. Recognizing the challenges people face in maintaining fitness routines due to time constraints and limited resources, the idea emerged to create a comprehensive platform that integrates gym access, equipment shopping, nutritional tracking, and personalized workout guidance.',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeveloperInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBEBEB),
      appBar: AppBar(
        backgroundColor: Color(0xFFEBEBEB),
        title: Text(
          'Developer Info',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Muhammad Fathir Yudhistira',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              '211652L',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
