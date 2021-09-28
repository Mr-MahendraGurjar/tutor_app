import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseProvider {
  FirebaseProvider._internal() {
    print("Instance created FirebaseProvider");
  }

  factory FirebaseProvider() => _singleton;
  static final FirebaseProvider _singleton = FirebaseProvider._internal();

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> addTutorUser(String firstName, String lastName, String userName, String email, String password, String type) async {
    await _fireStore.collection('tutor').doc().set({
      'fName': firstName,
      'lName': lastName,
      'uName': userName,
      'email': email,
      'password': password,
      'type': type,
    });
  }

  Future<void> addStudentUser(String firstName, String lastName, String userName, String email, String password, String type) async {
    await _fireStore.collection('student').doc().set({
      'fName': firstName,
      'lName': lastName,
      'uName': userName,
      'email': email,
      'password': password,
      'type': type,
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> checkEmailInTutor(String email) {
    return _fireStore.collection('tutor').where('email', isEqualTo: email).limit(1).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> checkEmailInStudent(String email) {
    return _fireStore.collection('student').where('email', isEqualTo: email).limit(1).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> tutorLogin(String email, String password) {
    return _fireStore.collection('tutor').where('email', isEqualTo: email).where('password', isEqualTo: password).limit(1).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> studentLogin(String email, String password) {
    return _fireStore.collection('student').where('email', isEqualTo: email).where('password', isEqualTo: password).limit(1).get();
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    Reference _storageReference = FirebaseStorage.instance.ref().child(
        DateTime.now().millisecondsSinceEpoch.toString());
    assert(imageFile.existsSync());
    UploadTask storageUploadTask = _storageReference.putFile(imageFile);
    TaskSnapshot storageTaskSnapshot = await storageUploadTask;
    print(storageTaskSnapshot.ref.getDownloadURL());
    return storageTaskSnapshot.ref.getDownloadURL();
  }



}
