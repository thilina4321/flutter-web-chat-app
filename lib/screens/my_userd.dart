import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_caht/screens/all_users.dart';
import 'package:flutter/material.dart';

class MyUsersScreen extends StatelessWidget {
  final userId;
  MyUsersScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AllUsersScreen(
              userId: userId,
            );
          }));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('collectionPath').snapshots(),
        builder: (context, snap) {
          return ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.green,
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text('Thilina'),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
