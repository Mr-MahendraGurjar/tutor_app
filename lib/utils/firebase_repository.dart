import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutor_app/utils/firebase_provider.dart';

class FirebaseRepository {
  FirebaseProvider firebaseProvider = FirebaseProvider();

  Future<void> addTutorUser({String firstName, String lastName,  String userName,  String email,  String password, String type}) =>
      firebaseProvider.addTutorUser(firstName, lastName, userName, email, password, type);

  Future<void> addStudentUser({String firstName, String lastName,  String userName,  String email,  String password, String type}) =>
      firebaseProvider.addStudentUser(firstName, lastName, userName, email, password, type);

  Future<QuerySnapshot<Map<String, dynamic>>> tutorLogin({ String email,  String password}) => firebaseProvider.tutorLogin(email, password);

  Future<QuerySnapshot<Map<String, dynamic>>> studentLogin({ String email,  String password}) => firebaseProvider.studentLogin(email, password);

  Future<QuerySnapshot<Map<String, dynamic>>> checkEmailInTutor({ String email}) =>
      firebaseProvider.checkEmailInTutor(email);

  Future<QuerySnapshot<Map<String, dynamic>>> checkEmailInStudent({ String email}) =>
      firebaseProvider.checkEmailInStudent(email);

  Future<String> uploadImageToStorage({ File file}) => firebaseProvider.uploadImageToStorage(file);
}
