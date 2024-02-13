import 'launch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitcompanion_project/services/firebaseauth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      User user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print('User not signed in.');
        return;
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          _usernameController.text = userDoc.data()['username'];
          _emailController.text = userDoc.data()['email'];
          _phoneNumberController.text = userDoc.data()['phone'];
        });
      } else {
        print('User document not found.');
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  Future<void> _updateUser(String username) async {
    try {
      User user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print('User not signed in.');
        return;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'username': username});

      setState(() {
        _usernameController.text = username;
      });

      print('Username updated successfully.');
    } catch (e) {
      print('Error updating username: $e');
    }
  }

  Future<void> _updateNumber(String phone) async {
    try {
      User user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print('User not signed in.');
        return;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'phone': phone});

      setState(() {
        _phoneNumberController.text = phone;
      });

      print('Username updated successfully.');
    } catch (e) {
      print('Error updating username: $e');
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
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        iconTheme: IconThemeData(
            color: Colors.black),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildEditableField(
              labelText: 'Username',
              controller: _usernameController,
              readOnly: false,
              onPressedSave: () {
                _updateUser(_usernameController.text);
              },
            ),
            _buildEditableField(
              labelText: 'Email',
              controller: _emailController,
              readOnly: true,
            ),
            _buildEditableField(
              labelText: 'Phone Number',
              controller: _phoneNumberController,
              readOnly: false,
              onPressedSave: () {
                _updateNumber(_phoneNumberController.text);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.logout, color: Colors.black,),
        backgroundColor: Colors.limeAccent,
        tooltip: 'Sign Out',
        onPressed: () async {
          await FirebaseAuthService().signOut();
          Get.to(() => Launch());
        },
      ),
    );
  }

  Widget _buildEditableField({
    String labelText,
    TextEditingController controller,
    bool readOnly,
    VoidCallback onPressedSave,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                labelText: labelText,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              controller: controller,
              readOnly: readOnly,
            ),
          ),
          if (!readOnly)
            IconButton(
              icon: Icon(Icons.edit, color: Colors.black),
              onPressed: onPressedSave,
            ),
        ],
      ),
    );
  }
}
