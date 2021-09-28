import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutor_app/screens/student_home_page.dart';
import 'package:tutor_app/screens/student_tutor_sign_up.dart';
import 'package:tutor_app/utils/firebase_repository.dart';
import 'package:tutor_app/widgets/common/custom_input_decoration.dart';
import 'package:tutor_app/widgets/validation.dart';

class StudentLogin extends StatefulWidget {
  const StudentLogin({Key key}) : super(key: key);

  @override
  _StudentLoginState createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  final firebaseRepository = FirebaseRepository();
  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Sign in with\nStudent',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'pac', fontSize: 35),
            ),
            SizedBox(
              height: 25,
            ),
            TextFormField(
              controller: emailTextController,
              keyboardType: TextInputType.text,
              decoration: CustomInputDecoration(
                labelText: "Email",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }else if (!isEmail(emailTextController.text)) {
                  return 'Please enter valid email';
                }
                return null;
              },
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: passwordTextController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: CustomInputDecoration(
                labelText: "Password",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                return null;
              },
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: MaterialButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      final result = await InternetAddress.lookup('example.com');
                      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                        firebaseRepository.studentLogin(email: emailTextController.text, password: passwordTextController.text).then((value) async {
                          print('check' + value.docs.length.toString());
                          try {
                            if (value.docs.length > 0) {
                              setState(() {
                                isLoading = false;
                              });
                              prefs.setBool('status', true);
                              prefs.setString('type', '2');
                              prefs.setString('userId', value.docs[0].id);
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> StudentHomePage()));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid credentials')));
                              setState(() {
                                isLoading = false;
                              });
                            }
                          } on Exception catch (e) {
                            print('=' + e.toString());
                            setState(() {
                              isLoading = false;
                            });
                          }
                        });
                      }
                    } on SocketException catch (_) {
                      setState(() {
                        isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please check your internet connection')));
                    }
                  }
                },
                height: 55,
                minWidth: MediaQuery.of(context).size.width,
                color: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: isLoading
                    ? CupertinoActivityIndicator()
                    : Text(
                  '  Log In  ',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Haven't account?   ",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    TextSpan(
                        text: 'Get help sign up.',
                        style: TextStyle(color: Colors.blueAccent, fontSize: 14, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>StudentSignUp(text: 'Student',type: '2',)));
                          }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
