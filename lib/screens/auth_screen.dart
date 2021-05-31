import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_caht/widgets/auth_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late UserCredential user;
  bool isLoading = false;

  authentication(String email, String userName, String password, bool isLoging,
      BuildContext ctx) async {
    try {
      setState(() {
        isLoading = true;
      });
      if (isLoging) {
        user = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        user = await auth.createUserWithEmailAndPassword(
            email: email, password: password);

        FirebaseFirestore.instance
            .collection('user')
            .doc(user.user!.uid)
            .set({'userId': user.user!.uid, 'userName': userName});
      }
      setState(() {
        isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });

      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text('The password provided is too weak.')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: Text('The account already exists for that email.')));
      } else if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text('No user found for that email.')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text('Wrong password provided for that user.')));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      SnackBar(content: Text(e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthWidget(
        submitFn: authentication,
        isLoading: isLoading,
      ),
      backgroundColor: Colors.blue,
    );
  }
}
