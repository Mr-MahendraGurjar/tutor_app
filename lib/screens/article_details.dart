import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ArticleDetail extends StatefulWidget {
  final String question;
  final String answer;
  final String picture;
  final String id;
  final String userId;
  final String createAt;
  const ArticleDetail({Key key, this.question, this.answer, this.picture, this.id, this.userId, this.createAt}) : super(key: key);

  @override
  _ArticleDetailState createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  TextEditingController commentController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  File image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.question,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    widget.createAt,
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: 200,
                width: MediaQuery.of(context).size.width,
                color: Colors.black54,
                child: widget.picture == null
                    ? Container()
                    : Image.network(
                        widget.picture,
                        fit: BoxFit.cover,
                      ),
              ),
              Text(
                widget.answer,
                style: TextStyle(height: 1.5, fontSize: 16),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 90,
                color: Colors.white,
                child: Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      height: 28,
                      width: 28,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 1, color: Colors.grey),
                          image: DecorationImage(
                              image: NetworkImage('https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'), fit: BoxFit.cover)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        child: Center(
                          child: TextField(
                            controller: commentController,
                            cursorColor: Colors.black.withOpacity(0.5),
                            decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      if (commentController.text != '') {
                                        FirebaseFirestore.instance
                                            .collection('comment')
                                            .doc(widget.id)
                                            .collection('comments')
                                            .doc()
                                            .set({'studentComment': commentController.text, 'userId': widget.userId}).then((value) {
                                          commentController.text = '';
                                          FocusScopeNode currentFocus = FocusScope.of(context);
                                          if (!currentFocus.hasPrimaryFocus) {
                                            currentFocus.unfocus();
                                          }
                                        });
                                      } else {
                                        print('no comments');
                                      }
                                    },
                                    child: Icon(Icons.send)),
                                border: InputBorder.none,
                                hintText: "Add a comment",
                                hintStyle: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.5))),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection('comment').doc(widget.id).collection('comments').snapshots(),
                  builder: (context, snapComment) {
                    if (!snapComment.hasData) {
                      return SizedBox.shrink();
                    } else {
                      if (snapComment.data.docs.length == 0) {
                        return Center(
                          child: SizedBox.shrink(),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                      stream: FirebaseFirestore.instance.collection('comment').doc(widget.id).collection('comments').snapshots(),
                                      builder: (context, snapComment) {
                                        if (!snapComment.hasData) {
                                          return SizedBox.shrink();
                                        } else {
                                          if (snapComment.data.docs.length == 0) {
                                            return Center(
                                              child: SizedBox.shrink(),
                                            );
                                          } else {
                                            return ListView.builder(
                                                itemCount: snapComment.data.docs.length,
                                                itemBuilder: (context, index) => Row(
                                                      children: [
                                                        FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                                            future: FirebaseFirestore.instance
                                                                .collection('student')
                                                                .doc(snapComment.data.docs[index].data()['userId'])
                                                                .get(),
                                                            builder: (context, snap) {
                                                              if (!snap.hasData) {
                                                                return const SizedBox.shrink();
                                                              } else {
                                                                if (snap.data.data() == null) {
                                                                  return const SizedBox.shrink();
                                                                } else {
                                                                  return Expanded(
                                                                    child: ListTile(
                                                                      leading: Container(
                                                                        height: 35,
                                                                        width: 35,
                                                                        decoration: BoxDecoration(
                                                                            shape: BoxShape.circle,
                                                                            border: Border.all(width: 1, color: Colors.grey),
                                                                            image: DecorationImage(
                                                                                image: NetworkImage(
                                                                                    'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
                                                                                fit: BoxFit.cover)),
                                                                      ),
                                                                      title: Row(
                                                                        children: [
                                                                          Text(
                                                                            snap.data.data()['fName'] + ' ' + snap.data.data()['lName'],
                                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                                          ),
                                                                          SizedBox(
                                                                            width: 10,
                                                                          ),
                                                                          Text(snapComment.data.docs[index].data()['studentComment'] == null
                                                                              ? ''
                                                                              : snapComment.data.docs[index].data()['studentComment']),
                                                                        ],
                                                                      ),
                                                                      subtitle: Row(
                                                                        children: [
                                                                          Text(
                                                                            '21m',
                                                                            style: TextStyle(fontSize: 12),
                                                                          ),
                                                                          SizedBox(width: 10),
                                                                          Text('12 likes', style: TextStyle(fontSize: 12)),
                                                                          SizedBox(
                                                                            width: 10,
                                                                          ),
                                                                          Text('Reply', style: TextStyle(fontSize: 12)),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                              }
                                                            }),
                                                      ],
                                                    ));
                                          }
                                        }
                                      });
                                });
                          },
                          child: Text(
                            "Responses (${snapComment.data.docs.length.toString()})",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                    }
                  }),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
