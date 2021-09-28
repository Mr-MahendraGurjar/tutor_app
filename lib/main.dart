import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutor_app/screens/splash_screen.dart';
import 'package:tutor_app/screens/student_home_page.dart';
import 'package:tutor_app/screens/tutor_home_page.dart';
import 'package:tutor_app/screens/user_selection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tutor App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
