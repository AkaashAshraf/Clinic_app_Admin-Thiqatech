import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:demoadmin/screens/homePage.dart';
import 'package:demoadmin/screens/loginPage.dart';

class AuthService {
  //Handles Auth
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return LoginPage();
          }
        });
  }

  //Sign out
  static Future<bool> signOut() async {
    bool isSignOut = false;

    await FirebaseAuth.instance.signOut().then((v) {
      isSignOut = true;
    }).catchError((e) {
      print(e); //Invalid otp
      isSignOut = false;
    });

    return isSignOut;
  }

  //SignIn

  static Future<bool> signIn(String email, String password) async {
    bool isLoggedIn = false;
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      isLoggedIn = true;
    } on FirebaseAuthException catch (e) {
      isLoggedIn = false;
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    return isLoggedIn;
  }
}
