import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_caht/user/user.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final receiverId;
  final receiverName;
  final myName;
  Chat(
      {required this.receiverId,
      required this.receiverName,
      required this.myName});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  var _key = GlobalKey<FormState>();

  var message;
  var me;
  List<QueryDocumentSnapshot<Object?>> otherData = [];
  @override
  void initState() {
    me = Me.getUser();

    super.initState();
  }

  ScrollController sc = ScrollController();

  getData() {
    FirebaseFirestore.instance
        .collection('messages')
        .where('sender', isEqualTo: widget.receiverId)
        .where('receiver', isEqualTo: me)
        .get()
        .then((value) {
      otherData = value.docs;
      // otherData.add(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    getData();

    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .where('sender', isEqualTo: me)
            .where('receiver', isEqualTo: widget.receiverId)
            .snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snap.hasError) {
            return Text(snap.error.toString());
          }

          var docs = snap.data!.docs;
          docs += otherData;
          docs.sort((a, b) => b['time'].seconds - (a['time'].seconds));

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    reverse: true,
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      return Container(
                          margin: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: docs[index]['sender'] == me
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  decoration: BoxDecoration(
                                    color: docs[index]['sender'] == me
                                        ? Colors.grey
                                        : Colors.purple,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        docs[index]['myName'],
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(docs[index]['message']),
                                    ],
                                  )),
                            ],
                          ));
                    }),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                        child: Form(
                      key: _key,
                      child: TextFormField(
                        onSaved: (value) {
                          message = value;
                        },
                        validator: (val) {
                          if (val?.trim() == '') {
                            return;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            fillColor: Colors.grey, hoverColor: Colors.green),
                      ),
                    )),
                    IconButton(
                        onPressed: () {
                          bool isValid = _key.currentState!.validate();
                          if (isValid) {
                            _key.currentState?.save();

                            FirebaseFirestore.instance
                                .collection('messages')
                                .doc()
                                .set({
                              'sender': me,
                              'receiver': widget.receiverId,
                              'message': message,
                              'myName': widget.myName,
                              'time': Timestamp.now()
                            });
                            _key.currentState!.reset();
                          }
                        },
                        icon: Icon(Icons.send)),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          );
        },
      ),
    );
  }
}
