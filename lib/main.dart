import 'package:fire_caht/layout/double_column.dart';
import 'package:fire_caht/layout/single_column.dart';
import 'package:fire_caht/screens/all_users.dart';
import 'package:fire_caht/user/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.black,
              child: Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              )),
            );
          }
          if (snap.hasData) {
            Me.addUser(snap.data!.uid);
            return AllUsersScreen(
              userId: snap.data!.uid,
            );
          }
          return MediaQuery.of(context).size.width > 800
              ? DoubleColumnLayout()
              : SingleColumnLayout();
        },
      ),
    );
  }
}
