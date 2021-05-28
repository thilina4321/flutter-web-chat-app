import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chat')
              .doc('LewXjKovKVYTsgvEcW1z')
              .collection('messages')
              .add({'text': 'this is the new one'});
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        actions: [
          DropdownButton(
              icon: Icon(Icons.more_vert),
              onChanged: (value) {
                if (value == 'logout') {
                  FirebaseAuth.instance.signOut();
                }
              },
              items: [
                DropdownMenuItem(
                    value: 'logout',
                    child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.exit_to_app),
                          SizedBox(
                            width: 8,
                          ),
                          Text('Sign Out')
                        ],
                      ),
                    )),
              ]),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .doc('LewXjKovKVYTsgvEcW1z')
            .collection('messages')
            .snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snap.hasError) {
            Text(snap.error.toString());
          }

          final docs = snap.data!.docs;

          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                return Text(docs[index]['text']);
              });
        },
      ),
    );
  }
}
