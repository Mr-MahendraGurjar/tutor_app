import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor_app/screens/student_home_page.dart';
import 'package:tutor_app/screens/tutor_home_page.dart';
import 'package:tutor_app/screens/user_selection.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool status;
  String type;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      checkStatus();
    });
  }

  Future<Null> checkStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    status = prefs.getBool('status');
    type = prefs.getString('type');
    if (status ?? false) {
      if (type == '1') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TutorHomePage()));
      } else if (type == '2') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StudentHomePage()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserSelection()));
      }
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserSelection()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Text(
            'Tutor App',
            style: TextStyle(fontFamily: 'pac', fontSize: 30),
          ),
        ),
      ),
    ));
  }
}
