// ignore_for_file: use_build_context_synchronously, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vanrakshak/screens/mainScreens/mainScreen.dart';

class LoginAuthorization with ChangeNotifier {
  UserCredential? userCredential;
  bool loading = false;

  void loginValidation(
      {required TextEditingController? emailAddress,
      required TextEditingController? password,
      required BuildContext context}) async {
    if (emailAddress!.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email Address is Empty")));
      return;
    } else if (password!.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Password is Empty")));
      return;
    } else if (emailAddress.text.trim() == 'admin1@gmail.com' &&
        password.text.trim() == 'admin1pass') {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid Credentials")));
      return;
    } else {
      try {
        loading = true;
        notifyListeners();

        userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailAddress.text, password: password.text)
            .then((value) async {
          loading = false;
          notifyListeners();
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const MainScreen()));
          return null;
        });
      } on FirebaseAuthException catch (e) {
        loading = false;
        notifyListeners();

        if (e.code == "user-not-found") {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("User Not Found")));
        } else if (e.code == "wrong-password") {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Wrong Password")));
        }
      }
    }
  }
}
