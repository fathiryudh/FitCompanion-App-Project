import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class FirebaseAuthService {
  //FirebaseAuth instance
  final FirebaseAuth _fbAuth = FirebaseAuth.instance;

  Future<User> signIn({String email, String password}) async {
    try {
      var passwordHash = sha256.convert(utf8.encode(password)).toString();

      UserCredential ucred = await _fbAuth.signInWithEmailAndPassword(
          email: email, password: passwordHash);

      User user = ucred.user;

      print("Signed In successfull! userid: $ucred.user.uid, user: $user. ");

      return user;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message, gravity: ToastGravity.TOP);

      return null;
    } catch (e) {
      print(e.message);

      return null;
    }
  } //signIn

  Future<User> signUp(
      {String email,
      String username,
      String password,
      String phonenumber}) async {
    try {
      var passwordHash = sha256.convert(utf8.encode(password)).toString();

      UserCredential ucred = await _fbAuth.createUserWithEmailAndPassword(
          email: email, password: passwordHash);

      User user = ucred.user;

      FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'username': username,
        'email': email,
        'password': passwordHash,
        'phone': phonenumber,
      });

      print("Signed In successful! userid: $ucred.user.uid, $user.");

      return user;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message, gravity: ToastGravity.TOP);

      return null;
    } catch (e) {
      print(e.message);

      return null;
    }
  } //signUp

  Future<void> signOut() async {
    await _fbAuth.signOut();
  }
}
