import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_caht/screens/Chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AllUsersScreen extends StatelessWidget {
  final userId;
  AllUsersScreen({this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Your Friend'),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
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
          MaterialButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Container(
                        margin: const EdgeInsets.all(0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Cancel',
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Ok',
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
            child: Icon(Icons.search),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .where('userId', isNotEqualTo: userId)
            .snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          var user = snap.data!.docs;
          print(user);
          return ListView.builder(
              itemCount: user.length,
              itemBuilder: (context, index) {
                return InkWell(
                  mouseCursor: MouseCursor.defer,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Chat(
                        receiverName: user[index]['userName'],
                        receiverId: user[index]['userId'],
                      );
                    }));
                  },
                  child: Container(
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
                        Text(user[index]['userName']),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
