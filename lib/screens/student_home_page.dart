import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor_app/screens/article_details.dart';
import 'package:tutor_app/screens/user_selection.dart';
import 'package:tutor_app/screens/view_profile.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({Key key}) : super(key: key);

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  String userId = '';

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    print('userId ******** $userId');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(child: DrawerHeader(child: Container(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
                 Container(
                   decoration: BoxDecoration(
                     shape: BoxShape.circle
                   ),
                   child: Padding(
                     padding: const EdgeInsets.all(1.3),
                     child: Container(
                       height: 70,
                       width: 70,
                       decoration: BoxDecoration(
                           shape: BoxShape.circle,
                           border: Border.all(width: 1, color: Colors.white),
                           image: DecorationImage(
                               image: NetworkImage('https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
                               fit: BoxFit.cover)),
                     ),
                   ),
                 ),
                 FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                     future: FirebaseFirestore.instance.collection('student').doc(userId).get(),
                     builder: (context, snapshot) {
                       if (!snapshot.hasData) {
                         return SizedBox.shrink();
                       } else {
                         if (snapshot.data == null) {
                           return Center(
                             child: SizedBox.shrink(),
                           );
                         } else {
                           return snapshot.data == null
                               ? SizedBox.shrink()
                               : Text(
                             "${snapshot.data.data()['fName']} ${snapshot.data.data()['lName']}",
                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                           );
                         }
                       }
                     }),
                 GestureDetector(
                     onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewProfile(userType:'2'))),
                     child: Text('View profile')),
               ],
             )
            ))),
            Container(
              child: Column(children: <Widget>[
                ListTile(title: Text('Home'), onTap: () {}),
                ListTile(title: Text('Audio'), onTap: () {}),
                ListTile(title: Text('Reading List'), onTap: () {}),
                ListTile(title: Text('Interests'), onTap: () {}),
                ListTile(title: Text('New Story'), onTap: () {}),
                ListTile(title: Text('Logout'), onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.clear();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserSelection()));
                }),
              ]),
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text('Home'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('article').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.data.docs.length == 0) {
                return Center(
                  child: Text('No Articles'),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ArticleDetail(
                                          question: snapshot.data.docs[index].data()['title'],
                                          answer: snapshot.data.docs[index].data()['answer'],
                                          picture: snapshot.data.docs[index].data()['image'],
                                          id: snapshot.data.docs[index].id,
                                          userId: userId,
                                          createAt: DateFormat.yMMMMd('en_US').format(snapshot.data.docs[index].data()['createAt'].toDate()),
                                        )));
                          },
                          child: Card(
                            margin: EdgeInsets.all(5),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ListTile(
                                title: Text(
                                  snapshot.data.docs[index].data()['title'],
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                              future: FirebaseFirestore.instance
                                                  .collection('tutor')
                                                  .doc(snapshot.data.docs[index].data()['userId'])
                                                  .get(),
                                              builder: (context, snap) {
                                                if (!snap.hasData) {
                                                  return SizedBox.shrink();
                                                } else {
                                                  if (snap.data == null) {
                                                    return Center(
                                                      child: SizedBox.shrink(),
                                                    );
                                                  } else {
                                                    return Text(
                                                      snap.data.data()['fName'],
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    );
                                                  }
                                                }
                                              }),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(DateFormat('dd,MMM – KK:mm a').format(snapshot.data.docs[index].data()['createAt'].toDate()),
                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
                                      ],
                                    ),
                                    Text(
                                      '...',
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
                                    ),
                                  ],
                                ),
                                trailing: Container(
                                  height: 80,
                                  width: 80,
                                  color: Colors.black54,
                                  child: Image.network(
                                    snapshot.data.docs[index].data()['image'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ));
              }
            }
          }),
    );
  }
}
