import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor_app/utils/firebase_repository.dart';

class CreateArticles extends StatefulWidget {
  const CreateArticles({Key key}) : super(key: key);

  @override
  _CreateArticlesState createState() => _CreateArticlesState();
}

class _CreateArticlesState extends State<CreateArticles> {
  TextEditingController titleController = TextEditingController();
  TextEditingController answerController = TextEditingController();
  bool isLoading = false;
  final ImagePicker picker = ImagePicker();
  File image;
  final firebaseRepository = FirebaseRepository();
  TextEditingController captionController = TextEditingController();
  String userId = '';

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Create New Article',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text('Title'),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 0),
              child: Container(
                decoration: ShapeDecoration(
                  color: Color(0xffF4F4F4),
                  shadows: [
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-5, -5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(5, 5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(7),
                      topRight: Radius.circular(7),
                      bottomLeft: Radius.circular(7),
                      bottomRight: Radius.circular(7),
                    ),
                  ),
                ),
                child: TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    fillColor: Color(0xffF4F4F4),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffF4F4F4),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffF4F4F4),
                      ),
                    ),
                    border: new OutlineInputBorder(
                      borderSide: new BorderSide(),
                    ),
                    labelStyle: TextStyle(
                      fontSize: 17,
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ), // Only numbers can be entered
                  validator: (String value) {
                    if (value.isEmpty || value.length < 4) {
                      return 'Please enter valid title';
                    }
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text('Answer'),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 0),
              child: Container(
                decoration: ShapeDecoration(
                  color: Color(0xffF4F4F4),
                  shadows: [
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-5, -5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(5, 5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(7),
                      topRight: Radius.circular(7),
                      bottomLeft: Radius.circular(7),
                      bottomRight: Radius.circular(7),
                    ),
                  ),
                ),
                child: TextFormField(
                  controller: answerController,
                  maxLines: 25,
                  decoration: InputDecoration(
                    fillColor: Color(0xffF4F4F4),
                    filled: true,
                    hintText: 'Answer',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffF4F4F4),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffF4F4F4),
                      ),
                    ),
                    border: new OutlineInputBorder(
                      borderSide: new BorderSide(),
                    ),
                    labelStyle: TextStyle(
                      fontSize: 17,
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ), // Only numbers can be entered
                  validator: (String value) {
                    if (value.isEmpty || value.length < 4) {
                      return 'Please enter valid title';
                    }
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text('Picture (Optional)'),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                final pickedFile = await picker.getImage(source: ImageSource.camera);

                if (pickedFile != null) {
                  image = File(pickedFile.path);
                  setState(() {});
                } else {
                  print('No image selected.');
                  return;
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black54,
                ),
                child: image == null
                    ? Container(
                )
                    : Image.file(
                        image,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: MaterialButton(
                  onPressed: () {
                    isLoading = true;
                    setState(() {});
                    firebaseRepository.uploadImageToStorage(file: image).then((value) {
                      FirebaseFirestore.instance.collection('article').doc().set({
                        'image': value,
                        'title': titleController.text,
                        'answer': answerController.text,
                        'userId': userId,
                        'createAt': Timestamp.now()
                      }).then((value) {
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.pop(context);
                      });
                    });
                  },
                  height: 55,
                  minWidth: MediaQuery.of(context).size.width,
                  color: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: isLoading
                      ? CupertinoActivityIndicator()
                      : Text(
                          'Submit',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
