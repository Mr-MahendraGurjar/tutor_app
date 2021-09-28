import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutor_app/screens/student_home_page.dart';
import 'package:tutor_app/screens/tutor_home_page.dart';
import 'package:tutor_app/utils/firebase_repository.dart';
import 'package:tutor_app/widgets/common/custom_input_decoration.dart';
import 'package:tutor_app/widgets/validation.dart';

class StudentSignUp extends StatefulWidget {
  final String text;
  final String type;
  const StudentSignUp({Key key, this.text, this.type}) : super(key: key);

  @override
  _StudentSignUpState createState() => _StudentSignUpState();
}

class _StudentSignUpState extends State<StudentSignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameTextController = TextEditingController();
  final TextEditingController lastNameTextController = TextEditingController();
  final TextEditingController userNameTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController confirmPasswordTextController = TextEditingController();
  final TextEditingController emailNameTextController = TextEditingController();
  final TextEditingController bioTextController = TextEditingController();
  bool isAcceptedTermAndCond = false;

  final firebaseRepository = FirebaseRepository();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(child: _buildForm()),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Sign up with\n${widget.text}',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'pac', fontSize: 35),
            ),
            SizedBox(
              height: 25,
            ),
            TextFormField(
              controller: firstNameTextController,
              keyboardType: TextInputType.text,
              decoration: CustomInputDecoration(
                labelText: "First Name",
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: Colors.pink,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: lastNameTextController,
              keyboardType: TextInputType.text,
              decoration: CustomInputDecoration(
                labelText: "Last Name",
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: Colors.pink,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: userNameTextController,
              keyboardType: TextInputType.text,
              decoration: CustomInputDecoration(
                labelText: "User Name",
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: Colors.pink,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: passwordTextController,
              keyboardType: TextInputType.text,
              enableSuggestions: false,
              autocorrect: false,
              obscureText: true,
              decoration: CustomInputDecoration(
                  hintText: "Password",
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Colors.pink,
                  )),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: confirmPasswordTextController,
              keyboardType: TextInputType.text,
              enableSuggestions: false,
              autocorrect: false,
              decoration: CustomInputDecoration(
                  hintText: "Confirm Password",
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Colors.pink,
                  )),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                } else if (passwordTextController.text != confirmPasswordTextController.text) {
                  return 'Password does not match';
                }
                return null;
              },
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: emailNameTextController,
              keyboardType: TextInputType.text,
              decoration: CustomInputDecoration(
                labelText: "Email Address",
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: Colors.pink,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                } else if (!isEmail(emailNameTextController.text)) {
                  return 'Please enter valid email';
                }
                return null;
              },
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: MaterialButton(
                onPressed: () => signUp(),
                height: 50,
                minWidth: MediaQuery.of(context).size.width,
                color: widget.text == 'Tutor' ? Colors.blue : Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: isLoading
                    ? CupertinoActivityIndicator()
                    : Text('SIGN UP', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  signUp() {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      if (widget.type=='1') {
        firebaseRepository.checkEmailInTutor(email: emailNameTextController.text).then((value) {
          if (value.docs.length > 0) {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email already exist')));
          } else {
            firebaseRepository
                .addTutorUser(
                    firstName: firstNameTextController.text,
                    lastName: lastNameTextController.text,
                    email: emailNameTextController.text,
                    type: widget.type,
                    password: passwordTextController.text,
                    userName: userNameTextController.text)
                .then((value) async {
              setState(() {
                isLoading = false;
              });
               Navigator.pop(context);
            }).catchError((onError) {
              setState(() {
                isLoading = false;
              });
            });
          }
        });
      }else{
        firebaseRepository.checkEmailInStudent(email: emailNameTextController.text).then((value) {
          if (value.docs.length > 0) {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email already exist')));
          } else {
            firebaseRepository
                .addStudentUser(
                firstName: firstNameTextController.text,
                lastName: lastNameTextController.text,
                email: emailNameTextController.text,
                type: widget.type,
                password: passwordTextController.text,
                userName: userNameTextController.text)
                .then((value) async {
              setState(() {
                isLoading = false;
              });
              Navigator.pop(context);
            }).catchError((onError) {
              setState(() {
                isLoading = false;
              });
            });
          }
        });
      }
    }
  }
}
