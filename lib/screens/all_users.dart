import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_caht/screens/Chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AllUsersScreen extends StatefulWidget {
  final userId;
  AllUsersScreen({this.userId});

  @override
  _AllUsersScreenState createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  var me;

  getName() async {
    await FirebaseFirestore.instance
        .collection('user')
        .where('userId', isEqualTo: widget.userId)
        .get()
        .then((value) {
      setState(() {
        me = value.docs[0]['userName'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getName();
  }

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
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .where('userId', isNotEqualTo: widget.userId)
            .snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          var user = snap.data!.docs;
          return ListView.builder(
              itemCount: user.length,
              itemBuilder: (context, index) {
                return InkWell(
                  mouseCursor: MouseCursor.defer,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Chat(
                        myName: me,
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
                          child: Text(
                              user[index]['userName'].toString().split('')[0]),
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
